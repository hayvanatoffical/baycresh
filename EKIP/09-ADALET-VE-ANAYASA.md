# BAYCREST — Adalet ve Anayasa

**Sürüm:** 3.0 · 24 Eylül 2026 · **Yeni belge**
**Durum:** Tasarım baz çizgisi; dava, cezaevi ve testler oyunda uygulanmış sayılmaz.
**Okuyucu:** Tasarımcı ve kodcu için zorunlu. Diğer herkes 1–2. bölümleri okur.
**Ön koşul:** `00`, `02`
**Bağlı kararlar:** UK-03, 04, 05, 06, 07, 08 · ORTAK-017, 018, 039, 047, 053

Bu belge kurgusal Verania'nın oyun hukukunu anlatır. **Gerçek bir ülkenin hukukunu açıklamaz** ve Roblox'un platform kurallarının yerine geçmez. Belgedeki süre ve tutarlar başlangıç değeridir; tek kaynakları `03-EKONOMI.md` §14'tür ve K4 testinde ayarlanır.

---

## 1. Amaç ve sınır

Bu belgenin amacı, suçun sonunu bir kovalamacadan **anlaşılır bir hukuk sürecine** dönüştürmektir: olay → delil → dosya → karar → infaz → kapanış.

Tasarım hedefleri:

- **Adil:** Masum bir oyuncu, yalnız çanta göstermediği veya başkası onu suçladığı için hapse girmez.
- **Hafif:** Cezalar kısadır. Oyuncu cezasını tamamlamak için uzun süre ekrana bakmaz (UK-08).
- **Kesintisiz:** Dava, sanık oyunda olmasa da ilerler ve sonuçlanır (UK-04).
- **Anlaşılır:** Her karar, hangi delilin hangi şartı karşıladığını gösterir.

Kapsam dışı: oyuncu hâkim yoktur (ORTAK-039). Mahkeme, sunucunun doğruladığı kurallarla çalışan bir **NPC mahkemedir**. Oyuncular polis, tanık ve sonraki aşamada avukat olarak katılır. Hiçbir oyuncu diğerine keyfî ceza veremez.

## 2. Verania Anayasası

Anayasa uzun bir hukuk ansiklopedisi değildir. Oyuncunun davranışlarının sonucunu önceden görebilmesini sağlayan on iki kısa ilkedir. Oyuncu bunları mahkeme binasında ve telefonun **Dosyalarım** sekmesinde okuyabilir.

| Madde | İlke | Oyundaki karşılığı |
|---|---|---|
| V-A01 | Mülkiyetin devamlılığı | Normal ceza şirketi, evi ve aracı silmez. Suç geliri ve suç aleti bunun dar istisnasıdır. |
| V-A02 | Delile bağlı sorumluluk | Şüphe, maske, yüksek nakit veya sorguya ret tek başına mahkûmiyet değildir. |
| V-A03 | Açık suç tanımı | Her suçun eylemi, gerekli delili ve yaptırım aralığı oyuncuya açıkça gösterilir (§6). |
| V-A04 | Ölçülülük | Küçük ihlal hapisle cezalandırılmaz. Tek bir infaz 10 dakikayı geçmez. |
| V-A05 | Savunma ve temsil | Her sanığın savunma yolu vardır. Oyunda değilse ücretsiz NPC temsilci savunur. |
| V-A06 | Yoklukta işlem | Oyunda olmamak süreci durdurmaz; katılmamak suçluluk kanıtı değildir. |
| V-A07 | Çıkar çatışması yasağı | Kimse kendi dosyasını veya taraf olduğu vakayı yönetemez. |
| V-A08 | Gerekçeli karar | Karar, hangi delilin hangi şartı karşıladığını ekranda açıklar. |
| V-A09 | İtiraz ve düzeltme | Yanlış kimlik, eksik bağlam veya sistem hatası için itiraz yolu vardır. |
| V-A10 | Aynı işlem bir kez | Aynı olay için ikinci kez para kesilmez veya süre eklenmez. |
| V-A11 | Eşit yargısal erişim | Robux; delili, kararı, ceza süresini veya kaçış kolaylığını değiştirmez. |
| V-A12 | Oyun hukukunun sınırı | Hile yaptırımları ve platform moderasyonu mahkemeden ayrıdır; mahkeme bunları geçersiz kılamaz. |

