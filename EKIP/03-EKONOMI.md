# BAYCREST — Ekonomi

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Başlangıç değerli tasarım baz çizgisi; ekonomi modeli ve oyun testi henüz tamamlanmadı.
**Okuyucu:** Tasarımcı ve kodcular
**Ön koşul:** `00`, `01`, `02`
**Bağlı kararlar:** ORTAK-003, 004, 005, 006, 007, 008, 009, 010, 011 · UK-13, UK-15

Ekonomi ve oynanış ayarlarına ilişkin başlangıç değerlerinin tasarım kaynağı §14'tür. Kod uygulandığında bu değerler `Ayarlar.lua` dosyasına taşınır; servislerin içine bağımsız sabitler gömülmez. **Değerler henüz üretim ölçümüyle onaylanmamıştır.** §15'teki model ve prototip sonuçlarıyla değiştirilir; değişiklikler hem bu belgeye hem koda işlenir. Harita ve performans hedefleri kendi belgelerinde ölçülür.

---

## 1. Bu oyunun bir numaralı ölüm riski

> **Bir numaralı risk: ekonominin kırılması.**

Tycoon ekonomileri şöyle ölür. Bir oyuncu bir açık bulur ve üç günde herkesten yüz kat zengin olur. Para anlamını yitirir. Yeni oyuncu hiçbir zaman yetişemeyeceğini görür ve gider.

Bu belgedeki her fren bunu önlemek içindir. Sürüm 2.0'da denge, sayılarla değil anlatıyla savunuluyordu ve bir hesap hatası vardı. Sürüm 3.0 bir hesap sözleşmesi ve doğrulama modeli ekliyor.

## 2. Para birimi

Tek para birimi: **Crown (₡)**. Kirli nakit ayrı bir para birimi değildir; aynı Crown'un izlenen bir türüdür (`02` §11).

**Robux ile Crown satılmaz.** Doğrudan para satmak ekonomiyi çökertir ve pay-to-win algısı yaratır (§13).

## 3. Hesap sözleşmesi

Sürüm 2.0'da ciro, ücret, gider ve net kâr birbirine karışıyordu. Artık her işletme aynı dört satırla hesaplanır (ORTAK-004):

```
Ciro (brüt satış)
 − Mal maliyeti (stok)
 − Ücretler (NPC maaşları)
 − Sabit giderler (ruhsat payı, sigorta primi)
 = Net kâr
```

- **Marj** = net ÷ ciro. Perakende başlangıç marjı %40'tır. Diğer ailelerin marjı `10` §2'de tanımlanır.
- Aktif oyun, NPC üretimi ve çevrimdışı hesap **aynı sözleşmeyi** kullanır.
- Aklama kotası **ciroya** bağlıdır; aklanan para ciroya sayılmaz (`02` §11.2).
- Aşağıdaki gelir tablosu, sahibi aktifken ve maaşlar düşülmeden önceki **net ₡/dk** değeridir.

## 4. Zaman birimleri

Tek kaynak `01-SAHIPLIK-VE-ISLETME.md` §4.1'dir. Özet:

| Birim | Süre |
|---|---|
| Oyun günü | 48 gerçek dakika |
| Üretim günü | İşletmenin 48 dakikalık üretim süresi; maaş ve ruhsat dönemi |
| Gerçek gün | 24 saat |
| İnfaz süresi | Gerçek dakika |

Eski belgelerdeki "aylık" ifadesi kaldırıldı. 30 oyun günü tam 24 gerçek saate denk geliyordu. Bu da "aylık maaş"ı fiilen günlük bir giriş zorunluluğuna çeviriyordu.

## 5. Gelir tablosu

Dakika başına, sahibi aktifken:

