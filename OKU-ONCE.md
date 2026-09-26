# BAYCREST — Belge Paketi

**Sürüm 3.0 · 24 Eylül 2026**

**Dokümantasyon düzeni:** 25 Eylül 2026. Ürün kararları 3.0 baz çizgisinde kaldı; görev ve üretim dosyaları eklendi. Güncel giriş: [README.md](README.md).

---

## Paket nasıl çalışır

Paketin tek karar kaynağı `KARARLAR.md`'dir. Bir belge onunla çelişirse karar kaydı geçerlidir ve belge düzeltilir. Ekonomi ve oyun ayarlarının başlangıç değerleri `EKIP/03-EKONOMI.md` §14'tedir; harita ve performans hedefleri kendi belgelerinde ölçülür.

### `KARARLAR.md` — kök dizin

Kullanıcı kararları, iki bağımsız değerlendirmenin birleştirilmiş sonuçları, elenen ve ertelenen fikirler, açık konular.

### `EKIP/` — herkes okur

| Dosya | İçerik |
|---|---|
| `00-BASLA-BURADAN.md` | Omurga, tasarım yasası, sekiz değişmez kural, isimler, konumlandırma |
| `01-SAHIPLIK-VE-ISLETME.md` | Çekirdek döngü, yuva mimarisi, NPC çalışanlar, zaman, geri dönüş |
| `02-ENVANTER-VE-SUC.md` | Envanter, gizleme, polis etkileşimi, silah ve sağlık, tanık, aklama, denetim |
| `03-EKONOMI.md` | Hesap sözleşmesi, sayılar, frenler, `Ayarlar.lua`, ekonomi modeli |
| `04-TEKNIK.md` | Mimari, tek yazar kuralı, görünürlük güvenliği, NPC, adalet servisi, test |
| `05-HARITA-SANAT-ANIMASYON.md` | Sanat yönü, bölgeler, kurumlar, yuvalar, animasyon, araçlar |
| `06-ARAYUZ-VE-SES.md` | Ekranlar, erişilebilirlik, moderasyon, ses |
| `07-YOL-HARITASI.md` | Katman 0–6, kapılar, roller, riskler, ölçütler |
| `08-SOZLUK.md` | Adlar, terimler, zaman birimleri, kimlikler — referans |
| `09-ADALET-VE-ANAYASA.md` | Anayasa, delil, mahkeme, cezaevi, kaçış |
| `10-IS-VE-MESLEK-KATALOGU.md` | Altı iş ailesi, 24 işletme, meslekler, ilk yayın kapsamı |

### `OZEL/` — sadece sen

| Dosya | İçerik |
|---|---|
| `A1-AI-IS-AKISI.md` | MCP kurulumu, AI iş bölümü, ücretsiz araç tuzakları, ekibe öğretme |
| `A2-PROMPT-KUTUPHANESI.md` | Kopyala-yapıştır prompt şablonları |
| `A3-PLATFORM-VE-PARA.md` | Yayın gereksinimleri, yaş kuralları, gelir, pazarlama |
| `ARSIV/` | İkinci değerlendirmenin özgün raporu |

### Üretim ve AI çalışma klasörleri

| Yol | İçerik |
|---|---|
| `AI_CONTEXT/` | AI için görev rotası, Studio/MCP iş akışı, 3D üretim ve QA standardı |
| `DESIGN_DRAFTS/` | Henüz onaylanmamış sahne ve 3D varlık brief'leri |
| `PRODUCTION/` | Gerçek varlıkların köken, lisans ve test kanıtı kayıtları |
| `DOKUMAN-YONETIMI.md` | Kaynak önceliği, durumlar ve değişiklik akışı |

---

## Sürüm 2.0'dan ne değişti

Bu sürüm iki bağımsız yapay zekâ değerlendirmesinin ve kullanıcı kararlarının birleştirilmiş hâlidir.

**Kullanıcı kararları uygulandı.** Kimse ölmez, yaralanır ve hastaneye gider. Silahlar pahalıdır ve düşük hasar verir. Verania'nın bir anayasası, mahkemesi ve cezaevi var; dava sen oyunda olmasan da işler. Cezalar kısadır. Her meslek aynı soyulma riski altında değil.

**İki yeni belge.** `09-ADALET-VE-ANAYASA.md` ve `10-IS-VE-MESLEK-KATALOGU.md`.