## 3. Kural katmanları

1. **Anayasa:** Yukarıdaki on iki ilke.
2. **Suç ve yaptırım kataloğu:** Her suçun kimliği, eylemi, gerekli delili ve yaptırım aralığı (§6).
3. **Kurum yetkileri:** Polis, FCU, mahkeme, cezaevi, sağlık (§4).
4. **İş ve sözleşme kuralları:** Teslim, ücret, kalite ve maaş uyuşmazlıkları. Bunlar mahkemeye gitmez; **otomatik uyuşmazlık kararıyla** çözülür. Örneğin şerefli çalışanın tazminat talebi bu katmandadır (`01` §5.3). Böylece adalet sarayı gündelik işler için zorunlu bir kuyruğa dönüşmez.
5. **Sunucu topluluk kuralları:** Özel sunucu sahiplerinin kuralları. Platform kurallarını aşamaz ve kalıcı ekonomide ceza yetkisi oluşturamaz.

## 4. Kurumlar ve yetkiler

| Kurum | Yer | Yetkisi | Yetkisi olmayan |
|---|---|---|---|
| **BMP** (şehir polisi) | Blackstone karakolu | Soru, gerekçeli durdurma, delile dayalı arama, gözaltı, delil toplama, dosya açma | Ceza vermek, süre belirlemek |
| **FCU** (mali şube) | Karakol içinde | Denetim açma (dayanakla), defter inceleme, mali dosya | Kendi bağlantılı dosyaları (`02` §12.3) |
| **Mahkeme** (NPC) | Baycrest Courthouse | Kural tablosuna göre karar, yaptırım, itirazı değerlendirme | Katalog dışı ceza, tavan üstü süre |
| **Cezaevi** | Wrenmoor Correctional Facility | İnfaz, koşullu tahliye görevleri, kaçış olayı | Süreyi keyfî uzatmak |
| **Sağlık** | Verania General Hospital | Yaralı nakli ve tedavi | Suçluyu serbest bırakmak |

Oyuncu rolleri: **polis** delil toplar ve dosyayı sunar; **tanık** olayı gördüyse ifadesi kaydedilir; **cezaevi görevlisi** görevleri ve kaçış olaylarını yönetir. **Avukatlık** yayın sonrasında gelir. Ücretsiz NPC temsilin yerine ücretli bir zorunluluk olarak gelmez.

## 5. Delil modeli

### 5.1 Delil türleri ve gücü

| Delil | Güç | Not |
|---|---|---|
| **Sistem olayı** (soygun başladı, atış, hasar, kaçış) | Olayı kanıtlar | Kimliği ancak olayın doğası gereği bağlar: kaçış, durdurmadan kaçma, görevlinin kendi hasar kaydı |
| **Kamera kaydı** (polis tarafından alınmış) | Güçlü | Maskeliyse yüz yok; kıyafet ve boy var |
| **Net tanık ifadesi** (alınmış) | Güçlü | |
| **Bulanık tanık ifadesi** | Orta | İki bulanık ifade ve kıyafet eşleşmesi birlikte güçlü sayılır |
| **Kısmi tanık ifadesi** | Zayıf | Tek başına yetmez |
| **Suç anında yakalanma**, üzerinde o olaya ait kirli nakit veya suç eşyası | Güçlü | Kirli nakit olay kimliği taşır |
| **Plaka kaydı** | Orta | Aracı bağlar, sürücüyü değil |
| **Denetim bulgusu** | Güçlü | Yalnız S-07 için |

**Delil sayılmayanlar:** Çanta reddi, şüphe kaydı ve oyuncunun serbest metinle yaptığı ihbar. İhbar yalnız ilk incelemeyi başlatabilir.

### 5.2 Mahkûmiyet kuralı

Bir suçtan mahkûmiyet için iki şart birlikte gerekir:

1. **Olay kanıtı:** Suçun gerçekleştiğine dair bir sistem olayı veya denetim bulgusu.
2. **Kimlik bağı:** En az **bir güçlü** veya **iki orta** delil. Kimliği olayın kendisi bağlıyorsa (kaçış gibi) bu şart karşılanmış sayılır.

### 5.3 Delil–sanık bağı

Her delil, sunucuda kaynağıyla birlikte saklanır; örneğin bir tanık kaydı hangi oyuncunun görüntüsünden üretildiğini bilir. Mahkeme, dosyadaki sanığın delilin kaynağıyla eşleştiğini doğrular.

