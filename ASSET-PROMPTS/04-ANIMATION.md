# 04 — Animasyon

**Durum:** TASLAK · K0.4
**Rig varsayımı:** Roblox R15.

## Mevcut durum

K0 kaynağında animasyon **yoktur**. NPC'ler `moveNpc()` içinde bir `CFrameValue` tween'i ile kayarak hareket ediyor — yürüme animasyonu olmadan. Bu prototip için kabul edilmiş bir kısayoldur ve `PRODUCTION/K0.4_KNOWN_LIMITATIONS.md` içinde kayıtlıdır.

Bu dosya, gerçek rig'e geçildiğinde üretilecek **minimum** seti tanımlar. Liste bilinçli olarak kısadır: K0'ın test ettiği şey animasyon kalitesi değildir.

## Minimum set

| Kimlik | Loop | Süre | Root motion | Gameplay purpose | Öncelik |
|---|---|---|---|---|---|
| `ANIM-IDLE` | evet | 3.0 s | hayır | NPC beklerken canlı görünsün | **1** |
| `ANIM-WALK` | evet | 1.0 s | **hayır** | Yürüme; konum kodla sürülür | **1** |
| `ANIM-WAIT-QUEUE` | evet | 4.0 s | hayır | Müşteri sabırsızlanıyor sinyali | **1** |
| `ANIM-HAND-ITEM` | hayır | 1.2 s | hayır | Satışın görsel kapanışı | **1** |
| `ANIM-RECEIVE-ITEM` | hayır | 1.2 s | hayır | Müşteri malı alır | 2 |
| `ANIM-INSPECT` | hayır | 2.0 s | hayır | "Sadece bakıyorum" | 2 |
| `ANIM-PAY` | hayır | 1.0 s | hayır | Para el değiştirir | 2 |
| `ANIM-REJECT` | hayır | 1.5 s | hayır | Pazarlık reddi | 2 |
| `ANIM-SALE-SUCCESS` | hayır | 1.5 s | hayır | Oyuncu tarafı kutlama | 3 |

## Root motion kararı

**Hiçbir animasyonda root motion istenmez.** Gerekçe: `moveNpc()` konumu sunucu tarafından tween ile sürüyor ve müşteri yolu (`CustomerEntry → CustomerQueue → CustomerExit`) kodla belirleniyor. Animasyon kökü de hareket ederse iki yazar aynı konuma yazar ve NPC kayar veya seğirir.

Yürüyüş animasyonu bu yüzden **yerinde adım** olarak üretilir; ilerlemeyi kod sağlar. Bu, `EKIP/04-TEKNIK.md` içindeki "tek yazar kuralı"nın animasyondaki karşılığıdır.

## Ortak teknik şart

- **Rig:** Roblox R15 iskelet hiyerarşisi. 15 parça: HumanoidRootPart, LowerTorso, UpperTorso, Head, ve sol/sağ Upper/Lower Arm, Hand, Upper/Lower Leg, Foot.
- **Kare hızı:** 30 fps. Roblox `KeyframeSequence`'e aktarılacak.
- **Loop animasyonlarında ilk ve son kare aynı olmalı** (seamless). Aksi halde döngüde zıplama olur.
- **Nötr başlangıç.** Non-loop animasyonlar idle duruşundan başlayıp idle duruşunda biter ki `AnimationTrack` geçişleri yumuşasın.
- **Abartı sınırı.** Omuz/kalça rotasyonu 35°'yi aşmasın; R15 parçaları ayrık olduğu için aşırı rotasyonda eklem açılır.
- **Yüz yok.** R15 baş tek parçadır; yüz animasyonu istenmez.
- **Parmak yok.** R15 elde parmak eklemi yoktur.

## Prompt şablonu

Animasyon üretimi araca göre çok değişir (text-to-motion, mocap kütüphanesi, elle anahtar kare). Ortak istek metni:

