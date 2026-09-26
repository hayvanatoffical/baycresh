# BAYCREST — Yol Haritası

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Üretim kapıları planıdır; hiçbir kapı geçmiş kabul edilmez.
**Okuyucu:** Herkes, özellikle proje yöneticisi
**Ön koşul:** `00-BASLA-BURADAN.md`
**Bağlı kararlar:** UK-09 · ORTAK-025, 029, 030, 046

Bu sürümde tarih taahhüdü yoktur. Önceki 20 haftalık plan, ekibin ölçülmüş kapasitesine dayanmadığı için kaldırıldı.

Bunun yerine **kapılar** var. Kapı geçilir, sonra bir sonraki başlar. Süre, kapının ne zaman geçildiğiyle ölçülür.

---

## 1. Yöntem

```
Küçük yap → oyna → ölç → devam et veya dur
```

Her katmanın tek bir doğrulama sorusu vardır. Kapı koşulları karşılanmadan sonraki katmanın üretimine başlanmaz; eksik koşullar ve düzeltme deneyi kaydedilir.

**Ne kadar sürdüğünü sonradan öğreneceğiz.** Katman 0 bittiğinde gerçek hızınızı ilk kez öğrenmiş olacaksınız ve geri kalan plan o hıza göre yazılacak (UK-09).

**Kapılarda beyan değil davranış ölçülür.** "Eğlendin mi?" sorusunun cevabı arkadaşlar arasında her zaman evettir. Bunun yerine şunlara bakılır: oyuncu süre dolunca kendiliğinden devam etti mi, ertesi gün kendiliğinden girdi mi, nerede bıraktı.

Sürüm 2.0'daki Katman 2 çok fazla sistemi tek kapıda topluyordu. Artık üçe bölündü: sivil çeşitlilik, suç ve adalet (ORTAK-029).

---

## 2. Katman 0 — Mikro prototip

**Tek soru: Bir şeye sahip olup büyütmek tatmin ediyor mu? Ve ekip gerçekte ne hızda üretiyor?**

### İçerik

- Blackstone Bazaar'ın tek sokağı, gri kutu
- Tek tezgâh, tek oyuncu
- **Polis yok. Suç yok. Silah yok.**
- İlk sahiplik, oyuncunun ekonomiyi grind etmesini beklemeden **ilk 5 dakika içinde** görünür; bu süre K0 test hipotezidir, yayın garantisi değildir
- Sahiplikten sonra pazar kaydı ve iki stok seçeneği; görünür talep oyuncunun hangi ürüne para bağlayacağını etkiler
- NPC müşteride satış; pazarlıkçıda düşük teklifi kabul / açıklanabilir bütçe sinyaline göre karşı teklif / reddet kararı
- Kazanç birikir, tezgâh 2. seviyeye çıkar; yükseltme daha fazla stok kapasitesi olarak görünür
- Bir NPC çalışan tutma ve bir maaş günü; maaş işletme gideri olarak ayrı gösterilir
- Gri kutu grafikler, hazır sesler

K0 sayıları üretim ekonomisi değildir. Oturumun 20 dakika içinde sahiplik, stok kararı, pazarlık, yükseltme ve çalışan davranışını göstermesi için sıkıştırılır; `03` §14 değerleri ayrıca korunur.

### Kapı kontrolü

Üç kişi ayrı ayrı 20 dakika oynar. Mümkünse bu kişiler ilgili özelliği geliştirenlerden seçilmez. Test tarihi, sürüm, cihaz, katılımcı ve gözlem notu kaydedilir. Ölçülenler:

| Ölçüm | Nasıl |
|---|---|
| Kendiliğinden devam | 20 dakika dolunca kaçı oynamaya devam etti? |
| Durma noktası | Nerede sıkıldılar? |
| İkinci gün | Ertesi gün hatırlatılmadan kaçı girdi? |

| Sonuç | Karar |
|---|---|
| En az ikisi kendiliğinden devam etti, ertesi gün en az biri hatırlatılmadan girdi | K1'e geç |
| En az ikisi devam etti, ertesi gün kimse girmedi | Yalnız çekirdek döngüyü iyileştir ve kapıyı tekrar ölç |
| En az ikisi süre dolunca bıraktı | İlerlemeyi durdur; çekirdek döngü için yeni hipotez yaz ve tekrar test et |