> Sunucu faili bilir; mahkeme yalnız **toplanmış deliği** görür.

Bunun iki sonucu vardır:

- **Masum, başkasının suçundan mahkûm olamaz.** Yanlış kişiye yöneltilen dosya beraatla kapanır ve dosyayı açan memurun yetki puanı düşer.
- **Suçlu, delil toplanmadıkça mahkûm olmaz.** Polisin işi faili bulmak ve delil toplamaktır. Mahkemenin her şeyi bilen bir makine olmaması bu yüzden oyunun kendisidir.

### 5.4 Delili kim toplar

- **Oyuncu polis:** Olay yerindeki tanıklardan ifade alır, kamera kaydını ister, bulanık tanıkları eşleştirir, defter bulmacasını çözer.
- **Oyuncu polis yoksa NPC soruşturması:** Yalnız sistem olayını, kamera kaydını ve net tanıkları toplar. Oyuncu polis daha fazla delil toplayabildiği için dosyaya değer katar.

## 6. Suç ve yaptırım kataloğu v1

İlk sürüm az sayıda suçla başlar. Katalog büyüdükçe bu tabloya satır eklenir; her satırın bir kimliği vardır.

| Kod | Suç | Gerekli delil | Yaptırım aralığı |
|---|---|---|---|
| **S-01** | Ruhsatsız silah taşıma | Delile dayalı aramada veya yaralanınca silahın bulunması | Silaha el koyma ve 1.500–3.000 ₡; tekrarında 1–2 dk hapis |
| **S-02** | Kamu düzenini bozma: havaya ateş, şehirde silahı açıkta gezdirme | Sistem kaydı ve kimlik bağı | İlkinde uyarı; sonra 500–1.500 ₡; tekrarında 1 dk |
| **S-03** | NPC şehir hedefinin soygunu | Sistem soygun olayı ve kimlik bağı | Kirli nakde el koyma ve 3–6 dk |
| **S-04** | Oyuncu işletmesinin soygunu | Sistem soygun olayı ve kimlik bağı | Kirli nakde el koyma, mağdura telafi ve 2–5 dk |
| **S-05** | Görevliyi yaralama (polis, sağlık, cezaevi) | Görevlinin sistem hasar kaydı | 5–8 dk |
| **S-06** | Gerekçeli durdurmadan kaçma | Sistem kaydı | 500–1.000 ₡ veya 1 dk |
| **S-07** | Aklama: riskli bölgede biriken tutarsızlık | Denetim bulgusu | Tutarsız tutar kadar para cezası ve işletmenin bir oyun günü askıya alınması; hapis yok |
| **S-08** | Cezaevinden kaçış | Sistem kaçış olayı | Kalan süre + 2 dk (teslim olursa +1 dk); tavan 10 dk |

**Kurallar:**
- **Tek infaz tavanı 10 dakikadır.** Aynı dosyadaki suçlar üst üste eklenmez; en ağır olanın aralığı esas alınır ve ağırlaştırıcılar (tekrar, görevli yaralama) aralığın üst yarısına taşır.
- **Ağırlaştırıcılar:** Son 1 gerçek gün içinde aynı suçtan mahkûmiyet, suç alanında ateş edilmesi.
- **Hafifleticiler:** İkrar (%25 indirim), teslim olma, ilk suç.
- **Para cezası yetmezse** borç oluşmaz; kısa bir kamu hizmeti görevine dönüşür.

## 7. Dosyanın yaşam döngüsü

| Durum | İşlem | Sonraki olasılık |
|---|---|---|
| **Olay kaydı** | Sunucu doğrulanabilir bir olayı kaydeder | İlk inceleme |
| **İlk inceleme** | Olay, suç tanımıyla eşleştirilir | Kapanış veya soruşturma |
| **Soruşturma** | Tanık, kamera ve işlem kayıtları toplanır | Delil yetersizliği veya iddia |
| **İddia ve bildirim** | Sanığa dosya özeti gönderilir | Duruşma |
| **Duruşma** | Katılım, savunma veya NPC temsil | Karar |
| **Karar** | Kurallı değerlendirme | Beraat, para veya hizmet yaptırımı, kısa hapis |
| **İnfaz** | Karar, kimliğiyle bir kez uygulanır | Süre biter, koşullu tahliye, itiraz sonucu veya kaçış |
| **Kapanış** | Kısıtlar kalkar; sınırlı bir geçmiş saklanır | Yeni bir olay yoksa yeni ceza yok |

