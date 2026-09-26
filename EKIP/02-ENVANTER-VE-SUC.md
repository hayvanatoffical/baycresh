# BAYCREST — Envanter, Güvenlik ve Suç

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Tasarım baz çizgisi; oyunda uygulanmış veya test edilmiş özellik anlamına gelmez.
**Okuyucu:** Herkes. Tasarımcı, kodcu ve animasyon sorumlusu için zorunlu.
**Ön koşul:** `00-BASLA-BURADAN.md`, `01-SAHIPLIK-VE-ISLETME.md`
**Bağlı kararlar:** ORTAK-005, 007, 017, 019, 020, 022, 023, 024, 035, 038, 052, 053 · UK-02, UK-13, UK-14, UK-15

Envanter sistemi oyunun imzasıdır ve buradaki her kural görünürlüğe dayanır. Suçun hukuki sonucu (delil, mahkeme, cezaevi) `09-ADALET-VE-ANAYASA.md`'dedir. Belgedeki sayılar başlangıç değeridir ve tek kaynakları `03-EKONOMI.md` §14'tür.

---

## 1. Envanter felsefesi

Çoğu oyunda envanter bir **listedir**. Tuşa basarsın, bir ızgara açılır ve ne taşıdığın kimseyi ilgilendirmez.

Bizde envanter bir **beyandır**. Taşıdığın her şeyin bedeninde bir yeri, o yerin de bir görünürlüğü vardır. Ne taşıdığın ya çevrendekilerin gördüğü bir bilgidir ya da gizlemek için bedel ödediğin bir sırdır.

Üç kural:

**Yer dardır, ama angarya değildir.** Kimlik, cüzdan ve anahtarlar yer tutmaz. Yer yalnız anlamlı kararlar için daralır: silah, nakit, alet.

**Gizlemek ekipman ister.** Silahın varsa ve gizleyecek eşyan yoksa onu elinde taşırsın ve herkes görür. Kılıf, çanta ve palto ayrı satın alınır.

**Görünürlüğün sonucu vardır.** NPC'ler gördüklerine tepki verir. Polis gördüğünü sorabilir. Diğer oyuncular gördüklerine göre karar verir.

## 2. Birim mimarisi

### 2.1 Alanlar

Yer **birim** ile ölçülür. Eski "slot" kavramı kaldırıldı; yarım slot artık yok (ORTAK-020).

| Alan | Kapasite | Görünürlük |
|---|---|---|
| **Cep** | 2 cep × 2 birim | Gizli; orta eşyada şişkinlik riski |
| **Sırt** | 1 uzun eşya | **Her zaman görünür** |
| **Eller** | 1 eşya | **Her zaman görünür** |
| **Çanta** | 8–20 birim (tipine göre) | Çanta görünür, **içerik gizli** |
| **Araç bagajı** | 24 birim | Kapalıyken gizli; açıkken yakındakiler görür |
| **Ev kasası** | 40 birim | Yalnız evdeyken erişilir; ilk sürümde güvenli |

### 2.2 Boyut sınıfları

| Sınıf | Birim | Nereye girer | Örnek |
|---|---|---|---|
| Küçük | 1 | Cep, çanta, bagaj | Telefon, maske, kelepçe anahtarı, küçük alet |
| Orta | 2 (bir cebi doldurur) | Cep, çanta, bagaj | Tabanca, 10.000 ₡ deste |
| Büyük | 4 | Yalnız çanta veya bagaj | Kasa kesme aleti, ev eşyası |
| Uzun | — | Yalnız sırt veya bagaj | Av tüfeği, kürek, olta |

### 2.3 Temel eşyalar

**Kimlik, cüzdan, anahtarlık (araç ve ev anahtarları) ve ruhsat kartları yer tutmaz.** Her oyuncuda her zaman bulunurlar. Telefon bilinçli olarak 1 birim yer tutar: bedeli uzaktan yönetimdir (`01` §9).

### 2.4 Nakit

- Cüzdan ilk **2.500 temiz ₡**'yi yer tutmadan taşır.
- Fazlası destelerle taşınır: her başlayan 5.000 ₡ için 1 birim. 10.000 ₡ 2 birim, yani bir cebi doldurur.
- 45.000 temiz ₡ 9 birimdir ve çanta gerektirir.
- **Kirli nakit** temiz nakitten ayrı bir destedir. Cüzdan muafiyeti kirli nakde uygulanmaz: her başlayan 5.000 kirli ₡ 1 birim tutar. 25.000 kirli ₡ 5 birim eder.

## 3. Gizleme

### 3.1 Temel kural ve önizleme

> Bir eşyayı gizleyemiyorsan, onu **elinde taşırsın.**

Kılıfın yoksa tabancan elindedir. Şehir merkezinde elinde tabancayla yürümek NPC paniği ve 118 ihbarı demektir.

