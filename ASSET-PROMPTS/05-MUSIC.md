# 05 — Müzik

**Durum:** TASLAK · K0.4

K0 için **dört parça** yeterlidir. Daha fazlası bu prototipin sorusunu ölçmeye katkı vermez ve lisans/telif yüzeyini gereksiz büyütür.

## Liste

| Kimlik | Tür | Süre | Loop | Gameplay purpose | Öncelik |
|---|---|---|---|---|---|
| `MUS-MARKET-DAY` | Ortam | 90–120 s | evet, seamless | Pazarın gündüz atmosferi | **1** |
| `MUS-OWNERSHIP` | Sakin tema | 60–90 s | evet, seamless | Sahiplik/ilerleme hissi | 2 |
| `MUS-UPGRADE-STING` | Sting | 2–3 s | hayır | Seviye 2 açıldı | 2 |
| `MUS-SALE-CUE` | Mikro cue | 0.8–1.2 s | hayır | Satış tamamlandı | **1** |

`MUS-SALE-CUE` birinci öncelikte çünkü K0'ın çekirdek döngüsünde en sık tekrar eden olumlu geri bildirimdir. `MUS-MARKET-DAY` birinci öncelikte çünkü sessiz bir pazar testçiye "oyun bitmiş/bozuk" hissi verir.

## Bütün müzik promptlarında geçerli kurallar

- **Konuşmayı ve SFX'i bastırmaz.** Oyun altında çalar. Orta frekanslar (800 Hz – 4 kHz) boş bırakılır; satış/pazarlık SFX'i orada yaşar.
- **Vokal yok.** Hiçbir parçada sözlü vokal, ad-lib veya anlaşılır hece yok. Sebep: tekrar dinlemede en hızlı yorulan katman vokaldir ve çok dilli bir oyuncu kitlesinde dikkat dağıtır.
- **Yoğunluk düşük ve sabit.** Dramatik build, drop, breakdown veya ani dinamik sıçrama yok. Ortam müziği oyuncunun karar anını maskelememelidir.
- **Seamless loop zorunlu** (ortam ve tema için). Baş ve son aynı noktada birleşmeli; fade-in/fade-out ile bitirilmiş dosya kabul edilmez.
- **Mono uyumluluk.** Telefon hoparlöründe çalacak. Stereo genişletme efektleriyle mono'da faz iptali yaratan üretim kabul edilmez.
- **Kuyruk temiz.** Sting ve cue dosyalarında baştaki sessizlik 10 ms'yi geçmez; gecikmeli tetikleme hissi yaratır.

## MUS-MARKET-DAY

**Gameplay purpose:** oyuncunun 20 dakika boyunca altında oturduğu katman. Fark edilmemesi başarıdır.

```
Instrumental background music loop for a warm Mediterranean-Anatolian open-air
market during the daytime. Relaxed, everyday, gently optimistic - a normal working
morning, not a festival and not a tense scene.

Instrumentation: nylon-string acoustic guitar, light hand percussion (frame drum,
shaker) played softly with brushes or fingers, a soft plucked string instrument
carrying a simple modal motif, warm upright bass on long notes. Acoustic and small
ensemble; no orchestra.

Tempo: 84-96 BPM. Time signature 4/4.
Mood: calm, warm, unhurried, content.
Dynamics: flat and consistent. No build, no drop, no crescendo, no section change
that pulls attention.
Mix: leave the 800 Hz - 4 kHz midrange relatively open so game sound effects and
dialogue stay clearly audible over the music. Keep the low end tight and modest.

Length: 90 to 120 seconds, composed as a SEAMLESS LOOP - the end must join the
beginning with no gap, no fade in, no fade out and no audible seam.

Strictly no vocals, no vocal samples, no humming, no choir, no spoken word.
No sound effects, no market crowd noise, no ambience recordings - music only.
```

## MUS-OWNERSHIP

**Gameplay purpose:** oyuncu tezgâhı sahiplendikten sonra devreye girebilecek ikinci katman. Opsiyoneldir; K0 kapısı bunsuz da geçilir.

```
Instrumental background music loop expressing quiet personal progress: someone has
just become the owner of a small market stall and is settling into the work.

Same world and instrument family as the daytime market loop, but sparser and more
intimate: solo nylon-string guitar carrying the melody, very light sustained warm
pad underneath, minimal percussion or none at all.

Tempo: 72-84 BPM. Time signature 4/4.
Mood: calm pride, steadiness, small-scale hope. Warm, not triumphant, not sad.
Dynamics: flat and consistent, even quieter than the market loop.
Mix: open midrange, no sharp transients.

Length: 60 to 90 seconds, SEAMLESS LOOP with no fade in or fade out.

Strictly no vocals, no percussion build, no drums kit, no sound effects.
```