| Kaynak | Net ₡/dk | Not |
|---|---|---|
| Taksi, kiralık şirket aracıyla | 30 | İlk oturum; araç kirası düşülmüş |
| Taksi, kendi aracınla | 40 | **Taban ölçü.** Her şey buna göre ölçülür |
| Taksi, NPC şoför (araç başına) | 14 | 40 × %35 brüt; maaş ayrı |
| Kasiyerlik, NPC marketinde | 25–70 | Performansa bağlı |
| Tezgâh, seviye 1 | 20 | |
| Tezgâh, seviye 2 | 40 | |
| Dükkân, seviye 3 | 85 | |
| Dükkân, seviye 4 | 110 | |
| Mağaza, seviye 5 | 140 | |
| Polis, aktif vaka | 60 | NPC vakaları dahil; boşta 25 |
| FCU, açık dosya | 65 | Rütbe gerektirir |
| Sağlık ekibi, aktif olay | 50 | Doğrulanmış olay başına |
| Cezaevi görevlisi | 40 | |

**Seviye maliyetleri (perakende örneği):**

| Seviye | Maliyet | Toplam | Tahmini ulaşma |
|---|---|---|---|
| 1 — Tezgâh | 1.500 | 1.500 | 30–45 dk |
| 2 — Büyük tezgâh | 5.000 | 6.500 | 1–3 sa |
| 3 — Dükkân | 15.000 | 21.500 | 8–12 sa |
| 4 — Genişletilmiş dükkân | 45.000 | 66.500 | 20–25 sa |
| 5 — Mağaza | 150.000 | 216.500 | 45–55 sa |

Seviye 5'in maliyeti, seviye 4'teki yaklaşık 25 saatlik net gelire eşittir (110 × 60 × 25 ≈ 165.000). Bu, ekonominin ana emiş noktasıdır.

**Kritik gözlem:** En yüksek meslek geliri 140 ₡/dk'dır ve buna ulaşmak 45 saati aşar. Eğri diktir ama zaman ister. Bu kasıtlıdır.

## 6. Otomasyon ve çevrimdışı hesap

### 6.1 Oyundayken NPC'li işletme

Sahibi oyundayken başka bir işletmesi NPC ile çalışıyorsa:

```
Brüt katkı = işletmenin net oranı × NPC verimi (%35 / %20 / %10)
Net katkı  = brüt katkı − maaş payı
```

Örnek: Seviye 3 dükkân, memnun NPC. Brüt katkı 85 × 0,35 ≈ 29,8 ₡/dk. Maaş payı 85 × 0,07 ≈ 6 ₡/dk. Net yaklaşık **23,8 ₡/dk**, yani sahibin aktif gelirinin ~%28'i. Bu, `01` §5.6'daki %25–30 hedefine uyar.

### 6.2 Çevrimdışı pencere

Oyuncu çıktıktan sonra işletmeler **8 saatlik bir pencerede** üretir. Çevrimdışı oran **net** bir orandır: maaş ve ruhsat içinden ödenmiş sayılır.

| Durum | Çevrimdışı net verim |
|---|---|
| En az bir memnun çalışanı var | %10 |
| Çalışanı yok | %5 |

Pencere dolunca işletme dinlenmeye geçer; gelir de gider de durur (`01` §4.3).

**Hesap (düzeltilmiş):** Çalışanlı seviye 3 dükkân, 8 saat: 85 × 0,10 × 480 ≈ **4.080 ₡**. Bu, yaklaşık **48 dakikalık** aktif oyuna denk gelir.

> **Düzeltme:** Sürüm 2.0'da "85 × 0,35 × 8 saat ≈ 14.000 ₡, bu 20 dakikalık aktif oyundan az" yazıyordu. Bu yanlıştı: 14.000 ₡, 3. seviyede yaklaşık 168 dakikalık aktif gelire eşittir. Yeni değerle 8 saatlik uzaklık, bir saatten az aktif oyuna denk gelir. Hedef bant 20–60 dakikadır; simülasyonla ayarlanır.

### 6.3 Neden otomasyon oyunu öldürmüyor

Oyuncuyu geri getiren şey kayıp korkusu değil, çekicilerdir: dönüş özetindeki birikmiş kazanç, açılacak bir sonraki seviye, karar bekleyen bir çalışan (`01` §11). Maaş günü ve dolan kasa gibi baskılar yalnız oyuncu oyundayken işler. Uzun süre uzak kalmak para basmaz: 8 saatlik tavan ve düşük çevrimdışı oran bunu garanti eder.