Riskli görünürlük değişimi bir arayüz kazası olmamalıdır. Gizlenemeyen bir eşyayı gizli bir yere taşımaya çalıştığında eşya kendiliğinden ele geçmez; önce bir önizleme çıkar:

> Kılıfın yok. Tabanca elinde, herkesin görebileceği şekilde taşınacak.
> [ Onayla ] [ Vazgeç ]

Onaylarsan eşya ele geçer. Başarısız bir işlem hiçbir eşyayı kaybettirmez (ORTAK-020).

### 3.2 Gizleme ekipmanları

| Ekipman | Ne yapar | Yan etki |
|---|---|---|
| **Kılıf** | Tabanca cebe gizli girer | Ruhsatlıysa tamamen yasaldır |
| **Sırt çantası** | Orta ve büyük eşyaları gizler | Çantanın kendisi görünür ve sorulabilir |
| **Uzun palto** | Şişkinliğin fark edilme ihtimalini düşürür | Yaz gününde NPC'ler garipser |
| **Alet çantası** | Aletleri meşru gösterir | Yalnız atölye mesleğindeyken inandırıcıdır |
| **Tüfek kılıfı** | Tüfeğin türünü gizler, kendisini gizlemez | Uzun kılıf taşımak başlı başına dikkat çeker |

**Tüfek asla gizlenemez.** Sırtta durur ve herkes görür. Tek gizleme yolu araç bagajıdır.

### 3.3 Şişkinlik

Cepteki orta boy eşya yakın mesafede fark edilebilir:

| Durum | Fark edilme |
|---|---|
| Kılıf ve palto | Çok düşük |
| Kılıf, paltosuz | Düşük |
| Kılıfsız | Gizleme yok; eşya eldedir |
| Koşarken veya çarpışırken | İki katına çıkar |

Şişkinlik fark edilirse **ihbar olmaz**; yalnız o NPC'de bir şüphe kaydı oluşur. Polis o NPC'yi sorgularsa bunu öğrenir. Oyuncu bu kaydı sonradan, kendisine açılan bir dosyada görür (Kural 7).

## 4. Bilgi erişimi

Görünürlük bir oyun kuralıdır, görsel bir efekt değildir. Kim neyi görür, aşağıdaki matris tanımlar (ORTAK-019). Teknik uygulaması `04-TEKNIK.md` §2'dedir.

| Bilgi | Sahibi | Yakındaki oyuncu | Polis | NPC | Kamera |
|---|---|---|---|---|---|
| Eller ve sırt | Evet | Evet | Evet | Evet | Evet |
| Cep içeriği | Evet | Hayır | Yalnız delile dayalı aramada | Hayır | Hayır |
| Çanta nesnesi | Evet | Evet | Evet | Evet | Evet |
| Çanta içeriği | Evet | Halka açık yerde açık tutulduğu sürece | Gösterilirse veya delile dayalı aramada | Açıkken görüş alanındaysa | Açıkken kadrajdaysa |
| Açık bagaj içeriği | Evet | Menzilde ve görüşte, açık kaldığı sürece | Aynı | Aynı | Aynı |
| Aranma seviyesi | Evet | Hayır | Seviyeye göre (§9.2) | Hayır | — |
| Şüphe kaydı | Dosyada sonradan | Hayır | Sorgulayan polis | Kaydı tutan NPC | — |

**Bir kez gösterilen bilgi geri alınamaz.** Çanta içeriğini gören oyuncu onu görmüştür. Bu, çantayı halka açık yerde açmanın bedelidir.

## 5. Polis etkileşimi: soru, durdurma, arama

### 5.1 Üç kademe

Polis rolü taciz veya zorunlu itaat mekanizmasına dönüşmemelidir. Bu yüzden etkileşim üç kademeye ayrılır (ORTAK-017):

| Kademe | Ne zaman | Oyuncunun seçenekleri | Ret veya uzaklaşmanın sonucu |
|---|---|---|---|
| **Gönüllü soru** | Her zaman | Göster · Reddet · Uzaklaş | Hiçbir şey |
| **Gerekçeli durdurma** | Sistem listesinden bir gerekçe varsa: şehirde görünür silah, şehirde maske, aranma ≥1 ve tarife uyum, trafik ihlali, eşik üstü şüphe | Durmak zorunludur. Göster · Reddet | Ret küçük bir şüphe üretir ve bu şüphe 10 dakikada söner. Kaçmak: Aranma 1 (`09` S-06) |
| **Delile dayalı arama** | Delil varsa: aktif dosyada net eşleşme, kamera kaydı, suç anında yakalanma, Aranma ≥2 | Seçenek yok; polis çantayı ve cepleri açar | Bulunan yasadışı eşya delil olur |

### 5.2 Ret hakkı