**Sahiplik mimarisi düzeltildi.** İşletme kaydının tek bir yazarı var. Cephe yerine beş yuva sınıfı geldi; kapasite artık başarı senaryosunda da yetiyor.

**Zaman birimleri ayrıldı.** "Aylık maaş" fiilen günlük giriş zorunluluğu demekti. Artık dört ayrı birim var ve saat yalnız işletme çalışırken işliyor.

**Ekonomi hesabı düzeltildi.** Bir çarpma hatası vardı. Hesap sözleşmesi, suç–temiz oran hedefi ve doğrulama modeli eklendi.

**Çatışma ve sağlık sistemi eklendi.** Sürüm 2.0'da silah vardı ama can, ölüm ve toparlanma kuralları hiç yazılmamıştı.

**Polis etkileşimi üçe ayrıldı.** Gönüllü soru, gerekçeli durdurma, delile dayalı arama. Ret hiçbir zaman mahkûmiyet gerekçesi değil.

**Platform bilgileri düzeltildi.** Yayın eşiği, yaş etiketleri, DevEx yaşı, topluluk kurma ücreti ve özel sunucu modeli.

**İki araç markası değişti.** Anadol ve Kartal gerçek adlarla çakışıyordu; Ova Motors ve Siper geldi.

---

## Nereden başlanır

1. Sen `OKU-ONCE.md` → `KARARLAR.md` → `EKIP/00` → `OZEL/A1` oku
2. Ekibe `EKIP/` ve görevlerine göre `AI_CONTEXT/` ile `DESIGN_DRAFTS/` klasörlerini ver; herkes `00`'ı okusun
3. Herkes kendi belgesini okusun
4. Üretim başlangıcında Roblox topluluğu, sahiplik ve yazılı gelir paylaşımı konularını proje sahibi gözden geçirsin; ekip üyeleri küçük birer somut çıktı üretsin
5. Katman 0'ı başlat: tek tezgâh, tek oyuncu, polis yok, suç yok, silah yok

---

## Bu paketin doğrulama sınırı

3.0 baz çizgisi **tasarım** doğrulamasından geçti: belgeler arası tutarlılık, aritmetik kontrolü ve platform kurallarının kaynak kontrolü. 25–26 Eylül üretim düzeni kaynak önceliğini, taslak statülerini, gerçek kodu ve üretim kanıtını ayrı tanımlar; bütün açık tasarım risklerini kapattığı iddiasında değildir.

K0 için gerçek Luau kaynakları yazıldı ve 25 Eylül'de önceki runtime ile bir Studio smoke testi kaydedildi. Aktif kaynak bugün `K0-market-0.4.1`'dir. K0.3 bağımsız denetimden geçirildi; iki oyun-durduran hata (rafta tek birim kalınca yenilemenin imkânsızlaşması ve kayıt bitiminde kalıcı ekonomi çıkmazı) ölçülerek kanıtlandı ve giderildi (K0.4). Ardından kaynak başsız bir Luau harness'inde gerçekten çalıştırıldı; kurtarmanın kasayı sıfırlaması, stoksuz harcama çıkmazı ve sahip devri yarışı dahil beş hata bulunup giderildi (K0.4.1). Doğrulama üç katmanlıdır: statik paket denetimi (`TOOLS/validate_package.py`), 20 senaryoluk ekonomi simülasyonu (`TOOLS/scenarios_k0.py`; 19/20, bir açık tasarım bulgusu sahip kararı bekliyor) ve gerçek kaynağı sahte motorda çalıştıran harness (`TOOLS/run_luau_harness.py`). **K0.4.1 kaynaklarının Studio place'ine uygulandığı, Android'de ölçüldüğü veya üç bağımsız oyuncunun 20 dakikalık kapısından geçtiği henüz doğrulanmadı.** Tarihsel Studio testi `PRODUCTION/K0_TECHNICAL_CHECK_2026-09-25.md`, K0.3 kaynak denetimi `PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md`, güncel uygulama raporu `PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md` içindedir.

Bu nedenle `UYGULANDI` ile `DOĞRULANDI` aynı şey değildir. Sayısal K0 değerleri kontrollü prototip değerleridir; üretim ekonomisinin yerine geçmez. Platform ve AI/varlık hak bilgileri hızlı değişir; `OZEL/A3` §7 ve `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` yayın öncesinde yeniden kontrol edilir.
