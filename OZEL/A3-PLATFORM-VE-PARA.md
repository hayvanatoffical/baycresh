# A3 — Platform, Para ve Konumlandırma

**Sürüm:** 3.0 · 24 Eylül 2026
**Okuyucu:** Sadece sen. Kararların özeti `EKIP/00` §8'de ekiple paylaşılıyor.
**Bağlı kararlar:** ORTAK-010, 011, 031, 036, 046

Bu belgedeki bilgiler 24 Eylül 2026'da kontrol edildi. **Platform kuralları hızlı değişiyor; çeyrekte bir kontrol et (§7).**

Her satır üç kategoriden biriyle işaretli:
- **[DOĞRULANDI]** — Resmî kaynakta görüldü
- **[ÇELİŞKİLİ]** — Kaynaklar uyuşmuyor
- **[VARSAYIM]** — Doğrulanamadı

---

## 1. Yayın gereksinimleri

> **Sürüm 2.0'daki bilgilerin bir kısmı yanlıştı.** Aşağıdakiler düzeltilmiş hâlidir (ORTAK-031).

### 1.1 Üç yayın katmanı [DOĞRULANDI]

| Katman | Kitle | Gereksinim |
|---|---|---|
| **Kişisel kullanım** | Yalnız düzenleme yetkisi olanlar | Hesabın iyi durumda olması |
| **Güvenilir arkadaşlar ve 16+** | Yaşı doğrulanmış 16 yaş üstü | Yaş kontrolü (kimlik veya yüz tahmini), iyi durumda hesap |
| **Tüm yaşlar** | Roblox Kids (5–8) ve Select (9–15) dahil | Aşağıdaki dört şart birden |

**Tüm yaşlar için dört şart:**

1. **Yaş kontrolü ve kimlik doğrulaması.** 18 yaş üstü yaratıcılar kimlik doğrulaması yapar; **18 yaş altı yaratıcılar yüz tahminiyle yaş kontrolü kullanabilir.** Bu önemli: ekipte 18 yaşını doldurmuş biri olmaması mutlak bir engel değil.
2. **İki adımlı doğrulama (2FA).**
3. **Ödeme veya abonelik:** İadeli 1.000 Robux yayın ücreti, iadeli 50.000 Robux hızlandırılmış inceleme ücreti, veya iki kesintisiz ay Roblox Plus ya da Premium aboneliği. İade koşulu, oyunun uygunluk kazandıktan sonra üç ay uygun kalmasıdır. Topluluk standartları ihlali nedeniyle kalıcı olarak kaldırılırsa ücret iade edilmez.
4. **Değerlendirme süreci:** Yeni oyunlar önce yaşı doğrulanmış 16+ kullanıcılara açılır. Resmî destek sayfası, ilk dönemde **60 gün içinde 250 benzersiz oynanış** gerektiğini belirtiyor; oynama süresi, hesap yaşı, geçmiş ve platformdaki harcama gibi sinyaller değerlendiriliyor.

> **Düzeltme:** Sürüm 2.0'da eşik "500" yazıyordu. Resmî sayfada 250 görünüyor. İki sayı da farklı kaynaklarda geçtiği için yayın öncesinde tekrar kontrol et.

**Grup sahipliği [DOĞRULANDI]:** Uygunluk ilk yayında doğrulanır. **Gruba ait oyunlarda bütün şartları grup sahibinin karşılaması gerekir.**

**Abonelik sona ererse:** Oyun "tüm yaşlar" kitlesinde kalır, ama yeni güncelleme yayımlamak için yeniden abone olmak gerekir.

### 1.2 Bizim için anlamı

Baycrest 16 yaş altı için tasarlanmadı: vergi, maaş, denetim, mülk, defter, mahkeme. On yaşındaki bir çocuğun ilgisini çekecek çok az şey var.

> **Karar (ORTAK-036): 16+ ile başlıyoruz. İçeriği Moderate sınırında tutuyoruz. Tüm yaşlara açılma kararını Katman 6'da veriye bakarak vereceğiz.**

Bu bir eksiklik değil, bir konumlandırma. Yeni oyunlar zaten önce 16+ kitleye açılıyor, yani kapıyı açık tutmak bedava. Ekibe böyle anlat; moral farkı yaratır.

### 1.3 Lojistik: bu hafta halledilecekler

1. **Roblox topluluğu kur.** Oyun bir kişiye değil topluluğa ait olmalı. Ekip değişse, biri ayrılsa veya hesap kapansa bile oyun toplulukta kalır. **Topluluk kurmak 100 Robux'tur** [DOĞRULANDI]; sürüm 2.0'daki "bedava" bilgisi yanlıştı.
2. **Topluluk sahibini belirle.** Yayın şartlarını karşılayacak kişi bu olmalı: yaş kontrolü ve 2FA.
3. **2FA'yı herkeste aç.**
4. **Gelir paylaşımını yazılı konuş** (§4.3).

