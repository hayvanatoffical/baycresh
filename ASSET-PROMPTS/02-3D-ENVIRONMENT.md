# 02 — 3D çevre

**Durum:** TASLAK · K0.4

K0 sahnesi `Workspace/BlackstoneBazaar_K0` altında yaşıyor ve şu anda tamamen Luau `Part` ilkelleriyle kuruluyor (`GAME/SCENE_BUILD.lua`, `GAME/STALL_ART_V3.lua`, `GAME/MARKET_SYSTEM_BUILD.lua`). Bu bölüm o gri kutuların yerine geçecek modelleri tanımlar.

## Kapsam kilidi

K0 tek tezgâhlı bir prototiptir. Aşağıdaki liste **tamdır**; şehir, ikinci sokak, iç mekân, araç ve bina içi K0 kapsamı değildir.

| Kimlik | Karşılığı (kaynak) | Gameplay purpose | Öncelik |
|---|---|---|---|
| `ENV-STALL-01` | `Stall_01` | Oyuncunun sahiplendiği şey | **1** |
| `ENV-STALL-SHELF2` | `Stall_01.Level2Shelf` | Yükseltmenin görünür karşılığı | **1** |
| `ENV-MARKET-DESK` | `MarketSystem.PermitOffice` | Kayıt kararının yeri | **1** |
| `ENV-WHOLESALE-DESK` | `OrangeWholesale` / `BreadWholesale` | Stok ve tasfiye kararının yeri | **1** |
| `ENV-DEMAND-BOARD` | `MarketSystem.DemandBoard` | Talebin okunduğu yer | **1** |
| `ENV-PAVEMENT-MOD` | zemin | Yürünebilir alan | 2 |
| `ENV-FACADE-MOD` | arka plan | Pazarın bir yerde olduğu hissi | 3 |
| `ENV-STREET-MOD` | yaya hattı | Dekoratif kalabalığın yolu | 3 |

Oyuncu 20 dakikada `SalePoint`, `PermitOffice`, iki toptancı tezgâhı ve `DemandBoard` arasında gidip gelir. Bu beş nokta **birbirinden bakışla ayırt edilebilir** olmalıdır; aynı gri kutunun beş kopyası kabul edilmez.

## Ortak teknik şart

- **Modülerlik.** Kaldırım, cephe ve sokak 8 stud ızgarasına oturur; uçları komşu modülle boşluksuz birleşir.
- **Pivot.** Modülün taban merkezinde, ızgaraya hizalı. Tezgâhta pivot ön kenarın ortası (oyuncu yaklaşımı buradan ölçülür).
- **Çarpışma.** Dekoratif geometri (tente saçağı, tabela, süs) `CanCollide = false` varsayımıyla üretilir; yürüme yüzeyi ayrı ve basit kutu çarpışmadır. Karmaşık mesh çarpışması istenmez.
- **Malzeme sayısı.** Modül başına en fazla 2 malzeme. Ortak atlas tercih edilir (`08`).
- **Yön.** Tezgâhın müşteri tarafı +Z'ye bakar; oyuncu tarafı -Z.
- **Etkileşim yüzeyi boş bırakılır.** `ProximityPrompt` taşıyan yüzeylerde (tabela, pano) model üzerine yazı **modellenmez**; yazı `SurfaceGui` ile gelir.

## ENV-STALL-01 — pazar tezgâhı

**Gameplay purpose:** oyuncunun ilk dakikada sahiplendiği tek nesne. Seviye 1'de mütevazı, seviye 2'de görünür biçimde büyümüş olmalı.

```
A single open-air market stall for a warm Mediterranean-Anatolian bazaar, game-ready
low-poly model, lightly stylised, soft rounded edges, medium saturation.

Structure: a rectangular wooden counter about 4 units wide, 1.6 units deep and
1.6 units tall, with four corner posts rising to a simple fabric canopy above.
The canopy is a flat or gently sloped rectangle of cloth with a slight sag between
posts and a short scalloped fringe on the customer-facing edge.

A flat blank sign board is mounted on the front of the canopy, facing the customer
side. The sign must be COMPLETELY BLANK - no text, no letters, no numbers, no logo.
It is a flat quad that a game engine will draw text onto.

The counter top is empty and flat, ready for goods to be placed by the engine.
A single empty lower shelf runs under the counter.

Materials: weathered painted wood for the frame, woven cloth for the canopy.
Maximum two materials total.

Style: clean readable silhouette from 15 units away, no clutter, no products,
no crates, no people, no ground, no background, no surrounding buildings.
Neutral studio lighting, no baked shadows.

Orientation: customer side faces +Z, origin at the centre of the front bottom edge,
+Y up. Real-world scale: counter height 1.10 m.

Budget target: <= 1,500 triangles for the whole stall.
```

**Kabul notu:** tente rengi çalışma zamanında değiştirilir (`TweenService` ile `Canopy.Color`). Bu yüzden tente **beyaza yakın nötr** üretilmeli ki renklendirme temiz otursun.

## ENV-STALL-SHELF2 — seviye 2 rafı