**Reddetmek suç değildir ve mahkûmiyet gerekçesi değildir** (V-A02).

- Gönüllü soruya ret hiçbir şey üretmez.
- Gerekçeli durdurmada ret küçük, sönen bir şüphe üretir. Aynı memurdan gelen tekrar durdurmada ret yeni şüphe üretmez.
- Ret hiçbir durumda tek başına denetim veya dava dayanağı olmaz (ORTAK-053).

**Süre ve bağlantı.** Oyuncu tarafında karar süresi sınırlıdır. Süre dolarsa gönüllü soruda "uzaklaştı", durdurmada "reddetti" sayılır. Bağlantı koparsa işlem iptal edilir ve hiçbir şey üretmez. Aranan bir oyuncunun aranması ise bağlantı kopsa da sürer.

### 5.3 Sınırlar

- Aynı memur aynı kişiye 5 dakikada en fazla bir gönüllü soru sorabilir.
- Aynı gerekçeyle aynı kişiye 10 dakikada en fazla bir gerekçeli durdurma yapılabilir; tekrar için yeni bir gerekçe gerekir.
- Gerekçesi sonradan yanlış çıkan durdurmalar ve arama sonuçsuz kalan delile dayalı aramalar memurun **yetki puanını** düşürür. Yetki puanı düşen memurun arama yetkisi geçici olarak kalkar.

### 5.4 Kamusal ifşa

Çantayı halka açık yerde açmak risklidir. Markette çantanı açıp kirli nakit gösterirsen:

- NPC müşteriler görür ve bir kısmı ihbar eder.
- Diğer oyuncular görür ve seni hedef olarak işaretleyebilir.
- Kamera varsa kayda geçer.

Bu, oyuncunun kendi dikkatsizliğiyle yarattığı bir risktir ve tamamen adildir.

### 5.5 Neden bu sistem imza

Birçok RP oyununda polis bir tuşa basar, envanteri görür ve iş biter. Mekanik yok, rol yok, gerilim yok.

Bizde polis **gözlemlemek, gerekçe bulmak ve delil toplamak** zorundadır; suçlu ise **rol yapmak** zorundadır. İkisi arasında gerçek bir bilgi oyunu doğar.

## 6. Nakit fiziktir

Para bankada olmak zorunda değildir; çantanda da taşırsın.

| Yer | Güvenlik | İz |
|---|---|---|
| **Banka** | Çalınamaz | Her yatırma kayda geçer |
| **Çanta** | Görünürdür, sorulabilir | İz yok |
| **Ev kasası** | İlk sürümde güvenli | İz yok |
| **Araç bagajı** | Açıkken görünür | İz yok |

Büyük bir soygundan sonraki sonuç zinciri kendiliğinden işler:

```
Kuyumcu soygunu
   → 25.000 kirli ₡ = 5 birim (cüzdan muafiyeti yok)
   → Cebe sığmaz, çanta şart
   → Çanta görünür
   → Gerekçeli durdurmada polis çantayı sorar
   → Göstermek yakalanmak, reddetmek şüphe
   → Aracına ulaşman gerek; bagaj kapalıyken tek gizli yer
```

Soygunun zor kısmı kasayı açmak değil, **parayı güvenli yere götürmektir.** Kaçış yolculuğu oyunun bir parçasıdır.

## 7. Silah, hasar, yaralanma ve hastane

Bu bölüm UK-13, UK-14 ve UK-15'i uygular: silahlar pahalıdır, hasar düşüktür, kimse ölmez. Hedef, silahın bir **statü ve karar** olması; herkesin elinde duran bir oyuncak olmaması (ORTAK-023).

### 7.1 Silahlar pahalıdır

| Kalem | Başlangıç fiyatı | Not |
|---|---|---|
| Silah ruhsatı | 5.000 ₡ + sınav görevi | Temiz sicil gerekir; mahkûmiyetle askıya alınır |
| Ruhsatlı tabanca | 25.000 ₡ | Yaklaşık bir dükkân (seviye 3) fiyatı |
| Kılıf | 2.500 ₡ | |
| Şarjör (12 atış) | 450 ₡ | Atış başına yaklaşık 37 ₡ |
| Bakım | Her 60 atışta 1.000 ₡ | Bakımsız silah tutukluk yapar |
| Av tüfeği (yayın sonrası, Northwood) | 40.000 ₡ + av ruhsatı | |
| Kaçak tabanca (Oldport aracısı) | 45.000 **kirli** ₡ | Ruhsatsızdır; yakalanınca el konur |

- Ruhsatlı silah yalnız Blackstone'daki **NPC silah satış noktasından** alınır. Oyuncu işletmeleri silah satamaz (`10` §6).
- **Pompalı tüfek yoktur.** Yüksek hasar sınıfıdır ve UK-15 ile uyumsuzdur.
- Polis görevdeyken ücretsiz bir görev tabancası ve **elektroşok** alır. Görev bitince ikisini de teslim eder.

