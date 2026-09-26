# 07 — UI ve ikonografi

**Durum:** TASLAK · K0.4
**Bu dosya görsel üretmez.** Sonraki görsel AI oturumuna verilecek promptları tutar.

## Kaynak bağlantısı

`K0MarketHUD.client.lua` şu anda **tamamen metin tabanlı**: "Kasa 180 ₡", "Portakal 8 kg | Ekmek 6 adet", "Talep Portakal +15% / 42 sn". Telefon ekranında bu satırlar hızlı taranamıyor. İkonlar metni değiştirmez, **metnin yanına** gelir ve tarama hızını artırır.

## İkon listesi

| Kimlik | HUD'daki yeri | Ne anlatır | Öncelik |
|---|---|---|---|
| `ICON-CASH` | `cashLabel` | Kasa | **1** |
| `ICON-ORANGE` | `stockLabel`, teklif kartı | Portakal stoğu | **1** |
| `ICON-BREAD` | `stockLabel`, teklif kartı | Ekmek stoğu | **1** |
| `ICON-DEMAND-UP` | `demandLabel` | Talep yüksek ürün | **1** |
| `ICON-PERMIT` | `permitLabel` | Pazar kaydı durumu | **1** |
| `ICON-LEVEL` | `ownershipLabel` | Tezgâh seviyesi | 2 |
| `ICON-WORKER` | `workerLabel` | Kasiyer durumu | 2 |
| `ICON-ACCEPT` | teklif kartı "Sat" | Kabul | 2 |
| `ICON-COUNTER` | teklif kartı "Karşı teklif" | Pazarlık | 2 |
| `ICON-DECLINE` | teklif kartı "Reddet" | Ret | 2 |
| `ICON-BUDGET-TIGHT/MID/LOOSE` | `offerSignal` | SIKI / ORTA / ESNEK | 2 |
| `ICON-LIQUIDATE` | K0.4 tasfiye durumu | Zararına satış | 3 |

## Değişmez şart: küçük boyutta okunabilirlik

Bu setin tek gerçek zorluğu budur.

- **Tasarım boyutu 24×24 px.** Bütün ikonlar 24 px'te okunabilir olmak zorunda; 256 px'te güzel görünmesi bir şey ifade etmez.
- **Tek renk siluet + en fazla bir vurgu rengi.** İki renkten fazlası 24 px'te çamurlaşır.
- **Çizgi kalınlığı ≥ 2 px** (24 px ızgarada). İnce çizgi telefonda kaybolur.
- **İç boşluk ≥ 2 px.** Kenara dayanan ikon kırpılmış görünür.
- **Renk körlüğü güvenliği.** Hiçbir bilgi **yalnız** renkle taşınmaz. `ICON-DEMAND-UP` yukarı ok taşır, yeşil olduğu için değil. Bütçe sinyalleri (SIKI/ORTA/ESNEK) **farklı biçim** kullanır, farklı renk değil.
- **Dolu form tercih edilir**, ince kontur değil.

## Ortak prompt gövdesi

```
A single flat vector game UI icon, designed to be legible at 24x24 pixels.

Style: solid filled shapes with a clear outer silhouette, minimal internal detail,
soft rounded corners, no gradients, no drop shadows, no bevel, no glow, no 3D
perspective, no outline sketch style.

Colour: one base colour plus at most one accent colour. Flat fills only.

Composition: single centred subject on a fully transparent background, with a small
even margin on all sides. No text, no numbers, no letters, no currency symbol,
no border, no frame, no badge, no background circle or square.

Line weight: any internal line must be at least 2 pixels wide on a 24x24 grid.

Deliver as a clean square image with transparency. One icon only, not a sheet,
not a grid of variants, not a collage.

Subject: [see below]
```

## Konu tanımları

