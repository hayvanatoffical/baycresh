# 06 — Ses efektleri (SFX)

**Durum:** TASLAK · K0.4

SFX, K0'ın **en yüksek getirili ses yatırımıdır**. Müzikten önce gelir: karar geri bildirimi sesle anında okunur, müzik yalnız atmosfer verir.

## Liste

| Kimlik | Tetikleyici (kaynak) | Süre | Öncelik |
|---|---|---|---|
| `SFX-SALE-SUCCESS` | `completeSale()` | 0.4–0.7 s | **1** |
| `SFX-CASH` | `completeSale()` / ödeme | 0.3–0.5 s | **1** |
| `SFX-UI-CLICK` | teklif kartı düğmeleri | 0.05–0.12 s | **1** |
| `SFX-STOCK-PLACE` | `restock()` | 0.4–0.8 s | **1** |
| `SFX-CUSTOMER-ARRIVE` | müşteri `queue`'ya varır | 0.3–0.6 s | **1** |
| `SFX-SALE-FAIL` | teklif reddedildi / süre doldu | 0.4–0.7 s | 2 |
| `SFX-NEGOTIATE` | pazarlıkçı teklifi açılır | 0.3–0.6 s | 2 |
| `SFX-UPGRADE` | seviye 2 | 0.8–1.2 s | 2 |
| `SFX-HIRE` | kasiyer alındı | 0.6–1.0 s | 2 |
| `SFX-NOTIFY` | `notice()` toast | 0.2–0.4 s | 3 |
| `SFX-PERMIT-LAPSE` | kayıt bitti | 0.6–1.0 s | 2 |
| `SFX-LIQUIDATE` | K0.4 tasfiye | 0.4–0.7 s | 2 |

`SFX-PERMIT-LAPSE` ve `SFX-LIQUIDATE` K0.4'te eklendi çünkü bu iki durum artık gerçek birer oyuncu kararı; sessiz kalırlarsa oyuncu ne olduğunu anlamaz.

## Ortak şart

- **Telefon hoparlöründe seçilebilir.** Ana enerji 400 Hz – 5 kHz aralığında. 100 Hz altındaki içerik telefonda duyulmaz ama dosya boyutu ve headroom harcar; kesilir.
- **Kısa ve kuyruksuz.** Uzun reverb yok. Oyuncu saniyeler içinde ikinci bir olayı tetikleyebilir; kuyruklar üst üste binerse çamurlaşır.
- **Baştaki sessizlik ≤ 10 ms.** Aksi halde tepki gecikmeli hissedilir.
- **Tepe seviyesi −3 dBFS'yi aşmaz.** Karıştırma başlığı bırakılır.
- **Tekrar toleransı.** `SFX-UI-CLICK`, `SFX-SALE-SUCCESS` ve `SFX-CASH` bir oturumda onlarca kez çalar. Keskin, parlak veya "komik" olmamalıdır.
- **Mono.** Konumsal ses K0'da gerekli değil; mono dosya hem küçüktür hem telefonda tutarlıdır.
- **Vokal yok.** İnsan sesi `09-VOICE-OPTIONAL.md`'nin konusudur.

## Promptlar

Ortak başlık:

```
Produce a single short game sound effect, mono, 48 kHz, dry with minimal room tone,
no music, no voice, no branding jingle. Peak at or below -3 dBFS. No silence at the
start of the file. Natural short decay to full silence by the end.
The sound must stay pleasant when repeated dozens of times in a 20 minute session.
Main energy between 400 Hz and 5 kHz so it remains audible on a phone speaker.
```

Buna aşağıdaki klip tanımı eklenir.

**SFX-SALE-SUCCESS** — `0.4-0.7 s`
```
A warm, soft, two-part confirmation: a light wooden tap immediately followed by a
gentle rising plucked note. Reads as "the sale went through" without being a
fanfare. Understated and friendly. No coin sound, no cash register bell, no sparkle.
```

**SFX-CASH** — `0.3-0.5 s`
```
A small handful of light coins settling into a shallow metal tray. Soft and muted,
not bright, not a jackpot cascade. Two or three coin contacts only, not a long pour.
No register bell, no paper notes, no music.
```

**SFX-UI-CLICK** — `0.05-0.12 s`
```
A very short, soft, dry UI tap for a touchscreen button. Neutral wooden or muted
plastic click. Extremely low profile: this fires on every interface press and must
never become fatiguing. No pitch sweep, no digital beep, no synth blip.
```