### 7.2 Hasar düşüktür

| Değer | Başlangıç |
|---|---|
| Can | 100 |
| Tabanca, isabet başına | 12 (en az 9 isabet) |
| Av tüfeği, isabet başına | 18 (en az 6 isabet) |
| Kafa atışı çarpanı | Yok |
| Yenilenme | 20 saniye hasar almazsan saniyede 2 can |
| Elektroşok | Hasar yok; 4 saniye etkisiz bırakır |
| Araç çarpması | Oyuncuya hasar vermez, yalnız iter |

Tek atışla veya birkaç saniyede yaralama yoktur. Çatışma kısa bir mücadeledir, anlık bir infaz değildir.

### 7.3 Bağlam kuralı

Oyuncuya ateş yalnız **meşru bir bağlam** varsa mümkündür. Bağlam yoksa tetik oyunculara karşı kilitlidir ve ekranda sebebi yazar: "Bu kişiye ateş etmek için geçerli bir durum yok."

Meşru bağlamlar:

1. **Görevdeki polis ve aranan kişi:** Aranma ≥2 olan veya suç anında yakalanan kişi.
2. **Aktif suç alanı:** Soygun başladığında hedef mekân ve çevresi. Bu alanda fail, polis ve güvenlik görevlisi arasında ateş mümkündür.
3. **Meşru müdafaa:** Sana hasar veren kişiye 60 saniye boyunca karşılık verebilirsin.

Havaya veya boşluğa ateş etmek kamu düzenini bozmaktır: Aranma 1 ve bir suç kaydı oluşur (`09` S-02). Sebepsiz saldırı böylece mekanik olarak mümkün değildir. Şehir RP oyunlarındaki en yaygın taciz biçimini bu kural kapatır.

### 7.4 Yaralı durumu

Canı sıfıra düşen oyuncu **ölmez, yaralanır** (UK-14):

1. Yere çöker ve hareket edemez. Silah, envanter ve telefon kapanır. 118 otomatik aranır.
2. **45 saniye** yardım bekler. Bu sürede:
   - Bir oyuncu **sağlık ekibi** gelip ilk yardım yaparsa, oyuncu 30 canla ayağa kalkar ve hastaneye gitmez.
   - Kimse gelmezse NPC ambulans gelir ve oyuncuyu hastaneye götürür.
3. Aranan bir oyuncu yaralıyken polis onu kelepçeleyebilir.

Görsel dil: kan yok. Yere çökme, sersemlik efekti ve bandaj.

### 7.5 Hastane

**Verania General Hospital** Blackstone'dadır.

- Tedavi 30 saniye sürer ve **ücretsizdir**. Yaralanan masum bir oyuncu hiçbir şey ödemez.
- Oyuncu tam canla çıkar.
- Aranma ≥2 iken yaralanan oyuncu hastane çıkışında **gözaltına** alınır ve dosyası mahkemeye gider (`09` §7).

### 7.6 Yaralanınca ne düşer

| Durum | Kaybedilen |
|---|---|
| Suçla ilgisi olmayan eşya ve para | **Hiçbir şey.** Yalnız zaman. |
| Taşınan kirli nakit | Yarısı olay yerine düşer. **Yalnız polis toplayabilir** ve toplanan para delil olarak el konur. 2 dakika içinde toplanmazsa şehir el koyar ve para ekonomiden çıkar. |
| Ruhsatsız silah | Düşer; yalnız polis toplar ve el konur. |
| Ruhsatlı silah, temiz nakit, meşru eşya | Hiçbir şey |

Diğer oyuncular düşen hiçbir şeyi alamaz. Böylece oyuncular birbirini yaralayarak ganimet toplayamaz.

### 7.7 Güvenli bölgeler ve yeni oyuncu koruması

**Güvenli bölgeler:** Doğma noktası, hastane, Civic Licensing Office, adalet sarayı içi, ibadethaneler ve **Blackstone Bazaar**. Bu bölgelerde silah çekilemez, hasar verilemez ve suç eylemi başlatılamaz. Aranan bir oyuncu güvenli bölge korumasından yararlanmaz.

**Yeni oyuncu koruması:** Oyuncu ilk 2 aktif saatinde hasar almaz ve silah çekemez. Bir suç eylemi başlatırsa koruma hemen biter (ORTAK-052).

### 7.8 NPC'ler

**NPC'ler hasar almaz.** Tehdit edildiklerinde (silah çekildiğinde) teslim olur, ellerini kaldırır veya kaçarlar. NPC polis yalnız öldürücü olmayan araç kullanır: elektroşok ve kelepçe. Bu hem şiddet düzeyini düşük tutar hem de NPC'lere karşı anlamsız şiddeti ortadan kaldırır.

