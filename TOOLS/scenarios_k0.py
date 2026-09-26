#!/usr/bin/env python3
"""BAYCREST K0.4 — senaryo dogrulamasi (dogrulama katmani 2).

Yirmi zorunlu senaryoyu GIVEN / WHEN / THEN / FAILURE MODE olarak yurutur.

Iki farkli kanit turu vardir ve KARISTIRILMAZ:

  SCENARIO VERIFIED : TOOLS/simulate_k0.py ekonomi modeli uzerinde gercekten
                      calistirildi ve sonuc olculdu.
  SOURCE VERIFIED   : Roblox calistirilamadigi icin davranis simule edilemez;
                      bunun yerine kaynaktaki kuralin VARLIGI dogrulandi.

Hicbir senaryo "Roblox'ta dogrulandi" demez. Studio ve cihaz kanitlari
PRODUCTION/K0.4_NEXT_TEST_PLAN.md icindeki testlerle toplanir.

Kullanim:
    python3 TOOLS/scenarios_k0.py
    python3 TOOLS/scenarios_k0.py --verbose
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from simulate_k0 import C, Policy, Sim, run_matrix  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
SERVER = (ROOT / "GAME/src/ServerScriptService/K0Market.server.lua").read_text(encoding="utf-8")
HUD = (ROOT / "GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua").read_text(encoding="utf-8")

RESULTS: list[dict] = []


def scenario(num, title, kind, given, when, then, failure_mode, check):
    """check() -> (ok: bool, evidence: str)"""
    try:
        ok, evidence = check()
    except Exception as exc:  # bir senaryonun patlamasi digerlerini durdurmaz
        ok, evidence = False, f"senaryo calistirilamadi: {exc!r}"
    RESULTS.append({
        "num": num, "title": title, "kind": kind, "given": given, "when": when,
        "then": then, "failure_mode": failure_mode, "ok": ok, "evidence": evidence,
    })


def src(pattern: str, text: str = None) -> bool:
    return re.search(pattern, text if text is not None else SERVER) is not None


def fresh(**kw) -> Sim:
    """K0.4 kurallariyla bir oturum."""
    base = dict(fix_rng_gate=True, fix_soft_lock=True, fix_partial_restock=True)
    base.update(kw)
    pol = base.pop("policy", Policy("senaryo"))
    return Sim(policy=pol, seed=C["PlaytestSeed"], **base)


# ---------------------------------------------------------------- 1-5
def s1():
    start = fresh(duration=1).run()
    sim = fresh(duration=30).run()
    # Baslangic kasasi dogru verilmeli ve ilk 30 saniyede hem sahiplik hem kayit
    # hem de ilk stok karari fiilen mumkun olmali.
    ok = (start.cash == C["StartingCash"] and not start.claimed
          and sim.claimed and sim.permit and sim.total_stock() > 0
          and sim.cash >= 0)
    return ok, (f"t=1s kasa {start.cash} C (baslangic {C['StartingCash']} C, sahiplik yok); "
                f"t=30s sahiplik={sim.claimed} kayit={sim.permit} "
                f"stok={sim.total_stock()} birim kasa={sim.cash} C")


def s2():
    sim = fresh(duration=5).run()
    # Sahiplik ucretsiz olmali: sahiplenme aninda kasa degismemeli.
    ok = sim.claimed and sim.cash == C["StartingCash"]
    return ok, f"sahiplik t={sim.policy.claim_at}s, kasa hala {sim.cash} C (ucretsiz)"


def s3():
    sim = fresh(duration=30).run()
    ok = sim.first_stock_at >= 0 and sim.total_stock() > 0
    return ok, f"ilk stok t={sim.first_stock_at}s, elde {sim.total_stock()} birim"


def s4():
    """Talebi gormezden gelen oyuncu cezalandirilmali ama kilitlenmemeli."""
    blind = fresh(policy=Policy("kor", follow_demand=False), duration=1200).run()
    smart = fresh(policy=Policy("takipci", follow_demand=True), duration=1200).run()
    ok = blind.operating_result() < smart.operating_result() and blind.dead_locked_at < 0
    return ok, (f"talep korlugu sonuc {blind.operating_result()} C < "
                f"talep takibi {smart.operating_result()} C; cikmaz yok")


def s5():
    sim = fresh(duration=1200).run()
    aligned = sum(1 for e in sim.events if "Talep yuksek" in e or "stok" in e)
    ok = sim.operating_result() > 0 and aligned > 0
    return ok, f"20 dk sonunda isletme sonucu {sim.operating_result()} C, stok islemi {aligned}"


# ---------------------------------------------------------------- 6-10
def s6():
    sim = fresh(duration=1200).run()
    buyers = [c for c in sim.customers if c[0] == "Buyer"]
    ok = len(buyers) > 0 and sim.sales > 0
    return ok, f"{len(buyers)} normal alici geldi, {sim.sales} satis kapandi"


def s7():
    sim = fresh(duration=1200).run()
    barg = [c for c in sim.customers if c[0] == "Bargainer"]
    signals = {c[3] for c in barg}
    ok = len(barg) > 0 and signals <= {"SIKI", "ORTA", "ESNEK"} and len(signals) > 1
    return ok, f"{len(barg)} pazarlikci, gorulen butce sinyalleri {sorted(signals)}"


def s8():
    sim = fresh(policy=Policy("kabulcu", counter_bargain=False, accept_bargain=True),
                duration=1200).run()
    ok = sim.accepts > 0 and sim.sales > 0
    return ok, f"{sim.accepts} kabul, ciro {sim.revenue} C"


def s9():
    # Reddin stoku TUKETMEDIGINI dogrudan olc: teklif cozulmeden onceki ve sonraki
    # stok ayni kalmali. Oturum istatistigine bakmak bunu kanitlamaz.
    sim = fresh(duration=1)
    sim.stock = {"orange": 5, "bread": 4}
    offer = {"sku": "orange", "units": 2, "ask": 28, "bid": 22, "counter": 25,
             "max_budget": 20, "kind": "Bargainer", "signal": "SIKI"}
    before = dict(sim.stock)
    sim.policy = Policy("retci", counter_bargain=False, accept_bargain=False)
    sim.resolve_offer(offer, worker_handled=False)
    stock_same = sim.stock == before
    counter_fail = fresh(duration=1)
    counter_fail.stock = {"orange": 5, "bread": 4}
    counter_fail.policy = Policy("pazarlikci", counter_bargain=True)
    counter_fail.resolve_offer(dict(offer), worker_handled=False)
    ok = stock_same and sim.declines == 1 and counter_fail.stock == before
    return ok, (f"acik ret: stok {before} -> {sim.stock} (degismedi), ret sayaci {sim.declines}; "
                f"butceyi asan karsi teklif de stoku tuketmedi: {counter_fail.stock}")


def s10():
    # Kuralin kendisini test et, tek bir oturumun sansini degil: sinyal karsi
    # teklifin sonucunu GERCEKTEN belirliyor mu?
    from simulate_k0 import BARGAIN_PROFILES
    rnd = lambda x: max(1, int(x + 0.5))
    asks = sorted({rnd(p["Retail"] * u * m)
                   for sku, p in C["Products"].items()
                   for u in range(1, 4 if sku == "orange" else 3)
                   for m in (1.0, 1 + C["DemandBonusRatio"])})
    rates = {}
    for name, _w, mr in BARGAIN_PROFILES:
        fails = [a for a in asks if rnd(a * C["BargainCounterRatio"]) > rnd(a * mr)]
        rates[name] = len(fails) / len(asks)
    sim = fresh(policy=Policy("pazarlikci", counter_bargain=True), duration=2400).run()
    # SIKI cogunlukla reddetmeli, ESNEK hicbir zaman reddetmemeli.
    ok = (rates["SIKI"] >= 0.8 and rates["ESNEK"] == 0.0
          and rates["SIKI"] > rates["ORTA"] and sim.counters > 0)
    return ok, (f"karsi teklif red orani: SIKI %{rates['SIKI']*100:.0f}, "
                f"ORTA %{rates['ORTA']*100:.0f}, ESNEK %{rates['ESNEK']*100:.0f} — "
                f"sinyal sonucu belirliyor; oturumda {sim.counters} karsi teklif")


# ---------------------------------------------------------------- 11-14 (kaynak)
def s11():
    checks = {
        "tip dogrulamasi": src(r'type\(id\) ~= "number"'),
        "NaN/tam sayi reddi": src(r"id % 1 ~= 0"),
        "eylem beyaz listesi": src(r'action ~= "accept" and action ~= "counter" and action ~= "decline"'),
        "teklif kimligi eslesmesi": src(r"id ~= offer\.id"),
        "hiz siniri": src(r"acceptDecisionCall\(player\)"),
        "pazarlikci olmayana karsi teklif reddi": src(r'action == "counter" and offer\.kind ~= "Bargainer"'),
    }
    ok = all(checks.values())
    return ok, "; ".join(f"{k}={'var' if v else 'YOK'}" for k, v in checks.items())


def s12():
    checks = {
        "sahip disi RemoteEvent reddi": src(r"if not acceptDecisionCall\(player\) then return end\s*\n\s*if player ~= owner"),
        "prompt guard sahiplik kontrolu": src(r"if player ~= owner or not inRange"),
        "izleyici atamasi": src(r"function setSpectator"),
        "tek satici kilidi": src(r"if owner then setSpectator\(player\) else assignOwner\(player\) end"),
    }
    ok = all(checks.values())
    return ok, "; ".join(f"{k}={'var' if v else 'YOK'}" for k, v in checks.items())


def s13():
    checks = {
        "oturum seri numarasi": src(r"state\.sessionSerial"),
        "cikista ozet": src(r'printSessionSummary\("owner_left"\)'),
        "aktor temizligi": src(r"cleanupActors\(\)"),
        "durum sifirlama": src(r"resetState\(\)"),
        "hiz siniri kovasi temizligi": src(r"decisionBuckets\[player\] = nil"),
        "bekleyen islerin iptali": src(r"waitForSession\(gap, serial\)"),
    }
    ok = all(checks.values())
    return ok, "; ".join(f"{k}={'var' if v else 'YOK'}" for k, v in checks.items())


def s14():
    checks = {
        "sirada yeni sahip": src(r"function chooseNextOwner"),
        "ertelenmis atama": src(r"task\.defer\(chooseNextOwner\)"),
        "yeni sahibe temiz durum": src(r"owner = player\s*\n\s*resetState\(\)"),
    }
    ok = all(checks.values())
    return ok, "; ".join(f"{k}={'var' if v else 'YOK'}" for k, v in checks.items())


# ---------------------------------------------------------------- 15-20
def s15():
    """Kasa dibe vurdugunda oyuncunun hala yapabilecegi bir sey olmali."""
    sim = fresh(duration=2400).run()
    lowest = min(
        (int(m.group(1)) for e in sim.events
         for m in [re.search(r"kasa (\d+) C", e)] if m),
        default=sim.cash)
    ok = sim.dead_locked_at < 0
    return ok, f"2400s boyunca cikmaz yok; en dusuk gozlenen kasa {lowest} C"


def s16():
    """Stok bitince yenileme MUMKUN olmali — K0.3'un kilitlendigi yer."""
    k03 = Sim(policy=Policy("dengeli"), seed=C["PlaytestSeed"], duration=1200).run()
    k04 = fresh(policy=Policy("dengeli"), duration=1200).run()
    ok = k04.lost_sales < k03.lost_sales and k04.sales > k03.sales
    return ok, (f"K0.3 satis {k03.sales} / kacan {k03.lost_sales} -> "
                f"K0.4 satis {k04.sales} / kacan {k04.lost_sales}")