---

## 2. Yaş katmanları ve içerik etiketi

### 2.1 Etiketler [DOĞRULANDI]

| Etiket | Kim erişir |
|---|---|
| Minimal / Mild | Roblox Kids (5–8) ve Select (9–15) ve üstü |
| **Moderate** | Roblox Select (9–15) ve standart 16+ — **hedefimiz** |
| Restricted | Yalnız yaşı doğrulanmış **18+** |

> **İki düzeltme:** Sürüm 2.0 "Moderate yalnız 16+" ve "Restricted 17+" diyordu. İkisi de yanlıştı. Moderate etiket, yayın şartları karşılanırsa 9–15 yaş kitlesine de açılabiliyor ve Restricted 18+.

### 2.2 Restricted etiketine gitmeyin

Restricted etiket kitleyi daraltır ve bazı ülkelerde oyunu tamamen kapatır: **Restricted etiketli oyunlar Kore, Suudi Arabistan ve Türkiye'de oynanamıyor** [DOĞRULANDI].

Moderate'te kalmak için yapılması gerekenler ve bizim durumumuz:

| Gereklilik | Baycrest | Kaynak |
|---|---|---|
| Gerçekçi ağır kan yok | ✅ Hiç kan yok (UK-14) | `00` Kural 6 |
| Güçlü şiddet yok | ✅ Ölüm yok, düşük hasar (UK-15) | `02` §7 |
| **Alkol yok** | ✅ Bar ve alkol kapsam dışı | `05` §1.6 |
| Romantik tema yok | ✅ Yok | — |
| Küfür yok | ✅ Filtre ve strong language kapalı | `06` §7.2 |
| Özel alan içeren sosyal takılma alanı yok | ✅ Ev davetle girilir, hangout değiliz | `01` §8 |
| Oynanabilir kumar yok | ✅ Kural 1 | `00` §6 |

### 2.3 İki incelikli konu

**Sosyal takılma (hangout) sınıflandırması [DOĞRULANDI].** Rol yapmanın merkezde olduğu oyunlar hangout sayılmıyor; bunun için rol benimseme ve rol oynamaya yarayan oyun içi eşyaların merkezi olması gerekiyor. Baycrest bunu fazlasıyla karşılıyor. **Ama:** başlık veya açıklama hangout'a atıf yaparsa oyun hangout olarak sınıflandırılıyor.

> **Kural:** Mağaza başlığında ve açıklamasında "hangout", "chill", "vibe" gibi kelimeler kullanma. Yayın kontrol listesine eklendi (`07` §8).

**Kumar [DOĞRULANDI].** Oynanabilir kumar, simüle kumar dahil, hiçbir yaş etiketinde serbest değil. Oynanamayan tasvir (oynanamayan bir kumarhane görmek gibi) Moderate etikette mümkün. Bizde ikisi de yok.

---

## 3. Türkiye durumu

### 3.1 Erişim [ÇELİŞKİLİ]

Birçok haber kaynağı, Roblox'un Türkiye'deki erişim engelinin 680 gün sonra **18 Haziran 2026'da kaldırıldığını** bildirdi. Engel, 7 Ağustos 2024'te bir mahkeme kararıyla uygulanmıştı.

**Ama:** Temmuz 2026 tarihli en az bir kaynak, BTK kayıtlarında erişim engeli kararının yürürlükte görünmeye devam ettiğini bildirdi.

> **Durum: çelişkili.** Kesin bilgi gibi kullanma. Yayından önce kendin kontrol et: VPN'siz bir bağlantıdan platformun açılıp açılmadığına bak (AÇIK-08).

### 3.2 7578 sayılı Kanun [KISMEN DOĞRULANDI]

1 Mayıs 2026 tarihli Resmî Gazete'de yayımlandı. 5651 sayılı Kanun'da değişiklik yapıyor.

**Doğrulananlar:**
- 15 yaş yasağı metinde **sosyal ağ sağlayıcıları** için yazılmış: sosyal ağ sağlayıcı 15 yaşını doldurmamış çocuklara hizmet sunamaz. Yaş doğrulama dahil gerekli tedbirleri almakla yükümlü.
- Kanun oyun platformları için **ayrı bir çerçeve** çiziyor; "oyun", "oyun dağıtıcısı", "oyun geliştiricisi" ve "oyun platformu" tanımları mevzuata ilk kez giriyor.
- Yaş derecelendirmesi olmayan oyunların platformda sunulmasına ilişkin kısıtlar var.
- Teknik hükümlerin **1 Kasım 2026'da** yürürlüğe girmesi bekleniyor; 15–18 yaş içerik ayrımı ve denetim süreçleri bir yönetmelikle netleşecek.

