# BAYCREST — Doküman ve K0 kaynak denetimi

**Son denetim:** 26 Eylül 2026  
**Kapsam:** 3.0 tasarım baz çizgisi + `K0-market-0.3.0` kaynak paketi.  
**Doğrulama sınırı:** Statik paket ve kaynak denetimi yapılmıştır. K0.3'ün Studio/Android/üç bağımsız oyuncu testi henüz yapılmamıştır.

## 1. 25 Eylül belge düzeninde giderilen sorunlar

| Bulgu | Etki | Düzenleme |
|---|---|---|
| K0 kapısında üç testçi yazarken sonuç dili belirsizdi | Kapı kararı belirsiz | `07` §2 ham sayı ve davranış ölçümüne bağlandı |
| Ekip belgeleri özel `OZEL/` dosyalarına operasyonel talimat için bağlanıyordu | Ekipte eksik erişim | Ortak akış `AI_CONTEXT/` ve `PRODUCTION/` içine taşındı |
| Ölçülmemiş performans değerleri sınır gibi okunabiliyordu | Yanlış optimizasyon | Hedef / varsayım / ölçüm ayrımı yapıldı |
| `Ayarlar.lua` yokken tek sayı kaynağı gibi anılıyordu | Tasarım–uygulama karışıyordu | `03` tasarım baz çizgisi, kod karşılığı ayrı tanımlandı |
| AI varlık kabulinde kimlik/lisans kanıtı yoktu | Yayın hakkı riski | `ASSET_PROVENANCE.md` ve 3D üretim hattı oluşturuldu |

## 2. 26 Eylül K0.3 denetiminde giderilen sorunlar

| Kimlik | Bulgu | Düzeltme | Durum |
|---|---|---|---|
| K03-RUN-01 | Aynı sürümden iki `K0Market` Script'i çalışırsa yalnız sürüm Attribute'u bunu yakalamıyordu | Sunucu oturumuna özel `__K0MarketRuntimeLock` eklendi | KAYNAKTA UYGULANDI |
| K03-SEC-01 | Remote action yalnız `string` kontrolünden geçiyor, açık allowlist yoktu | `accept/counter/decline` allowlist + sayısal offer ID + owner/mesafe/state doğrulaması | KAYNAKTA UYGULANDI |
| K03-QA-01 | Dekoratif kalabalık ve ekonomi aynı RNG akışını tükettiği için üç testçinin koşulları gereksiz değişebilirdi | Sabit `PlaytestSeed` kullanan ekonomi RNG'si ve ayrı kozmetik RNG | KAYNAKTA UYGULANDI |
| K03-QA-02 | K0 davranış ölçümü ilk sahiplik/satış/yükseltmeyle sınırlıydı | İlk stok, teklif, karar; talebe uygun stok; accept/counter/ret sayaçları; yenileme/maaş sayacı eklendi | KAYNAKTA UYGULANDI |
| K03-QA-03 | 20 dakika sonunda gözlemcinin tek yerde okuyacağı özet yoktu | Hedef sürede server Output özet satırı; oyun durdurulmaz | KAYNAKTA UYGULANDI |
| K03-UX-01 | Dar ekranda üç teklif düğmesi ölçek küçülmesiyle küçük dokunma hedefine dönüşebiliyordu | Dar ekranda düğmeler dikey ve daha büyük yerleşir | KAYNAKTA UYGULANDI |
| K03-CFG-01 | HUD'da prototip ücretleri `70/45/60/250` gibi kopyalanmıştı | HUD metinleri `K0MarketConfig` üzerinden okunuyor | KAYNAKTA UYGULANDI |
| K03-CFG-02 | Dünya panosu metni config değişince sürüklenebilirdi | Runtime permit/toptan/fiyat panolarını config'ten yeniliyor | KAYNAKTA UYGULANDI |
| K03-VFX-01 | Satış paketi efekti dünya orijinine bağlıydı | Efekt `SalePoint` konumuna bağlandı | KAYNAKTA UYGULANDI |
| K03-DOC-01 | `OKU-ONCE` ve eski denetim “hiç kod/test yok” diyerek sonraki üretim kayıtlarıyla çelişiyordu | Tarihsel Studio smoke testi ile güncel K0.3 statik durum ayrıldı | DÜZELTİLDİ |
| K03-DOC-02 | Tarihsel teknik kontrol artık var olmayan aktif `GAME/src/K0Game` yollarını gösteriyordu | Kaynak yolları `GAME/legacy/` olarak tarihsel gerçeğe bağlandı | DÜZELTİLDİ |
| K03-LIC-01 | OpenAI/Roblox AI/Creator Store için proje çapında hak–atıf kapısı yoktu | `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` oluşturuldu ve provenance'a bağlandı | DÜZELTİLDİ |

