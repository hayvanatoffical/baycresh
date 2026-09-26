# BAYCREST — Harita, Sanat ve Animasyon

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Sanat ve dünya tasarımı baz çizgisi; varlıklar ve performans hedefleri henüz üretim testinden geçmedi.
**Okuyucu:** Builder, 3D ve animasyon sorumluları
**Ön koşul:** `00`, `01`, `02`
**Bağlı kararlar:** ORTAK-002, 022, 023, 032, 043, 044, 048

Oyunun imza sistemlerinin tamamı animasyona bağlıdır: animasyon olmadan "çanta sorgusu" tuşa basmaktan ibaret kalır.

---

## 1. Sanat yönü

### 1.1 Tek cümlede

Baycrest, gerçekçi olmaya çalışmayan ama **inandırıcı** bir Akdeniz liman şehridir. Temiz geometri, sıcak renkler, yaşanmış detaylar.

### 1.2 Neden gerçekçilik peşinde koşmuyoruz

Stilize yön, küçük ekibin tutarlı bir görsel dil kurmasını ve mobil cihazlarda maliyeti yönetmesini kolaylaştırır. AI ile üretilen varlıklar da aynı geometri, renk, ölçek ve kalite kontrolünden geçer; stil uyumsuzluğu veya model hatası kabul edilmez.

### 1.3 Renk paleti

| Kullanım | Renk | Hex |
|---|---|---|
| Bina duvarı (baskın) | Kirli krem | `#E8DCC8` |
| Bina duvarı (ikincil) | Soluk terrakota | `#C97B5A` |
| Çatı | Kiremit kırmızısı | `#A34A32` |
| Asfalt | Koyu gri | `#3D3D42` |
| Kaldırım | Açık gri-bej | `#B8B0A4` |
| Bitki | Zeytin yeşili | `#6B7B4A` |
| Deniz | Derin turkuaz | `#1B5E6B` |
| Resmî ve kolluk | Lacivert | `#1E3A5F` |
| Adalet ve kurum | Taş grisi | `#8A8578` |
| Sağlık | Soluk yeşil-beyaz | `#D9E6DC` |
| Uyarı ve alarm | Turuncu-kırmızı | `#D64525` |

Palete sadık kalın. Her yapı kendi şemasını uydurursa şehir dağınık görünür.

### 1.4 Aydınlatma

- **Gündüz:** Sıcak, sarımsı, yumuşak gölge.
- **Akşam üstü:** Oyunun en güzel göründüğü an. Tüm kapak görselleri ve tanıtım çekimleri burada yapılır.
- **Gece:** Mavi-yeşil sokak lambaları, karanlık ara sokaklar.
- **Zaman döngüsü:** 1 oyun günü = 48 gerçek dakika.

Bu 48 dakika keyfî değil. Aklama kotası, denetim gecikmesi ve NPC ritmi buna bağlı (`03` §4).

### 1.5 Şiddetin görsel dili

Kural 6 gereği kan yoktur, ölüm yoktur, yüksek hasar yoktur (UK-14, UK-15). Bunun görsel karşılığı:

- Yaralanan oyuncu yere çöker ve sersemlik efekti görünür. **Kan, yara izi ve gore yok.**
- Ambulans ve sedye animasyonları sakin ve profesyoneldir.
- Silah efektleri abartısızdır: küçük namlu parlaması, hafif geri tepme, minimum duman.
- Elektroşok kısa bir mavi efekttir.
- Cezaevi kasvetli değil, resmî ve sakindir. Hücre temizdir.

### 1.6 Yapmayacaklarımız

Tanınmış gerçek marka logosu, tabelası veya ambalajı. Gerçek araçların birebir kopyası. Gerçek polis amblemi veya üniforması. Siyasi sembol. Kan, gore ve parçalanma. Bar, alkol şişesi ve içki tabelası (Moderate etiket sınırı, `00` §8).

---

## 2. Harita

### 2.1 Ölçek

Şehrin büyüklüğü stud sayısıyla değil, **yolculuk süreleriyle** tanımlanır (ORTAK-044). Eski belgedeki "2.000 × 2.000 stud" değeri iptal edildi; "arabayla 3–4 dakika" ifadesiyle tutarsızdı.

