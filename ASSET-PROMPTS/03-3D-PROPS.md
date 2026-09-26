# 03 — 3D proplar

**Durum:** TASLAK · K0.4

Proplar K0'ın **en yüksek öncelikli** varlık grubudur. Oyuncunun kararı iki ürün arasında olduğu için ekmek ile portakalın küçük ekranda anında ayrılması doğrudan bir oynanış şartıdır.

## Kaynak bağlantısı

`K0Market.server.lua` içindeki `visibleUnits()` fonksiyonu `Unit_1` … `Unit_N` adlı `BasePart`'ların `Transparency` değerini açıp kapatarak stok gösteriyor. Yani:

- Her ürün için **tek bir birim mesh'i** gerekir; sahne onu N kez çoğaltır.
- Birim mesh'leri `OrangeFront` (8 adet), `BreadFront` (6 adet), `OrangeUpper` (8), `BreadUpper` (6) altında yaşar.
- Bu yüzden birim modeli **tek başına ve tekrar edildiğinde** iyi görünmelidir.

## Prop listesi

| Kimlik | Karşılığı | Gameplay purpose | Öncelik |
|---|---|---|---|
| `PROP-ORANGE-UNIT` | `Unit_n` (OrangeFront/Upper) | Stok birimi, 1 kg portakal | **1** |
| `PROP-BREAD-UNIT` | `Unit_n` (BreadFront/Upper) | Stok birimi, 1 adet ekmek | **1** |
| `PROP-CRATE` | toptancı / raf | Toptan alımın görsel dili | **1** |
| `PROP-PRICE-TAG` | `OrangePrice` / `BreadPrice` | Fiyatın dünyada okunduğu yer | **1** |
| `PROP-TOTE-BAG` | NPC aksesuarı | Müşterinin alışverişe geldiği sinyali | 2 |
| `PROP-CASH-TRAY` | `SalePoint` | Ödemenin gerçekleştiği yer | 2 |
| `PROP-SMALL-SIGN` | tezgâh tabelası | Sahiplik hissi | 2 |
| `PROP-SHELF-BOX` | raf dolgusu | Boş rafın çıplak durmaması | 3 |

## Ortak şart

- **Tek birim = tek mesh.** Yığın modellenmez; yığını motor kurar.
- **Pivot tabanda.** Birim propların pivotu alt yüzeyin merkezinde olmalı ki rafa oturduğunda gömülmesin.
- **Çarpışmasız.** Vitrin propları `CanCollide = false`; çarpışma gerekmiyor.
- **Ölçek.** Portakal ≈ 0.30 stud çap. Ekmek ≈ 0.85 stud uzunluk. İkisi **belirgin biçimde farklı boyutta** olmalı.
- **Siluet ayrımı.** Portakal küre, ekmek uzun ve köşeli. Renk körü bir oyuncu bile ayırt edebilmeli.

## PROP-ORANGE-UNIT

```
A single orange fruit, game-ready low-poly 3D model, lightly stylised.

Shape: a slightly flattened sphere with a small dimple at the stem end and one
small flat green leaf attached at the stem. Gentle surface irregularity so it does
not read as a perfect ball, but no deep pores.

Colour: warm saturated orange, slightly lighter on top. Matte, not glossy, not wet.

Must look correct BOTH alone and when 8 copies are stacked in a shallow row.
Therefore: no strong unique marking, no single hero highlight, no asymmetric bruise.

Real-world scale: 8 cm diameter. Origin at the centre of the bottom of the fruit,
+Y up. Single material, single UV set, no baked shadows, no background, no plate,
no crate, no hands, no other fruit.

Budget target: <= 150 triangles.
```

## PROP-BREAD-UNIT

```
A single loaf of bread, game-ready low-poly 3D model, lightly stylised.

Shape: an elongated oval loaf with a rounded top and three shallow diagonal slashes
across the crust. Clearly longer than it is wide, so its silhouette can never be
confused with a round fruit.

Colour: warm golden brown crust, slightly darker in the slashes. Matte.

Must look correct BOTH alone and when 6 copies are laid in a row.

Real-world scale: 24 cm long. Origin at the centre of the bottom of the loaf,
+Y up. Single material, single UV set, no baked shadows, no background, no board,
no basket, no crumbs, no slices, no other bread.

Budget target: <= 200 triangles.
```

## PROP-CRATE

```
An empty shallow wooden produce crate, game-ready low-poly.

Shape: a rectangular open-top crate with slatted sides and visible gaps between
the slats, corner posts slightly taller than the walls so crates can stack.

EMPTY. No produce inside.

Colour: pale untreated wood with light wear at the corners.

Real-world scale: 40 x 30 x 14 cm. Origin at the centre of the base, +Y up.
Single material, no baked shadows, no background, no contents, no labels, no text.

Budget target: <= 300 triangles.
```

## PROP-PRICE-TAG

**Gameplay purpose:** talep bonusu uygulandığında fiyat burada değişiyor (`setPriceTag`). Yani bu prop **dinamik veri gösteren bir yüzeydir**; üzerine yazı modellenmez.

```
A small market price tag holder, game-ready low-poly.

Shape: a simple flat rectangular card about 20 x 12 cm held at a slight backward
tilt by a thin wire or wooden stake, so the card faces a standing customer.

The card face is COMPLETELY BLANK - no text, no numbers, no currency symbol, no
printed lines. It is a flat quad that the game engine draws text onto.

The blank face must be light, matte and evenly lit with no texture noise so
engine-drawn text stays legible at small size on a phone screen.

Colour: off-white card, dark thin frame edge.

Origin at the base of the stake, card facing +Z. Single material, no baked shadows,
no background.

Budget target: <= 80 triangles.
```

## PROP-CASH-TRAY

```
A small shallow payment tray for a market counter, game-ready low-poly.

Shape: a shallow rounded rectangular dish with a low lip, about 22 x 16 x 3 cm,
with a simple ridged base. Empty.

Colour: worn dark metal or dark painted wood, matte.

Origin at the centre of the base, +Y up. Single material, no coins, no notes,
no baked shadows, no background.

Budget target: <= 120 triangles.
```

## PROP-TOTE-BAG / PROP-SMALL-SIGN / PROP-SHELF-BOX

```
[TOTE BAG] A soft cloth shopping tote with two loop handles, hanging as if held at
the side, slightly slumped and partly full but with no visible contents. Woven
fabric, warm off-white with one simple stripe. 35 x 40 cm. Must be a SEPARATE mesh
suitable for attaching to a character's hand or shoulder.

[SMALL SIGN] A small hanging wooden sign board with two short chains at the top.
Face COMPLETELY BLANK - no text, no letters, no carving. 60 x 25 cm. Face toward +Z.

[SHELF BOX] A small closed generic storage box for filling empty shelf space.
Plain cardboard or thin wood, no branding, no text, no labels. 25 x 18 x 15 cm.

All: game-ready low-poly, single material each, matte, no baked shadows, no
background, origin at the natural resting/mounting point.
Budget target: <= 200 triangles each.
```

## Neden ayrıntı istenmiyor

Bu proplar ekranda çoğunlukla **8-15 stud uzaktan ve telefon ekranında** görünür. Portakalın gözenek dokusu bu mesafede bir piksele düşer ama üçgen bütçesini ve doku belleğini gerçekten harcar. K0'ın sorusu görsel kalite değil, karar okunabilirliğidir; prop bütçesi buna göre kısılmıştır.
