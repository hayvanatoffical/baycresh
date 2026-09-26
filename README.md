# BAYCREST — Proje dokümantasyonu

**Tasarım baz çizgisi:** 3.0 · 24 Eylül 2026  
**Dokümantasyon düzeni:** 26 Eylül 2026  
**Üretim durumu:** K0 kaynak paketi `K0-market-0.4.1`. K0.3 bağımsız olarak denetlendi; iki oyun-durduran hata (raf kilidi ve kayıt çıkmazı) ölçülerek kanıtlandı ve giderildi (K0.4). K0.4 kaynağı ardından başsız bir Luau harness'inde gerçekten çalıştırıldı; kurtarmanın kasayı sıfırlaması, stoksuz harcama çıkmazı, sahip devri yarışı, çift talep panosu metni ve HUD taşması bulunup giderildi (K0.4.1). İlk sahiplik, görünür talep/stok kararı, açıklanabilir pazarlık, seviye 2, kasiyer/maaş, kontrollü 20 dakikalık ölçüm ve mobil teklif düzeni kaynakta mevcut. Doğrulama üç katmanlıdır: statik paket denetimi (PASS), 20 senaryoluk ekonomi simülasyonu (19/20; 1 açık tasarım bulgusu: talep panosu ekonomide ödüllendirilmiyor, sahip kararı bekliyor) ve gerçek kaynağı sahte motorda çalıştıran harness (28/28 PASS). Studio olmadan place dosyası da bu depoda kurulup doğrulanıyor ve Open Cloud ile yüklenip telefondan oynanabiliyor ([PRODUCTION/K0_STUDIOSUZ_TEST_YOLU.md](PRODUCTION/K0_STUDIOSUZ_TEST_YOLU.md)); bu yol henüz Roblox'ta denenmedi. **Bu kaynak Studio place'ine uygulanmadı, Android'de ölçülmedi ve oyuncu testinden geçmedi.** Ayrıntı: [PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md](PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md).

Baycrest, Verania'da geçen çok oyunculu bir şehir hayatı oyunudur. Ürün kararı, uygulanmış özellik ve üretim taslağı birbirinden ayrı tutulur. Bugünkü belgeler geliştirmeyi yönlendirir; oyunun çalıştığına dair kanıt değildir.

## Nereden başlanır?

1. [OKU-ONCE.md](OKU-ONCE.md) ve [KARARLAR.md](KARARLAR.md) dosyalarını oku.
2. Ekip üyesiysen [EKIP/00-BASLA-BURADAN.md](EKIP/00-BASLA-BURADAN.md) ile başla; görevine uygun tek veya iki uzmanlık belgesini seç.
3. AI ile çalışırken [AI_CONTEXT/README.md](AI_CONTEXT/README.md) içindeki görev rotasını kullan.
4. Yeni bir 3D varlık için [AI_CONTEXT/3D_MODELING/PIPELINE.md](AI_CONTEXT/3D_MODELING/PIPELINE.md) ve [DESIGN_DRAFTS/3D/ASSET_REGISTER.md](DESIGN_DRAFTS/3D/ASSET_REGISTER.md) dosyalarını aç.
5. Değişiklik yapmadan önce [DOKUMAN-YONETIMI.md](DOKUMAN-YONETIMI.md) içindeki karar ve gözden geçirme kuralını uygula.

## Klasörler ve yetki

| Yol | İşlev | Yetki / durum |
|---|---|---|
| `KARARLAR.md` | Kullanıcı kararları, kabul/ret, açık konular | Tasarımda tek karar kaynağı |
| `EKIP/` | Sistemlerin kanonik tasarım belgeleri | Ekipçe okunur; karar kaydına bağlı |
| `AI_CONTEXT/` | AI görev yönlendirmesi ve üretim standartları | Türetilmiş bağlam; karar vermez |
| `DESIGN_DRAFTS/` | Somut varlık ve sahne taslakları | Kabul edilene kadar öneri |
| `PRODUCTION/` | Üretim kanıtı ve varlık kökeni kayıtları | Gerçek işlem yapıldıkça doldurulur |
| `GAME/` | K0 Studio script kaynakları ve sahne kurucusu | Studio kopyasıyla eşit tutulur; oyun içi prototip |
| `OZEL/` | Proje sahibinin özel çalışma notları | Ekip/AI bağlamına otomatik kopyalanmaz |
| `OZEL/ARSIV/` ve kökteki değerlendirme planı | Geçmiş değerlendirme ve gerekçeler | Karar kaynağı değildir |

**Çelişki sırası:** Proje sahibinin son açık talimatı → `KARARLAR.md` → ilgili `EKIP/` belgesi → `AI_CONTEXT/` → `DESIGN_DRAFTS/` → arşiv. Sayısal ekonomi ve oyun ayarlarının tasarım baz çizgisi `EKIP/03-EKONOMI.md` §14'tür; değerler prototipte doğrulanır.

## Yakın üretim hedefi

[EKIP/07-YOL-HARITASI.md](EKIP/07-YOL-HARITASI.md) Katman 0: Blackstone Bazaar'da tek tezgâh, tek oyuncu, NPC müşteriye satış, büyütme ve bir maaş günü. Polis, suç ve silah K0 kapsamına girmez. Harita ve varlık taslakları bu dar kapsamı destekler.

**Mevcut Studio hedefi:** Roblox place ID `83986068176961`; `Workspace/BlackstoneBazaar_K0`. Güncel kaynak/migrasyon adımları [GAME/README.md](GAME/README.md), K0.3 kaynak denetimi [PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md](PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md), K0.2 tarihsel yeniden yapılandırma kaydı [PRODUCTION/K0_CODE_REWORK_2026-09-25.md](PRODUCTION/K0_CODE_REWORK_2026-09-25.md) ve önceki Studio sanat/oynanış kontrolü [PRODUCTION/K0_ART_PLAYCHECK_2026-09-25.md](PRODUCTION/K0_ART_PLAYCHECK_2026-09-25.md) içindedir.

## Durum disiplini

- `TASLAK`: öneri; karar veya uygulanmış özellik sayılmaz.
- `ONAYLI TASARIM`: karar kaydıyla uyumlu; oyun içinde çalıştığı anlamına gelmez.
- `UYGULANDI`: Studio/kod değişikliği ve izlenebilir konum mevcut.
- `DOĞRULANDI`: kabul testi, cihaz/sürüm ve kanıt kaydı mevcut.

Platform kuralları ve teknik sınırlar güncellenebilir. Yayına ilişkin kontroller yayın ayında resmî kaynaktan yeniden yapılır. 3D üretimindeki ölçülmemiş bütçeler hipotez olarak işaretlenir.

**Paket kontrolü:** `python3 TOOLS/validate_package.py` (statik: topoloji, sürüm ve kaynak değişmezleri, Markdown bağlantıları), `python3 TOOLS/scenarios_k0.py` (ekonomi senaryoları) ve `python3 TOOLS/run_luau_harness.py` (gerçek Luau kaynağı sahte motorda; Luau CLI gerekir). Studio'suz place kurulumu: `python3 TOOLS/build_place.py` (Lune gerekir); yükleme ve gerçek sunucuda smoke: `python3 TOOLS/roblox_cloud.py` (sahibin anahtarı gerekir; ayrıntı [TOOLS/place_build/README.md](TOOLS/place_build/README.md)). Son kaynak raporu `PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md` içindedir. Bu kontrollerin hiçbiri Roblox Studio runtime testinin yerine geçmez.
