# BAYCREST — Arayüz ve Ses

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Arayüz ve ses tasarımı baz çizgisi; varlık kabulü ve cihaz testi henüz yapılmadı.
**Okuyucu:** Arayüz ve ses sorumlusu
**Ön koşul:** `00`, `01`, `02`, `09`
**Bağlı kararlar:** ORTAK-014, 020, 021, 027, 028, 045, 049, 050

---

## 1. Arayüz ilkeleri

**Telefon önce.** Her buton başparmakla basılabilir olmalı. Küçük yazı okunmaz.

**Bilgi görünür olmalı.** Oyunun tasarımı bilgi üzerine kuruludur. Aranma, tanık durumu, çalışan ruh hali, aklama kotası, dava durumu ve infaz süresi net gösterilir (Kural 7).

**Gizli bilgi iz bırakır.** Şüphe puanı ve çalışan karakteri anlık olarak gösterilmez, ama sonradan okunabilir bir iz bırakır: dosyada, defterde veya dönüş özetinde. Bu, "görünmez ceza yok" kuralının uygulanma biçimidir.

**Ekranda aynı anda en fazla 5 öğe.** HUD tam olarak §2'deki beş öğeden oluşur. Yeni bir öğe eklemek için var olan biri çıkmalıdır.

**Envanter bir liste değil, bir beden.**

**Ayarlar her zaman erişilebilir.** Ayarlar, yardım, kurallar ve raporlama telefondan bağımsızdır (ORTAK-021).

## 2. Ana HUD

| Öğe | Konum | İçerik |
|---|---|---|
| Para | Sağ üst | Banka ve nakit ayrı; kirli nakit varsa ayrı ve farklı renkte |
| Meslek durumu | Sol üst | "Vardiyada: Kasiyer" veya boş |
| Durum rozeti | Sağ üst, paranın altı | Aranma seviyesi, İnfaz sayacı veya Kaçak. Yalnız biri görünür |
| Etkileşim istemi | Ekran ortası altı | "E — Kasayı aç" |
| Mini harita | Sol alt | Açılıp kapanabilir |

**Şüphe puanı HUD'da gösterilmez.** Aranma serttir ve gösterilir; şüphe yumuşaktır ve oyuncu anlık olarak bilmez. Polis onu durdurduğunda veya dosyasını okuduğunda anlar.

**Can göstergesi** yalnız can tam değilken görünür. Oyunun çoğu zamanı çatışmasız geçer; sürekli duran bir can barı gereksizdir.

## 3. Envanter ekranı

Oyunun en çok bakılacak ekranı. **Izgara olmayacak.** Karakterin silueti gösterilir ve birimler bedenin üzerinde durur.

```
        [ELLER]
          ●
    ┌─────────────┐
    │   [SIRT]    │   ← uzun eşyalar, her zaman görünür
    │      ●      │
    │ [CEP] [CEP] │   ← her biri 2 birim, gizli
    └─────────────┘
        [ÇANTA]
      ● ● ● ● ● ●
```

**Görünürlük göstergesi zorunlu.** Her alanın yanında küçük bir simge durur. Kural: hiçbir bilgi yalnız renkle taşınmaz; simge, renk ve metin birlikte kullanılır (ORTAK-028).

| Simge | Renk | Metin | Anlam |
|---|---|---|---|
| Açık göz | Turuncu | "Görünür" | Herkes görüyor |
| Kapalı göz | Lacivert | "Gizli" | Gizli |
| Yarı kapalı göz | Sarı | "Riskli" | Gizli ama şişkinlik riski var |

Oyuncu envanteri açtığında tek bakışta "beni gören biri ne görüyor" sorusunun cevabını almalıdır. Bu tek gösterge sistemin tamamını öğretir; hiçbir öğretici metin gerekmez.

**Birimler görünür.** Çanta "6/12 birim" der. Cüzdandaki nakit ayrı gösterilir ve yer tutmadığı belirtilir.

**Riskli taşıma önizlemesi.** Gizlenemeyen bir eşya gizli bir alana sürüklendiğinde eşya kendiliğinden ele geçmez; önce onay istenir (ORTAK-020):

> Kılıfın yok. Tabanca elinde, herkesin görebileceği şekilde taşınacak.
> [ Onayla ] [ Vazgeç ]

## 4. Zorunlu ekranlar

### 4.1 Polis etkileşimi (iki taraflı)

Üç kademe için üç farklı sunum gerekir (`02` §5).