**İki yol vardır:**

- **Hızlı yargılama:** Suç anında yakalanan ve delili tam olan sanık gözaltına alınır. Duruşma hemen, en geç 1 dakika içinde, sanık oyundayken yapılır. En sık yaşanacak yol budur.
- **Olağan yargılama:** Faili sonradan tespit edilen dosyalarda sanığa bildirim gider ve duruşma, bildirim penceresi dolunca yapılır (§8.1).

**Gözaltı**, mahkûmiyetle aynı şey değildir. Karakolda en fazla 2 dakika sürer ve yalnız hızlı yargılama için kullanılır. Gereksiz uzun ön tutma yoktur.

## 8. Duruşma

### 8.1 Bildirim ve pencere

Olağan yargılamada sanığa telefonuna ve dönüş özetine bildirim gider: suçlama, delil özeti, duruşma zamanı ve seçenekler. Duruşma, bildirimden **10 gerçek dakika** sonra yapılır. Bu başlangıç değeridir (AÇIK-12).

### 8.2 Savunma seçenekleri

Sanık oyundaysa Baycrest Courthouse'a gidebilir ya da telefonundan dosya üzerinden savunma yapabilir:

| Seçenek | Ne olur |
|---|---|
| **İkrar** | Suçu kabul eder; yaptırımda %25 indirim |
| **İtiraz noktası seçmek** | "Yanlış kimlik", "meşru müdafaa", "bağlam dışı değildi" veya "sistem hatası". Sunucu kendi kayıtlarından otomatik olarak kontrol eder; örneğin meşru müdafaa için önce kimin hasar verdiğine bakar. |
| **Sessiz kalmak** | NPC temsilci aynı otomatik kontrolleri yapar |

### 8.3 Yoklukta yargılama

- Sanık oyunda değilse dava durmaz. **Ücretsiz NPC temsilci**, §8.2'deki bütün otomatik kontrolleri yapar. Bu yüzden oyunda olmamak sonucu kötüleştirmez.
- Kayıtta "sanık bizzat katıldı" yazılmaz. Durum doğru biçimde tutulur: **"yokluğunda, temsil yoluyla sonuçlandı."**
- Oyunda olmadığı için ek ceza veya ek para cezası oluşmaz.
- Sanık giriş yaptığında suçlama, delil özeti, karar, süre ve itiraz yolu tek bir özet ekranda gösterilir. Kimse sessizce bir hücreye bırakılmaz.

### 8.4 Karar ekranı

Karar ekranı şunları gösterir: suç kodu ve adı, kullanılan deliller ve karşıladıkları şart, yaptırım, süre, uygulanan indirim ve ağırlaştırıcılar, itiraz yolu (V-A08).

## 9. İnfaz

### 9.1 Süre

- Hapis süresi **gerçek dakikayla** ölçülür. Tek infaz tavanı **10 dakikadır**.
- **Kaçak değilken çevrimdışı süre de sayılır.** Giriş yaptığında süre kalmışsa cezaevinde başlarsın; bitmişse serbest başlarsın ve karar özetini görürsün (ORTAK-047).
- Oyundan çıkıp dönmek, sunucu değiştirmek, avatarı sıfırlamak veya yaralanmak infazı sıfırlamaz. Yalnız gerçek zaman ilerler.

UK-06'daki "çıkmak tek hamlede kolay olmasın" ilkesi, **erken çıkış yollarının zorluğuyla** karşılanır (§10). Normal süre kısa ve güvenilir yoldur.

### 9.2 Cezaevi hayatı

Wrenmoor Correctional Facility'de hücre, ortak alan ve görev alanı (çamaşırhane, mutfak, bahçe) bulunur.

- Mahkûm diğer mahkûmlarla konuşabilir ve görev yapabilir.
- Telefon **yalnız okuma** modundadır: işletmelerini görür, yönetemez.
- İşletmeleri bu sürede normal NPC verimiyle çalışmaya devam eder. Ceza likiditeye vurur, işletmeye değil.

## 10. Çıkış yolları