## 7. Suç: sermaye sıçraması ve temiz servet sınırı

### 7.1 Hedef ve türetme

> **Suç dakika başına kazandırmaz. Suç, zamanla yarışan riskli bir yoldur ve temiz servete katkısı aklama kotasıyla sınırlıdır.**

**Tasarım hedefi (ORTAK-006):** Suç ağırlıklı bir oyuncu, uzun vadede temiz yolu izleyen bir oyuncunun **en fazla 1,2–1,5 katı temiz servet** üretir ve sonuçları çok daha dalgalıdır.

Bu tavanı soygun büyüklüğü değil **aklama kotası** sağlar. Seviye 3 dükkân sahibi bir oyuncu üzerinden hesap:

```
Yasal net gelir                  = 85 ₡/dk
Ciro (marj %40)                  = 85 ÷ 0,40 = 212,5 ₡/dk
Oyun günü cirosu (48 dk)         = 10.200 ₡
Risksiz kota (%20)               = 2.040 kirli ₡ / oyun günü
Kesinti sonrası temiz (%15)      = 1.734 ₡ / oyun günü ≈ 36 ₡/dk
Toplam temiz gelir               = 85 + 36 = 121 ₡/dk
Oran                             = 121 ÷ 85 ≈ 1,42
```

Riskli bölge (%20–35) beklenen değerde bu oranı hedefin üst sınırına yaklaştırır. Karşılığında tutarsızlık kaydı ve denetim riski (S-07) doğar. Simülasyon bu bölgeyi özellikle ölçer.

**Sonuç:** İşletmesi olmayan bir suçlu parasını ancak başkasının kotasından ve komisyonla temizleyebilir. Suç yolu, meşru işletmeyi büyütmeyi gerektirir; iki yol tek oyuncuda birleşir.

### 7.2 Şehir hedefleri

Büyük soygun ödülleri NPC'ye ait şehir hedeflerindedir (`02` §10.3).

| Hedef | Kasa (kirli ₡) | Hedef yakalanma | Beklenen kirli | Katman |
|---|---|---|---|---|
| Mahalle bakkalı (NPC) | 4.000 | %30 | 2.800 | K3 |
| Blackstone büyük marketi (NPC) | 12.000 | %45 | 6.600 | K5 |
| Kuyumcu (NPC) | 25.000 | %60 | 10.000 | K5 |

- Yakalanma oranları sabit sayı değil, telemetriyle ölçülen hedeflerdir. Şehir alarm seviyesi (`02` §9.3) bunları dengeler.
- Kişisel soygun soğuması 30 dakikadır. Bir NPC hedefin kasası 20 dakikada yeniden dolar.
- Beklenen kirli para aklama kotasını çoğu zaman aşar. Fazlası ya yasadışı alışverişte harcanır (para çıkışı) ya da taşınırken risk altında kalır.

### 7.3 Oyuncu işletmesi kasası

Yalnız nakit riskli sektörlerde, seviye 3 ve üstünde, sahibi oyundayken bulunur. Kasada son 10 dakikanın nakit satışı durur (nakit payı %50) ve kasa tavanlıdır:

| Seviye | Kasa tavanı |
|---|---|
| 3 | 1.100 ₡ |
| 4 | 1.400 ₡ |
| 5 | 1.800 ₡ |

Mağdurun kaybının %40'ını sigorta öder. Oyuncu işletmesi soygunu bir servet kaynağı değildir; riskli sektörde ölçülü bir gerilim kaynağıdır.

### 7.4 Aklama parametreleri

