# 01 — 3D karakterler (NPC)

**Durum:** TASLAK · K0.4
**Bu oturumda görsel üretilmedi.** Aşağıdakiler sonraki görsel/model AI oturumuna verilecek promptlardır.

## K0'ın gerçekten ihtiyacı olan karakterler

Kaynak koddaki `makeNpc` şu anda dört rol üretiyor. Gerçek varlık ihtiyacı bununla sınırlıdır:

| Kimlik | Rol | Oyundaki işi | Öncelik |
|---|---|---|---|
| `NPC-CUST-BUYER` | Normal alıcı | Etiket fiyatını kabul eder | **1** |
| `NPC-CUST-BARGAINER` | Pazarlıkçı | Bütçe sinyali taşır; kararın karşı tarafı | **1** |
| `NPC-CUST-BROWSER` | Bakan müşteri | "Sadece bakıyorum" — tezgâhın canlı görünmesi | 2 |
| `NPC-WORKER-CASHIER` | Kasiyer | Oyuncunun ilk yatırımının görünür karşılığı | 2 |
| `NPC-PEDESTRIAN` | Yoldan geçen | Yalnız dekoratif kalabalık | 3 |

Pazarlıkçı ile normal alıcının **silueti farklı olmalıdır**: oyuncu kim geldiğini teklif kartını açmadan önce anlayabilmelidir. Bu bir oynanış şartıdır, süsleme değil.

## Ortak teknik standart

Bütün karakterler aynı kurallarla üretilir:

- **Roblox R15 uyumlu oran.** Yetişkin ≈ 5 stud. Baş/gövde/bacak oranları R15 rig'ine bağlanabilir olmalı.
- **A-pose.** T-pose değil; omuzlar ~45°. Kol/bacak ayrımı net.
- **Uzuv ayrımı görünür.** Kol gövdeye yapışık modellenmez; rigging sırasında bölünebilmelidir.
- **Basit topoloji.** Dörtgen ağırlıklı, temiz edge flow. Dirsek/diz/omuzda deformasyon için en az 2 halka.
- **Aksesuar ayrı.** Saç, sakal, küpe, çanta, şapka, önlük **ayrı mesh** olarak üretilir ve ayrı dosya olarak teslim edilir. Gövdeye kaynatılmaz.
- **Temiz siluet.** Küçük ekranda 64 px yükseklikte bile rol ayırt edilebilmeli.
- **Simetri.** Aksi belirtilmedikçe sol-sağ simetrik.
- **Pivot.** Ayak tabanının ortası, dünya orijininde; karakter +Z'ye bakar.

## Referans görsel promptu (turnaround)

Model üretiminden önce her karakter için bir referans sayfası istenir.

```
Character reference turnaround sheet, single character, 4 orthographic views in one
image on a plain neutral mid-grey background: front, back, left side, right side.
All four views at IDENTICAL scale, feet aligned on the same ground line, camera
orthographic with no perspective distortion, no foreshortening.

Pose: relaxed A-pose, arms lowered about 45 degrees from the torso, legs shoulder
width apart, palms facing the body, head level and facing forward.

Style: lightly stylised game character, soft rounded forms, readable silhouette,
medium colour saturation, flat even studio lighting, no dramatic shadows, no
rim light, no background scenery, no props on the floor.

Proportions: game-engine humanoid, roughly 6 heads tall, clearly separated limbs,
no clothing that merges arms into the torso, no flowing cloth, no capes.

Accessories (hair, bag, hat, apron, beard) must be drawn as clearly detachable
elements that sit ON the body silhouette, not carved into it.

Output: clean line and colour, no text, no watermark, no logo, no colour chart,
no multiple characters, no collage of variants.
```

### Karakter başına varyasyon bloğu

Yukarıdaki gövdeye şu bloklardan biri eklenir.

**NPC-CUST-BUYER — normal alıcı**
```
Subject: an ordinary adult market shopper in a warm Mediterranean-Anatolian town.
Simple everyday clothes: plain shirt, plain trousers, flat shoes. Neutral friendly
expression. Carries a soft cloth tote bag on one shoulder. Calm, unhurried posture.
Colour palette: muted olive, warm sand, soft terracotta.
```