| Yol | Koşul | Bedel ve sınır |
|---|---|---|
| **Normal tahliye** | Sürenin dolması | En güvenilir yol; ücretsiz |
| **Koşullu erken tahliye** | Cezaevi görevlerini tamamlamak | Süreden toplam en fazla %30 indirim. Her görev belirli aralıkla bir kez yapılabilir; görev tekrarlayarak süre sıfırlanamaz |
| **Başarılı itiraz** | Yanlış kimlik, eksik bağlam veya sistem hatasının gösterilmesi | Para ödeyerek karar silinmez. Kabul edilen itiraz bir düzeltme kaydı üretir (§12) |
| **Kaçış** | Çok adımlı kaçış senaryosunu tamamlamak | Kaçış raporu ve yakalanma riski; tek tuş veya ücretli ürün değildir (§11) |
| **Kefalet** | — | Ertelendi. Ekonomik üstünlüğe dönüşürse hiç eklenmez |

İlk sürümde: normal tahliye, üç koşullu tahliye görevi, temel itiraz ve iyi test edilmiş **tek bir** kaçış senaryosu. Birden fazla kaçış rotası, çekirdek akış çalıştıktan sonra eklenir.

## 11. Kaçış ve kaçış raporu

### 11.1 Senaryo (K4)

Kaçış çok adımlıdır ve oyun içinde gözlenebilir:

1. Görev alanında bir alet edinme fırsatını yakalamak.
2. Bakım tünelinin kilidini süreli bir mini oyunla açmak.
3. Gözetleme kulesinin görüş alanından zamanlamayla geçmek.
4. Dış çitteki boşluktan çıkıp kurum bölgesinden uzaklaşmak.

Bir NPC veya oyuncu görevli fark ederse kaçış başarısız olur ve süreye 1 dakika eklenir. Kaçış sırasında bağlantı koparsa girişim iptal olur: oyuncu hücrede başlar ve ek ceza almaz. Kopan bağlantı hiçbir durumda başarılı kaçış sayılmaz.

### 11.2 Kaçış raporu

Kaçış tamamlandığında sunucu **bir kez** kaçış olayı üretir. Rapor şunları içerir: kişi ve vaka kimliği, kaçış zamanı, son doğrulanmış görünüm ve son görüldüğü konum.

- **Sürekli ve nedensiz canlı konum yoktur.** Konum, yeni gözlemler geldikçe güncellenir.
- Oyuncunun durumu **Kaçak** olur. Kaçakken infaz sayacı durur.
- Çevrimdışı kalıp dönmek kaçış kaydını ve kalan süreyi silmez.

### 11.3 Kaçaklığın sonu

| Nasıl biter | Sonuç |
|---|---|
| Yakalanmak | Kalan süre + 2 dk; toplam tavan 10 dk |
| Teslim olmak | Kalan süre + 1 dk |
| **Zaman aşımı:** 30 dakika çevrimiçi kaçaklık | Kalan süre ve kaçış cezası, dakika başına bir para cezasına çevrilir ve dosya kapanır |

Kaçakken banka ve işletme yönetimi açıktır; oyuncu ekonomik olarak dışlanmaz. Ama güvenli bölge korumasından yararlanamaz ve kaçaklık bir gerekçeli durdurma sebebidir. **Oyuncu sonsuza kadar kaçak kalmaz.**

## 12. İtiraz ve düzeltme

- Her karara karar sonrası **bir kez** itiraz edilebilir. Oyuncu bir gerekçe seçer ve sunucu kayıtları yeniden kontrol eder.
- İtiraz kabul edilirse aktif kısıtlar hemen kalkar, el konulan meşru eşya ve para iade edilir ve yanlışlıkla geçirilen hapis süresi için küçük bir oyun içi telafi ödenir.
- Sistem hatası kaynaklı düzeltmeler, ekip tarafından da başlatılabilir ve bir düzeltme kaydı bırakır.

## 13. Kötüye kullanım önlemleri