Kapı kararı için ham gözlemler saklanır. Üç kişilik sonuç, geniş oyuncu kitlesi hakkında istatistiksel kanıt sayılmaz; bu bir erken eleme testidir.

Test kaydı için `PRODUCTION/K0_TEST_RECORD_TEMPLATE.md` kopyalanır; şablondaki `ölçülmedi` alanları gerçek sonuç olmadan değiştirilmez.

### Kapasite ölçümü (UK-09)

K0 aynı zamanda ekibin ölçüldüğü yerdir. Bittiğinde şunlar yazılır:

- Kişi başı fiilî haftalık çalışma süresi
- Bir oynanabilir özelliğin gerçek üretim süresi
- İnceleme ve düzeltme yükü
- Ekip içi bağımlılıklar
- Gerçek telefondaki ilk performans sonuçları

**Bu bilgi görülmeden kesin bir yayın tarihi verilmez.**

### Neden suç prototipe girmiyor

Temel döngü suç olmadan sıkıcıysa, suç eklemek onu kurtarmaz; yalnızca sıkıcılığı gizler. Önce tabanı doğrulayın.

---

## 3. Katman 1 — Kalıcılık ve yerleşim

**Soru: Sahip olduğun şey seni ertesi gün geri getiriyor mu ve çıkış-giriş sonrası hâlâ senin mi?**

### İçerik

- Kalıcı veri: DataStore, oturum kilidi, sürüm ve göç
- **İşlem bütünlüğü:** işlem kimliği, tekrar koruması
- **Tek yazar kuralı** ve olay kutusu
- **Yuva atama sistemi** ve şirket rehberi (teknik olarak en zor parça)
- Çevrimdışı hesap ve 8 saatlik pencere
- Üretim günü, maaş ve ruhsat
- NPC çalışan sistemi: üç maaş yolu, üç karakter, referans ve deneme
- İşletme büyüme hattı (5 seviye)
- Taksi mesleği ve NPC şoföre devretme, 2 araç
- Telefon menüsü ve ayrı ayarlar menüsü
- Dönüş özeti
- **Ekonomi telemetrisi**
- Blackstone Merkez'in bir bölümü ve kurum alanlarının gri kutu yerleşimi

### Kapı kontrolü

10 kişi 3 gün oynar.

| Ölçüm | Eşik |
|---|---|
| İkinci gün geri dönen | Küçük örneklemde oran değil, sayı ve sebep konuşulur |
| Veri kaybı | **Sıfır.** Bir kayıp bile kapıyı kapatır |
| Yuva sorunu | Kimse "işletmemi açamadım" demedi |
| Çevrimdışı kazanç | Hedef banttaki değere yakın |

---

## 4. Katman 2 — Sivil çeşitlilik

**Soru: Farklı meslek gerçekten farklı karar üretiyor mu?**

### İçerik

- Perakende dışında en az bir karşıt aile: **atölye (tamirhane)** veya **proje (müteahhitlik)**
- Ortak altyapı: sipariş, stok, kalite, teslim
- Bir tedarik sözleşmesi örneği: stok teslimi
- İkinci bir mobil meslek: kurye veya minibüs
- Blackstone Merkez'in tamamlanması

### Kapı kontrolü

İki farklı ailede 20'şer dakika oynayan bir kişi, iki iş kolunun **farklı kararlar** ürettiğini söyleyebiliyor mu? Cevap "ikisi de tıklamaktan ibaret" ise altyapı fazla tektipleşmiş demektir.

---

## 5. Katman 3 — Envanter ve sınırlı suç

**Soru: Çanta sorgusu anı gerçekten gergin mi ve masum bir oyuncu taciz edilebiliyor mu?**

### İçerik