| Yolculuk | Hedef süre |
|---|---|
| Blackstone Bazaar'dan Ironhill'deki dükkâna, yaya | 60–90 sn |
| Blackstone'dan Oldport'a, araçla | 60–75 sn |
| Şehrin bir ucundan diğerine, araçla | 2–2,5 dk |
| Blackstone'dan Wrenmoor'a, araçla | 60–90 sn |
| Karakoldan adalet sarayına, yaya | 30 sn |

Gri kutu aşamasında bu süreler ölçülür ve ölçek buna göre ayarlanır (AÇIK-06). Harita küçük tutulur; sebebi teknik değil sosyaldir. Büyük harita oyuncuyu seyreltir ve şehir ölü görünür.

Wrenmoor uzaktır ama ulaşılabilir olmalıdır. Tahliye olan oyuncu için ücretsiz bir NPC servisi şehir merkezine döner; kimse uzun ve zorunlu bir yürüyüşe mahkûm edilmez.

### 2.2 Bölgeler ve inşa sırası

| Sıra | Bölge | Rol | Katman |
|---|---|---|---|
| 1 | **Blackstone Bazaar** | Tezgâhlar, prototip alanı, güvenli bölge | K0–K1 |
| 2 | **Blackstone Merkez** | Ana yoğunluk, kurumlar, büyük cepheler | K1–K3 |
| 3 | **Ironhill** | Dar yokuşlu mahalle, standart cepheler, kovalamaca | K3 |
| 4 | **Wrenmoor** | Kurum bölgesi: cezaevi | K4 |
| 5 | **Oldport** | Suç ekonomisi, depolar, sanayi yuvaları, aracılar | K5 |
| 6 | **Alderbrook / Willowfield** | Köyler, çiftçilik, Rural Guard | Yayın sonrası |
| 7 | **Northwood** | Kaçış rotası, av, vahşi hayvanlar | Yayın sonrası |
| 8 | **Marlowe Ridge / Deepvale** | Arazi sürüşü, manzara | Yayın sonrası |

### 2.3 Kurumlar

UK-10 ve UK-14 gereği kurumlar ana plana **baştan** yerleştirilir. Ayrıntılı mimari üretim oynanış prototipinden sonra yapılır; bu, kurumları vizyondan çıkarmak değildir (ORTAK-048).

| Kurum | Yer | İlk sürümde |
|---|---|---|
| **BMP Karakolu** | Blackstone meydanı | Giriş, delil masası, gözaltı alanı, kısa nezaret |
| **Baycrest Courthouse** | Karakola yürüme mesafesinde | Giriş, başvuru ekranı, bir duruşma salonu, bekleme alanı |
| **Verania General Hospital** | Blackstone, ana yola yakın | Acil girişi, tedavi alanı, çıkış; ambulans garajı |
| **Wrenmoor Correctional Facility** | Kurum bölgesi | Kabul, hücre bloğu, ortak alan, görev alanı, avlu, kaçış rotası |
| **Civic Licensing Office** | Blackstone meydanı | Ruhsat işlemleri, işletme satın alma; kısa ve anlaşılır |

Hastane ana yola yakın olmalıdır: ambulans ulaşımı ve yaralı nakli oyunun sık yaşanacak anıdır.

Cezaevi için builder notu: **kaçış rotası bir oynanış yoludur.** Bakım tüneli, gözetleme kulesinin görüş konisi ve dış çitteki boşluk gri kutu aşamasında test edilebilir olmalıdır (`09` §11.1).

### 2.4 İşletme yuvaları

`01-SAHIPLIK-VE-ISLETME.md` §2.3'teki mimarinin fiziksel karşılığı. Bu, haritanın en kritik kararıdır.

| Yuva sınıfı | Nerede | Sunucu başına | Ölçü |
|---|---|---|---|
| **Çarşı tezgâhı** | Blackstone Bazaar | 24 | Küçük, standart tezgâh gövdesi ve tabela alanı |
| **Standart cephe** | Ironhill (14), Blackstone (4) | 18 | Aynı kapı, vitrin ve tabela ölçüsü |
| **Büyük cephe** | Blackstone Merkez | 6 | Geniş vitrin, çift kapı |
| **Pasaj birimi** | Blackstone Arcade | 12 | Bina içi bağımsız birimler |
| **Sanayi yuvası** | Oldport ve Ironhill alt sokakları | 10 | Atölye, depo, proje ofisi; geniş kapı ve araç erişimi |