def s17():
    """Kayit bitisi ticareti durdurmali ama CIKMAZ yaratmamali."""
    k03 = Sim(policy=Policy("dengeli"), seed=C["PlaytestSeed"], duration=2400).run()
    k04 = fresh(policy=Policy("dengeli"), duration=2400).run()
    ok = k03.dead_locked_at > 0 and k04.dead_locked_at < 0
    return ok, (f"K0.3 t={k03.dead_locked_at}s'de kalici kilit; "
                f"K0.4 kilit yok (tasfiye cikisi + sinirli kurtarma)")


def s18():
    sim = fresh(policy=Policy("yukseltici", buy_upgrade=True, hire_worker=False),
                duration=1200).run()
    ok = sim.level == 2 and sim.upgrade_spent == C["UpgradeCost"]
    return ok, f"seviye {sim.level}, yukseltme gideri {sim.upgrade_spent} C"


def s19():
    """Kasiyer bir YATIRIM olmali, otomatik kazanma dugmesi degil."""
    with_worker = fresh(policy=Policy("kasiyerli", hire_worker=True), duration=2400).run()
    without = fresh(policy=Policy("kasiyersiz", hire_worker=False), duration=2400).run()
    ok = (with_worker.hired and with_worker.worker_sales > 0
          and with_worker.operating_result() < without.operating_result())
    return ok, (f"kasiyerli sonuc {with_worker.operating_result()} C "
                f"({with_worker.worker_sales} kasiyer satisi, maas {with_worker.wages_spent} C) < "
                f"kasiyersiz {without.operating_result()} C — otomatik kazanma degil")