- Birim envanter mimarisi: cep, sırt, eller, çanta, bagaj
- Gizleme, kılıf, şişkinlik, riskli taşıma önizlemesi
- Nakit fiziği ve cüzdan
- **Polis etkileşiminin üç kademesi** ve bekleme süreleri
- **Silah (pahalı, düşük hasarlı), bağlam kuralı, yaralı durumu, hastane, ambulans**
- Güvenli bölgeler ve yeni oyuncu koruması
- Tanık sistemi ve robot resim
- Şüphe ve aranma, şehir alarm seviyesi
- Bir NPC şehir hedefi (mahalle bakkalı) ve riskli sektör kasası
- Kirli para, aklama kotası, tutarsızlık, denetim, FCU temel
- NPC devriyeler ve oyuncu polis
- RP kıyafet katmanı
- Ironhill ve standart cepheler
- **Geçici adalet:** suç anında yakalananlara otomatik para cezası ve 1 dk gözaltı

### Kapı kontrolü

20–30 kişilik kapalı test. Dört ölçüt:

- **Çanta sorgusu anında oyuncular ne yapıyor?** Rol yapıyorlarsa sistem çalışıyor; rastgele basıyorlarsa çalışmıyor.
- **Taciz testi:** Hiç suç işlemeyen bir oyuncu bir oturum boyunca rahatsız edilmeden oynayabiliyor mu?
- **Çatışma testi:** Yaralanan oyuncu ne hissediyor? "Haksızlık" mı, "kendi hatam" mı?
- **Ekonomi telemetrisi:** Kohort medyanları ve suç/temiz oranı hedef bantta mı?

---

## 6. Katman 4 — Adalet

**Soru: Karar adil ve anlaşılır mı; kısa ceza ve kaçış döngüsü çalışıyor mu?**

### İçerik

- Adalet sarayı ve Wrenmoor cezaevi, gri kutu
- Delil modeli ve delil–sanık bağı
- Suç ve yaptırım kataloğu v1 (8 madde)
- İki yargılama yolu: hızlı ve olağan
- Çevrimdışı dava, NPC temsil, adalet kuyruğu
- Karar ekranı ve itiraz
- İnfaz, üç koşullu tahliye görevi
- Tek kaçış senaryosu ve kaçış raporu
- Anayasa metni ve katalog arayüzü
- Cezaevi görevlisi mesleği

### Kapı kontrolü

`09-ADALET-VE-ANAYASA.md` §14'teki 13 kabul senaryosunun tamamı geçmelidir. Ek olarak:

- Hapse giren oyuncu neden girdiğini kendi cümleleriyle anlatabiliyor mu?
- 5 dakikalık bir ceza "ağır" hissettiriyor mu? (Hissettiriyorsa süreler kısaltılır.)

---

## 7. Katman 5 — Geniş kapalı test

**Soru: Çeşitlilik, nüfus, telefon performansı ve veri bütünlüğü birlikte çalışıyor mu?**

### İçerik

- Katalogdan seçilen iş kolları (hedef 6–8, alt sınır 3)
- Oldport ve sanayi yuvaları
- Ev sistemi
- Kalan NPC şehir hedefleri: büyük market ve kuyumcu
- 8 araç
- Özel sunucular ve Game Pass'ler
- Çok dil
- NPC vakaları ve defter bulmacası
- Optimizasyon ve telefon testi

---

## 8. Katman 6 — İlk yayın

### Yayın öncesi kontrol listesi