**Builder için zorunlu kurallar:**

- Her sınıfın içindeki yuvalar **birebir aynı ölçüdedir**: kapı genişliği, vitrin yüksekliği, tabela alanı.
- Tabela alanı boş bırakılır. Oyuncunun seçtiği şablon, metin ve renk oraya yerleşir.
- Dış görünüm işletme tipine göre değişebilir, ama **geometri aynı kalır**.
- İç mekânlar standart bir şablondan türer. Aile başına bir varyant yeterlidir: perakende, atölye, hizmet.
- Mobil işletmeler (taksi, kurye, minibüs) yuva tüketmez; ortak durak ve garaj kullanırlar.

### 2.5 Bölge notları

**Blackstone Bazaar.** Tek bir pazar sokağı, iki sıra tezgâh, üstü tenteli. Güvenli bölgedir: silah çekilemez. K0 prototipi burada geçer ve her yeni oyuncunun ilk sahipliği buradadır. Canlı, kalabalık ve sıcak görünmeli.

**Blackstone Merkez.** Izgara sokaklar, 3–5 katlı binalar, merkezde meydan. Karakol, adalet sarayı ve ruhsat ofisi meydana bakar. Büyük market meydanın karşısındadır. Soygun anında polis yaklaşık 20 saniye uzaklıktadır.

**Ironhill.** Oyunun en özgün bölgesi. Dar, dolambaçlı ve yokuşlu. Ani virajlar, kör noktalar ve merdiven sokaklar. Kovalamaca burada hız değil **yol bilgisi** ödüllendirir. Standart cephelerin çoğu burada.

**Oldport.** Konteyner, vinç, depo, dalgakıran. Loş, sisli, az NPC. Sanayi yuvaları ve yasadışı aracı burada. Suçluların güvende hissettiği tek yer.

**Wrenmoor.** Şehir çekirdeğinin dışında, tek yolla bağlı bir kurum bölgesi. Düz, açık, az sığınak. Kaçan birinin saklanacak yer bulması zor olmalı.

**Northwood** (yayın sonrası). Yol yok, patika var. Polis aracı giremez. Av tüfeği taşımanın normal karşılandığı tek bölge.

### 2.6 Sokak isimlendirme

Sokak adları İngilizce ve okunabilir olmalıdır. Kural: **sıfat + nesne** veya **meslek + sokak tipi**.

Örnekler: Harbour Lane, Old Mill Street, Tanner's Row, Anchor Way, Quarry Road, Salt Street, Cooper's Alley, Kiln Road, Net Quay, Forge Lane.

Şehir içi yön bulma bu adlara dayanır ve NPC tanık tarifleri bunları kullanır: "Harbour Lane tarafına kaçtı."

### 2.7 İbadethaneler

Blackstone'da bir cami ve bir kilise bulunur. İkisi de aynı özenle yapılır, ikisi de siluetin parçasıdır, ikisi de girilebilir ve sakin alanlardır.

**Kesin kurallar:**
- Hiçbir oynanış mekaniği, görev, ödül veya para kazancı ibadethanelere bağlanmaz. Dekordur.
- **Güvenli bölgedir:** silah çekilemez, hasar verilemez, suç işlenemez, araç giremez (ORTAK-043).

---

## 3. Varlık üretimi

### 3.1 İsimlendirme

```
Bolge_Kategori_Ad_Varyant

Blackstone_Bina_Apartman_01
Bazaar_Yuva_Tezgah_03
Ironhill_Yuva_StandartCephe_07
Wrenmoor_Bina_Hucre_01
Ortak_Arac_Sedan_01
Ortak_Prop_SokakLambasi_01
```

Türkçe karakter kullanmayın (ı, ş, ğ, ü, ö, ç). Bazı sistemler bunları bozar.

### 3.2 Modüler inşa

Parça kütüphanesi kurun: duvar parçaları (düz, köşe, pencereli, kapılı, balkonlu), zemin, çatı, balkon, kepenk, tente, klima, uydu anteni.

