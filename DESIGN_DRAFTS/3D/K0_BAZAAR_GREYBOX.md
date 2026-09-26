# SCN-K0-001 — Blackstone Bazaar tek sokak gri kutusu

**Durum:** GRİ KUTU (Studio'da; cihaz QA bekliyor) · **Katman:** K0 · **Öncelik:** P0  
**Kaynak:** `EKIP/07` §2 ve `EKIP/05` §2.2, §2.5, §6.

## Sınır

Tek sokak, tek işlevsel tezgâh, spawn, NPC giriş/çıkış yolu ve anlaşılır yaya akışı. Çevre blokları siluet düzeyinde kalır. Karakol, suç sistemi, silah, tam şehir, araç yolu ve detaylı kurum üretimi bu sahnenin kabul koşulu değildir.

## Planlanan yerleşim ilişkisi

```text
Oyuncu spawnı → tezgâhı gören yaklaşım → satış/iyileştirme alanı
NPC spawnı    → okunur yaya hattı      → müşteri kuyruğu → çıkış
Sokak kenarı  → çevre silueti          → görüş ve hareket sınırı
```

**Uygulanan ilk ölçüler:** Yol 128 × 24 stud, kuzey kaldırım 128 × 16 stud, tezgâh tabanı 16 × 12 stud. Spawn yaklaşık `(-40, 1.5, -6)`, NPC girişi `(36, 2.8, -4)`, müşteri noktası `(0, 2.8, -4)`, çıkış `(-36, 2.8, -4)`. Bu değerler `GAME/SCENE_BUILD.lua` içindeki gri kutu yerleşimidir; oyuncu testinden sonra değişebilir. Yol, kaldırım ve tezgâh 4 stud ızgarasını temel alır. K0'da çatışma sistemi bulunmaz.

## K0 test teslimi

- Studio Explorer ağacı: `Workspace/BlackstoneBazaar_K0` altında adlandırılmış parçalar ve NPC yol noktaları.
- Bir ekran görüntüsü: oyuncu girişinden satış alanı; bir görüntü: tezgâh/NPC yaklaşımı.
- Yürüme ve kamera testi; oyuncu veya NPC'nin takıldığı nokta kayıtlı.
- `07` §2'deki üç ayrı 20 dakikalık test için sürüm ve gözlem formu.

**Durum kanıtı:** Roblox place ID `83986068176961`, `Workspace/BlackstoneBazaar_K0` altında 133 alt nesne; sahne ve NPC yol noktaları Studio'da görüldü. Play sırasında oyuncu satış noktasına yürüdü. Gündüz/akşam karşılaştırması, Android ve üç katılımcılı 20 dakikalık test henüz yapılmadı. Ayrıntı: [teknik kontrol](../../PRODUCTION/K0_TECHNICAL_CHECK_2026-09-25.md).