- [ ] Orta seviye Android telefonda 30 FPS
- [ ] Veri kaydı 50 kez test edildi, hiç kayıp yok
- [ ] İki sekmede aynı hesapla giriş denendi
- [ ] Adalet kabul senaryolarının 13'ü de geçti
- [ ] Konsolda kırmızı hata yok
- [ ] Ekonomi telemetrisi çalışıyor ve kohort değerleri sağlıklı
- [ ] Ekonomi modeli (`03` §15) çalıştırıldı ve kontrolleri geçti
- [ ] Olgunluk anketi dürüstçe dolduruldu
- [ ] **İçerikte alkol, bar, kan ve ölüm yok**
- [ ] **Açıklama ve başlıkta "hangout" çağrışımı yok**
- [ ] Tüm oyuncu metinleri filtreleniyor; filtre hatasında metin yayımlanmıyor
- [ ] Engelleme ve raporlama bütün sosyal yüzeylerde çalışıyor
- [ ] Kapak görseli oyunda olmayan hiçbir şey göstermiyor
- [ ] Kapak görseli suç değil, sahiplik gösteriyor
- [ ] Tüm sesler lisanslı; lisans kaydı tutuldu
- [ ] Hiçbir tanınmış gerçek marka, logo veya kurum yok; yeni adlar marka aramasından geçti
- [ ] İngilizce ve Türkçe metinler tam
- [ ] Öncelik 1 animasyonların hepsi var
- [ ] Oyun bir topluluğa ait ve sahibi yayın şartlarını karşılıyor
- [ ] Gelir paylaşımı yazılı olarak konuşuldu
- [ ] Yönetim platform kurallarını yayın ayında güncel resmî kaynaklardan yeniden kontrol etti ve sonucu kaydetti

---

## 9. Yayın sonrası

Yayın bitiş değil başlangıçtır. Algoritma düzenli güncellemeyi ve geri dönüşü ödüllendiriyor.

**İlk 30 gün:** Haftada en az bir güncelleme. Küçük olabilir. Süreklilik büyüklükten önemlidir.

**Sonraki bölgeler:** Alderbrook ve Rural Guard → Willowfield ve çiftçilik → Northwood ve av → Marlowe Ridge ve arazi sürüşü.

**Sonraki sistemler:** Avukatlık, işletme uzmanlaşması, geniş sözleşme sistemi, kişisel şehir hafızası, çanta kapkaçı, sahte defter, ek kaçış rotaları, banka soygunu, ev hırsızlığı, oyuncu dükkânlarının ekipman satışı.

**Tüm yaşlara açılma kararı** burada, veriye bakılarak verilir (AÇIK-09).

---

## 10. Roller ve çalışma ritmi

### 10.1 Roller

Tek kişilik rol yok. **İkili gruplar.** Biri hastalanır, sınavı çıkar, motivasyonu düşer; ikili grup bunu tolere eder.

| Grup | Sorumluluk | Ana belge |
|---|---|---|
| **Kod** | Sistemler, sunucu mantığı, veri, AI ile geliştirme | `04` |
| **Harita** | Bölgeler, binalar, yuvalar, kurumlar, proplar, ışık | `05` |
| **Varlık ve Animasyon** | Araçlar, kıyafetler, animasyonlar | `05` |
| **Arayüz ve Ses** | Ekranlar, envanter arayüzü, ses | `06` |
| **Tasarım ve Test** | Denge, `Ayarlar.lua`, ekonomi modeli, oynanış testi | `01`–`03`, `09` |
| **Yönetim ve Topluluk** | Plan, topluluk, sosyal medya, mağaza sayfası, moderasyon | `07`, `A3` |

**Kimse tek başına vazgeçilmez olmamalı.** Herkes kendi işinin nasıl yapıldığını kısa bir not olarak yazsın.

### 10.2 Ritim

| Ne zaman | Ne olur | Süre |
|---|---|---|
| Haftada bir | Toplantı: ne bitti, ne var | 45 dk |
| Hafta ortası | Yazılı kontrol: takılan var mı? | 15 dk |
| Haftada bir | **Birlikte oyna ve test et** | 1 saat |

**Birlikte oynama atlanmaz.** Kendi oyununu oynamayan ekip ne yaptığını bilmez.

### 10.3 "Bitmiş" ne demek

Üçü birden doğruysa bitmiştir. "Neredeyse bitti" diye bir şey yoktur.

1. Çalışıyor ve konsolda hata yok
2. Başka biri test etti ve onayladı
3. Ne yaptığı bir cümleyle gruba yazıldı ve değişiklik Git'e işlendi

### 10.4 Takıldığında

Bir sorunda **45 dakikadan fazla** takılırsan dur ve gruba yaz. Acemi ekiplerde en büyük zaman kaybı tek başına debelenmektir.

---

## 11. Risk listesi