## 8. Tanık sistemi

Bir suç işlendiğinde görüş alanındaki her NPC bir **tanık kaydı** oluşturur. Kayıt şunları tutar: failin **olay anındaki** görünüm anlık görüntüsü, kıyafet rengi, araç plakası, zaman, konum ve netlik.

- **Robot resim** bu anlık görüntüden üretilir ve netliğe göre bozulur. Net tarif tam görüntü verir; bulanık tarif silüet ve iki baskın rengi verir. Oyuncunun sonradan kıyafet değiştirmesi geçmiş tanığı değiştirmez (ORTAK-019).
- **Tanık kaydı NPC nesnesinden ayrıdır.** NPC havuza dönse de kayıt olay dosyasında kalır.
- **Oyuncu polis varsa** olay yerindeki tanıklardan ifade alır. Bulanık tanıkları birbiriyle ve kamerayla eşleştirerek delili güçlendirebilir.
- **Oyuncu polis yoksa** NPC soruşturması yalnız sistem olayını, kamera kaydını ve net tanıkları toplar. Oyuncu polis daha fazla delil toplayabildiği için değer katar.

**Netlik dört şeye bağlıdır:**

| Faktör | Etki |
|---|---|
| Maskeliydi | Yüz gizli; yalnız kıyafet ve boy |
| Silah çekildi, NPC korktu | Bulanık tarif, yüksek hata payı |
| Sessiz suç, NPC sakin | Net tarif |
| Mesafe uzak | Kısmi tarif |

**Avatar ve kıyafet.** Oyuncu şehirde, Roblox avatarının üzerine giyilen oyun içi **RP kıyafetini** taşır. RP kıyafeti giyildiğinde avatarın yüz ve baş aksesuarları gizlenir; saç görünür kalır. **Maske yalnız oyun içi bir eşyadır** (ORTAK-022). Tanık tarifindeki renkler bu yüzden anlamlıdır.

**Maske otomatik doğru cevap değildir.** Maske yüzünü gizler, ama şehirde maskeli dolaşmak gerekçeli durdurma sebebidir ve NPC'ler ihbar eder. Silah çekmek tanığı korkutur ve tarifi bozar, ama aranma seviyeni yükseltir. Her seçimin bir bedeli vardır.

## 9. Şüphe ve aranma

Bunlar iki ayrı sistemdir ve karıştırılmamalıdır. İkisi de **dosyadan** ayrıdır: aranma bir kovalamaca durumudur, dosya ise hukuki süreçtir. Aranmanın sönmesi dosyayı kapatmaz.

### 9.1 Şüphe (yumuşak)

Kişiseldir, kanıt değildir ve zamanla söner.

**Kaynakları:** Gerekçeli durdurmada ret, şişkinliğin fark edilmesi, maskeli dolaşmak, uygunsuz yerde uygunsuz eşya.

Polisin şüpheyle yapabileceği şey **sormak ve izlemektir**. Eşik üstü şüphe gerekçeli durdurma sebebi olabilir. Şüphe tutuklama, arama veya mahkûmiyet sebebi olamaz.

### 9.2 Aranma (sert)

İşlenmiş bir suçtan ve bir sistem olayından doğar.

| Seviye | Tetikleyici | Polisin gördüğü |
|---|---|---|
| **0 — Temiz** | — | Hiçbir şey |
| **1 — İhbar** | Sessiz suç, maskeli suç, durdurmadan kaçma, havaya ateş | Yalnız mahalle adı |
| **2 — Tarif** | Maskesiz suç veya net tanık | Mahalle ve robot resim |
| **3 — Takip** | Suç alanında ateş edildi | Konum periyodik güncellenir |
| **4 — Kırmızı bülten** | Görevli (polis, sağlık, cezaevi) yaralandı | Canlı konum, robot resim, plaka; tüm birimlere |
| **Kaçak** | Cezaevinden kaçış | Son görülen konum ve görünüm; yeni gözlemlerle güncellenir (`09` §11) |

Kural 7 gereği oyuncu kendi seviyesini ekranda görür ve neden yükseldiğini kısa bir bildirimle okur:

> ⚠ **Aranma 2** — Bir tanık seni maskesiz gördü

**Soğuma:** Seviye zamanla düşer. Şehir dışına çıkmak, kıyafet ve araç değiştirmek soğumayı hızlandırır.

### 9.3 Şehir alarm seviyesi

Suç dengesi sunucudaki oyuncu polis sayısına bağlıdır, bu yüzden NPC müdahalesi ona göre ayarlanır (ORTAK-024):