## MUS-UPGRADE-STING

**Gameplay purpose:** 250 ₡ yükseltmesinin duyulur karşılığı. Oturumda **en fazla bir kez** çalar, bu yüzden biraz daha belirgin olabilir.

```
A very short musical sting for a small business upgrade being unlocked in a game.

Instrumentation: nylon-string guitar and a soft warm bell or glockenspiel, matching
a Mediterranean-Anatolian acoustic palette. A short rising three-note figure
resolving to a warm major chord.

Mood: earned, satisfying, modest. This is a small shop getting a second shelf, not
a boss defeat or a jackpot.

Length: 2 to 3 seconds total. Starts immediately with no leading silence. Ends with
a natural short decay, fully silent by the end of the file.

No vocals, no drums, no riser, no whoosh, no orchestral hit, no applause,
no coin sound effect.
```

## MUS-SALE-CUE

**Gameplay purpose:** her satışta çalar. K0'ın 20 dakikasında 40–90 kez duyulabilir (simülasyon: 91–97 satış / 40 dk). **Tekrarda yorulmaması birinci şarttır.**

```
An extremely short positive confirmation cue for completing a small sale in a game.

Instrumentation: two soft plucked notes, a rising interval, on a warm nylon-string
guitar or a soft mallet instrument. Nothing else.

Mood: quietly positive, neutral-friendly. Must remain pleasant after being heard
dozens of times in a single 20 minute session, so it must be understated, short and
free of any sharp or bright transient.

Length: 0.8 to 1.2 seconds. No leading silence. Natural short decay to full silence.

Peak level should sit a few dB below the music bed so it confirms without startling.

No vocals, no drums, no cash register sound, no coin jingle, no sparkle, no riser,
no reverb tail longer than the note itself.
```

## Tool adaptation

Aşağıdaki notlar 26 Eylül 2026 itibarıyla resmî kaynaklardan doğrulanmıştır. Yayın öncesi yeniden kontrol edilir.

**Suno**
- Ücretsiz/abone olmayan kullanım: resmî Terms of Service, çıktıların yalnız "lawful, personal and non-commercial purposes" için kullanılacağını yazıyor. **Ücretsiz plan çıktısı Baycrest'e giremez.**
- Ücretli (Pro/Premier): Suno, kullanıcıya çıktı üzerindeki haklarını devrediyor ("assigns to you all of its right, title and interest in and to any Output owned by Suno"), Terms'e ve indirme kısıtlarına bağlı kalmak şartıyla.
- Her iki planda da geçerli uyarı: "Due to the nature of machine learning, Suno makes no representation or warranty to you that any copyright will vest in any Output." Yani **telif oluşacağı garanti edilmiyor**; bu, atıf ve köken kaydını daha önemli yapar.
- Karar: **ücretli plan ADAY; ücretsiz plan yasak.**

**Udio ve diğer müzik araçları**
- Bu oturumda resmî şartları doğrulanmadı. `11-LICENSE-AND-PROVENANCE.md` içinde **UNKNOWN / REVIEW REQUIRED** olarak işaretlidir. Doğrulanmadan kullanılmaz.

**Roblox Creator Store**
- Store'dan alınan ses varlıkları Roblox deneyimleri içinde kullanım lisansı taşır. K0 için en düşük riskli yoldur ve ilk tercih olarak değerlendirilmelidir.

**Roblox ses yükleme kuralları**
- Yüklenen sesler moderasyondan geçer ve süre/gizlilik kuralları değişebilir. Yüklemeden önce Creator Hub'ın güncel audio sayfası kontrol edilir. Bu pakette ölçülmüş bir süre sınırı yazılmamıştır.

## K0 için dürüst değerlendirme

K0 kapısı müziksiz de geçilebilir. Müzik, testçinin oyunu "bitmemiş" hissetmesini azaltır ama **karar verip vermediğini ölçmez**. Üretim sırasında en sona konmasının sebebi budur. Eğer bütçe tek bir parçaya yetiyorsa sıralama: `MUS-SALE-CUE` → `MUS-MARKET-DAY` → diğerleri.