**SFX-STOCK-PLACE** — `0.4-0.8 s`
```
A wooden produce crate being set down onto a wooden market counter, with a soft
rustle of contents settling. Solid and satisfying but not heavy or dramatic. Single
placement, not a stack of several. No voice, no music.
```

**SFX-CUSTOMER-ARRIVE** — `0.3-0.6 s`
```
A soft, neutral attention cue signalling that a customer has reached the stall:
two quiet footsteps on stone followed by a very short warm wooden knock. Must draw
the eye without startling. No bell, no chime, no voice, no door sound.
```

**SFX-SALE-FAIL** — `0.4-0.7 s`
```
A soft negative-but-polite cue: a short muted descending two-note figure on a warm
wooden or muted string tone. Signals "that one did not happen" without sounding like
a punishment, an error buzzer or a failure horn. No harsh dissonance, no buzz.
```

**SFX-NEGOTIATE** — `0.3-0.6 s`
```
A short curious cue signalling that a customer wants to negotiate: a light muted
wooden double-tap with a subtle upward inflection, as if a question has been asked.
Neutral in tone: it must not pre-judge the outcome as good or bad.
```

**SFX-UPGRADE** — `0.8-1.2 s`
```
A construction-flavoured accomplishment cue: a wooden shelf board being set into
place, a short brace or latch settling, and a soft warm resolving tone underneath.
Reads as "the stall physically grew". Modest scale - a second shelf, not a building.
No fanfare, no orchestral hit, no crowd cheer.
```

**SFX-HIRE** — `0.6-1.0 s`
```
A short warm cue for taking on an employee: a soft fabric movement (an apron being
tied) and a single gentle wooden tap, with a brief warm tone. Human-scale and
low-key. No voice, no applause, no fanfare.
```

**SFX-NOTIFY** — `0.2-0.4 s`
```
A very soft, low-profile notification tick for an on-screen message appearing.
A single muted wooden or felt tap with a barely-there tonal component. Quieter than
every other cue in the set; this is the most frequent sound in the game.
```

**SFX-PERMIT-LAPSE** — `0.6-1.0 s`
```
A cue signalling that a market registration has expired and trading has paused:
a soft wooden shutter or panel closing, followed by a low muted tone that settles
downward. Serious and clear but not alarming: the player has not lost anything,
trading is simply paused until they act. No alarm, no buzzer, no siren.
```

**SFX-LIQUIDATE** — `0.4-0.7 s`
```
A cue for selling stock back to the wholesaler at a loss: crate contents being
tipped or slid out, followed by a single flat, slightly dull wooden knock. Should
feel like a plain, slightly reluctant transaction - neither rewarding nor punishing.
No coin sound, no positive chime.
```

## Karıştırma ilişkileri

Aynı anda çalabilecek sesler arasında seviye hiyerarşisi:

1. `SFX-UI-CLICK` ve `SFX-NOTIFY` en sessiz katman (−18 dB civarı).
2. `SFX-SALE-SUCCESS`, `SFX-CASH`, `SFX-STOCK-PLACE` orta katman.
3. `SFX-UPGRADE`, `SFX-HIRE`, `SFX-PERMIT-LAPSE` en belirgin katman — oturumda az kez çalarlar.
4. Müzik hepsinin altında.

`SFX-SALE-SUCCESS` ile `SFX-CASH` çoğu zaman **arka arkaya** çalacak. İkisinin toplamı tek bir olay gibi duyulmalı; ayrı ayrı üretilip üst üste bindiğinde çamurlaşmamaları için ikisi de dar bantlı ve kısa istenmiştir.

## Tool adaptation

- **Roblox Creator Store** ilk kaynak olarak değerlendirilir: lisans yüzeyi en dar olan yoldur.
- **ElevenLabs (SFX):** ücretsiz plan non-commercial ile sınırlı; ticari yayına ücretsiz çıktı sokulmaz. Ücretli plan aday, varlık bazlı kontrol gerekir.
- Kendi kaydın (foley) her zaman en temiz köken kaydını verir: tahta tıklama, kasa, bozuk para ve kumaş sesleri ev ortamında kaydedilebilir. K0 ölçeğinde ciddi bir seçenektir.
- Hangi yol seçilirse seçilsin `11-LICENSE-AND-PROVENANCE.md` kaydı üretimden önce açılır.