| Görevdeki oyuncu polis | NPC müdahalesi |
|---|---|
| 0 | NPC müdahale birimi 1–4. seviyelerin hepsine gelir; yavaş ama kararlıdır |
| 1–2 | NPC birimler 1–3. seviyeye gelir ve oyuncu polise destek verir |
| 3 ve üstü | NPC yalnız 1–2. seviyelere gelir; büyük olaylar oyuncu polisindir |

Yakalanma oranları sabit sayılar değil, telemetriyle ölçülen hedeflerdir (`03` §7.2).

## 10. Sektöre göre risk ve soygun

### 10.1 Dört risk türü

Her meslek aynı soygun riski altında değildir (UK-02, ORTAK-005).

| Risk türü | Örnek | Koruma |
|---|---|---|
| **Operasyonel** | Stok yetişmemesi, yanlış plan, düşük kalite, araç bakımı | Önceden görünen bilgi, sınırlı zarar, telafi işi |
| **Ticari** | Yanlış ürün seçimi, düşük talep, kaçırılan sözleşme hedefi | Anlaşılır talep bilgisi, sabit başlangıç maliyeti |
| **Hukuki** | Kanıtlı sözleşme ihlali, suçla bağlantılı işlem | Delile bağlı süreç, itiraz, ölçülü yaptırım |
| **Suç kaynaklı** | Soyulabilir nakit | Sınırlı ve sigortalı kayıp, hedef koruması, müdahale |

Her işletme ailesinin risk profili `10-IS-VE-MESLEK-KATALOGU.md` §4'tedir.

### 10.2 Soyulabilir kasa

Yalnız **nakit riskli** işletmelerde bulunur: perakende ve perakende satış yapan üretim işletmeleri (fırın, kafe), seviye 3 ve üstü. Atölye, proje, lojistik, hizmet ve mobil işletmelerde soyulabilir kasa yoktur. Tezgâhlar Bazaar'da güvenli bölgededir.

- Kasada yalnız **son 10 dakikanın nakit satışı** durur; fazlası otomatik olarak tahsilata geçer.
- Kasa seviyeye göre tavanlıdır (`03` §7.3). Soyguncunun alacağı miktar küçüktür; oyuncu işletmesi soygunu bir servet kaynağı değildir.
- Hırsız yalnız kasadakini alır. Tahsilat ve banka dokunulmazdır.

### 10.3 Şehir hedefleri

Büyük soygun ödülleri **NPC'ye ait şehir hedeflerindedir**. Böylece büyük suç, başka bir oyuncunun emeğini değil şehri hedef alır.

| Hedef | Katman |
|---|---|
| Mahalle bakkalı (NPC) | K3 |
| Blackstone büyük marketi (NPC) | K5 |
| Kuyumcu (NPC) | K5 |
| Banka şubesi, zırhlı araç | Yayın sonrası |

Kasa değerleri ve hedef yakalanma oranları `03` §7.2'dedir.

### 10.4 Hedef koruması

- **Oyunda olmayan oyuncunun işletmesi soyulamaz** (ORTAK-038).
- Aynı işletme 30 dakikada bir defadan fazla soyulamaz.
- İşletme, sahipliğin ilk 2 aktif saatinde soyulamaz.
- Aktif suç dosyası olan bir oyuncu işletmesini dondurarak korumaya geçemez (`01` §4.4).

### 10.5 Sigorta

- Soygunda kaybedilenin **%40'ı** sigortadan ödenir. Sigorta primi sürekli bir para çıkışıdır.
- Her soygun olayının benzersiz bir kimliği vardır ve bir kez ödenir.
- **Anlaşmalı soygun kontrolü:** Soyguncu sahibin Roblox arkadaşıysa veya son 7 günde aralarında para transferi olduysa sigorta ödenmez ve olay FCU'ya bir kayıt olarak düşer.

### 10.6 Örnek: müteahhitlik

Oyuncu hazır ve onaylı plandan bir proje seçer, keşif yapar, iş sırasını ve ekibini belirler, malzeme teslimini organize eder ve kalite kontrolünden geçer. Ana risk yanlış keşif, gecikme ve yeniden iş yapmanın maliyetidir. **Kalas çalınması zorunlu bir eğlence kaynağı değildir.** Malzeme stoğu başka bir oyuncunun rastgele saldırısıyla yok edilemez (UK-02).

## 11. Kirli para ve aklama

### 11.1 Kirli nakit

Çalınan para **kirli nakit** olarak envanterde durur ve yer kaplar. Bankaya yatırılamaz. Yatırmaya çalışmak işlemi reddeder ve bir tutarsızlık kaydı üretir.

Kirli nakitle yalnız yasadışı alışveriş yapılır: kaçak silah, kilit aleti, sahte plaka. Bunları Oldport'taki NPC aracısı satar.

Yakalanınca veya yaralanınca kirli nakde el konabilir (§7.6, `09` §6).

### 11.2 Aklama kotası

Kirli parayı temizlemenin yolu **kendi işletmenin cirosudur**. Kota şöyle çalışır (ORTAK-007):

