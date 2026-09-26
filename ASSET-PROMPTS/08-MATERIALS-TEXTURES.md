# 08 — Malzemeler ve dokular

**Durum:** TASLAK · K0.4

Bu dosya stil ailesini tanımlar. `01`–`03` içindeki bütün modeller buradaki malzeme setinden beslenir; başka malzeme eklenmesi bir tasarım kararıdır ve `KARARLAR.md`'ye yazılır.

## Stil tanımı

**Hafif stilize, malzeme-doğru, düşük frekanslı.**

- Foto-gerçekçi değil: gözenek, mikro çizik ve gerçek kir haritası istenmez.
- Çizgi roman da değil: kalın kontur, el çizimi gölge, abartılı renk yok.
- Malzeme **kendini renk ve büyük desenle** anlatır, doku detayıyla değil.
- Bütün dokular **orta doygunluk** ve **sıcak** taraftadır. Soğuk mavi-gri palet Verania'nın pazar bölgesine ait değildir.

Gerekçe: telefon ekranında 8–15 stud mesafeden yüksek frekanslı doku detayı görünmez ama doku belleğini ve indirme süresini gerçekten harcar.

## Malzeme ailesi

K0'ın tamamı **altı malzeme** ile kurulabilir. Bu bir üst sınırdır.

| Kimlik | Nerede | Öncelik |
|---|---|---|
| `MAT-WOOD-PAINTED` | Tezgâh iskeleti, raflar, tabela | **1** |
| `MAT-CLOTH-CANOPY` | Tente, önlük, çanta | **1** |
| `MAT-PRODUCE` | Portakal ve ekmek yüzeyi | **1** |
| `MAT-CARDBOARD-CRATE` | Kasa, kutu | 2 |
| `MAT-STONE-PAVING` | Kaldırım, sokak | 2 |
| `MAT-METAL-PAINTED` | Ödeme tepsisi, menteşe, ayak | 3 |

## Ortak teknik şart

- **Tileable (seamless).** Bütün yüzey dokuları dört kenardan kusursuz tekrar etmeli.
- **Çözünürlük:** 512×512 varsayılan. 1024×1024 yalnız tezgâh ve cephe için, gerekçesi yazılarak.
- **Albedo yalnız.** Normal/roughness haritası K0'da istenmez; Roblox `SurfaceAppearance` kullanımı K1'e ertelendi.
- **Pişmiş aydınlatma yok.** Doku içinde gölge, ambient occlusion koyulaştırması, highlight veya yön ışığı olmayacak. Aydınlatmayı motor yapar.
- **Pişmiş kenar yok.** Kenar aşınması geometriden veya vertex renginden gelir, dokudan değil.
- **Atlas hedefi.** `MAT-CARDBOARD-CRATE`, `MAT-STONE-PAVING` ve `MAT-METAL-PAINTED` tek bir 1024×1024 atlasa yerleşebilir. Bu, çizim çağrısını düşürür.

## Ortak prompt gövdesi

```
A seamless tileable PBR-style albedo texture for a stylised low-poly game.

Requirements:
- Perfectly tileable on all four edges with no visible seam and no repeating
  hero detail that becomes obvious when tiled across a large surface.
- Flat even lighting. NO baked shadows, NO baked ambient occlusion, NO baked
  highlights, NO directional light, NO vignette.
- Low frequency detail only: the material must read from several metres away.
  No micro-scratches, no fine pores, no photographic grain, no dirt overlay.
- Medium colour saturation, warm colour temperature.
- Square image, no border, no text, no watermark, no colour swatch, no label.
- Albedo / base colour only. Do not produce a normal map, roughness map or
  material preview sphere.

Material: [see below]
```

## Malzeme tanımları

```
[MAT-WOOD-PAINTED]
Weathered painted softwood planking for a market stall. A warm terracotta-red paint
layer worn thin along the plank direction so pale timber shows through in broad
patches, not in fine scratches. Visible plank joins spaced widely. Matte.

[MAT-CLOTH-CANOPY]
Coarse woven awning fabric, off-white with evenly spaced broad vertical stripes in
a muted warm ochre. The weave is suggested by a soft regular texture, not by
individual visible threads. Slightly dusty. Matte, no sheen.

[MAT-PRODUCE]
A subtle organic surface base for stylised fruit and bread skin. Very gentle uneven
tonal variation with soft rounded mottling, no pores, no seeds, no slashes, no
specific fruit shape. This is a base layer that is tinted per product by the engine,
so it must be near-neutral in hue and mid-value.

[MAT-CARDBOARD-CRATE]
Pale untreated softwood slats for produce crates, with a light grey-tan tone and
broad soft grain lines running in one direction. Clean, lightly used, no stains,
no printed labels, no text, no stencil marks.

[MAT-STONE-PAVING]
Irregular stone paving slabs for a warm town square. Slabs of varying size in a
sand-grey to warm-beige range, separated by narrow darker joints. Surface is smooth
and worn. No cracks, no puddles, no moss, no debris, no drain covers.

[MAT-METAL-PAINTED]
Painted sheet metal in a muted dark slate colour, with broad soft wear revealing a
duller grey beneath along the larger forms. Matte, low reflectivity, no rust
streaks, no rivets, no scratches.
```

## Renk paleti

Bütün malzemeler bu paletten türetilir. Palet, mevcut HUD renkleriyle (`K0MarketHUD.client.lua`) uyumlu seçilmiştir ki dünya ile arayüz aynı oyuna ait görünsün.

| Rol | RGB | Nerede |
|---|---|---|
| Krem (ana açık) | `237, 226, 206` | Tente, kart, metin |
| Terracotta (vurgu) | `163, 74, 50` | Tezgâh boyası, tente rengi |
| Sıcak turuncu (vurgu 2) | `235, 153, 105` | HUD vurgu, fiyat |
| Koyu yeşil-gri (zemin) | `35, 43, 45` | HUD paneli, koyu metal |
| Zeytin (doğal) | `111, 132, 89` | Kumaş, bitki |
| Kum (nötr) | `206, 192, 155` | Kaldırım, kasa, çanta |

`Canopy.Color` çalışma zamanında `163, 74, 50` değerine tween ediliyor (sahiplenme anında). Bu yüzden `MAT-CLOTH-CANOPY` **nötr/açık** üretilmeli; renklendirme motor tarafından yapılacak. Dokunun içine terracotta boyanırsa tween görünmez olur.

## Atlas planı

```
1024 x 1024 ortak atlas:
  [0,0   - 512,512]   MAT-CARDBOARD-CRATE
  [512,0 - 1024,512]  MAT-STONE-PAVING
  [0,512 - 512,1024]  MAT-METAL-PAINTED
  [512,512- 1024,1024] yedek / gelecek malzeme
```

`MAT-WOOD-PAINTED`, `MAT-CLOTH-CANOPY` ve `MAT-PRODUCE` ayrı 512×512 dosyalar olarak kalır: üçü de tile oranı farklı yüzeylerde kullanılıyor ve atlasa konursa kenar kanaması olur.

## Doğrulama sınırı

Buradaki çözünürlük ve malzeme sayısı hedefleri **ölçülmemiştir**. Android'de gerçek bellek ve FPS etkisi ölçülene kadar hiçbiri platform garantisi olarak yazılmaz. İlk ölçüm `PRODUCTION/K0.4_NEXT_TEST_PLAN.md` içindeki cihaz testinde alınır.
