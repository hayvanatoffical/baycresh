# K0 — Studio'suz test yolu (Redmi telefon)

**Durum:** Araştırma tamam · place kurulumu ve bulut smoke betiği bu depoda doğrulandı · **Roblox'a hiçbir şey gönderilmedi** (API anahtarı yok) · 26 Eylül 2026
**Kaynak sürümü:** `K0-market-0.4.5`
**Teknik ayrıntı:** [`TOOLS/place_build/README.md`](../TOOLS/place_build/README.md)

## Kısa cevap

- **Roblox Studio telefonda yok.** Studio yalnız Windows ve macOS'ta çalışır. Android ve Redmi için bir sürümü yok.
- Roblox'un telefondaki yeni **Build** sekmesi Studio değildir. Yazılı istemden yapay zekâyla basit oyun üretir. Temmuz 2026'dan beri yalnız Yeni Zelanda'da alfa olarak açık. K0'ın Luau kaynağını yükleyip test etmeye yaramaz.
- **Açık kaynaklı tam bir Studio yok.** Studio'nun parçalarının açık kaynaklı karşılıkları var. Bunlar pakete eklendi:
  - **Lune** ve **rbx-dom**: place dosyasını Studio'suz kurar.
  - Roblox'un resmî **Open Cloud** API'leri: place'i Studio'suz yükler ve Roblox'un kendi sunucusunda betik çalıştırır.
- Sonuç: place bu bulut ortamında kurulur ve doğrulanır. Sahibin anahtarıyla Roblox'a yüklenir. Gerçek motorda smoke testi yapılır. Oyun Redmi'deki **Roblox uygulamasından** oynanır. Test planının çoğu böyle telefondan yapılabilir. Yapılamayanlar §5'te açıkça yazılı.

## 1. Araştırma sonucu

Kontrol tarihi 26 Eylül 2026.