```
Generate a humanoid character animation for a game engine rig with a 15-bone
structure equivalent to Roblox R15: root, lower torso, upper torso, head,
upper arm / lower arm / hand and upper leg / lower leg / foot on both sides.

Constraints:
- 30 fps.
- NO root motion. The root bone must stay at the origin for the whole clip;
  forward travel is driven by game code, not by the animation.
- No finger bones, no facial bones, no tail, no props.
- Shoulder and hip rotation must stay under 35 degrees to avoid joint separation
  on a rig made of detached segments.
- The clip starts and ends in a relaxed standing pose.
- [LOOP ONLY] The first and last frame must be identical for a seamless loop.

Clip: [see per-clip description below]
Duration: [see table]
```

### Klip açıklamaları

**ANIM-IDLE** (loop, 3.0 s)
```
A relaxed standing idle for an ordinary adult. Very subtle weight shift from one
foot to the other, slow shallow breathing in the chest, occasional tiny head
settle. Extremely low amplitude - this plays constantly and must not draw attention.
```

**ANIM-WALK** (loop, 1.0 s)
```
A walk cycle performed IN PLACE. Natural relaxed adult walking pace, roughly two
steps per second, arms swinging in opposition to the legs, slight torso counter
rotation. The root stays fixed at the origin; only the limbs and torso move.
```

**ANIM-WAIT-QUEUE** (loop, 4.0 s)
```
A standing wait that reads as mild impatience without being comic. Weight shifts
between feet, one arm crosses loosely over the body, an occasional small glance
to the side and back. Slightly more movement than the neutral idle so a player can
tell at a glance that this customer is waiting on them.
```

**ANIM-HAND-ITEM** (non-loop, 1.2 s)
```
From a relaxed standing pose, the character reaches forward and slightly down with
one hand as if placing a small object onto a counter at waist height, holds briefly,
then returns to the relaxed standing pose. The hand does not grip or open; the item
is attached by game code.
```

**ANIM-RECEIVE-ITEM** (non-loop, 1.2 s)
```
From a relaxed standing pose, the character extends both hands forward at waist
height as if accepting a small parcel, draws the hands back toward the chest, then
returns to the relaxed standing pose.
```

**ANIM-INSPECT** (non-loop, 2.0 s)
```
From a relaxed standing pose, the character leans in slightly, tilts the head down
toward a shelf at chest height, one hand raised near the chin in consideration,
then straightens back to the relaxed standing pose.
```

**ANIM-PAY** (non-loop, 1.0 s)
```
From a relaxed standing pose, one hand moves to the hip then extends forward at
waist height in a short handing-over motion, then returns. Brief and unceremonious.
```

**ANIM-REJECT** (non-loop, 1.5 s)
```
From a relaxed standing pose, the character makes a small polite refusal: a single
shallow head shake and one hand raised briefly palm-outward at chest height, then
returns to the relaxed standing pose. Polite, not angry, not theatrical.
```

**ANIM-SALE-SUCCESS** (non-loop, 1.5 s)
```
From a relaxed standing pose, a short contained expression of satisfaction: a
single nod and a brief small fist-close at waist height. Understated - this fires
often and must not become annoying on repetition.
```

## Roblox'a alma

- Klipler `KeyframeSequence` olarak içe aktarılır ve Animation Editor üzerinden asset'e dönüştürülür. Bu adım **Studio gerektirir** ve bu pakette `NEEDS STUDIO` durumundadır.
- Yüklenen animasyonlar hesaba bağlıdır; grup sahipliğine geçiş planlanıyorsa animasyonlar baştan grup altında yüklenmelidir. Aksi halde sonradan taşınamaz.
- Animasyon içe aktarma kuralları ve rig gereksinimleri değişebilir; içe aktarmadan önce Creator Hub'ın güncel animasyon sayfası kontrol edilir.

## K0'da animasyon gerçekten gerekli mi

Dürüst cevap: **hayır, K0 kapısı için gerekli değil.** Mevcut kayarak hareket çirkindir ama "oyuncu karar veriyor mu" sorusunu ölçmeyi engellemez. Bu set, K0 kapısı geçildikten sonra ilk görsel yatırım olarak planlanmıştır. `ANIM-IDLE` ve `ANIM-WALK` tek başına algılanan kaliteyi en çok artıran ikilidir; diğerleri sonra gelebilir.