```
[ICON-CASH]        A small stack of two or three coins seen at a slight angle,
                   simplified to overlapping discs. Warm gold accent.
                   Not a banknote, not a wallet, not a money bag, not a dollar sign.

[ICON-ORANGE]      A single round citrus fruit with one small leaf at the top.
                   Warm orange accent. Perfectly round silhouette - this must be
                   instantly distinguishable from the bread icon by SHAPE alone.

[ICON-BREAD]       A single oval loaf of bread with two short diagonal slashes on
                   top. Warm golden-brown accent. Clearly elongated horizontally -
                   never round.

[ICON-DEMAND-UP]   A bold upward-pointing arrow with a short horizontal baseline
                   under it, suggesting a rising level. The arrow shape alone must
                   communicate "higher demand" with no colour and no text.

[ICON-PERMIT]      A simple document sheet with one folded corner and a small round
                   seal or stamp mark in the lower area. Not a padlock, not a badge,
                   not a certificate ribbon.

[ICON-LEVEL]       Two horizontal shelf bars stacked with a gap between them, the
                   upper bar slightly shorter. Reads as "the stall gained a level".
                   Not a star, not a chevron, not a number.

[ICON-WORKER]      A simple head-and-shoulders bust wearing an apron, the apron
                   shown as a distinct trapezoid across the chest. The apron is the
                   identifying feature. Not a generic user avatar, not a tie.

[ICON-ACCEPT]      A bold check mark with thick even strokes.

[ICON-COUNTER]     Two short horizontal arrows pointing toward each other at
                   different heights, suggesting an exchange of offers.
                   Not a handshake, not a chat bubble, not a scale.

[ICON-DECLINE]     A bold X with thick even strokes, clearly different in silhouette
                   from the check mark at small size.

[ICON-BUDGET-TIGHT]   A narrow vertical bar, filled only at the bottom third,
                      inside a thin capsule outline. Shape communicates "little
                      room". Must be distinguishable from the other two budget
                      icons WITHOUT colour.
[ICON-BUDGET-MID]     The same capsule filled to about two thirds.
[ICON-BUDGET-LOOSE]   The same capsule filled almost completely.

[ICON-LIQUIDATE]   A crate with a downward arrow emerging from it, suggesting stock
                   leaving at a loss. Muted, neutral accent - not red, not alarming.
```

## Bütçe sinyali tasarım kararı

`SIKI / ORTA / ESNEK` şu anda HUD'da **yalnız metin** olarak gösteriliyor (`offerSignal.Text`). Bu K0'ın en önemli tek bilgisi: pazarlıkta karşı teklifin tutup tutmayacağını belirleyen sinyal budur.

Üç ayrı ikon yerine **tek bir doluluk göstergesi**nin üç durumu seçildi. Sebep: oyuncu üç ayrı sembolü ezberlemek zorunda kalmaz, doluluk miktarını doğrudan okur. Bu, `06-ARAYUZ-VE-SES.md`'deki erişilebilirlik ilkesiyle uyumludur.

## Teslim biçimi

- **SVG** tercih edilir (ölçeklenir, küçük).
- Roblox `ImageLabel` PNG ister; SVG'den 64×64 ve 128×128 PNG dışa aktarılır.
- Bütün set **tek bir sprite sheet**'e konabilir; `ImageRectOffset` ile kullanılır. Bu, doku yükleme sayısını azaltır.
- Dosya adı `ICON-*` kimliğiyle birebir aynı olmalı ki `ASSET_PROVENANCE.md` kaydıyla eşleşsin.

## Kabul kontrolü

Her ikon için `10-ASSET-VALIDATION.md` doldurulur. İkonlara özel iki ek test:

1. **24 px testi.** İkon 24 px'e küçültülüp telefon ekranında bakılır. Ne olduğu anlaşılmıyorsa reddedilir.
2. **Gri tonlama testi.** İkon gri tonlamaya çevrilir. Portakal/ekmek ve üç bütçe sinyali hâlâ ayırt edilebiliyor olmalı. Ayırt edilemiyorsa biçim yeniden tasarlanır.