- Kota, işletmenin o oyun günündeki **doğrulanmış yasal satışının** yüzdesidir.
- **Aklanan para ciroya sayılmaz.** Bu yüzden aklama kendi kapasitesini büyütemez.
- İşletmenin bütün aklama kaynakları (sahibin kendi kirli parası ve dışarıdan gelen para) **aynı kotayı** paylaşır.
- Kota oyun gününe bağlıdır ve işletme kaydında tutulur. Sunucu değiştirmek onu sıfırlamaz.

### 11.3 Risk bölgeleri

| Yasal satışa oranı | Sonuç |
|---|---|
| %0–20 | **Risksiz.** Para temizlenir. |
| %20–35 | **Riskli.** Her işlem bir tutarsızlık kaydı üretir ve denetim ihtimali artar. |
| %35 üstü | **Yasak.** İşlem reddedilir ve bir açıklama kartı gösterilir. |

Aklama kesintisi %15'tir. Kota göstergesi telefonda sayı olarak görünür (`06` §4.9). Görünmez eşik haksızlık hissi yaratır.

Aklama kapasitesi işletmenin gerçek büyüklüğüne bağlıdır. Bu kural suçlu oyuncuyu meşru işletmesini büyütmeye zorlar; iki yol tek oyuncuda birleşir. Suç yolunun temiz servet katkısı bu kotayla sınırlanır (`03` §7.1).

### 11.4 Başkasının işletmesinden aklama

Mümkündür, ama iki taraflıdır: aklamayı kabul eden işletme sahibi denetim riskini de üstlenir. Komisyon oyuncular arasında konuşulur.

