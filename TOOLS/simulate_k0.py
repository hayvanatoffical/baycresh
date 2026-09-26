#!/usr/bin/env python3
"""BAYCREST K0 — bagimsiz senaryo/ekonomi simulatoru (dogrulama katmani 2).

Bu arac Roblox Studio calistirmaz. `K0Market.server.lua` icindeki ekonomi ve
musteri dongusu kurallarini bagimsiz olarak yeniden kurar ve davranisi senaryo
bazli yurutur. Amaci statik denetimin (validate_package.py) tekrari olmak degil,
kurallarin BIRLIKTE calisirken urettigi sonucu olcmektir.

Modellenen kurallar kaynaktan okunur degil, kaynaga BAKILARAK yazilmistir; bu
yuzden simulator ile kaynak arasindaki her sapma bir bulgudur ve rapora yazilir.

Kullanim:
    python3 TOOLS/simulate_k0.py            # ozet
    python3 TOOLS/simulate_k0.py --verbose  # senaryo ayrintisi
"""
from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG_LUA = ROOT / "GAME/src/ReplicatedStorage/K0MarketConfig.lua"


# --------------------------------------------------------------------------
# Config: gercek degerler Lua config'inden okunur ki simulator sayi surukleme
# yapmasin. Ayrıştırılamayan alan varsa bu bir bulgudur, sessiz varsayilan yok.
# --------------------------------------------------------------------------
def parse_config() -> dict:
    text = CONFIG_LUA.read_text(encoding="utf-8")
    proto = text.split("Prototype = {", 1)[1]

    def num(name: str) -> float:
        m = re.search(rf"\b{name}\s*=\s*([0-9.]+)", proto)
        if not m:
            raise SystemExit(f"config alani bulunamadi: {name}")
        return float(m.group(1))

    def product(sku: str) -> dict:
        m = re.search(rf"{sku}\s*=\s*\{{(.*?)\n            \}}", proto, re.S)
        if not m:
            raise SystemExit(f"urun bulunamadi: {sku}")
        body = m.group(1)

        def f(name: str) -> int:
            mm = re.search(rf"\b{name}\s*=\s*(\d+)", body)
            if not mm:
                raise SystemExit(f"{sku}.{name} bulunamadi")
            return int(mm.group(1))

        return {
            "Retail": f("Retail"),
            "WholesaleBundle": f("WholesaleBundle"),
            "WholesaleCost": f("WholesaleCost"),
            "Level1Capacity": f("Level1Capacity"),
            "Level2Capacity": f("Level2Capacity"),
        }

    return {
        "StartingCash": int(num("StartingCash")),
        "PermitFee": int(num("PermitFee")),
        "PermitPeriodSeconds": int(num("PermitPeriodSeconds")),
        "UpgradeCost": int(num("UpgradeCost")),
        "HireCost": int(num("HireCost")),
        "WagePerShift": int(num("WagePerShift")),
        "ShiftSeconds": int(num("ShiftSeconds")),
        "PlaytestSeed": int(num("PlaytestSeed")),
        "TargetSessionSeconds": int(num("TargetSessionSeconds")),
        "ArrivalGapMin": int(num("ArrivalGapMin")),
        "ArrivalGapMax": int(num("ArrivalGapMax")),
        "ShopperWalkMin": int(num("ShopperWalkMin")),
        "ShopperWalkMax": int(num("ShopperWalkMax")),
        "PatienceMin": int(num("PatienceMin")),
        "PatienceMax": int(num("PatienceMax")),
        "WorkerResponseSeconds": int(num("WorkerResponseSeconds")),
        "DemandCycleSeconds": int(num("DemandCycleSeconds")),
        "DemandBonusRatio": num("DemandBonusRatio"),
        "DemandPickChance": num("DemandPickChance"),
        "BargainBidRatio": num("BargainBidRatio"),
        "BargainCounterRatio": num("BargainCounterRatio"),
        "LiquidationRatio": num("LiquidationRatio"),
        "RescueGrantLimit": int(num("RescueGrantLimit")),
        "Products": {"orange": product("orange"), "bread": product("bread")},
    }