| Seçenek | Durum | K0 için anlamı | Kaynak |
|---|---|---|---|
| Roblox Studio | Windows 10+ ve macOS 10.14+ | Telefonda çalışmaz | [Studio setup](https://create.roblox.com/docs/studio/setup) |
| Roblox Build (telefon) | Yazılı istemle yapay zekâ üretimi; 28 Temmuz 2026'dan beri yalnız Yeni Zelanda'da public alfa | Luau kaynağı yüklemek veya test etmek için değil | [Roblox Newsroom, Temmuz 2026](https://about.roblox.com/newsroom/2026/07/build-without-limits-on-roblox) |
| Açık kaynak Studio | Yok | — | — |
| Lune + rbx-dom (açık kaynak) | Roblox nesne modeli ve yansıma veritabanıyla `.rbxl` okur ve yazar | Place bu ortamda kurulur; özellik adı ve tipi gerçek veritabanıyla denetlenir. Oyun çalıştırmaz. | [Lune](https://github.com/lune-org/lune), [rbx-dom](https://github.com/rojo-rbx/rbx-dom) |
| Open Cloud Place Publishing | `.rbxl`'i var olan bir place'e yeni sürüm olarak yükler | Studio'suz yükleme | [Place publishing](https://create.roblox.com/docs/cloud/guides/usage-place-publishing) |
| Open Cloud Luau Execution | Bir place sürümünde, Roblox sunucusunda betik çalıştırır. Oyuncu yok, fizik yok, place scriptleri kendiliğinden başlamaz, değişiklik kaydedilmez. En fazla 5 dakika. | Gerçek motorda smoke testi | [Luau Execution](https://create.roblox.com/docs/cloud/features/luau-execution), [DevForum duyurusu](https://devforum.roblox.com/t/beta-open-cloud-engine-api-for-executing-luau/3172185) |
| Developer Console | Oyun içinde sohbete `/console` yazılır veya Roblox menüsü → Settings → Developer Console açılır. **Server** loglarını yalnız oyunun sahibi (veya düzenleme izni olan) görür. | Sunucunun `summary`, `rescue_grant`, `dead_end` satırları telefondan okunur | [Developer Console](https://create.roblox.com/docs/studio/developer-console) |
| MicroProfiler (mobil) | Telefonda Settings → MicroProfiler **On**. Aynı Wi-Fi'daki başka bir cihazın tarayıcısından ekranda yazan IP:port açılır. Kare süresi (ms) gösterir. | Aşama 3 FPS ölçümü için tek resmî yol. İkinci cihaz gerekir. | [MicroProfiler](https://create.roblox.com/docs/performance-optimization/microprofiler) |
| Yeni deneyim veya place oluşturma | Roblox belgesine göre Studio ister | Telefondan yeni test place'i **açılamaz**. Var olan bir place'e yüklenir (§4). | [Publish games and places](https://create.roblox.com/docs/production/publishing/publish-games-and-places) |
| Sürüm geçmişi | Her yükleme yeni sürümdür; eski sürümler kalır. Dashboard'daki **Restore** yeni bir sürüm oluşturur ama canlıya **kendiliğinden almaz**; canlıya almak için belge Studio'da yayınlamayı söyler. | Yanlış yüklenen canlı sürüm telefondan tam geri alınamayabilir | [Version History](https://create.roblox.com/docs/projects/version-history) |

## 2. Yol nasıl işler

1. **Kur (bu ortamda, anahtar gerekmez):** `python3 TOOLS/build_place.py` dört test profilini `.rbxl` olarak kurar ve beş kontrolle doğrular.
2. **Yükle (sahibin izniyle):** `python3 TOOLS/roblox_cloud.py publish <profil> --yes`. `--yes` olmadan yalnız ne gönderileceğini yazar.
3. **Gerçek motorda smoke (otomatik):** `python3 TOOLS/roblox_cloud.py smoke <profil>`. Test planının Aşama 0 ölçütlerini ve tabela fiyatlarını Roblox sunucusunda denetler.
4. **Oyna (Redmi):** Roblox uygulamasında place açılır, test planı adımları oynanır, sunucu satırları `/console` ile okunur.

Her yükleme ve smoke `dist/place/` altına kanıt kaydı bırakır. Test kaydına bu kayıtların adı yazılır.

## 3. Sahibin bir kez yapacakları (telefon tarayıcısından)

1. **Place kararını ver** (§4).
2. **API anahtarı oluştur:** <https://create.roblox.com/dashboard/credentials> → API Keys → Create API Key.
   - Access Permissions: `universe-places` → **Write**.
   - Access Permissions: `universe.place.luau-execution-session` → **Read** ve **Write**.
   - Restrict by Experience açık; yalnız test place'inin deneyimini seç.
   - Roblox, 60 gün kullanılmayan anahtarı kendiliğinden kapatır.
3. **Universe ID ve Place ID'yi bul:**
   - Universe ID: Creator Dashboard → Creations → deneyimin küçük resminde **⋯** → **Copy Universe ID**.
   - Place ID: deneyim → Places → place'e dokun. Adres çubuğunda `…/places/<PLACE ID>/configure`.
4. **Değerleri ortam ayarlarına ekle, sohbete yazma:**
   - Claude Code oturumunun başlığındaki bulut ortamı menüsünü aç → **Edit**.
   - **API credentials** bölümü varsa oraya, yoksa ortam değişkeni olarak ekle: `ROBLOX_API_KEY`, `ROBLOX_UNIVERSE_ID`, `ROBLOX_PLACE_ID`.
   - Yeni açılan oturum bu değerleri görür.
   - **Anahtar hiçbir zaman sohbete, bir dosyaya veya Drive'a yazılmaz.** Araç anahtarı hiçbir çıktıya yazmaz.
5. Yeni oturumda "default'u yayınla ve smoke çalıştır" demen yeterli.

## 4. Açık karar: hangi place'e yüklenecek?

Bu karar **sahibindir**. Araç kendiliğinden seçmez.

| Seçenek | Artı | Risk |
|---|---|---|
| **A. Önemsiz başka bir deneyimin place'i** (varsa, örneğin eski bir deneme) — önerilen | Ana place'e dokunulmaz | O place'teki eski içerik canlıdan kalkar |
| **B. Ana place `83986068176961`** | Ek bir şey gerekmez | Canlı sürüm temiz sahneyle değişir. Studio'daki AI model yerleşimi (`AI_ASSET_PLACEMENT`) temiz sahnede yoktur. Eski sürümler Version History'de kalır, ama birini yeniden canlıya almak belgeye göre Studio ister. Araç bu place'e ancak `--allow-main-place` ile yazar. |

Test planı Aşama 0 da "place'in kopyasını al, aslında çalışma" der. Telefondan kopya place açılamadığı için A önerilir.

Erişim ayarı: place **Private** kalabilir; sahibi oynayabilir. B12 ve Aşama 4 için başka oyuncular gerekir. O zaman Configure → Settings → Audience, **Friends** veya **Playtesters** yapılır. Deneyimi **Public** yapmak bu testin parçası değildir.

## 5. Test planı telefonda

[`K0.4_NEXT_TEST_PLAN.md`](K0.4_NEXT_TEST_PLAN.md) adımlarının Studio'suz karşılığı:

| Plan adımı | Nasıl | Profil | Not |
|---|---|---|---|
| Aşama 0: hazır satırı, eski runtime yok, uyarı yok, migration ikinci kez tek metin | **Bulut smoke** (otomatik) | `default` | Redmi'de `/console` → Log → Server'da `Baycrest K0 market server ready K0-market-0.4.5` de görülür |
| Aşama 0: NPC tek parça yürür (weld) | **Redmi'de oyna** | `default` | Fizik ister; bulut smoke göremez |
| Aşama 1: 12 adımlı smoke | **Redmi'de oyna** | `default` | |
| 2a raf kilidi | **Redmi'de oyna** | `default` | |
| 2b kayıt çıkmazı ve kurtarma | **Redmi'de oyna** | `permit90` | `rescue_grant` ve `dead_end` satırları `/console` Server'da. Sonra `default` yeniden yüklenir. |
| 2c hızlı ardışık `FireServer` | **Telefonda yapılamaz** | — | İstemci konsolunda komut çubuğu yok; sunucu komut çubuğu istemciden olay gönderemez. Harness H08 kanıtı geçerli; bu satır `STUDIO PENDING` kalır. "Normal oynanışta tıklama kaybolmadı" satırı Redmi'de gözlenir. |
| 2d B11 yükseltme reddi | **Redmi'de oyna** | `cash325` | |
| 2d B11 kasiyer reddi | **Redmi'de oyna** | `cash385` | |
| 2d B12 sahip devri | **İki hesap** | `default` | Önce ikinci hesap girer ve tezgâhı sahiplenir. Sahip ikinci oyuncu olarak girer ve `/console` Server'da `summary reason=owner_left` satırını okur. Server logunu yalnız sahip gördüğü için sıra böyledir. İkinci hesap veya cihaz yoksa açık kalır. |
| 2d B14 Stop özeti | **Telefonda gözlenemez** | — | Son oyuncu çıkınca sunucu kapanır, konsol da kapanır. Harness H11 kanıtı geçerli; `STUDIO PENDING` kalır. |
| 2d B19 tabela fiyatları | **Bulut smoke** + Redmi'de bak | her profil | Smoke her profilde tabelanın config fiyatını gösterdiğini denetler |
| Aşama 3 K0.4.2 sesleri | **Redmi'de oyna** | `default` | Telefon hoparlörü asıl hedeftir; bu satır telefonda tam yapılabilir. Sesler önce Creator Store bağlantılarından dinlenebilir: [`ASSET_PROVENANCE.md`](ASSET_PROVENANCE.md) |
| Aşama 3 K0.4.3 siluet ve ikonlar | **Redmi'de oyna** | `default` | Telefonda tam yapılabilir. Gri tonlama testi için ekran görüntüsü alınır ve siyah-beyaz filtreyle bakılır. Telefonda bu filtre bulunamazsa görüntü saklanır ve sonra çevrilir. |
| Aşama 3 K0.4.4 telefon düzeni, dokunmatik metinler, NPC yönü | **Redmi'de oyna** | `default` | Telefonda tam yapılabilir; bu satırların asıl hedefi Redmi'dir. Teklif kartı açıkken ve bir bildirim görünürken birer ekran görüntüsü alınır. |
| Aşama 3 K0.4.5 okunabilirlik ve ekran ölçüsü | **Redmi'de oyna** + `/console` | `default` | Telefonda tam yapılabilir. Konsolun Log sekmesinde Client'ta `[K0 HUD] alan …` satırı okunur veya ekran görüntüsü alınır; sorular [`K0_TELEFON_EKRAN_VE_YAZI.md`](K0_TELEFON_EKRAN_VE_YAZI.md) §6. |
| Aşama 3 cihaz testi | **Redmi** (hedef cihaz) | `default` | FPS yalnız ölçülürse yazılır: mobil MicroProfiler ve ikinci cihaz. Ölçülmezse "ölçülmedi" yazılır, tahmin yazılmaz. |
| Aşama 4 üç oyuncu | Üç hesap, sırayla | `default` | Sahip aynı sunucuda izleyici olarak bulunur ve `summary` satırlarını `/console`'dan kopyalar veya ekran görüntüsü alır. Konsoldan metin kopyalama telefonda denenmedi. |

Profil testi bitince `default` yeniden yüklenir. Test profiliyle ölçüm yapılmaz.

## 6. Redmi için

- Roblox uygulaması Google Play'den kurulur.
- Asgari gereksinim için üçüncü taraf kaynaklar Android 8.0+ ve OpenGL ES 3.0 destekli GPU diyor. Roblox'un resmî yardım sayfası bu ortamdan açılamadı; bu değer **doğrulanmadı**. Pratik kontrol: uygulama açılıyor ve başka oyunlar oynanıyorsa cihaz uygundur.
- Test kaydına cihaz modeli yazılır (Ayarlar → Telefon hakkında). Aşama 5 bunu ister.
- Test en az yatay modda yapılır.

## 7. Doğrulama durumu

| Parça | Sonuç | Nerede |
|---|---|---|
| `build_place.py`: dört profil kuruldu, beş kontrol | **PASS** (her biri 405 nesne) | Bu ortam, Lune 0.10.5 |
| Harness ağacıyla karşılaştırma | **PASS** (yalnız açıklanmış iki fark: motorun yarattığı `Camera`, şablon klasörü `StarterCharacterScripts`) | Bu ortam |
| Kasıtlı bozma denemeleri (yanlış özellik adı, yanlış tip, yanlış enum, yanlış profil, ağaç farkı, yanlış tabela metni) | Hepsi **FAIL** verdi, yani araç hatayı yakalıyor | Bu ortam |
| Bulut smoke betiği, harness H17 | **PASS** iki sinyal modunda, 29 kontrol | Sahte motor |
| `test_roblox_cloud.py`: istemci ve korumalar | **22/22 PASS** | Sahte yerel sunucu |
| Roblox API erişimi | Anahtarsız istek `401 Missing API Key Header` döndü; uç nokta bu ortamdan erişilebilir | Gerçek Roblox |
| Gerçek yükleme, bulut smoke, Redmi oyunu | **DENENMEDİ** — anahtar ve place kararı bekleniyor | — |

Bu tablodaki hiçbir satır `STUDIO PENDING` veya `DEVICE PENDING` statüsünü kaldırmaz. Bulut smoke geçerse Aşama 0'ın otomatik ölçütleri gerçek motorda geçmiş sayılır. Oynanış ölçütleri Redmi testine kalır.