**Polis tarafında:** "Çantayı sor" butonu her zaman aktiftir. "Durdur" butonu yalnız sistem bir gerekçe tanıdığında aktifleşir ve **gerekçe ekranda yazar**: "Gerekçe: şehirde görünür silah." "Ara" butonu yalnız delil varsa aktifleşir. Pasif butonun neden pasif olduğu dokununca açıklanır.

**Oyuncu tarafında:** Büyük butonlar; panik anında basılıyor. Kademe açıkça yazar.

```
Polis çantanı soruyor.  (Gönüllü — reddetmek serbesttir)

  [ GÖSTER ]   [ REDDET ]   [ UZAKLAŞ ]
```

```
Polis seni durdurdu.
Gerekçe: Şehirde görünür silah taşıma

  [ GÖSTER ]   [ REDDET ]
```

Gönüllü soruda süre dolarsa "uzaklaştı", durdurmada "reddetti" sayılır. **Bağlantı koparsa işlem iptal olur ve hiçbir şey üretmez.**

### 4.2 Olay açıklama kartı

Her ceza, kayıp, ret ve reddedilen işlemle birlikte tek bir kart çıkar (ORTAK-050). Kart dört şeyi gösterir:

1. **Ne oldu:** "Aklama işlemi reddedildi."
2. **Neden:** "Bugünkü kotanın %35 üstündesin."
3. **Ne kadar sürer:** "Kota bir sonraki oyun gününde yenilenir."
4. **Ne yapabilirsin:** "Kotayı artırmak için yasal satışını büyüt."

Kart hassas delili herkese göstermez; yalnız ilgili oyuncuya görünür.

### 4.3 Aranma bildirimi

Ekranın üstünde 3 saniye görünen şerit. **Sebep yazmak zorunlu.**

> ⚠ **Aranma 2** — Bir tanık seni maskesiz gördü

### 4.4 Tanık sorgusu (polis)

- Siyah-beyaz robot resim (olay anının görüntüsünden üretilir)
- Netlik göstergesi: Net tarif / Bulanık tarif / Yalnız kıyafet
- Metin notu: "Mavi ceketli, maskeli, beyaz sedanla Harbour Lane'e kaçtı"
- "Dosyaya ekle" butonu ve delil gücü göstergesi

### 4.5 Yaralı ekranı

Can sıfıra düştüğünde (`02` §7.4). Sade, sakin, kansız.

```
Yaralandın.

Yardım bekleniyor...  38 sn
Sağlık ekibi çağrıldı (118)

Kaybedeceklerin: taşıdığın kirli nakdin yarısı
Meşru eşyaların ve paran güvende.
```

Son iki satır önemlidir: oyuncu panik anında neyi kaybetmeyeceğini bilmelidir.

### 4.6 Hastane çıkış ekranı

```
Tedavi edildin. Ücret alınmadı.
Can: 100

[ Çıkış ]
```

Aranma ≥2 ise bunun yerine gözaltı bildirimi ve dosya özeti gösterilir.

### 4.7 Adalet ekranları

**Dosya bildirimi.** Suçlama, delil özeti, duruşma zamanı, seçenekler ve "sen oyunda olmasan da ücretsiz temsilci savunacak" açıklaması.

**Duruşma.** İkrar, itiraz noktası seçimi veya sessiz kalma. Her seçeneğin sonucu önceden yazar.

**Karar ekranı (V-A08).** Suç kodu ve adı, kullanılan deliller ve karşıladıkları şart, yaptırım, süre, indirimler ve ağırlaştırıcılar, itiraz butonu.

**İnfaz göstergesi.** HUD durum rozetinde kalan süre. Cezaevinde koşullu tahliye görevleri ve kazanılan indirim görünür.

**Kaçak durumu.** Rozet "Kaçak" der; kalan süre donmuştur ve zaman aşımı sayacı görünür.

**Dosyalarım.** Telefonda: açık dosyalar, kapanmış dosyalar, anayasa metni, suç kataloğu.

### 4.8 Dönüş özeti

Girişte tek ekran, kaydırılabilir (ORTAK-027, `01` §11):

```
Sen yokken (4 sa 12 dk)

💰 Tahsilat            +3.740 ₡
👤 Ayşe (kasiyer)      Memnun. Maaşı ödendi.
👤 Mehmet (şoför)      Huzursuz. Sebebi: notlarına bak.
⚖ CASE-221            Karar: beraat. Delil yetersiz.
🎯 Sonraki hedef       Dükkâna 3.200 ₡ kaldı

[ İşletmelerim ]  [ Dosyalarım ]  [ Kapat ]
```