def s20():
    sims = run_matrix(fix_rng_gate=True, fix_soft_lock=True,
                      duration=C["TargetSessionSeconds"])
    locked = [s.policy.name for s in sims if s.dead_locked_at >= 0]
    profitable = [s.policy.name for s in sims if s.operating_result() > 0]
    reached_l2 = [s.policy.name for s in sims if s.level >= 2]
    ok = not locked and len(profitable) == len(sims)
    return ok, (f"{len(sims)} politika x {C['TargetSessionSeconds']}s: cikmaz {len(locked)}, "
                f"kari {len(profitable)}/{len(sims)}, seviye2 {len(reached_l2)}/{len(sims)}")


SIM = "SCENARIO VERIFIED"
SRC = "SOURCE VERIFIED"

scenario(1, "Yeni oyuncu ilk kez girer", SIM,
         "Bos sunucu, oyuncu yok", "Oyuncu katilir",
         "Baslangic kasasi verilir, sahiplik ve kayit yolu acilir",
         "Oyuncu ne yapacagini bilmez veya kasa yanlis baslar", s1)
scenario(2, "Tezgahi sahiplenir", SIM,
         "Oyuncu girdi, tezgah sahipsiz", "Tabelada sahiplenir",
         "Sahiplik UCRETSIZ; kasa degismez",
         "Ilk sahiplik ekonomi grind'inin arkasina saklanir", s2)
