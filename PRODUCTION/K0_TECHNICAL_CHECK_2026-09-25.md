# K0 teknik kontrol — 25 Eylül 2026

**Yer:** Roblox Studio, place ID `83986068176961` · `Workspace/BlackstoneBazaar_K0`  
**Kapsam:** Tek oyunculu K0 gri kutu, satış, seviye 2, kasiyer, maaş. Bu kayıt üç katılımcılı ürün kabul testi değildir.

> **Tarihsel kaynak notu (25 Eylül, sonraki K0.2/K0.3 düzenlemeleri):** Bu kontrol yapıldığında `K0Config/K0Game/K0HUD` aktifti. K0.2 kaynak yeniden yapılandırmasında bu üç dosya `GAME/legacy/` altına taşındı ve aktif kaynak `K0MarketConfig/K0Market/K0MarketHUD` oldu. Aşağıdaki tablo bu test anının kaydıdır.
> **Güncel kaynak:** Aktif K0 runtime artık `K0-market-0.3.0`dır. Bu dosya yalnız 25 Eylül Studio gözleminin tarihsel kanıtıdır; güncel kaynak denetimi için [`K0_FINAL_AUDIT_2026-09-26.md`](K0_FINAL_AUDIT_2026-09-26.md) kullanılır.


## Uygulama

| Parça | Studio konumu | Kaynak |
|---|---|---|
| Bazaar sokağı ve tezgâh | `Workspace/BlackstoneBazaar_K0` | `GAME/SCENE_BUILD.lua` |
| Ekonomi yapılandırması | `ReplicatedStorage/K0Config` | `GAME/legacy/K0Config.lua` |
| Sunucu oynanışı | `ServerScriptService/K0Game` | `GAME/legacy/K0Game.server.lua` |
| Oyuncu arayüzü | `StarterPlayer/StarterPlayerScripts/K0HUD` | `GAME/legacy/K0HUD.client.lua` |

Kayıt sonrası Studio'da sahnenin 133 alt nesnesi, spawn ve üç script görüldü. Üç script yerel kaynaklarla satır satır aynı çıktı. Yer kullanıcı tarafından Roblox'a kaydedildi; proje klasöründe `.rbxl` dosyası bulunmadı.

## Play kontrolü

| Senaryo | Gözlenen sonuç |
|---|---|
| Normal K0 ayarı ile müşteri gelişi | NPC sahnede oluştu, satış istemi açıldı |
| Oyuncu satış noktasına yürüyüp `E` kullandı | Satış sayısı 1, kasa 0 → 80 ₡ |
| Arayüz | Kasa 80 ₡ ve yükseltme hedefi gösterildi; `IgnoreGuiInset=false` |
| Konsol | Normal ayardaki son Play oturumunda yalnız `Baycrest K0 server ready`; script hatası yok |
| Seviye 2, çalışan ve maaş | Geçici test ayarı ile 6.000 ₡ satıştan sonra 5.000 ₡ yükseltme; raflar açıldı, kasiyer oluştu, 134 ₡ maaş ödendi |
| Kasiyer otomatik satışı | Geçici test ayarında ikinci satış kasiyer tarafından yapıldı; kasa 1.000 → 3.100 ₡ |

Geçici test değerleri (`SaleReward=6000`, `ShiftSeconds=30` veya `8`, `WorkerServeSeconds=1`) kontrol için kullanıldı ve normal değerlere geri alındı. Kaydedilen yapılandırmada satış 80 ₡, çalışan servisi 7 saniye, K0 üretim günü 180 saniyedir. Kanonik tasarım günü 2.880 saniye ve seviye 2 maliyeti 5.000 ₡ olarak korundu.

## Açık doğrulamalar

- Üç ayrı katılımcıyla 20 dakikalık oturum ve ertesi gün gönüllü dönüş: **yapılmadı**. `EKIP/07` §2 kapısı açık.
- Android FPS/bellek, dokunmatik istemler, iki ışık koşulu: **ölçülmedi**.
- Animasyon ve lisanslı ses: **eklenmedi**.
- Para, seviye ve çalışan durumu oturumlar arasında tutulmuyor; K1 kalıcılık tasarımına bağlı.
- Yerel script kopyaları Studio ile eşleşiyor; otomatik Rojo eşitlemesi ve Git geçmişi henüz kurulmadı.
- K0 tek oyunculu prototip; çok oyunculu sahiplik, eşzamanlı gelir ve kötü niyetli istek testi K1 öncesi ele alınmalı.

**Sonuç:** K0 teknik dikey kesiti Studio'da çalışıyor. K0 oyuncu kapısı henüz geçmedi.