Bildirim yığınına dönüşmemeli; en fazla 6 satır ve tek bir hedef.

### 4.9 İşletme yönetimi

Telefondan. Gösterilenler:

- Ciro, mal maliyeti, ücretler, sabit giderler ve **net kâr** ayrı satırlar (`03` §3)
- Kasa doluluğu ve tahsilata geçme zamanı
- Seviye ve bir sonraki yükseltmenin maliyeti
- Çalışan listesi, ruh hali göstergeleri ve çalışan notları
- Maaş günü sayacı (üretim günü cinsinden)
- **Aklama kota göstergesi:** bugünkü yasal satış, risksiz kota, kullanılan miktar ve kalan. Üç bölge renk, metin ve sayıyla birlikte gösterilir
- Defter: satırlar ve **açıklanmamış çekimler** (fırsatçı çalışanın izi)
- Dondurma modu butonu; aktif dosya varsa pasif ve sebebi yazılı

**Kota göstergesi kritiktir.** Oyuncu eşiği sayı olarak görmeli, tahmin etmemelidir. Görünmez eşik haksızlık hissi yaratır.

### 4.10 Şirket rehberi

Telefonda ve şehirdeki bilgi panolarında. İşletme adı, ailesi, durumu (açık, NPC modunda, uzaktan) ve **bu sunucudaki adresi** ile yol tarifi. Dinamik yuva sisteminin kullanıcıya görünen yüzü budur (ORTAK-049).

### 4.11 Denetim dosyası (FCU)

- Açık dosyalar listesi ve delil gücü göstergesi
- Her dosyada: tutarsızlık kayıtları, tanık ifadeleri, kamera kanıtları
- **Defter bulmacası:** ciro grafiğinde anomali işaretleme, tutarsızlığı kanıtla eşleştirme
- "Denetim aç" butonu; **dayanak yoksa pasif** ve sebebi yazılı
- Yetki puanı göstergesi

### 4.12 Tezgâh ve kasiyer vardiya ekranı

- Müşteri sırası göstergesi
- Vardiya kazancı ve kasa doluluğu
- **Kırmızı buton:** büyük, kolay basılır; panik anında lazım

### 4.13 Telefon menüsü ve ayarlar

**Telefon sekmeleri:** Mesajlar, Banka, İşletmelerim, Çalışanlar, Araçlarım, Ev, Rehber, Dosyalarım.

**Telefondan bağımsız menü (her zaman erişilebilir):** Ayarlar, Yardım, Kurallar ve Anayasa, Raporla, Engellenenler.

## 5. Erişilebilirlik

- **Renk tek başına bilgi taşımaz.** Her durum simge, renk ve kısa metinle birlikte gösterilir.
- **Yazı boyutu ayarlanabilir:** normal, büyük, çok büyük. Tüm ekranlar üçünde de test edilir.
- **Süreli kararlarda güvenli varsayılan.** Süre dolarsa en az zararlı seçenek uygulanır: gönüllü soruda uzaklaşma, durdurmada ret, duruşmada NPC temsil.
- **Kritik bilgi hiçbir zaman yalnız sesle verilmez.** Alarm ve siren görsel karşılığı olan olaylardır.
- **Dokunma hedefleri** en az 44×44 piksel.

## 6. Tipografi ve stil

- Yazı tipi: okunaklı, resmî duran bir sans-serif
- **Telefonda yazı boyutu (UK-19):** en küçük yazı 12 px'tir (Roblox arayüz pikseli; telefonda yaklaşık Android dp). Bu, §5'teki "normal" kademedir. Arayüz devasa olmaz: telefonda paneller en küçük yazıları 12 px'e denk gelecek kadar ölçeklenir, daha büyük değil. "Büyük" ve "çok büyük" kademeler oyuncunun ayarıdır. Hesap: `PRODUCTION/K0_TELEFON_EKRAN_VE_YAZI.md`.
- Köşeler: hafif yuvarlatılmış, 6 px
- Arka plan: koyu yarı saydam `#12161A`, %85
- Vurgu: lacivert `#1E3A5F` (resmî), turuncu `#D64525` (uyarı), taş grisi `#8A8578` (adalet)

## 7. Metin, dil ve moderasyon

### 7.1 Dil

Birincil **İngilizce**, ikincil Türkçe. Tüm metinler `Metinler.lua` içindedir ve koda gömülmez.

```lua
return {
    en = { aranma2 = "A witness saw your face" },
    tr = { aranma2 = "Bir tanık seni maskesiz gördü" },
}
```

Yeni bir metin yazarken **her zaman iki dili birden ekleyin.** Sonradan toplamak iki kat iş çıkarır.