**Gameplay purpose:** 250 ₡ yükseltmesinin görünür karşılığı. Oyuncu parasının nereye gittiğini *görmelidir*; bu yükseltmenin tek geri bildirimi değildir ama en güçlüsüdür.

```
An upper display shelf unit that mounts onto the back of an existing market stall.
Two horizontal wooden shelf boards supported by simple side brackets, spanning the
full 4 unit width of the stall, sitting above the counter and below the canopy.

The shelves are EMPTY. No products, no crates, no baskets.

Same weathered painted wood and same colour family as the stall frame, so it reads
as an addition to the same business rather than a different object.

Low-poly, game-ready, soft rounded edges, no baked shadows, no background.
Origin at the centre of the bottom mounting edge, +Z toward the customer.

Budget target: <= 400 triangles.
```

## ENV-MARKET-DESK — pazar yönetimi

**Gameplay purpose:** kayıt ücretinin ödendiği ve kayıt bittiğinde geri dönülen yer. Kayıt borcu durumunda oyuncunun **buraya bakması** gerekir, dolayısıyla uzaktan tanınmalıdır.

```
A small municipal market registration desk in an open-air bazaar. A compact wooden
booth roughly 2.5 units wide with a service window opening on the customer side,
a narrow counter ledge under the window, and a small flat roof.

A blank rectangular notice board is fixed beside the window, facing the customer.
It must be COMPLETELY BLANK - no text, no letters, no numbers, no posters.

Slightly more formal and better maintained than a produce stall: straighter lines,
painted rather than weathered, a single restrained official accent colour.

Low-poly, game-ready, two materials maximum, no people, no background, no ground.
Origin at the centre of the front bottom edge, service window facing +Z.

Budget target: <= 900 triangles.
```

## ENV-WHOLESALE-DESK — toptancı tezgâhı

**Gameplay purpose:** stok alınan ve K0.4'te **tasfiye yapılan** yer. Aynı model iki kez kullanılır (portakal ve ekmek); ürünü ayıran şey model değil, üstündeki proplar ve `SurfaceGui`'dir.

```
A wholesale supply desk in an open-air bazaar: a sturdy low wooden counter about
3 units wide with a stacked-crate storage frame behind it. The crates in the frame
are empty and generic, suggesting bulk supply without showing any specific produce.

A blank price board is mounted on the front face, facing the customer. It must be
COMPLETELY BLANK - no text, no numbers, no price marks.

Plainer and more utilitarian than the player's own stall: no canopy, no decoration.

Low-poly, game-ready, two materials maximum, no products, no people, no background.
Origin at the centre of the front bottom edge, customer side facing +Z.

Budget target: <= 1,000 triangles.
```

## ENV-DEMAND-BOARD — talep panosu

**Gameplay purpose:** K0'ın karar döngüsünün girdisi. Oyuncu buraya bakıp hangi ürüne para bağlayacağına karar verir. **Uzaktan okunabilirliği bir oynanış şartıdır.**

```
A free-standing market information board: a large flat vertical panel about
2.5 units wide and 2 units tall on two simple legs, tilted back slightly toward
the viewer for readability.

The panel face is COMPLETELY BLANK - no text, no chalk marks, no letters, no
numbers, no drawn produce. It is a flat quad that the engine draws onto.

A simple wooden frame runs around the panel edge. A small fabric awning may sit
above the panel to visually separate it from a plain wall.

The blank face must be a flat, evenly lit, matte, light-coloured surface with no
texture noise, so engine-drawn text stays legible on a phone screen.

Low-poly, game-ready, no background, no people. Panel face toward +Z.

Budget target: <= 300 triangles.
```

## ENV-PAVEMENT-MOD / ENV-FACADE-MOD / ENV-STREET-MOD

**Gameplay purpose:** yalnız bağlam. Bunlar karar taşımaz ve K0 testini etkilemez; en son üretilir.

```
A modular tileable segment of a warm Mediterranean-Anatolian bazaar street,
8 x 8 units, designed to tile seamlessly with identical copies on all four edges.

[PAVEMENT] Flat stone paving with subtle irregular slabs, a shallow kerb along one
edge, no props, no debris, walkable and flat.

[FACADE] A shallow building frontage, maximum 1.5 units deep, low stone and plaster
wall with one shuttered window and a simple cornice. Background only: no doorway the
player can enter, no interior.

[STREET] A flat road segment with a simple kerb on both sides, no markings,
no vehicles.

All: low-poly, game-ready, one material each, edges exactly on the 8 unit grid so
copies snap together with no seam or gap, no baked shadows, no background.
Origin at the centre of the tile base, +Y up.

Budget target: <= 500 triangles per tile.
```

## Performans yaklaşımı

- **LOD:** K0 ölçeğinde (tek tezgâh, dört NPC, dört yaya) LOD gerekmez. Cephe ve sokak modülleri çoğaltılırsa ilk LOD adayı onlardır.
- **Draw call:** kaldırım/cephe/sokak ortak atlasa bağlanır; tezgâh ve toptancı ayrı kalabilir.
- **Ölçüm yok.** Yukarıdaki üçgen sayıları **hedeftir**. Gerçek FPS ve bellek etkisi Android'de ölçülmeden hiçbir belgeye garanti olarak yazılmaz.