## 3. K0 prototipi ile kanonik belge uyumu

K0.3 bilerek dar tutulmuştur. `EKIP/07` Katman 0 ile eşleşen oynanabilir zincir:

`ücretsiz ilk sahiplik → pazar kaydı → görünür talep → iki stok seçeneği → NPC satış/pazarlık → seviye 2 kapasitesi → kasiyer → maaş günü`

Aşağıdaki sistemler **K0'a eklenmemiştir:** polis, suç, silah, mahkeme, DataStore, kalıcı ekonomi, çoklu işletme, gerçek R15 NPC üretim hattı. Bunları “eksik özellik” diye K0'a taşımak yol haritasını ihlal eder.

`BAYCREST-v3-Tam-Zayiflik-ve-Iyilestirme-Plani.md` içinde önerilen bağımsız `0B` bilgi-gerilimi deneyi ürün açısından değerlidir fakat kanonik `EKIP/07` mevcut K0 kapısı sahiplik hipotezini sınar ve suç/polisi K0 dışı tutar. Bu yüzden 0B, K0.3 runtime'a gizlice eklenmedi. Proje sahibi isterse ayrı, atılabilir bir deney olarak tasarlanmalıdır.

## 4. Hâlâ açık ve gerçek test isteyen konular

| Konu | Neden kaynak koduyla kapatılamaz | Sonraki kanıt |
|---|---|---|
| K0 eğlence kapısı | Eğlence ve gönüllü devam statik analizle ölçülemez | 3 bağımsız oyuncu × 20 dk + ertesi gün gözlemi |
| Mobil kullanılabilirlik | Responsive kod gerçek cihaz sonucu değildir | Android ekran görüntüsü, dokunma ve okunabilirlik testi |
| FPS/bellek | Kaynak sayısı cihaz maliyetini tam göstermez | MicroProfiler / gerçek orta seviye Android |
| Ekonomi dengesi | K0 sayıları yalnız hızlı deney için sıkıştırılmıştır | Oturum kayıtları + `03` simülasyonu |
| Kalıcılık | K0 bellekte yaşar | K1 DataStore, işlem kimliği, göç ve tekrar giriş testi |
| R15 NPC | K0 NPC'leri prosedürel blok kukladır | Rig/animasyon/performans QA, K1+ |
| Varlık hakları | Genel sağlayıcı koşulu tek asset hakkını kanıtlamaz | Her canlı asset için provenance satırı + güncel koşul |

## 5. Paket kabul koşulu

Final ZIP'in kaynak açısından kabulü için:

- tüm göreli Markdown bağlantıları çözülmeli,
- aktif K0 runtime yalnız üç dosyadan oluşmalı,
- legacy runtime yalnız `GAME/legacy/` altında kalmalı,
- config sürümü ile README sürümü aynı olmalı,
- K0 aktif kaynakta eski `CounterAcceptChance` bulunmamalı,
- paket içi validator hatasız çalışmalı,
- ZIP CRC testi geçmeli.

Bu kontrollerin sonucu `PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md` içinde kaydedilir. Bunların hiçbiri Studio/oyuncu testinin yerine geçmez.