**NPC-CUST-BARGAINER — pazarlıkçı**
```
Subject: an adult market shopper who clearly intends to negotiate. Same world and
clothing family as the ordinary shopper but a DISTINCT silhouette: a light open
jacket or waistcoat over the shirt, and a small flat cap. One hand free and raised
slightly as if about to gesture a counter-offer. Alert, evaluating expression.
Colour palette: deeper slate blue and warm brown, slightly darker than the ordinary
shopper so the two read apart at small size.
```

**NPC-CUST-BROWSER — bakan müşteri**
```
Subject: an adult passer-by who is only looking. Same clothing family, lighter and
plainer than both buyers, no bag, hands behind the back or in pockets. Relaxed,
uncommitted posture, head turned slightly toward a shelf.
Colour palette: pale sand and washed grey-green, the lowest contrast of the three.
```

**NPC-WORKER-CASHIER — kasiyer**
```
Subject: a young adult market employee. Same world. Wears a simple work apron over
plain clothes as the single strongest identifying feature; the apron must read as a
separate layer. Sleeves rolled. Attentive, service-ready posture, facing forward.
Colour palette: the stall's own accent colour on the apron so the employee visually
belongs to the player's business.
```

**NPC-PEDESTRIAN — yoldan geçen**
```
Subject: a generic adult townsperson walking past, never interacting. Lowest detail
of the set. Plain clothes, no accessories, no bag. Neutral posture mid-stride.
Colour palette: desaturated, must not compete visually with customers at the stall.
```

## 3D model üretim promptu

Referans sayfası onaylandıktan sonra model araca şu promptla verilir.

```
Generate a game-ready 3D character mesh from the supplied 4-view orthographic
reference. Requirements:

- Humanoid proportions matching the reference exactly; do not restyle.
- A-pose as in the reference. Do not output T-pose or a dynamic pose.
- Single watertight body mesh. Accessories as SEPARATE meshes in the same file,
  named: HAIR, BAG, HAT, APRON, BEARD (only those present).
- Clean quad-dominant topology. Edge loops at shoulder, elbow, wrist, hip, knee,
  ankle and neck so the mesh deforms without collapsing.
- No interpenetrating geometry between body and accessories.
- Symmetrical along X unless the reference shows otherwise.
- Origin at the centre of the feet, character facing +Z, +Y up.
- Real-world scale: total height 1.40 m (this maps to ~5 Roblox studs).
- Single UV set, no overlapping shells except mirrored halves, 0-1 space.
- One base colour texture; no baked shadows, no baked ambient occlusion darkening,
  no baked highlights. Lighting is done by the engine.

Budget targets (hedef, ölçüm değil):
- Body: <= 3,000 triangles.
- Each accessory: <= 500 triangles.
- Texture: 1024x1024 maximum, 512x512 preferred.
```

## Roblox'a alma notları

- Karakter Roblox'ta **R15 rig** ile kullanılacaksa Avatar Setup / Rig Builder akışından geçirilir. Bu adım Studio gerektirir ve bu pakette **NEEDS STUDIO** olarak işaretlidir.
- K0 kapsamında NPC'lerin oynatılabilir avatar olması gerekmez; `Model` + `MeshPart` yeterlidir. Tam R15 rig'i animasyon (`04`) gerektiğinde zorunlu olur.
- Roblox'un mesh içe aktarma sınırları ve avatar kuralları değişebilir; içe aktarmadan önce Creator Hub'daki güncel mesh/avatar sayfası kontrol edilir. Bu pakette ölçülmüş bir sınır değeri yazılmamıştır.

## Tool adaptation

- **Meshy (free plan):** çıktı CC BY 4.0'dır ve **Meshy atfı zorunludur**. Ayrıntı `11-LICENSE-AND-PROVENANCE.md`.
- **Meshy (paid plan):** çıktı müşteriye aittir, atıf gerekmez.
- **Tripo (free):** ticari kullanım verilmiyor; K0 yayın adayı olarak kullanılmaz.
- **Roblox Studio AI mesh generation:** Studio içinde üretilir, provenance metadata'sı kaldırılmaz.
- Görsel referans için OpenAI görsel üretimi konsept aşamasında uygundur; doğrudan oyun varlığı değildir.

## Bu oturumda yapılmayanlar

- Karakter görseli üretilmedi (istenmedi).
- Hiçbir mesh üretilmedi veya Roblox'a yüklenmedi.
- Üçgen/doku hedefleri ölçülmedi; hedef olarak yazıldı.