C = parse_config()
# Isletme sermayesi tabani: toptancidaki en ucuz tek birim (K0.4.1 harcama korumasi).
MIN_UNIT = min(p["WholesaleCost"] // p["WholesaleBundle"] for p in C["Products"].values())

BARGAIN_PROFILES = [
    ("SIKI", 35, 0.86),
    ("ORTA", 45, 0.94),
    ("ESNEK", 20, 1.00),
]
VISITOR_WEIGHTS = [("Passerby", 30), ("Browser", 20), ("Buyer", 32), ("Bargainer", 18)]


class Stream:
    """Tek akisli deterministik RNG.

    Roblox `Random.new(seed)` ile bit-birebir ayni degildir; amac ayni SIRAYI ve
    ayni akis-paylasimini modellemektir. Bulgular akis sirasina dayanir, tek tek
    sayilarin degerine degil.
    """

    def __init__(self, seed: int):
        self.seed = seed & 0xFFFFFFFF
        self.draws = 0

    def _next(self) -> int:
        # xorshift32 — tekrarlanabilir ve tasinabilir olmasi yeterli.
        x = self.seed or 0x9E3779B9
        x ^= (x << 13) & 0xFFFFFFFF
        x ^= x >> 17
        x ^= (x << 5) & 0xFFFFFFFF
        self.seed = x & 0xFFFFFFFF
        self.draws += 1
        return self.seed

    def number(self) -> float:
        return self._next() / 0x100000000

    def integer(self, lo: int, hi: int) -> int:
        return lo + self._next() % (hi - lo + 1)


def weighted(stream: Stream, pairs) -> str:
    total = sum(w for _, w in pairs)
    roll = stream.number() * total
    acc = 0.0
    for key, w in pairs:
        acc += w
        if roll <= acc:
            return key
    return pairs[-1][0]


@dataclass
class Policy:
    """Oyuncu davranis modeli. Gercek oyuncu degil; karsilastirilabilir bir vekil."""

    name: str
    claim_at: int = 3
    permit_delay: int = 5          # sahiplenmeden sonra kayda kadar gecen saniye
    restock_reserve: int = 0       # stok alirken kasada birakilacak tampon
    buy_upgrade: bool = True
    hire_worker: bool = True
    accept_bargain: bool = True    # dusuk garantili teklifi kabul et
    counter_bargain: bool = True   # once karsi teklif dene
    follow_demand: bool = True     # talep goren urunu tercih et
    pay_wage: bool = True
    renew_permit: bool = True
    # Musteri tezgaha vardiktan sonra oyuncunun teklifi acip karar vermesi (sn).
    # Varsayim; gercek oyuncu olculmedi. Yalniz runtime_timing modunda kullanilir.
    response_seconds: int = 5


@dataclass
class Sim:
    policy: Policy
    seed: int
    duration: int = 1200
    fix_rng_gate: bool = False     # K0.4: ticaret kapaliyken ekonomi akisindan cekme yapma
    fix_soft_lock: bool = False    # K0.4: kayit borcu cikmazindan tasfiye ile cikis
    fix_partial_restock: bool = False  # K0.4: rafa sigan kadar birim fiyatindan stok al
    # K0.4.1: tezgahi bos rafla ve bir birimden az nakitle birakacak odeme reddedilir;
    # kurtarma kayit ucretini silir (K0.4 kalan tum nakdi aliyordu).
    fix_strand_guard: bool = False
    # K0.4.1: musteri dongusu Lua'daki gibi SIRALI zaman harcar (yuruyus, karar,
    # cikis). K0.4 modeli bu sureleri cekip zamana eklemiyordu; musteri akisi
    # gercek kaynagin yaklasik iki kati cikiyordu (katman 3 harness ile olculdu).
    runtime_timing: bool = False
    verbose: bool = False

    # durum
    t: int = 0
    cash: int = 0
    claimed: bool = False
    permit: bool = False
    permit_due: bool = False
    permit_remaining: int = 0
    level: int = 1
    stock: dict = field(default_factory=lambda: {"orange": 0, "bread": 0})
    hired: bool = False
    wages_due: bool = False
    shift_remaining: int = 0
    demand: str = "orange"
    demand_remaining: int = 0

    sales: int = 0
    revenue: int = 0
    wholesale_spent: int = 0
    permit_spent: int = 0
    wages_spent: int = 0
    upgrade_spent: int = 0
    hire_spent: int = 0
    lost_sales: int = 0
    accepts: int = 0
    counters: int = 0
    counter_success: int = 0
    declines: int = 0
    worker_sales: int = 0
    worker_revenue: int = 0
    player_sales: int = 0
    renewals: int = 0
    wage_payments: int = 0
    rescues: int = 0
    liquidations: int = 0
    first_upgrade_at: int = -1
    first_hire_at: int = -1

    events: list = field(default_factory=list)
    customers: list = field(default_factory=list)
    dead_locked_at: int = -1
    first_sale_at: int = -1
    first_stock_at: int = -1

    def __post_init__(self):
        self.phase = "idle"
        self.spawn_at = 0
        self.busy_until = 0
        self.pending = None
        self.rng = Stream(self.seed)
        self.cash = C["StartingCash"]
        self.shift_remaining = C["ShiftSeconds"]
        self.demand_remaining = C["DemandCycleSeconds"]
        self.demand = "orange" if self.rng.integer(1, 2) == 1 else "bread"

    # -- yardimcilar ------------------------------------------------------
    def commerce_active(self) -> bool:
        return self.claimed and self.permit and not self.permit_due

    def log(self, msg: str):
        self.events.append(f"[{self.t:4d}s] {msg}")

    def capacity(self, sku: str) -> int:
        p = C["Products"][sku]
        return p["Level2Capacity"] if self.level >= 2 else p["Level1Capacity"]

    def operating_cost(self) -> int:
        return self.wholesale_spent + self.permit_spent + self.wages_spent

    def operating_result(self) -> int:
        return self.revenue - self.operating_cost()

    def total_stock(self) -> int:
        return self.stock["orange"] + self.stock["bread"]

    def would_strand(self, cost: int) -> bool:
        return self.total_stock() == 0 and self.cash - cost < MIN_UNIT

    def economy_dead_end(self) -> bool:
        """Hicbir oyuncu eyleminin geri getiremeyecegi durum."""
        if not (self.claimed and self.permit):
            return False
        if self.permit_due:
            if not self.fix_soft_lock:
                # K0.3: kayit borcunda satis ve tasfiye yok; kasa yetmiyorsa bitti.
                return self.cash < C["PermitFee"]
            if self.total_stock() > 0:
                return False
            need = C["PermitFee"] + (MIN_UNIT if self.fix_strand_guard else 0)
            if self.cash >= need:
                return False
            return self.rescues >= C["RescueGrantLimit"]
        return self.total_stock() == 0 and self.cash < MIN_UNIT

    def stock_value(self) -> int:
        """Elde kalan stokun etiket degeri — cikmaz analizinde kullanilir."""
        return sum(self.stock[s] * C["Products"][s]["Retail"] for s in self.stock)

    # -- oyuncu eylemleri -------------------------------------------------
    def try_restock(self):
        if not self.commerce_active():
            return
        order = ["orange", "bread"]
        if self.policy.follow_demand:
            order = [self.demand] + [s for s in order if s != self.demand]
        for sku in order:
            p = C["Products"][sku]
            if self.fix_partial_restock:
                # K0.4: rafta yer varsa, sigan kadar birim fiyatindan al.
                room = self.capacity(sku) - self.stock[sku]
                if room <= 0:
                    continue
                per_unit = p["WholesaleCost"] // p["WholesaleBundle"]
                units = min(p["WholesaleBundle"], room)
                budget = self.cash - self.policy.restock_reserve
                units = min(units, max(0, budget // per_unit))
                if units < 1:
                    continue
                cost = units * per_unit
            else:
                # K0.3: yalnizca tam paket. Level1Capacity == bundle oldugu icin
                # rafta tek birim kalsa bile yenileme imkansiz hale gelir.
                if self.stock[sku] + p["WholesaleBundle"] > self.capacity(sku):
                    continue
                if self.cash - p["WholesaleCost"] < self.policy.restock_reserve:
                    continue
                units = p["WholesaleBundle"]
                cost = p["WholesaleCost"]
            self.cash -= cost
            self.wholesale_spent += cost
            self.stock[sku] += units
            if self.first_stock_at < 0:
                self.first_stock_at = self.t
            self.log(f"stok +{units} {sku} (-{cost} C)")
            return

    def try_upgrade(self):
        if not (self.policy.buy_upgrade and self.commerce_active() and self.level == 1):
            return
        # Yukseltme icin stok tamponu birak; aksi halde kasa bosalir.
        if self.cash >= C["UpgradeCost"] + C["Products"]["orange"]["WholesaleCost"]:
            if self.fix_strand_guard and self.would_strand(C["UpgradeCost"]):
                return
            self.cash -= C["UpgradeCost"]
            self.upgrade_spent += C["UpgradeCost"]
            self.level = 2
            if self.first_upgrade_at < 0:
                self.first_upgrade_at = self.t
            self.log(f"seviye 2 (-{C['UpgradeCost']} C)")

    def try_hire(self):
        if not (self.policy.hire_worker and self.commerce_active()):
            return
        if self.level >= 2 and not self.hired and self.cash >= C["HireCost"] + C["WagePerShift"]:
            if self.fix_strand_guard and self.would_strand(C["HireCost"]):
                return
            if self.first_hire_at < 0:
                self.first_hire_at = self.t
            self.cash -= C["HireCost"]
            self.hire_spent += C["HireCost"]
            self.hired = True
            self.wages_due = False
            self.shift_remaining = C["ShiftSeconds"]
            self.log(f"kasiyer alindi (-{C['HireCost']} C)")

    def try_permit(self):
        if not self.claimed:
            return
        if self.permit and not self.permit_due:
            return
        if self.permit_due and not self.policy.renew_permit:
            return
        fee = C["PermitFee"]
        rescued = False
        short = self.cash < fee or (self.fix_strand_guard and self.would_strand(fee))
        if short:
            # K0.3: cikis yok. K0.4: once tasfiye (ana dongude), stok bitince sinirli
            # kurtarma. K0.4 kurtarmasi kalan tum nakdi aliyordu; K0.4.1 ucreti siler.
            if not self.fix_soft_lock or self.total_stock() > 0:
                return
            if self.rescues >= C["RescueGrantLimit"]:
                return
            self.rescues += 1
            fee = 0 if self.fix_strand_guard else self.cash
            rescued = True
        was_renewal = self.permit and self.permit_due
        self.cash -= fee
        self.permit_spent += fee
        if was_renewal:
            self.renewals += 1
        self.permit = True
        self.permit_due = False
        self.permit_remaining = C["PermitPeriodSeconds"]
        tag = " KURTARMA" if rescued else ""
        self.log(f"pazar kaydi {'yenilendi' if was_renewal else 'alindi'}{tag} (-{fee} C, kasa {self.cash} C)")

    def try_pay_wage(self):
        if self.hired and self.wages_due and self.policy.pay_wage:
            if self.cash >= C["WagePerShift"]:
                if self.fix_strand_guard and self.would_strand(C["WagePerShift"]):
                    return
                self.cash -= C["WagePerShift"]
                self.wages_spent += C["WagePerShift"]
                self.wage_payments += 1
                self.wages_due = False
                self.shift_remaining = C["ShiftSeconds"]
                self.log(f"maas odendi (-{C['WagePerShift']} C)")

    # -- satis ------------------------------------------------------------
    def sell(self, sku: str, units: int, price: int, by_worker: bool):
        self.stock[sku] -= units
        self.cash += price
        self.sales += 1
        self.revenue += price
        if by_worker:
            self.worker_sales += 1
            self.worker_revenue += price
        else:
            self.player_sales += 1
        if self.first_sale_at < 0:
            self.first_sale_at = self.t
        self.log(f"satis {'[kasiyer]' if by_worker else '[oyuncu]'} {units} {sku} +{price} C")

    def make_offer(self, kind: str):
        """pickOffer() kaynagini birebir sirayla modeller."""
        # DRAW: talep secimi
        if self.rng.number() < C["DemandPickChance"]:
            sku = self.demand
        else:
            sku = "bread" if self.demand == "orange" else "orange"
        other = "bread" if sku == "orange" else "orange"
        # K0.3: bu cekim KOSULLU idi (Lua'da da Python'da da kisa devre) — musteri
        # basina cekim sayisi oyuncunun stok durumuna baglaniyordu ve tohum garantisi
        # bozuluyordu. K0.4: zar her zaman atilir, sonuc kosullu kullanilir.
        if self.fix_rng_gate:
            swap_roll = self.rng.number()
            if self.stock[sku] == 0 and self.stock[other] > 0 and swap_roll < 0.8:
                sku = other
        elif self.stock[sku] == 0 and self.stock[other] > 0 and self.rng.number() < 0.8:
            sku = other
        # DRAW: adet
        units = self.rng.integer(1, 3) if sku == "orange" else self.rng.integer(1, 2)
        p = C["Products"][sku]
        mult = (1 + C["DemandBonusRatio"]) if sku == self.demand else 1.0
        ask = max(1, int(p["Retail"] * units * mult + 0.5))
        offer = {"sku": sku, "units": units, "ask": ask, "kind": kind}
        if kind == "Bargainer":
            # DRAW: butce profili
            name = weighted(self.rng, [(n, w) for n, w, _ in BARGAIN_PROFILES])
            max_ratio = next(r for n, _, r in BARGAIN_PROFILES if n == name)
            offer["bid"] = max(1, int(ask * C["BargainBidRatio"] + 0.5))
            offer["counter"] = max(1, int(ask * C["BargainCounterRatio"] + 0.5))
            offer["max_budget"] = max(1, int(ask * max_ratio + 0.5))
            offer["signal"] = name
        else:
            offer["bid"] = ask
            offer["counter"] = ask
            offer["signal"] = "ETIKET"
        return offer

    def resolve_offer(self, offer: dict, worker_handled: bool):
        sku, units = offer["sku"], offer["units"]
        if self.stock[sku] < units:
            self.lost_sales += 1
            self.log(f"KACAN SATIS stok yetersiz ({units} {sku}, elde {self.stock[sku]})")
            return
        if worker_handled and offer["kind"] == "Buyer":
            self.sell(sku, units, offer["ask"], True)
            return
        if offer["kind"] != "Bargainer":
            self.accepts += 1
            self.sell(sku, units, offer["bid"], False)
            return
        # Pazarlik: once karsi teklif, bütçeyi asarsa satis kaybedilir.
        if self.policy.counter_bargain:
            self.counters += 1
            if offer["counter"] <= offer["max_budget"]:
                self.counter_success += 1
                self.sell(sku, units, offer["counter"], False)
            else:
                self.lost_sales += 1
                self.declines += 1
                self.log(f"karsi teklif reddedildi (sinyal {offer['signal']})")
            return
        if self.policy.accept_bargain:
            self.accepts += 1
            self.sell(sku, units, offer["bid"], False)
        else:
            self.declines += 1
            self.lost_sales += 1

    # -- musteri dongusu, K0.4.1 zaman modeli -------------------------------
    # K0Market.server.lua'daki dongu SIRALIDIR: kapi (ticaret + stok + musteri
    # yok) acilinca aralik cekilir ve beklenir, sonra musteri gelir ve dongu o
    # musteri tezgahtan ayrilana kadar baska musteri uretmez. Cekim sirasi Lua ile
    # aynidir (aralik, tur, yuruyus, [goz atma | teklif + sabir], cikis).
    def gate_ready(self) -> bool:
        return self.commerce_active() and self.total_stock() > 0

    def customer_tick(self):
        if self.pending and self.t >= self.pending["at"]:
            job, self.pending = self.pending, None
            if job["kind"] == "arrive":
                self.customer_arrives(job)
            elif self.commerce_active():
                worker_ok = job["worker"] and self.hired and not self.wages_due
                self.resolve_offer(job["offer"], worker_ok)
            else:
                self.lost_sales += 1
                self.log("teklif kayit bitince dustu")
        if self.phase == "busy" and self.pending is None and self.t >= self.busy_until:
            self.phase = "idle"
        if self.phase == "idle" and self.gate_ready():
            self.spawn_at = self.t + self.rng.integer(C["ArrivalGapMin"], C["ArrivalGapMax"])
            self.phase = "gap"
        if self.phase == "gap" and self.t >= self.spawn_at and self.gate_ready():
            kind = weighted(self.rng, VISITOR_WEIGHTS)
            self.phase = "busy"
            if kind == "Passerby":
                self.busy_until = self.t + self.rng.integer(8, 12)
                return
            walk = self.rng.integer(C["ShopperWalkMin"], C["ShopperWalkMax"])
            self.pending = {"kind": "arrive", "at": self.t + walk, "visitor": kind}

    def customer_arrives(self, job):
        kind = job["visitor"]
        if not self.commerce_active():
            self.busy_until = self.t + self.rng.integer(3, 5)
            return
        if kind == "Browser":
            browse = self.rng.integer(3, 8)
            self.busy_until = self.t + browse + self.rng.integer(3, 5)
            return
        offer = self.make_offer(kind)
        self.customers.append((kind, offer["sku"], offer["units"], offer["signal"]))
        patience = self.rng.integer(C["PatienceMin"], C["PatienceMax"])
        worker = self.hired and not self.wages_due and kind == "Buyer"
        response = C["WorkerResponseSeconds"] if worker else self.policy.response_seconds
        exit_walk = self.rng.integer(3, 5)
        if response > patience:
            self.lost_sales += 1
            self.busy_until = self.t + patience + exit_walk
            return
        self.pending = {"kind": "decide", "at": self.t + response, "offer": offer, "worker": worker}
        self.busy_until = self.t + response + exit_walk

    # -- ana dongu --------------------------------------------------------
    def run(self):
        next_arrival = 0
        claim_done = False
        while self.t < self.duration:
            # saniyelik saat
            if self.claimed and self.permit and not self.permit_due:
                self.permit_remaining = max(0, self.permit_remaining - 1)
                if self.permit_remaining == 0:
                    self.permit_due = True
                    self.log("KAYIT BITTI — ticaret durdu")
            if self.hired and not self.wages_due:
                self.shift_remaining = max(0, self.shift_remaining - 1)
                if self.shift_remaining == 0:
                    self.wages_due = True
                    self.log("maas vakti — kasiyer durdu")
            self.demand_remaining = max(0, self.demand_remaining - 1)
            if self.demand_remaining == 0:
                self.demand = "bread" if self.demand == "orange" else "orange"
                self.demand_remaining = C["DemandCycleSeconds"]

            # oyuncu eylemleri
            if not claim_done and self.t >= self.policy.claim_at:
                self.claimed = True
                claim_done = True
                self.log("tezgah sahiplenildi")
            if self.claimed and self.t >= self.policy.claim_at + self.policy.permit_delay:
                self.try_permit()
            self.try_pay_wage()
            self.try_upgrade()
            self.try_hire()
            if self.total_stock() == 0 or self.cash > 120:
                self.try_restock()

            # cikmaz tespiti: hicbir oyuncu eyleminin geri getiremeyecegi durum.
            # K0.4 modeli bunu yalniz K0.3 kurallarinda ariyordu ("not
            # fix_soft_lock"); K0.4 kurallariyla kosan senaryolar cikmazi
            # yapisal olarak GOREMIYORDU. Kural artik her modda ayni.
            if self.dead_locked_at < 0 and self.economy_dead_end():
                self.dead_locked_at = self.t
                self.log(f"CIKMAZ — kasa {self.cash} C, stok {self.total_stock()}, "
                         f"kayit borcu {self.permit_due}, kurtarma {self.rescues}")

            # K0.4 cikmaz cikisi: kayit borcu varken stok tasfiyesine izin ver
            if self.fix_soft_lock and self.permit_due and self.cash < C["PermitFee"]:
                if self.total_stock() > 0:
                    for sku in ("orange", "bread"):
                        if self.stock[sku] > 0:
                            p = C["Products"][sku]
                            salvage = max(1, int(p["Retail"] * C["LiquidationRatio"] + 0.5))
                            self.stock[sku] -= 1
                            self.cash += salvage
                            self.revenue += salvage
                            self.liquidations += 1
                            self.log(f"tasfiye 1 {sku} +{salvage} C (kayit borcu cikisi)")
                            break

            # musteri dongusu
            if self.runtime_timing:
                self.customer_tick()
            elif self.t >= next_arrival:
                gate_open = self.commerce_active() and self.total_stock() > 0
                if self.fix_rng_gate and not gate_open:
                    # K0.4: ticaret kapaliyken ekonomi akisindan cekme yapma
                    next_arrival = self.t + 1
                else:
                    gap = self.rng.integer(C["ArrivalGapMin"], C["ArrivalGapMax"])
                    next_arrival = self.t + gap
                    if gate_open:
                        kind = weighted(self.rng, VISITOR_WEIGHTS)
                        if kind == "Passerby":
                            self.rng.integer(8, 12)
                        else:
                            self.rng.integer(C["ShopperWalkMin"], C["ShopperWalkMax"])
                            if kind == "Browser":
                                self.rng.integer(3, 8)
                            else:
                                offer = self.make_offer(kind)
                                self.customers.append(
                                    (kind, offer["sku"], offer["units"], offer["signal"]))
                                self.rng.integer(C["PatienceMin"], C["PatienceMax"])
                                worker_ok = (self.hired and not self.wages_due
                                             and kind == "Buyer")
                                self.resolve_offer(offer, worker_ok)
                            self.rng.integer(3, 5)
            self.t += 1
        return self

    def summary(self) -> dict:
        return {
            "policy": self.policy.name,
            "seed": self.seed,
            "rng_draws": self.rng.draws,
            "cash": self.cash,
            "level": self.level,
            "hired": self.hired,
            "sales": self.sales,
            "player_sales": self.player_sales,
            "worker_sales": self.worker_sales,
            "revenue": self.revenue,
            "worker_revenue": self.worker_revenue,
            "operating_cost": self.operating_cost(),
            "operating_result": self.operating_result(),
            "lost_sales": self.lost_sales,
            "renewals": self.renewals,
            "wage_payments": self.wage_payments,
            "first_stock_at": self.first_stock_at,
            "first_sale_at": self.first_sale_at,
            "dead_locked_at": self.dead_locked_at,
            "first_upgrade_at": self.first_upgrade_at,
            "first_hire_at": self.first_hire_at,
            "rescues": self.rescues,
            "liquidations": self.liquidations,
            "stock_left": self.total_stock(),
            "stock_value": self.stock_value(),
        }


def run_matrix(fix_rng_gate=False, fix_soft_lock=False, duration=1200,
               fix_strand_guard=False, runtime_timing=False):
    policies = [
        Policy("dengeli"),
        Policy("yavas-baslangic", claim_at=40, permit_delay=90),
        Policy("pazarlik-yok", counter_bargain=False, accept_bargain=True),
        Policy("kasiyersiz", hire_worker=False),
        Policy("yukseltmesiz", buy_upgrade=False, hire_worker=False),
        Policy("talep-korlugu", follow_demand=False),
    ]
    out = []
    for pol in policies:
        sim = Sim(policy=pol, seed=C["PlaytestSeed"], duration=duration,
                  fix_rng_gate=fix_rng_gate, fix_soft_lock=fix_soft_lock,
                  fix_partial_restock=fix_soft_lock, fix_strand_guard=fix_strand_guard,
                  runtime_timing=runtime_timing).run()
        out.append(sim)
    return out


class SingleSkuSim(Sim):
    """Yalniz bir urunu stoklayan vekil: 'demand' talep goreni, 'anti' digerini.

    Talep panosunu izlemenin ekonomik degerini olcmek icin iki uc politika.
    Gercek oyuncu ikisinin arasinda bir yerdedir; fark bir ust sinirdir.
    """
    only = "demand"

    def try_restock(self):
        if not self.commerce_active():
            return
        other = "bread" if self.demand == "orange" else "orange"
        sku = self.demand if self.only == "demand" else other
        p = C["Products"][sku]
        room = self.capacity(sku) - self.stock[sku]
        per_unit = p["WholesaleCost"] // p["WholesaleBundle"]
        units = min(p["WholesaleBundle"], room, self.cash // per_unit)
        if units < 1:
            return
        self.cash -= units * per_unit
        self.wholesale_spent += units * per_unit
        self.stock[sku] += units
        if self.first_stock_at < 0:
            self.first_stock_at = self.t


class OtherSkuSim(SingleSkuSim):
    only = "anti"


def demand_value(seeds, duration=1200, cycle=None, bonus=None) -> dict:
    """Guncel kurallarla yalniz-talep eksi yalniz-diger isletme sonucu.

    cycle/bonus verilirse DemandCycleSeconds/DemandBonusRatio yalniz bu olcum
    icin degistirilir ve sonra geri yuklenir; kaynak config'e dokunulmaz.
    """
    saved = C["DemandCycleSeconds"], C["DemandBonusRatio"]
    if cycle is not None:
        C["DemandCycleSeconds"] = cycle
    if bonus is not None:
        C["DemandBonusRatio"] = bonus
    opts = dict(fix_rng_gate=True, fix_soft_lock=True, fix_partial_restock=True,
                fix_strand_guard=True, runtime_timing=True, duration=duration)
    try:
        diffs, wins, dead, sales_a, sales_b = [], 0, 0, 0, 0
        for seed in seeds:
            a = SingleSkuSim(policy=Policy("talep", hire_worker=False), seed=seed, **opts).run()
            b = OtherSkuSim(policy=Policy("ters", hire_worker=False), seed=seed, **opts).run()
            diffs.append(a.operating_result() - b.operating_result())
            wins += diffs[-1] > 0
            dead += (a.dead_locked_at >= 0) + (b.dead_locked_at >= 0)
            sales_a += a.sales
            sales_b += b.sales
    finally:
        C["DemandCycleSeconds"], C["DemandBonusRatio"] = saved
    n = len(diffs)
    ordered = sorted(diffs)
    median = (ordered[(n - 1) // 2] + ordered[n // 2]) / 2
    return {"n": n, "mean": sum(diffs) / n, "median": median, "wins": wins, "dead": dead,
            "sales_demand": sales_a / n, "sales_other": sales_b / n}


# K0.4.1 raporu §4'teki secenek tablosu. Mevcut deger ilk satirdir.
DEMAND_OPTIONS = [(None, None), (120, 0.15), (180, 0.15), (300, 0.15),
                  (60, 0.30), (180, 0.30), (300, 0.30)]


def print_demand_options(duration: int) -> None:
    seeds = range(2000, 2150)
    print(f"Talep panosu secenekleri — {len(seeds)} tohum (2000-2149), {duration}s, "
          f"guncel kurallar + kaynak zamanlamasi, kasiyersiz")
    print(f"{'dongu':>7}{'bonus':>7}{'ort.fark':>10}{'medyan':>8}{'talep kazanir':>15}"
          f"{'cikmaz':>8}{'satis talep/diger':>19}")
    for cycle, bonus in DEMAND_OPTIONS:
        r = demand_value(seeds, duration, cycle, bonus)
        c = cycle if cycle is not None else C["DemandCycleSeconds"]
        b = bonus if bonus is not None else C["DemandBonusRatio"]
        tag = "  <- mevcut" if cycle is None else ""
        print(f"{c:>6}s{b:>7.2f}{r['mean']:>+10.1f}{r['median']:>+8.1f}"
              f"{r['wins']:>9}/{r['n']:<5}{r['dead']:>8}"
              f"{r['sales_demand']:>11.1f}/{r['sales_other']:<7.1f}{tag}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--verbose", action="store_true")
    ap.add_argument("--duration", type=int, default=C["TargetSessionSeconds"])
    ap.add_argument("--fixed", action="store_true",
                    help="guncel kurallarla (K0.4.1) ve kaynaktaki musteri zamanlamasiyla calistir")
    ap.add_argument("--k04", action="store_true",
                    help="K0.4 raporundaki tabloyu yeniden uret (K0.4 kurallari, anlik musteri modeli)")
    ap.add_argument("--demand-options", action="store_true",
                    help="talep panosu ayar secenekleri tablosu (K0.4.1 raporu §4)")
    args = ap.parse_args()

    if args.demand_options:
        print_demand_options(args.duration)
        return 0

    if args.fixed:
        mode, opts = "K0.4.1", dict(fix_rng_gate=True, fix_soft_lock=True,
                                    fix_strand_guard=True, runtime_timing=True)
    elif args.k04:
        mode, opts = "K0.4 (anlik musteri modeli)", dict(fix_rng_gate=True, fix_soft_lock=True)
    else:
        mode, opts = "K0.3", {}
    print(f"BAYCREST K0 senaryo simulatoru — seed {C['PlaytestSeed']}, "
          f"sure {args.duration}s, mod={mode}")
    print("=" * 94)
    sims = run_matrix(duration=args.duration, **opts)

    hdr = (f"{'politika':<18}{'kasa':>7}{'satis':>7}{'kasiyer':>9}{'ciro':>7}{'sonuc':>8}{'kacan':>7}"
           f"{'yukselt':>9}{'kasiyer@':>9}{'kurtar':>8}{'cikmaz':>8}{'cekim':>7}")
    print(hdr)
    print("-" * 94)
    for sim in sims:
        s = sim.summary()
        print(f"{s['policy']:<18}{s['cash']:>7}{s['sales']:>7}{s['worker_sales']:>9}"
              f"{s['revenue']:>7}{s['operating_result']:>8}{s['lost_sales']:>7}"
              f"{s['first_upgrade_at']:>9}{s['first_hire_at']:>9}{s['rescues']:>8}"
              f"{s['dead_locked_at']:>8}{s['rng_draws']:>7}")

    if args.verbose:
        for sim in sims:
            print()
            print(f"--- {sim.policy.name} ---")
            for line in sim.events:
                print("  " + line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