scenario(3, "Stok secer", SIM,
         "Sahiplik ve kayit tamam", "Toptanciya gidilir",
         "Stok alinir ve rafta gorunur", "Oyuncu neye para bagladigini goremez", s3)
scenario(4, "Yanlis urun stoklar", SIM,
         "Talep panosu bir urunu gosteriyor", "Oyuncu digerini stoklar",
         "Sonuc daha dusuk olur ama oyun kilitlenmez",
         "Yanlis karar cezalandirilmaz (karar anlamsizlasir) veya oyunu bitirir", s4)
scenario(5, "Talebe uygun urun stoklar", SIM,
         "Talep panosu okunmus", "Talep goren urun stoklanir",
         "Isletme sonucu pozitif", "Dogru karar odullendirilmez", s5)
scenario(6, "Normal musteri gelir", SIM,
         "Ticaret aktif, stok var", "Buyer tipi musteri gelir",
         "Etiket fiyatindan satis mumkun", "Musteri hic gelmez veya satis kapanmaz", s6)
scenario(7, "Pazarlikci musteri gelir", SIM,
         "Ticaret aktif, stok var", "Bargainer tipi musteri gelir",
         "Butce sinyali (SIKI/ORTA/ESNEK) uretilir ve cesitlenir",
         "Sinyal yok veya tek tip — pazarlik gizli zar atmaya doner", s7)
scenario(8, "Kabul eder", SIM,
         "Acik teklif var", "Oyuncu kabul eder",
         "Satis kapanir, kasa artar", "Kabul calismaz veya yanlis fiyat uygulanir", s8)
scenario(9, "Reddeder", SIM,
         "Acik teklif var", "Oyuncu reddeder",
         "Satis olmaz, STOK DEGISMEZ", "Ret stoku tuketir (sessiz kayip)", s9)
scenario(10, "Karsi teklif verir", SIM,
          "Pazarlikci teklifi acik", "Oyuncu karsi teklif verir",
          "Butceye gore tutar veya tutmaz; sonuc sinyalle aciklanabilir",
          "Sonuc gizli zarla belirlenir — oyuncu ogrenemez", s10)
scenario(11, "Sahte/uygunsuz RemoteEvent gonderilir", SRC,
          "Exploiter client keyfi arguman gonderebilir", "Bozuk id/eylem gonderilir",
          "Sunucu tip, aralik, beyaz liste, kimlik ve hiz kontrolunden gecirmeden islemez",
          "Client fiyat/para/durum belirler", s11)