Bu parçalarla çok sayıda bina, tek tek modellemeye göre **çok daha hızlı** üretilir. (Eski belgedeki "20 bina 3 saatte" ifadesi ölçülmemiş bir vaatti ve kaldırıldı.)

**Izgara:** Her şey 4 stud ızgarasına oturur.

### 3.3 Optimizasyon

Aşağıdaki değerler platform sınırı değildir. Görsel kalite ve performans için **ilk üretim hedefleridir**; K1'de gerçek Android cihaz ve Roblox profiler ölçümleriyle değiştirilebilir (`04` §13). Varlık başına karar ve ölçüm kaydı `AI_CONTEXT/3D_MODELING` içindedir.

| Kural | Neden |
|---|---|
| Görünmeyen yüzleri silme | Parça sayısı |
| Tekrarlanan yapılar için paket bağlantısı | Bellek, toplu güncelleme |
| `CanCollide = false` dekoratifte | Fizik yükü |
| `CastShadow = false` küçük nesnede | Gölge pahalı |
| Küçük prop dokusunda 512×512 veya altıyla başlama | Ekranda kapladığı alana göre gereksiz piksel yükünü önleme; gerekirse ölçerek büyütme |
| Bölge başına 3.000 parça ilk inceleme eşiği | Ölçüm tetikleyicisi; tek başına FPS garantisi değildir |
| Her mesh için `CollisionFidelity` elle | Varsayılan değer performansı yer |

### 3.4 Varlık kaynakları

Varlık brief'i, teknik aktarım ve kabul kanıtı için `AI_CONTEXT/3D_MODELING/` standardı kullanılır. İlk K0/K1 varlık kimlikleri `DESIGN_DRAFTS/3D/ASSET_REGISTER.md` içindedir. K0 tezgâhı Studio'da sanat adayıdır; K1 cephe kiti hâlâ taslaktır. Aday olmak, cihaz ve haklar QA'sını geçtiği anlamına gelmez.

**Creator Store.** Lisansını her seferinde kontrol edin ve lisans kaydını tutun. Oyuna koymadan önce **içindeki script'leri silin**; kötü niyetli varlık yaygındır.

**AI üretimi.** Studio'nun gömülü MCP sunucusu prompt'tan dokulu mesh ve malzeme üretebiliyor. Prop ve dolgu nesnelerinde denenebilir; ana yapılar için önce modüler parça standardı uygulanır. Üretim ve kabul süreci: `AI_CONTEXT/3D_MODELING/PIPELINE.md`.

**Kendi modelleriniz.** Blender ücretsizdir. Basit bina ve prop için temel düzeyde öğrenmek yeterlidir.

---

## 4. Karakter görünümü

### 4.1 Oyuncu: RP kıyafet katmanı

Oyuncu şehirde, Roblox avatarının üzerine giyilen oyun içi **RP kıyafetini** taşır (ORTAK-022). Bu karar tanık sisteminin çalışması için zorunludur.

- RP kıyafeti giyildiğinde avatarın yüz ve baş aksesuarları gizlenir; saç görünür kalır.
- **Maske yalnız oyun içi bir eşyadır.** Böylece "maskeli mi" sorusunun net bir cevabı olur.
- Meslek kıyafetleri ayrı setlerdir: polis, sağlık, itfaiye, cezaevi görevlisi, tamirci, kurye.
- İlk sürüm için 8–10 sivil set, 5 meslek seti ve birkaç renk varyantı yeterlidir.
- Kozmetik kıyafet paketleri bu katmana eklenir (`03` §13).

### 4.2 NPC görünümleri

50–100 farklı görünüm hedefleyin. Çalışma zamanı maliyeti çok düşüktür, ama bellek ve doku maliyeti vardır (`04` §8.3).

- 10–12 kıyafet seti, rastgele kombinlenir.
- Yaş ve tip çeşitliliği: yaşlı, genç, işçi, memur, esnaf, öğrenci, turist.
- **Kıyafet renkleri net ayırt edilebilir olmalı.** Tanık tarifi buna dayanır.
- `Humanoid` yok (`04` §8).

---

## 5. Animasyon

### 5.1 Öncelik 1 — imza sistemleri (K0–K4)

Bunlar olmadan oyun kendini anlatamaz.