| Risk | Olasılık | Ne yaparız |
|---|---|---|
| **Ekonomi kırılır** | Yüksek | Ekonomi modeli K3'ten önce. Telemetri K1'de. Kohort ölçütleri. Bu 1 numaralı risk |
| **Kapsam şişer** | Çok yüksek | Katman kuralı. "Şunu da ekleyelim" → katalog ve yayın sonrası listesine yaz, bugün yapma |
| **Adalet sistemi fazla büyür** | Yüksek | K4 kapsamı sabit: 8 suç, 1 kaçış, 3 tahliye görevi. Genişleme yayın sonrası |
| **Ekip dağılır** | Yüksek | Küçük hedefler, haftalık somut çıktı, ikili gruplar |
| **Yuva sistemi çalışmaz** | Orta | K1'in en zor parçası. Erken yap, çok test et |
| **Veri kaybı** | Orta | Oturum kilidi, işlem kimlikleri, 50 kez test |
| **Taciz sorunu** | Orta | Bağlam kuralı, güvenli bölgeler, yeni oyuncu koruması, polis bekleme süreleri. K3 taciz testi |
| **Kimse oynamıyor** | Yüksek | Hedef 1.000 oyuncu, milyon değil |
| **Hile yapanlar** | Yüksek | Görünürlük sunucuda hesaplanır. Her sistemden sonra "nasıl kötüye kullanılır?" |
| **Telif veya politika ihlali** | Düşük ama ölümcül | `00`'daki 8 değişmez kural ve yayın kontrol listesi |

---

## 12. Başarı ölçütleri

| Ölçüt | İlk hedef | İyi | Çok iyi |
|---|---|---|---|
| 1. gün geri dönüş | %15 | %25 | %35 |
| 7. gün geri dönüş | %5 | %10 | %15 |
| Ortalama oturum | 8 dk | 15 dk | 25 dk |
| Eşzamanlı oyuncu | 20 | 100 | 500 |
| **İlk oturumda sahiplik oranı** | %40 | %60 | %75 |
| **İşletme sahibi oranı** | %20 | %40 | %60 |
| Suç işleyen oyuncu oranı | — | Ölçülecek; %30–40 beklentisi | — |

Son üç satır bu oyuna özgüdür. **İlk oturumda sahiplik oranı** yeni oyuncu deneyimini ölçer; düşükse giriş akışı bozuktur. **İşletme sahibi oranı** omurganın tuttuğunu gösterir; düşükse diğer bütün sayılar yanıltıcıdır.

Eşzamanlı oyuncu en az önemli ölçüttür. Algoritma geri dönüşe bakıyor.

Küçük testlerde oran kullanılmaz; sayı ve sebep konuşulur. Oranlar ancak K5'teki geniş testten itibaren anlamlıdır.

---

## 13. Karar verme yöntemi

1. Fikir gelince **hangi katmana ait** olduğunu belirle
2. Mevcut katmana ait değilse → `KARARLAR.md`'ye ertelenen olarak yaz, tartışmayı kapat
3. Aitse → tasarım yasasına hizmet ediyor mu? ("Her yol bir imparatorluğa çıkar")
4. Ediyorsa → kim yapacak, ne kadar sürer?
5. 1 haftadan uzunsa → parçala veya ertele

Tartışma 10 dakikayı geçiyorsa tasarım sorumlusu karar verir ve `KARARLAR.md`'ye yazar. Herkesin mutlu olduğu karar yoktur; ilerleyen karar vardır.

---

## 14. Bu hafta

**Herkes tek bir küçük şey yapıp gruba atsın.**

- **Kodcu:** Bir butona basınca sunucu konsola yazsın
- **Builder:** Üç bina, bir sokak, **bir standart çarşı tezgâhı**
- **Varlık:** Bir araç modeli veya bir animasyon
- **Arayüz:** Envanter siluetinin taslağı
- **Tasarımcı:** `01`, `02`, `03` ve `09`'u okuyup 5 maddelik itiraz listesi
- **Yönetici:** Topluluk kanalları kurulu ve herkes içinde; Roblox topluluğu kuruldu

Yedi küçük çıktı, bir saatlik toplantıdan fazla motivasyon verir.