scenario(12, "Baska oyuncu owner islemi yapar", SRC,
          "Iki oyuncu var, biri sahip", "Sahip olmayan islem dener",
          "Sunucu reddeder; sahip olmayan izleyici olarak isaretlenir",
          "Ikinci oyuncu sahibin ekonomisini degistirir", s12)
scenario(13, "Oyuncu islem sirasinda cikar", SRC,
          "Acik teklif ve bekleyen zamanlayicilar var", "Sahip oyundan ayrilir",
          "Oturum serisi artar, aktorler temizlenir, bekleyen isler iptal olur, ozet yazilir",
          "Nil referans hatasi veya onceki oturumun islemi yeni oturuma sizar", s13)
scenario(14, "Owner ayrildiktan sonra yeni sahip", SRC,
          "Sahip ayrildi, sirada oyuncu var", "Yeni sahip atanir",
          "Temiz durumla tek satici olarak atanir",
          "Iki sahip olusur veya tezgah kalici sahipsiz kalir", s14)
scenario(15, "Para minimuma yaklasir", SIM,
          "Kasa dibe iniyor", "Oyuncu harcamaya devam eder",
          "Her zaman yapilabilecek bir eylem kalir",
          "Oyuncu hicbir sey yapamaz hale gelir", s15)
scenario(16, "Stok biter", SIM,
          "Rafta artik birim kaldi", "Oyuncu yenilemek ister",
          "Yenileme MUMKUN olur (rafa sigan kadar)",
          "Tek birim kalinca raf kalici kilitlenir (K0.3 hatasi)", s16)
scenario(17, "Kayit/ruhsat suresi biter", SIM,
          "Kayit suresi doldu, kasa yetersiz", "Oyuncu devam etmek ister",
          "Ticaret durur ama CIKIS YOLU vardir (tasfiye / sinirli kurtarma)",
          "Kalici cikmaz: gelir yolu yok, olcum olur (K0.3 hatasi)", s17)
scenario(18, "Yukseltme alinir", SIM,
          "Kasa yukseltmeye yetiyor", "Seviye 2 alinir",
          "Kapasite buyur, gider kaydedilir", "Yukseltme yalniz sayi buyutur", s18)
scenario(19, "Calisan alinir", SIM,
          "Seviye 2 ve nakit var", "Kasiyer alinir",
          "Kasiyer satis yapar ama maas nedeniyle net getiri kasiyersizden DUSUK kalir",
          "Kasiyer otomatik kazanma dugmesine doner", s19)
scenario(20, "20 dakikalik test tamamlanir", SIM,
          "Alti farkli oyuncu politikasi", "Her biri 1200s oynar",
          "Hicbiri cikmaza girmez, hepsi pozitif isletme sonucu alir",
          "Test suresi icinde oyun kendini kilitler veya ekonomi cokerse olcum gecersiz", s20)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    print("BAYCREST K0.4 — senaryo dogrulamasi (katman 2)")
    print(f"Seed {C['PlaytestSeed']} · hedef oturum {C['TargetSessionSeconds']}s")
    print("=" * 78)

    for r in RESULTS:
        mark = "PASS" if r["ok"] else "FAIL"
        print(f"[{mark}] {r['num']:>2}. {r['title']}  ({r['kind']})")
        if args.verbose or not r["ok"]:
            print(f"        GIVEN   {r['given']}")
            print(f"        WHEN    {r['when']}")
            print(f"        THEN    {r['then']}")
            print(f"        FAILURE {r['failure_mode']}")
        print(f"        KANIT   {r['evidence']}")

    failed = [r for r in RESULTS if not r["ok"]]
    sim_n = sum(1 for r in RESULTS if r["kind"] == SIM)
    src_n = sum(1 for r in RESULTS if r["kind"] == SRC)
    print("=" * 78)
    print(f"{len(RESULTS)} senaryo: {sim_n} simule edildi, {src_n} kaynak kuralindan dogrulandi")
    if failed:
        print(f"FAIL — {len(failed)} senaryo: " + ", ".join(str(r["num"]) for r in failed))
        return 1
    print("PASS — 20/20. Studio ve cihaz kanidi hala BEKLIYOR (STUDIO PENDING / DEVICE PENDING).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