| Animasyon | Süre | Nerede | Katman |
|---|---|---|---|
| Tezgâhta satış: ürün uzatma | ~1,2 sn | Bazaar, sürekli tekrar | K0 |
| Kasiyerlik: ürün okutma | ~1,2 sn | Market | K0 |
| Para üstü verme | ~1 sn | Market, tezgâh | K0 |
| Raf ve tezgâh doldurma | ~2 sn, döngü | Büyütme | K1 |
| Maaş verme, zarf uzatma | ~1,5 sn | Çalışan yönetimi | K1 |
| Telefona bakma | döngü | Her yerde | K1 |
| **Çantayı açıp gösterme** | ~2 sn | Polis sorgusu — imza an | K3 |
| **Çantayı kapatıp reddetme** | ~1 sn | Polis sorgusu | K3 |
| Silahı kılıftan çekme | ~0,8 sn | Envanter | K3 |
| Eller yukarı, teslim | döngü | Durdurma, NPC korkusu | K3 |
| Kasa boşaltma | ~3 sn, döngü | Soygun | K3 |
| **Yaralı: yere çökme** | ~1,5 sn | Çatışma — kansız | K3 |
| **Yaralı: yerde bekleme** | döngü | Yardım beklerken | K3 |
| **İlk yardım yapma** | ~3 sn, döngü | Sağlık ekibi | K3 |
| Sedyeye alma | ~2,5 sn | Ambulans | K3 |
| Kelepçeleme (polis) | ~2 sn | Gözaltı | K3 |
| Kelepçelenme (suçlu) | ~2 sn | Gözaltı | K3 |
| **Duruşmada ayağa kalkma** | ~1,5 sn | Adalet sarayı | K4 |
| **Karar okunurken bekleme** | döngü | Adalet sarayı | K4 |
| Cezaevi görevi: süpürme veya taşıma | döngü | Wrenmoor | K4 |
| Kilit açma, alet kullanma | ~3 sn, döngü | Kaçış, suç | K4 |

### 5.2 Öncelik 2 — hareket seti

Yürüme, koşma, idle (silahsız), **idle (elinde tabanca)**, idle (sırtta uzun eşya), araca binme ve inme, ağır çantayla taşıma yürüyüşü, kelepçeli yürüme.

**Not:** "Elinde tabancayla idle" ayrı bir animasyon olmak zorundadır. Gizleme sisteminin görsel karşılığı budur: oyuncu silahını gizleyemediğinde bunu bedeninde görmelidir.

### 5.3 Öncelik 3 — yaşam (yayın sonrası)

Oturma, yemek yeme, mangal çevirme, kapı açma, anahtar çevirme, el sıkışma, işaret etme.

### 5.4 NPC animasyonları

NPC'lerde `Humanoid` yoktur, ama **`AnimationController` ve `Animator` ile normal animasyon oynatılır**. Eklemleri tek tek Tween'lemek gerekmez; bu sürüm 2.0'daki bir hatanın düzeltilmesidir (ORTAK-015).

NPC'lerin ihtiyacı olan jestler kısadır: yürüme döngüsü, durma, korku (eller yukarı), işaret etme, telefonla konuşma, müşteri sırasında bekleme.

### 5.5 Nasıl üretilecek

| Yöntem | Maliyet | Nerede kullanılır |
|---|---|---|
| Studio Animation Editor, elle | Ücretsiz, yavaş | İmza animasyonları |
| Studio içi AI animasyon eklentileri | Ücretsiz başlangıç, kredi sınırı | Hareket seti, NPC jestleri |
| Creator Store hazır animasyon | Ücretsiz, lisans kontrolü şart | Yürüme, koşma, idle |
| Blender ve retarget | Ücretsiz, öğrenme eğrisi var | Son çare |

**Kural:** Öncelik 1 listesindeki animasyonlar **elle yapılır veya elle düzeltilir**. Bunlar oyunun imzasıdır ve jenerik hissettiremezler. Öncelik 2 ve 3 için AI ve hazır varlık serbesttir.

---

## 6. Builder iş akışı