Fren: bir işletmenin toplam kotasının **en fazla yarısı** (yasal satışın %10'u) dışarıdan gelebilir.

Bundan gerçek bir sosyal ekonomi doğar: suçlunun büyük bir işletmeciye, işletmecinin komisyona ihtiyacı vardır ve ikisi de FCU'dan korkar.

## 12. Denetim ve FCU

### 12.1 Nasıl işler

```
Tutarsızlık kaydı oluşur
   → Anında hiçbir şey olmaz
   → Kayıtlar dosyada birikir
   → Oyun günü dönümünde denetim ihtimali hesaplanır
   → Denetim açılır, defterler incelenir
   → Temizse dosya kapanır, şüphe sıfırlanır
   → Değilse dosya mahkemeye gider (09, S-07)
```

**Zaman ölçeği bir oyun günüdür** (48 gerçek dakika). Aynı oturumda patlarsa aklama anlamsızlaşır; haftaya kalırsa gerilim kaybolur. Sahibi oyunda değilse hesaplama, giriş yaptığında ya da adalet kuyruğu işlediğinde yapılır (`04` §9).

### 12.2 Denetimi kim açar

**Sistem.** Tutarsızlık eşiği aşılınca otomatik olarak dosya açar.

**FCU memuru.** Dosyayı kendisi de açabilir, ama bir **dayanağı** olmalıdır:

- Geçerli dayanaklar: tanık ifadesi, kamera kaydı, sistem tutarsızlık kaydı.
- Tek başına dayanak **olmayanlar:** çanta reddi, oyuncu ihbarı. İhbar, ancak en az bir sistem kaydıyla birlikte dayanak olur.

Bu sınır olmazsa sistem bir taciz aracına döner.

### 12.3 Çıkar çatışması

- FCU memuru kendi işletmelerinin, ortaklarının ve son 7 günde para transferi yaptığı kişilerin dosyalarını açamaz.
- Kendisi hakkında aktif bir dosya olan oyuncu FCU görevine giremez.
- Dayanaksız çıkan denetim, açan memurun yetki puanını düşürür (V-A07).

### 12.4 NPC vakaları ve defter bulmacası

Suç işlenmeyen sunucuda FCU'nun işsiz kalmaması için **kurallı NPC vakaları** vardır (ORTAK-035):

- Her vakanın bir zaman çizelgesi, ifadeleri ve işlem kayıtları vardır.
- Bazı vakalar suçsuzlukla sonuçlanır. **Doğru kapatma da başarıdır.**

**Defter bulmacası:** FCU'nun işi okumak olduğu için arayüz bir listeden ibaret değildir. Memur ciro grafiğinde anomali bulur ve tutarsızlık kayıtlarını tanık veya kamera kanıtıyla eşleştirir. Doğru eşleşme dosyanın delil gücünü artırır. Aynı arayüz oyuncu vakalarında da kullanılır.

**FCU büyüme hattı:** Çözülen dosya başına yetki açılır: daha derin defter erişimi, NPC müfettiş atama, kendi birimi.

**Neden çalışır:** FCU, kesintisiz iş akışı olan tek polis rolüdür. Sunucuda hiç suç işlenmese bile okuyacak bir dosyası vardır.

## 13. Sonuçlar ve ceza felsefesi

Suçun sonucu bir **dosyadır**. Dosyanın akışı (delil, karar, infaz, itiraz, kaçış) `09-ADALET-VE-ANAYASA.md`'dedir.

> **Ceza likiditeye vurur, meşru varlığa değil.**

| Ceza | Etkisi |
|---|---|
| Uyarı | Kayıt; tekrarında yaptırım ağırlaşır |
| Para cezası | Bankadan kesilir; bakiye yetmezse borç değil, kısa hizmet görevi |
| El koyma | Yalnız suç geliri (kirli nakit) ve suç aleti (ruhsatsız silah) |
| İşletme askıya alma | Aklama vakalarında, bir oyun günü |
| Kısa hapis | En fazla 10 dakika (`09` §9) |

**Asla alınmayanlar:** meşru dükkân, araç, ev, mobilya, çalışanlar ve meşru para.

**Dar istisnalar:** Suçtan elde edildiği doğrulanmış nakde ve ruhsatsız silaha el konur. Hileyle oluşmuş kayıtlar moderasyonla geri alınır. Bunlar meşru mülkiyetin silinmesi değildir (V-A01).

Kaybettiğin şey zaman ve akıştır. Saatlerce emek verdiğin şey asla silinmez.

## 14. Katman planı

**K3'te gelenler:**
- Birim envanter, gizleme ve önizleme
- Polis etkileşiminin üç kademesi
- Silah (pahalı ve düşük hasarlı), yaralı durumu, hastane
- Tanık, şüphe ve aranma, şehir alarm seviyesi
- Bir NPC soygun hedefi ve riskli sektör kasası
- Kirli nakit, aklama v1, denetim, temel FCU, NPC vaka prototipi

**K4'te gelenler:** Mahkeme, cezaevi, kaçış (`09`).

**Yayın sonrasına ertelenenler:** Çanta kapkaçı, sahte defter üretimi, NPC muhasebecinin ihbar etmesi, tanık satın alma, banka şubesi, av tüfeği ve Northwood, ev hırsızlığı.

## 15. Karar günlüğü

| Karar | Gerekçe | Kimlik |
|---|---|---|
| Birim modeli, temel eşyalar yer tutmaz | Darlık karar üretmeli, angarya değil | ORTAK-020 |
| Gizleme ekipman ister, önizleme ve onay | "Silahım var" ile "silahım gizli" aynı şey değil; arayüz kazası suç olmamalı | v2 + ORTAK-020 |
| Nakit yer kaplar | Soygunun zor kısmı kaçış olmalı | v2 |
| Üç kademeli polis etkileşimi | Polis rolü tacize dönüşmesin | ORTAK-017 |
| Ret suç değil, tek başına dayanak değil | Meşru hamle olmalı | ORTAK-053 |
| Silahlar pahalı | Silah bir statü ve karar olsun | UK-13 |
| Ölüm yok; yaralı durumu ve hastane | Kullanıcı kararı; düşük şiddet düzeyi | UK-14 |
| Düşük hasar, pompalı yok | Kullanıcı kararı | UK-15 |
| Ateş yalnız meşru bağlamda | Sebepsiz saldırıyı mekanik olarak kapatır | ORTAK-023 |
| Masum yaralı hiçbir şey kaybetmez | Birbirini yaralayarak ganimet toplanmasın | ORTAK-023 |
| NPC'ler hasar almaz | Şiddet düzeyi; anlamsız NPC şiddeti yok | ORTAK-023 |
| Robot resim olay anının görüntüsü | Kıyafet değiştirmek anlamlı kalsın | ORTAK-019 |
| Şehir alarm seviyesi | Polissiz sunucuda büyük suç risksiz olmasın | ORTAK-024 |
| Soyulabilir kasa yalnız nakit riskli sektörlerde | Her meslek aynı risk altında değil | UK-02 |
| Büyük ödül NPC şehir hedeflerinde | Büyük suç oyuncu emeğini değil şehri hedeflesin | ORTAK-005 |
| Çevrimdışı işletme soyulamaz | Oyunda olmayana zarar verilmez | ORTAK-038 |
| Aklama kotası yasal satışa bağlı, üç bölge | Kendi kendini büyüten kapasite olmasın | ORTAK-007 |
| Denetim bir oyun günü sonra | Anında aklama anlamsız, hafta gerilimsiz | v2 |
| FCU için çıkar çatışması kuralları | Denetim taciz aracına dönüşmesin | ORTAK-017 |
| NPC vakaları ve defter bulmacası | Suçsuz sunucuda da anlamlı iş | ORTAK-035 |
| Ceza likiditeye | Meşru varlığı silen tycoon hayatta kalmaz | v2 |