| Parametre | Değer |
|---|---|
| Risksiz bölge | Yasal satışın %0–20'si |
| Riskli bölge | %20–35; her işlem bir tutarsızlık kaydı |
| Yasak bölge | %35 üstü; işlem reddedilir |
| Dışarıdan gelen aklama | Toplam kotanın en fazla yarısı (yasal satışın %10'u) |
| Kesinti | %15 |
| Dönem | Oyun günü; işletme kaydında tutulur, sunucu değişimiyle sıfırlanmaz |

> **Not:** Sürüm 1.0'da aklama kesintisi %30'du, sürüm 2.0'da %15'e indi. Asıl fren kesinti değil, kota ve fiziksel taşımadır.

### 7.5 Beş fren

1. **Soğuma:** Kişisel 30 dakika; hedef başına yeniden dolma süresi.
2. **Aklama kotası:** Yasal satışa bağlıdır ve kendi kendini büyütemez.
3. **Fiziksel taşıma:** 25.000 ₡ beş birimdir, çanta gerektirir ve çanta görünür.
4. **El koyma:** Yakalanınca veya yaralanınca kirli nakdin bir kısmı ekonomiden çıkar.
5. **Mahkeme:** Delil toplandıysa kısa bir hapis ve el koyma (`09` §6).

## 8. Silah ve güvenlik maliyetleri

Silahlar pahalıdır (UK-13). Silah sahibi olmak bir statü kararıdır.

| Kalem | Fiyat |
|---|---|
| Silah ruhsatı ve sınav | 5.000 ₡ |
| Ruhsatlı tabanca | 25.000 ₡ |
| Kılıf | 2.500 ₡ |
| Şarjör (12 atış) | 450 ₡ |
| Bakım (her 60 atış) | 1.000 ₡ |
| Av tüfeği (yayın sonrası) | 40.000 ₡ + av ruhsatı |
| Kaçak tabanca | 45.000 kirli ₡ |

**Toplam sahip olma maliyeti:** Ruhsat, tabanca, kılıf ve iki şarjör yaklaşık **33.400 ₡** eder. Bu, seviye 3 dükkânın yaklaşık 6,5 saatlik veya kendi taksiyle yaklaşık 14 saatlik net gelirine eşittir. Mühimmat ve bakım sürekli birer para çıkışıdır.

Kamera ve alarm: seviye 3'te 4.000 ₡, seviye 5'te 4 açılı sistem 10.000 ₡.

## 9. Sağlık, ceza ve sigorta

- **Hastane tedavisi ücretsizdir.** Yaralanan masum bir oyuncu hiçbir şey ödemez (`02` §7.5).
- **Para cezaları** `09` §6'daki katalogda. Bakiye yetmezse borç oluşmaz; kısa bir kamu hizmeti görevine dönüşür.
- **El konulan kirli nakit ve ruhsatsız silahlar** ekonomiden çıkar.
- **Sigorta primi:** Nakit riskli işletmelerde her üretim gününde net gelirin %1'i. Ödeme, kaybın %40'ı; olay başına bir kez (`02` §10.5).
- **İtiraz telafisi:** Yanlışlıkla geçirilen hapis dakikası başına küçük bir ödeme.

## 10. Maaş sistemi

Tek çalışan modeli, taksi şoförü dahil (ORTAK-008):

| Yol | Üretim günü başına maaş | Yük |
|---|---|---|
| Kendin ödersin | Taban = işletmenin net oranı × %7 × 48 | Her maaş günü tek dokunuş |
| Kısmi yetkili NPC | Taban × 1,25 | Her 5 üretim gününde bir onay |
| Tam yetkili muhasebeci | Taban × 1,5 + net kârın %5'i | Yok |

Örnek: Seviye 3 dükkân için taban maaş 85 × 0,07 × 48 ≈ 286 ₡ / üretim günü.

Çevrimdışıyken maaş işletmenin tahsilatından otomatik ödenir ve çevrimdışı net orana dahildir (§6.2). Bu, oyunun tek dürüst zaman–para takasıdır ve tamamen oyun içi parayla işler.

## 11. Para çıkışları

Oyuncunun parayı harcayacağı yer olmazsa ekonomi şişer.

**Sürekli:** Ruhsat payı (üretim günü başına net gelirin %3'ü), NPC maaşları, yakıt, araç bakımı, sigorta primi, mühimmat, silah bakımı.

**Tek seferlik:** Araç, işletme seviyeleri, kamera ve alarm, gizleme ekipmanları, ruhsat sınavları, silah, ev ve mobilya.

**Ceza:** Para cezası, el konulan kirli nakit ve ruhsatsız silah, denetim cezaları.

**Kozmetik:** Kıyafet, araç boyası, tabela ve vitrin şablonları.

**Yasadışı:** Kaçak silah, kilit aleti, sahte plaka. Bunlar kirli nakdi ekonomiden çıkarır.

**En önemli çıkış:** İşletme seviye yükseltmeleri (§5).

## 12. Enflasyon savunması ve telemetri

### 12.1 Frenler

**Kaynak tavanı.** Her gelir kaynağının saatlik bir üst sınırı vardır. Sınır aşıldığında verim düşer ama sıfırlanmaz ve bu durum ekranda gösterilir (Kural 7).

**Giriş fiyatları sabittir.** İlk tezgâh, ilk araç, ruhsatlar ve seviye 1–3 maliyetleri servete göre değişmez. Aksi hâlde eski oyuncuların zenginliği yeni oyuncuyu cezalandırırdı (ORTAK-009).

**Prestij endeksi.** Yalnız lüks araçlar, büyük cephe dekorları ve lüks mobilya **medyan servete** göre fiyatlanır. Ortalama kullanılmaz, çünkü birkaç aşırı hesaptan kolayca etkilenir.

### 12.2 Telemetri

Telemetri **K1'de** kurulur. Yayından sonra kurmaya çalışmak çok geç olur.

| Ölçüt | Neden |
|---|---|
| Oyun süresi kohortuna göre medyan servet (5., 10., 25., 50., 100. saat) | Enflasyonun gerçek göstergesi |
| İlk tezgâha ve ilk dükkâna ulaşma süresi | Yeni oyuncu deneyimi |
| Fiyat/gelir oranı | Satın alma gücü |
| En zengin %1'in toplam servetteki payı | Tekelleşme |
| Suç yolu / temiz yol temiz servet oranı | ORTAK-006 hedefi |
| Soygun yakalanma oranları | §7.2 hedefleri |
| Basılan ve yok edilen para | Bilgi amaçlı; tek başına alarm değil |
| Kamu maaşları toplamı | Devletin bastığı para |

**Basılan/yok edilen oranı tek başına bir enflasyon kanıtı değildir.** Oyuncu sayısı büyürken yeni oyuncular birikim yaptığı için bu oran doğal olarak 1'in üzerinde seyreder. Küçük kapalı testlerde anlamlı bir kapı ölçütü olarak kullanılmaz.

**İnceleme eşikleri (başlangıç):** Kohort medyanı haftadan haftaya %20'den fazla artarsa, en zengin %1'in payı %25'i geçerse veya suç/temiz oranı 1,5'i geçerse ayrıntılı inceleme yapılır.

Roblox'un yerleşik ekonomi analitiği uygunsa kullanılır; uygunluğu K1'de doğrulanır. Değilse kendi toplama servisimiz kurulur (`04` §4).

## 13. Robux gelir kalemleri

**İlke:** Güç satılmaz; görsellik, topluluk araçları ve kolaylık satılır. Robux ile ekonomik kapasite, yargı kararı, ceza süresi veya kaçış kolaylığı satın alınamaz (Kural 8).

| Ürün | Tip | Başlangıç fiyatı | Ne verir |
|---|---|---|---|
| Özel sunucu | **Aylık abonelik** (Roblox'un özel sunucu özelliği) | Tek aylık fiyat; pazar araştırmasıyla belirlenir | Topluluklara kendi sunucusu |
| Özel sunucu yönetim paketi | Game Pass | 300 R$ | Sunucu yönetimi: atma, saat, hava, etkinlik. Ekonomiye ve adalete dokunmaz |
| Araç kaplaması | Game Pass | 100–200 R$ | Görsel |
| Kıyafet paketi | Game Pass | 100–150 R$ | Görsel |
| Tabela ve vitrin temaları | Game Pass | 100–200 R$ | Görsel; hazır şablon |
| Dükkân iç dekor paketi | Game Pass | 150–250 R$ | Görsel |
| Gardırop yuvası | Game Pass | 100 R$ | Kayıtlı kıyafet sayısı |
| Ek radyo istasyonları | Game Pass | 100 R$ | Lisanslı kütüphaneden ek istasyonlar |
| İsim rengi | Game Pass | 100 R$ | Görsel |

**Kaldırılanlar:**
- *İşletme slotu +1:* Ek hak paralel bir gelir kaynağıdır, yani ekonomik güçtür (ORTAK-010).
- *Topluluğun kendi araç kaplamasını yüklemesi:* Moderasyon yükü nedeniyle ertelendi.

**Özel sunucu modları (ORTAK-011):**
- **Standart mod:** Kalıcı ekonomiyi paylaşır. Suç ödülleri ve oyuncular arası para akışı için ek sınır uygulanır: soygun ödülü %50.
- **Serbest RP modu:** Kazanç ve adalet sonuçları kalıcı ekonomiye taşınmaz. Mod ekranda açıkça gösterilir.

**Şans kutusu, kasa açma, çekiliş yok** (Kural 1). **Ücretsiz oyuncu tam oyunu oynar:** her mesleği yapabilir, her bölgeye girebilir, her işletmeye sahip olabilir.

## 14. `Ayarlar.lua` başlangıç değerleri

```lua
-- Zaman
OyunGunuSaniye            = 2880
UretimGunuSaniye          = 2880
CevrimdisiPencereSaat     = 8
UykuGun                   = 30
YuvaAyirmaSaniye          = 300

-- Gelir (net ₡/dk, sahibi aktif)
TaksiKiralikUcret         = 30
TaksiDakikaUcret          = 40
KasiyerTaban              = 25
KasiyerMaks               = 70
PerakendeMarj             = 0.40
SeviyeNetOran             = {20, 40, 85, 110, 140}
SeviyeMaliyet             = {1500, 5000, 15000, 45000, 150000}

-- NPC ve maaş
NPCVerimMemnun            = 0.35
NPCVerimHuzursuz          = 0.20
NPCVerimKirgin            = 0.10
TabanMaasOrani            = 0.07
KismiYetkiliCarpan        = 1.25
MuhasebeciCarpan          = 1.50
MuhasebeciKarPayi         = 0.05
CevrimdisiNetVerimCalisanli  = 0.10
CevrimdisiNetVerimCalisansiz = 0.05
RuhsatPayiOrani           = 0.03
ReferansKontrolUcreti     = 200

-- Kasa, soygun, sigorta
KasaBirikmeSaniye         = 600
KasaNakitPayi             = 0.50
KasaTavan                 = {nil, nil, 1100, 1400, 1800}
SigortaOrani              = 0.40
SigortaPrimiOrani         = 0.01
HedefKorumaSaniye         = 1800
YeniIsletmeKorumaSaat     = 2
SoygunSogumaSaniye        = 1800
NPCHedefDolmaSaniye       = 1200

-- Aklama
AklamaRisksizOran         = 0.20
AklamaRiskliUstOran       = 0.35
DisaridanAklamaOran       = 0.10
AklamaKesinti             = 0.15

-- Çatışma ve sağlık (UK-13, UK-14, UK-15)
CanMaks                   = 100
TabancaHasar              = 12
TufekHasar                = 18
KafaCarpani               = 1.0
YenilenmeBeklemeSaniye    = 20
YenilenmeHizi             = 2
ElektrosokSaniye          = 4
YaraliBeklemeSaniye       = 45
IlkYardimCan              = 30
HastaneTedaviSaniye       = 30
MesruMudafaaSaniye        = 60
KirliNakitDusmeOrani      = 0.50
DusenEsyaSureSaniye       = 120
YeniOyuncuKorumaSaat      = 2

-- Silah fiyatları (UK-13)
SilahRuhsatUcreti         = 5000
TabancaFiyat              = 25000
KilifFiyat                = 2500
SarjorFiyat               = 450
SarjorAtis                = 12
BakimAtisAraligi          = 60
BakimUcreti               = 1000
KacakTabancaFiyatKirli    = 45000

-- Polis etkileşimi
GonulluSoruBeklemeSaniye  = 300
DurdurmaBeklemeSaniye     = 600
RetSupheSonmeSaniye       = 600

-- Adalet (UK-08)
TekInfazTavanSaniye       = 600
GozaltiMaksSaniye         = 120
BildirimPenceresiSaniye   = 600
IkrarIndirimOrani         = 0.25
KosulluTahliyeMaksOran    = 0.30
KacisEkCezaSaniye         = 120
TeslimEkCezaSaniye        = 60
KacisBasarisizEkSaniye    = 60
KacakZamanAsimiSaniye     = 1800

-- Telemetri eşikleri
KohortMedyanUyariOrani    = 0.20
EnZengin1PayUyari         = 0.25
SucTemizOranUyari         = 1.50
```

## 15. Ekonomi modeli şartı

K3 başlamadan önce küçük bir ekonomi modeli (tablo veya kısa bir simülasyon) kurulur. Tek tek sayılar yerine oyuncu yolları hesaplanır.

**Arketipler:**
1. Temiz işletmeci
2. Karma oyuncu (işletme ve zaman zaman suç)
3. Suç ağırlıklı işletmeci
4. İşletmesiz suçlu
5. Kamu mesleği (polis veya FCU)

**Çıktılar:** Her arketip için 1., 5., 10., 25., 50. ve 100. saatte temiz servet; ilk tezgâh ve ilk dükkân süresi; çevrimdışı 8 saatin aktif dakika karşılığı.

**Geçmesi gereken kontroller:**
- Suç ağırlıklı / temiz oranı 1,2–1,5 aralığında.
- Çevrimdışı 8 saat, 20–60 dakikalık aktif gelire denk.
- NPC net katkısı, sahibin aktif gelirinin %25–30'u.
- Seviye 5, seviye 4'te yaklaşık 25 saatlik net.

Modeli tasarım sorumlusu kurar; yapay zekâ simülasyon kodunu hazırlayabilir. Sonuçları insan yorumlar ve onaylanmış değerleri §14'e işler.

## 16. Karar günlüğü

| Karar | Gerekçe | Kimlik |
|---|---|---|
| Hesap sözleşmesi: ciro, maliyet, ücret, gider, net | Kavramlar karışıyordu | ORTAK-004 |
| "14.000 ₡ < 20 dk" hatası düzeltildi | 168 dakikaya eşitti | ORTAK-004 |
| Çevrimdışı net %10 / %5, 8 saat tavan | 8 saat, bir saatten az aktif oyuna denk olsun | ORTAK-003 |
| Suç gelir değil, sermaye sıçraması | 1.0'da suç baskın stratejiydi | v2 |
| Temiz servet oranı 1,2–1,5 | Suç baskın olmasın ama anlamlı kalsın | ORTAK-006 |
| Büyük ödüller NPC şehir hedeflerinde | Oyuncu emeği hedef olmasın | ORTAK-005 |
| Aklama kotası yasal satışa bağlı, üç bölge | Kendi kendini büyütmesin | ORTAK-007 |
| Tek çalışan modeli, taksi %35 | %75 otomasyon yasasını deliyordu | ORTAK-008 |
| Silahlar pahalı, mühimmat ve bakım sürekli gider | Silah bir statü kararı olsun | UK-13 |
| Hastane ücretsiz | Masum yaralı cezalandırılmasın | UK-14 |
| Giriş fiyatları sabit, prestij endeksi medyana göre | Yeni oyuncu cezalandırılmasın | ORTAK-009 |
| Telemetri K1'de, kohort ölçütleri | Erken ve doğru veri | ORTAK-009, 029 |
| Robux ile slot yok | Ek hak ekonomik güçtür | ORTAK-010 |
| Özel sunucu abonelik; standart ve serbest mod | Doğru mekanizma; ekonomi korunur | ORTAK-011 |
| Oyunda borsa sistemi olacak; tasarımı, kuralları ve katmanı açık | Proje sahibi kararı. §1 riskini doğrudan etkilediği için §12 frenleri ve §15 modeli olmadan sayı konmaz | UK-18, AÇIK-14 |