1. **Kâğıtta kroki.** Sokaklar, ana binalar, oyuncu akış yönleri. 15 dk.
2. **Gri kutu.** Yalnız gri bloklarla hacim. Kovalamaca ve yolculuk süreleri test edilebilir mi?
3. **Oyna ve test et.** Arabayla gez, yürü, §2.1'deki süreleri ölç.
4. **Modüler parçalarla giydir.** Asıl iş.
5. **Prop yerleştir.** Şehri canlandıran şey budur.
6. **Aydınlatma ve rötuş.**
7. **Optimizasyon kontrolü.**

**En sık hata:** 2. adımı atlayıp 4'e geçmek. Sonra oynanış bozuk çıkar ve her şey baştan yapılır.

### 6.1 Bitmiş sayılma kriteri

- Arabayla gezilebiliyor, takılan yer yok
- Yaya olarak gezilebiliyor, görünmez duvar yok
- §2.1'deki yolculuk süreleri hedef aralıkta
- Gece ve gündüz ikisinde de iyi görünüyor
- Parça sayısı bütçe içinde
- Orta seviye telefonda 30 FPS
- **Yuva varsa:** ölçüler standart, tabela alanı boş, iç mekân şablonu bağlı
- **Kurum varsa:** giriş, işlem noktası ve çıkış anlaşılır; NPC ulaşımı bağlı

---

## 7. Araçlar

### 7.1 Kurgusal markalar

Marka adları değiştirildi. "Anadol" ve "Kartal" gerçek Türk otomotiv adlarıyla çakışıyordu ve `00` Kural 3 ile `08` §10'u ihlal ediyordu (ORTAK-032).

| Marka | Tip | Hissi |
|---|---|---|
| **Doruk** | Sedan, hatchback | Halk arabası |
| **Ova Motors** | Kamyonet, minibüs | İşçi aracı |
| **Siper** | Polis, SUV, ambulans, itfaiye | Resmî |
| **Egemen** | Spor, lüks | Zengin oyuncu hedefi |

Bunlar kurgusal marka adlarıdır. Gerçek dünyada da markalar yabancı isimli olabilir; bu, şehre karakter katar ve okunabilirliği bozmaz. Her yeni ad marka aramasından geçer (AÇIK-02).

### 7.2 İlk sürüm listesi

| Araç | Kullanım | Öncelik | Katman |
|---|---|---|---|
| Doruk Hatchback | Taksi, başlangıç | 1 | K1 |
| Doruk Sedan | Sivil | 1 | K1 |
| Siper Devriye | Polis | 1 | K3 |
| **Siper Ambulans** | Sağlık | 1 | K3 |
| Ova Kamyonet | Kargo, stok taşıma | 2 | K3 |
| Ova Minibüs | Toplu taşıma, cezaevi nakli | 2 | K4 |
| Siper İtfaiye | İtfaiye | 3 | K5 |
| Egemen Spor | Lüks | 3 | K5 |

Ambulans önceliği yükseldi: UK-14 gereği yaralı nakli çekirdek bir döngüdür.

### 7.3 Plaka

Format: `BC 42 VRN`. Her araca özgün bir plaka atanır.

Plaka tanık sisteminde bir delildir: **uzaktan okunabilir olmalıdır.** Doku çözünürlüğü ve yazı boyutu buna göre ayarlanır. Bu, "güzel görünsün" değil, oynanış gereğidir.

### 7.4 Bagaj

Her araçta 24 birimlik bagaj vardır (`02` §2.1). Bagaj kapağı açılabilir olmalı ve açıkken içerik görünür olmalıdır. Açık bagajda kirli nakit göstermek, markette çanta açmakla aynı riski taşır.

---

## 8. İlk hafta: builder'ların yapacağı

Tezgâh ve modüler parça işine başlamadan önce `DESIGN_DRAFTS/3D/ASSET_REGISTER.md` içindeki ilgili brief okunur; üretilen varlık QA ve köken kaydına bağlanır.

1. Studio'da yeni bir Baseplate aç.
2. 4 stud ızgarasına oturan 5 duvar parçası yap: düz, köşe, pencereli, kapılı, balkonlu.
3. Bu parçalarla 3 farklı bina kur.
4. **Bir standart çarşı tezgâhı yap.** Ölçüleri not al; bunlar tüm projenin standardı olacak.
5. Önüne sokak, kaldırım ve 5 prop koy.
6. Aydınlatmayı akşam üstüne ayarla, ekran görüntüsü al, gruba at.