### 7.2 Oyuncu metni

- Tüm oyuncu metinleri Roblox'un filtresinden geçer. **Filtre hata verirse metin yayımlanmaz** (ORTAK-014).
- **Tabela:** Serbest metin yoktur. Oyuncu hazır bir şablon seçer ve sınırlı bir kelime havuzundan ad kurar.
- **Mesajlaşma:** Roblox'un sohbet altyapısı üzerinden, yalnız çevrimiçi oyuncular arasında.
- **Engelleme** bütün yüzeylerde geçerlidir: telefon, yakınlık sohbeti, mahkeme salonu, cezaevi ortak alanı.
- **Raporlama** her sosyal yüzeyde bulunur.

---

## 8. Ses

### 8.1 Kaynak

Varsayılan kaynak **Creator Store'un lisanslı kütüphanesidir** ve ilk sürümde tek kaynaktır. Başka bir kaynak yalnız ticari lisansı belgelenmişse kullanılır ve lisans kaydı tutulur (ORTAK-045).

Telifli şarkı yüklenmez. Dışarıdan bulunan "müzik ID"lerinin çoğu zaten çalışmaz; kullanıcı yüklemeleri varsayılan olarak gizlidir.

Ücretsiz AI ses araçlarının ticari kullanım hakkı ayrıca doğrulanır. Hak ve kaynak kaydı olmadan dış ses oyuna alınmaz; kanıt `PRODUCTION/ASSET_PROVENANCE.md` dosyasına eklenir.

### 8.2 Öncelik sırası

Müzikten önce **ses efektleri** gelir; oyunu canlı hissettiren onlardır.

**K0–K1 zorunlu:** Kasa açılma, para sayma, ürün okutma (bip), tezgâh sesleri, ayak sesi (asfalt, beton, taş), kapı, kepenk, motor, fren, çarpma.

**K3 zorunlu:** Alarm, kırmızı buton, çanta fermuarı, kelepçe, silah (abartısız), elektroşok, telefon bildirimi, **ambulans sireni**, kalp monitörü (hastane, sakin).

**K4 zorunlu:** Tokmak, **denetim mührü**, hücre kapısı, cezaevi zili, anahtar şıngırtısı.

**Ortam sesleri:** Uzaktan trafik uğultusu (Blackstone), kalabalık ve pazarlık uğultusu (Bazaar), martı ve deniz (Oldport), rüzgâr ve uzak köpek (Wrenmoor).

### 8.3 İmza sesleri

Dört ses oyunun kimliğini taşıyacak ve tanıtım videolarında duyulacak:

**Çanta fermuarı.** Sorgu anında çalar. Kısa, net, gergin.
**Kasa sayacı.** Para sayılırken ritmik tıkırtı. Soygunun gerilimini bu taşır.
**Denetim mührü.** Dosya kapandığında çalar. Ağır, resmî, kesin.
**Tokmak.** Karar açıklandığında çalar. Tek vuruş, yankılı.

Bunlar özenle seçilir; geri kalanlar kütüphaneden hızlıca alınır.

### 8.4 Araç radyosu

Oyuncunun istediği ID'yi girebildiği radyo **yapılmaz**: telif riski ve moderasyon yükü taşır.

Bunun yerine sabit istasyonlar:

| İstasyon | İçerik |
|---|---|
| Baycrest FM | Lisanslı kütüphaneden seçilmiş, sakin |
| Ironhill Radio | Enerjik, elektronik |
| Classical | Enstrümantal |
| News | Kendi ürettiğimiz sahte şehir haberleri |

**News istasyonu fırsat:** Sunucudaki gerçek olaylardan haber üretilebilir: "Ironhill'de bir markette soygun bildirildi." Ucuz, kolay ve şehri canlı gösterir.

**Kural:** Haber oyuncu adı, işletme adı veya serbest metin kullanmaz. Yalnız olay türü ve mahalle (ORTAK-014).

Temel istasyonlar herkese açıktır; ek istasyonlar Game Pass ile.

---

## 9. İlk hafta: arayüz sorumlusunun yapacağı

1. `ScreenGui` içine para göstergesi (sağ üst).
2. 3 saniye görünüp kaybolan bildirim şeridi.
3. **Envanter siluetinin taslağı:** alanlar ve göz simgeleri. Çalışması gerekmiyor, görünmesi yeterli.
4. Telefonda nasıl göründüğünü test et (Studio'da cihaz emülasyonu var).
5. Yazı boyutu ayarını üç kademede dene.