**Doğrulanamayanlar [VARSAYIM]:** "Roblox e-Devlet entegre token tabanlı doğrulamayı uygulayan ilk platform oldu" ve "Türkiye'de 15 yaş altı hesap açamıyor" iddiaları birincil kaynakla doğrulanamadı.

> **Sonuç:** Türkiye pazarı en az 15+ görünüyor ve bu bizim 16+ konumlandırmamızla uyumlu. Türkiye'yi birincil pazar saymıyoruz, ama kaybetmiyoruz da. Kasım yönetmeliğini takip et.

### 3.3 Discord ve topluluk kanalları

Discord'un Türkiye'de erişime kapalı olduğu Haziran 2026 tarihli kaynaklarda bildiriliyor [ÇELİŞKİLİ; güncelliği kontrol edilmeli]. Pratikte Türk topluluğun bir kısmı VPN ile erişiyor.

**Kural:** Tek kanala bağlı kalma. Discord kurulabilir, ama yanında en az bir alternatif topluluk kanalı aç.

**Ekip için uyarı:** Roblox'un kendi kuralları, konumu gizlemek amacıyla VPN kullanımını yasaklıyor. Bu Discord'u değil **Roblox hesaplarını** ilgilendirir. Roblox hesabına VPN ile girmeyin.

---

## 4. Gelir ve ödeme

### 4.1 Gelir kalemleri

Tam liste `EKIP/03-EKONOMI.md` §13'te. Başlıklar:

- **Özel sunucular** [DOĞRULANDI]: Roblox'un yerleşik özelliği. **Game Pass değil, aylık Robux aboneliğidir.** Oyunun herkese açık olması gerekir ve ücretli erişimle aynı anda kullanılamaz.
- **Game Pass'ler:** Kozmetik ve topluluk araçları. Güç satılmaz.
- **Kaldırıldı:** Robux ile işletme slotu (ORTAK-010).

RP oyunlarında asıl gelirin özel sunuculardan geldiği yaygın bir görüş, ama bu **[VARSAYIM]**. Kendi verimizle doğrulayacağız. Topluluk kurucuları değerli müşterilerdir ve iyi araç verilirse oyunu kendileri pazarlar.

### 4.2 Parayı çekmek: DevEx [DOĞRULANDI]

| Şart | Değer |
|---|---|
| Asgari yaş | **13** |
| Asgari kazanılmış Robux | 30.000 |
| Doğrulanmış e-posta | Gerekli |
| Geçerli DevEx portal hesabı ve vergi formu | Gerekli |
| Hesabın iyi durumda olması | Gerekli |

> **Düzeltme:** Sürüm 2.0'da "DevEx için 18 yaş gerekir" yazıyordu. Yanlıştı; asgari yaş 13. Ancak vergi formu ve ödeme yöntemi pratikte yetişkin katılımı gerektirebilir.

**Ek fırsat [DOĞRULANDI]:** Roblox, uygun oyunlarda ABD'deki yaşı doğrulanmış 18+ oyuncuların harcamasına daha yüksek bir DevEx oranı uyguluyor; kapsama Game Pass, abonelik, geliştirici ürünleri ve özel sunucular dahil. Uygunluk ölçütleri karakter kalitesi ve özgün görsel yön gibi kriterlere bakıyor. Baycrest'in uygunluk durumu incelenmedi [AÇIK].

### 4.3 Paylaşım anlaşması

**Bu konuşmayı erteleme.** Para gelmeden önce yazılı bir paylaşım anlaşması yapın: kim, hangi oranda, hangi koşulda, biri ayrılırsa ne olur. Bu konuşma para geldikten sonra yapılırsa dostluklar biter.

Basit bir metin yeterli. Herkes okusun ve onaylasın. Ekipte 18 yaş altı üye varsa velisini de bilgilendirin. Kararın özeti `EKIP/00` §8'de ekiple paylaşılıyor (ORTAK-046).

### 4.4 Ön izleme reklamları [VARSAYIM]

Roblox'un oyun yüklenirken oynayan kısa reklamlardan gelir paylaşımı sunduğu biliniyor, ama mevcut şartları doğrulanmadı. Katman 6'da kontrol et.

---

## 5. Pazarlama

### 5.1 Algoritma

Öneri algoritmasının geri dönüşe ağırlık verdiği yaygın bir görüş [VARSAYIM; 28 günlük pencere iddiası doğrulanmadı]. Doğrulanabilir olan şu: tıklatan ama tutmayan oyunlar uzun vadede kaybeder.