| Risk | Önlem |
|---|---|
| Kişinin kendi dosyasına müdahalesi | Kendi dosyasına ve bağlantılı dosyalara polis veya FCU rolünde erişemez (V-A07) |
| Aynı olay için çifte ceza | Her karar ve infazın benzersiz kimliği var; ikinci uygulama reddedilir (V-A10) |
| Polisin yanlış kişiye dosya açması | Delil–sanık bağı beraatla kapatır; memurun yetki puanı düşer |
| İki hesapla anlaşmalı suç ve yakalama | Polis ödülü, arkadaş veya son 7 günde transfer yapılmış kişi yakalandığında verilmez |
| Özel sunucu yöneticisinin adalete müdahalesi | Yönetim araçları dava, karar ve infaza dokunamaz; serbest RP modunda adalet sonuçları kalıcı değildir |
| Robux ile avantaj | Yoktur (V-A11) |
| Sağlık ödülü istismarı | Sağlık ödülü yalnız doğrulanmış olaylarda ve kurban başına sınırlı verilir |

## 14. Kabul senaryoları

Bu senaryolar bir **test planıdır**; çalıştırılmış test sonuçları değildir.

1. Masum kişi, yalnız çanta göstermediği için hapse girmiyor.
2. Delili yetersiz olan dosya kapanıyor.
3. Yanlış kişiye yöneltilen dosya beraatla kapanıyor ve memurun yetki puanı düşüyor.
4. Çevrimdışı sanık ücretsiz temsille sonuç alıyor; kayıtta "yokluğunda" yazıyor.
5. Aynı karar iki sunucuda iki kez para kesmiyor ve süre eklemiyor.
6. Kişi kendi dosyasını polis rolünde değiştiremiyor.
7. Kaçak olmayan kişinin cezası çevrimdışıyken doğru süreyle ilerliyor.
8. Süresi biten kişi girişte tekrar hücreye kilitlenmiyor.
9. Kaçış bir rapor oluşturuyor; yeniden giriş raporu silmiyor.
10. Kaçış sırasında kopan bağlantı başarılı kaçış sayılmıyor.
11. Meşru müdafaa itirazı, hasarı ilk kimin verdiğini doğru kontrol ediyor.
12. Aranma ≥2 iken yaralanan kişi hastane çıkışında gözaltına alınıyor; aranmayan kişi alınmıyor.
13. Yanlış karar düzeltildiğinde kısıtlar kalkıyor ve telafi ödeniyor.

## 15. Katman planı

**K3 (geçici):** Mahkeme henüz yoktur. Suç anında yakalanan kişiye katalogdaki para cezası ve 1 dakika gözaltı otomatik uygulanır. Bu geçici çözüm K4'te kaldırılır.

**K4 (adalet prototipi):**
- Adalet sarayı gri kutu, bir duruşma salonu ve bekleme alanı
- Cezaevi: hücre, ortak alan, görev alanı
- Delil modeli, suç kataloğu v1 ve iki yargılama yolu
- NPC temsil, infaz, üç koşullu tahliye görevi, itiraz
- Tek kaçış senaryosu ve kaçış raporu

Kapı sorusu: *Karar adil ve anlaşılır mı; kısa ceza ve kaçış döngüsü eğlenceli mi?*

**Yayın sonrası:** Avukatlık mesleği, kefalet değerlendirmesi, ek kaçış rotaları, katalog genişlemesi.

## 16. Karar günlüğü

| Karar | Gerekçe | Kimlik |
|---|---|---|
| Kurgusal anayasa, 12 ilke | Suç ve ceza öngörülebilir olsun | UK-03 |
| NPC mahkeme, oyuncu hâkim yok | Keyfî ceza ve taciz riski | ORTAK-039 |
| Dava yoklukta sonuçlanır, NPC temsil ücretsiz | Oyunda olmak zorunlu olmasın | UK-04 |
| Delil–sanık bağı sunucuda doğrulanır | Masum, başkasının suçundan mahkûm olmasın | ORTAK-018 |
| Ret, şüphe ve ihbar delil değildir | Delile bağlı sorumluluk | ORTAK-053 |
| Tek infaz tavanı 10 dk, suçlar üst üste eklenmez | Hafif ceza | UK-08 |
| Kaçak değilken çevrimdışı süre sayılır | Hafif ceza; zorluk erken çıkış yollarında | ORTAK-047 |
| Dört çıkış yolu; kefalet ertelendi | Tek hamlede kolay çıkış olmasın | UK-06 |
| Kaçış raporu; kaçaklık zaman aşımıyla biter | Kaçış silinmesin ama sonsuz dışlanma da olmasın | UK-07 |
| İş uyuşmazlıkları otomatik karar | Mahkeme gündelik işlerin kuyruğu olmasın | B: 8.3 |