**Bizim için anlamı:** Çarpıcı ama yanıltıcı kapak görseli kısa vadede işe yarar, uzun vadede cezalandırılır. Tycoon omurgası bize burada doğal bir avantaj veriyor; birikimli oyunlar geri dönüşte iyidir.

### 5.2 Ne göstermeliyiz

Oyuncuların çoğunun hiç ciddi suç işlemeyeceğini tahmin ediyoruz [VARSAYIM; K5'te ölçülecek]. Bu, pazarlamayı doğrudan belirliyor.

**Kapak görseli suç göstermemeli.** Yanlış oyuncuyu çekersin, o oyuncu aradığı suç oyununu bulamaz, gider ve 1. gün geri dönüşü düşer.

**Göstermesi gereken:** İki işletmesi, evi ve arabası olan bir oyuncu. Akşam üstü ışığında. Oyunun içinden çekilmiş.

### 5.3 En güçlü dört video anı

1. Polisin çanta sorması ve oyuncunun reddetmesi
2. NPC tanığın soyguncunun yüzünü tarif etmesi
3. Denetim dosyasının açılması ve tutarsızlığın bulunması
4. **Mahkeme kararının okunması ve tokmak sesi**

Dördü de rakiplerde nadirdir; yayından önce birkaç rakip oyunu inceleyerek bunu doğrula. **Kovalamaca videosu çekme;** o alanda herkes var ve kimse fark edilmiyor.

### 5.4 Mağaza sayfası

- **Başlık:** Kısa, aranabilir, İngilizce: "Baycrest | City Life". **"Hangout", "chill", "vibe" kelimelerini kullanma** (§2.3).
- **Açıklama:** İlk iki satır her şeydir. Çanta, tanık ve denetim sistemini orada anlat.
- **Video:** Doğrudan Creator Hub'a yükle.
- **Bot ve sahte oyuncu asla.** Roblox bot hesaplara karşı işlem yürütüyor; yakalanan oyunlar oyuncu sayılarının büyük kısmını kaybediyor.

---

## 6. Ad ve marka riski

Sürüm 3.0'da iki araç markası değiştirildi: "Anadol" ve "Kartal" gerçek Türk otomotiv adlarıyla çakışıyordu (ORTAK-032).

**Kontrol edilmemiş iki ad var [AÇIK-01]:**

- **"Baycrest"** — Toronto'da bilinen bir sağlık kurumunun adıyla örtüşüyor.
- **"Blackstone"** — Büyük bir yatırım şirketinin adıyla örtüşüyor.

İkisi de farklı sektörlerde ve coğrafi ad olarak yaygın kelimeler. Ama oyun adı ticari bir karardır ve senin kararın. Yayından önce bir marka araması yap. Sonucu `KARARLAR.md` AÇIK-01'e yaz.

Yeni adlar (Ova Motors, Siper, Wrenmoor, Verania General Hospital) da aynı süreçten geçer (AÇIK-02).

---

## 7. Çeyreklik kontrol listesi

Platform kuralları hızlı değişiyor. Üç ayda bir şunları kontrol et ve bulduğun her yanlışı düzeltip sürüm numarasını artır:

- [ ] Yayın eşiği (250 mi, 500 mü?), ücret ve iade koşulları
- [ ] Yaş kontrolü ve kimlik doğrulama şartları
- [ ] İçerik olgunluk etiketleri ve Moderate sınırları
- [ ] Hangout ve serbest kullanıcı üretimi tanımları
- [ ] DevEx şartları, asgari tutar ve oranlar
- [ ] Özel sunucu ve Game Pass kuralları
- [ ] Studio MCP'ye yeni araç eklendi mi
- [ ] Creator Store ses lisans şartları
- [ ] Kullandığınız AI araçlarının ticari lisans şartları
- [ ] Türkiye erişim durumu (AÇIK-08)
- [ ] 7578 sayılı Kanun'un yönetmeliği (Kasım 2026)
- [ ] Discord erişimi
- [ ] Ön izleme reklamlarının mevcut şartları

**Kaynak dizini:**

- Yayın: `https://en.help.roblox.com/hc/en-us/articles/203313890-How-to-Publish-Games-on-Roblox`
- İçerik olgunluğu: `https://create.roblox.com/docs/production/promotion/content-maturity`
- Özel sunucular: `https://create.roblox.com/docs/production/monetization/private-servers`
- DevEx: `https://create.roblox.com/docs/production/monetization/developer-exchange`
- Studio MCP: `https://create.roblox.com/docs/studio/mcp`
- Topluluk kurma: `https://en.help.roblox.com/hc/en-us/articles/203313730`
