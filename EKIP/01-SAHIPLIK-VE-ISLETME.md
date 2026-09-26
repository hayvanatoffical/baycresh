# BAYCREST — Sahiplik ve İşletme

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Tasarım baz çizgisi; oyunda uygulanmış veya test edilmiş özellik anlamına gelmez.
**Okuyucu:** Herkes. Tasarımcı ve kodcu için zorunlu.
**Ön koşul:** `00-BASLA-BURADAN.md`
**Bağlı kararlar:** ORTAK-001, 002, 003, 008, 016, 021, 026, 027, 037, 042, 049

Bu belge oyunun omurgasıdır; diğer her sistem buna bağlanır. Belgedeki bütün sayılar başlangıç değeridir. Tek kaynakları `03-EKONOMI.md` §14'tür.

---

## 1. Çekirdek döngü

```
SAHİPLEN → BÜYÜT → OTOMATİKLEŞTİR → YENİ BİR ŞEY SAHİPLEN
```

Bir oyuncunun ilk on saati aşağıdaki gibi kurgulanır. Süreler yaklaşıktır ve K0–K1'de ölçülerek ayarlanır.

| Süre | Ne oluyor |
|---|---|
| İlk 5 dk | **Başlangıç tezgâhını sahiplenir.** Sahiplik para biriktirme duvarının arkasında değildir. Pazar kaydı ve satış için gereken sonraki adım açıkça gösterilir. |
| 5–20 dk | Görünür talebe göre ilk stok kararını verir, NPC müşterilerle satış/pazarlık dener ve tezgâhın görünür büyüme hedefini görür. K0 bu aralığı sıkıştırılmış sayılarla test eder. |
| 20–45 dk | İlk tezgâhta ikinci seviye ve çalışan önizlemesi hedeflenir. Gerçek süre K0/K1 oyuncu gözlemiyle yeniden ayarlanır. |
| 1–3 sa | İlk işletmenin üretim-ekonomisi dengesiyle 2. seviye/ruhsat hattı oturur; ikinci işletme hakkının koşulları doğrulanır. |
| 3–5 sa | İlk NPC çalışanını tutar: referans kontrolü yapar, deneme süresini gözler. |
| 5–7 sa | Kendi taksisini alır ve NPC şoföre devreder. İki gelir kaynağı olur. |
| 8–10 sa | Tezgâhtan dükkâna geçer (3. seviye, standart cephe). Kamera ve alarm takar, çünkü artık kaybedecek bir şeyi vardır. |

İki kritik an vardır. Birincisi **ilk birkaç dakika**: oyuncu oyunun “sahip ol ve büyüt” vaadini gerçekten görür. İkincisi **5–7. saat**: oyuncu ilk kez aynı anda iki şeye sahip olur. K0 ilk anı; sonraki katmanlar ikinci anı doğrular. Süreler başlangıç hipotezidir ve oyuncu testi sonucu olmadan garantiye dönüştürülmez.

## 2. Sahiplik mimarisi

### 2.1 Neden zor

Roblox'ta tek bir dünya yoktur. Oyun aynı anda onlarca paralel sunucuda çalışır. Bir dükkânı tüm sunucularda tek oyuncuya kilitlersek, o oyuncunun bulunmadığı sunucularda cephe kapalı kepenk olur. Aynı işletmeyi her sunucuda "gerçekten" çalıştırırsak bu kez aynı kayıt birden çok yerde değişir: çift gelir, çelişen stok, kopyalanan para.

### 2.2 Çözüm: kimlik, tek yazar, yuva

**İşletme sana aittir, cepheye değil.** İşletmenin seviyesi, stoğu, yükseltmeleri, tabelası, çalışanları, tahsilatı ve itibarı senin kaydında durur. Kalıcıdır ve normal cezalarla elinden alınmaz.

**Tek yazar.** İşletme kaydına yalnız senin oturumunu tutan sunucu yazar. Oyunda değilken hiçbir sunucu işletmeni değiştirmez. Başka sunuculardan gelen etkiler (mahkeme kararı gibi) kayda değil, **olay kutuna** düşer ve giriş yaptığında işlenir. Teknik ayrıntı: `04-TEKNIK.md` §4.

**Yuva sunucu başına atanır.** Sunucuya girdiğinde işletmelerin fiziksel yuvalara yerleşir. İşletmen bir **tercihli adres** hatırlar; o sunucuda boşsa oraya yerleşir.

### 2.3 Yuva sınıfları

Cephe tek tip değildir. Fiziksel yer ihtiyacı, işletmenin ailesine ve seviyesine göre farklı sınıflardan karşılanır.

| Sınıf | Kimin için | Yer | Sunucu başına (başlangıç) |
|---|---|---|---|
| **Çarşı tezgâhı** | Perakende, üretim ve hizmet işletmeleri, seviye 1–2 | Blackstone Bazaar | 24 |
| **Standart cephe** | Seviye 3–4 dükkânlar | Ironhill (14), Blackstone (4) | 18 |
| **Büyük cephe** | Seviye 5 mağazalar | Blackstone Merkez | 6 |
| **Pasaj birimi** | Hizmet işletmeleri ve taşma | Blackstone Arcade (bina içi birimler) | 12 |
| **Sanayi yuvası** | Atölye, tamirhane, depo, lojistik, proje ofisi | Oldport ve Ironhill alt sokakları | 10 |
| **Yuva yok** | Mobil işletmeler (taksi, kurye, minibüs) | Ortak durak ve garaj | — |

Kapasite **işletme sahibi sayısına değil, o sunucuda çevrimiçi olan fiziksel işletme sayısına** göre hesaplanır. 40 kişilik bir sunucuda oyuncuların %40–60'ı ikişer işletme işletirse fiziksel talep yaklaşık 32–48 olur. 70 yuvalık başlangıç kapasitesi bu aralığı taşma payıyla karşılar. Mobil işletmeler yuva tüketmez.

### 2.4 Yerleşim sırası

```
Sunucuya girdin
  → işletmelerin olay kutusuyla birlikte yüklendi
  → her fiziksel işletme için:
      1. Tercihli adres boş mu?               → oraya
      2. Aynı sınıfta boş yuva var mı?         → en yakınına + bildirim
      3. Komşu sınıfta eşdeğer yuva var mı?    → oraya; seviye kapasitesi korunur
      4. Pasaj birimi boş mu?                  → oraya
      5. Hiçbiri yoksa                         → "uzaktan hizmet": fiziksel görünüm yok,
                                                 kazanç hakkı tam, oyuncuya açıkça söylenir
```

Örnek bildirim:

> Ironhill No. 7 dolu. İşletmen bu sunucuda No. 11'de açıldı.

Oyuncu işletmesini "adres dolu" diye hiçbir zaman açamaz hâle gelmez ve kazancı bir kuyruğa bağlanmaz. Oyuncular işletmeleri **şirket rehberinden** bulur. Rehber işletmenin kimliğini sabit tutar ve o sunucudaki güncel adresi ile yol tarifini gösterir (ORTAK-049).

Bağlantısı kopan oyuncunun yuvası 5 dakika onun için ayrılır. Sonra havuza döner.

### 2.5 Sen oyunda değilken

- İşletmen başka hiçbir sunucuda "gerçekten" çalışmaz. Kazancın, giriş yaptığında formülle hesaplanır (§4.3).
- Senin yuvan havuza döner. Şehrin kepenkli görünmemesi için boş yuvalar **jenerik NPC dükkânlarıyla** dolar (K1).
- K5'te boş yuvalar çevrimdışı oyuncuların **salt okunur vitrin kopyalarını** da gösterebilir: tabela ve dekor görünür, ama vitrin ekonomiyi etkilemez (ORTAK-037).
- **Oyunda değilken işletmen soyulamaz** (ORTAK-038).

### 2.6 Uzun süre girmeyen oyuncu

30 gerçek gün girilmezse işletmeler **uykuya** geçer. Hiçbir veri silinmez; stok, seviye ve çalışanlar olduğu gibi kalır. Geri döndüğünde uyku bayrağı kalkar ve işletmelerin yeniden yerleşir.

"Oynamayı bıraktığı için her şeyini kaybetti" senaryosu bu oyunda yoktur.

## 3. İşletme kuralları

### 3.1 İşletme hakları

**Aynı türden en fazla 2 işletme.** İki market alabilirsin, üçüncüsünü alamazsın. Bu tekel engeli, çeşitliliği teşvik eder.

**Toplam işletme hakkı ruhsatla açılır:**

| Hak | Nasıl açılır |
|---|---|
| 1 | Başlangıç |
| 2 | Ticaret ruhsatı: ilk işletmeyi 2. seviyeye çıkar |
| 3 | Genişletilmiş ruhsat: 20 saat oyun ve temiz sicil |
| 4 | Kurumsal ruhsat: bir işletmeyi 5. seviyeye çıkar |

**Robux ile işletme hakkı satılmaz** (ORTAK-010). Ek hak paralel bir gelir kaynağı demektir, yani ekonomik güçtür.

### 3.2 Kira yok, ruhsat var

İşletmeyi satın alırsın ve senindir. Her **üretim gününün** (§4.1) sonunda küçük bir ruhsat payı otomatik kesilir. Ödenemezse işletme **askıya alınır**: kapanır, gelir üretmez, çalışanlar bekler. Borcu ödediğin an açılır. Askıya alınmış işletme hiçbir şey kaybetmez, sadece durur.

> **Karar gerekçesi:** Sürüm 1.0'da haftalık kira vardı ve ödenmezse dükkân gidiyordu. Bu, iki hafta sınav dönemi geçiren bir oyuncunun her şeyini silmek demekti. Sürüm 3.0'da aynı koruma maaşa ve bütün sürekli giderlere de uygulandı (§4).

### 3.3 Büyüme hattı

Her işletme beş seviyeli bir hat izler. Aşağıdaki örnek perakende içindir. Diğer ailelerin hattı aynı yapıdadır, ama içeriği ailenin kendi kararına göre değişir (`10-IS-VE-MESLEK-KATALOGU.md`).

| Seviye | Perakende örneği | Yuva | Yan etki |
|---|---|---|---|
| 1 | Küçük tezgâh, tek ürün grubu | Çarşı tezgâhı | Kasa küçük |
| 2 | Büyük tezgâh, ikinci ürün grubu | Çarşı tezgâhı | **Ticaret ruhsatı açılır** |
| 3 | Dükkân: iki kasa, stok alanı, ilk NPC yuvası, kamera (2 açı), alarm | Standart cephe | Kasa tavanı yükselir |
| 4 | Genişletilmiş dükkân, ikinci NPC yuvası | Standart cephe | Aklama kotası büyür |
| 5 | Mağaza: arka depo, 4 açı kamera | Büyük cephe | **Kurumsal ruhsat açılır** |

**Kritik denge.** Büyüdükçe daha çok kazanırsın. Nakit riskli sektörlerde daha çekici bir hedef de olursun, ama kaybın her zaman tavanlı ve sigortalıdır (`02-ENVANTER-VE-SUC.md` §10).

Seviye 5'e çıkmak, o işletmenin seviye 4'teki yaklaşık 25 saatlik net gelirine mal olur. Ekonominin ana emiş noktası budur.

### 3.4 Uzmanlaşma

Mahalle hizmeti, yüksek hacim veya uzman ürün gibi bedelli tercihler yayın sonrasına ertelendi (ORTAK-034).

## 4. Zaman ve devamsızlık

### 4.1 Birimler

Tek bir "ay" kelimesi üç farklı saati karıştırıyordu. Artık dört ayrı birim var (ORTAK-003):

| Birim | Süre | Ne için |
|---|---|---|
| **Oyun günü** | 48 gerçek dakika | Görsel gündüz–gece döngüsü, aklama kotası, NPC ritmi |
| **Üretim günü** | İşletmenin 48 dakikalık üretim süresi | Maaş ve ruhsat dönemi |
| **Gerçek gün** | 24 saat | Uyku (30 gerçek gün), güvenlik bekleme süreleri |
| **İnfaz süresi** | Gerçek dakika | Mahkeme cezası (`09` §9) |

Üretim günü takvimle değil, **işletmenin gerçekten çalıştığı süreyle** ilerler. İşletme dinlenirken, askıdayken veya dondurulmuşken saat durur.

### 4.2 Maaş günü

Her üretim gününün sonunda maaş günü gelir.

- **Oyundaysan:** Telefonuna bildirim gelir. Seçtiğin maaş yoluna göre öder ya da onaylarsın (§5.2).
- **Oyunda değilsen:** Maaş işletmenin tahsilatından otomatik ödenir; hangi maaş yolunu seçtiğin fark etmez. Tahsilat yetmezse işletme dinlenmeye geçer. Çalışan bekler, **karakter sonucu doğmaz**.

Çalışan karakteri yalnız **oyundayken** yaşanan ihmalden etkilenir: maaş günü geldiği hâlde bir oyun günü içinde ödememek gibi.

### 4.3 Çevrimdışı pencere

Çıkış yaptığın andan itibaren işletmelerin **8 saatlik bir pencerede** düşük verimle üretir (`03-EKONOMI.md` §6). Bu pencerede gelir ve gider birlikte işler. Pencere dolduğunda işletme **dinlenmeye** geçer: gelir de gider de durur. Hiçbir borç sınırsız birikmez.

### 4.4 Dondurma modu

Uzun bir ara vereceksen (sınav dönemi, tatil) telefonundan işletmeni dondurabilirsin. Dondurulan işletme üretmez, gider ödemez ve çalışanları sadakat kaybetmeden bekler.

Sınır: aktif bir suç dosyan veya denetimin varken dondurma açılmaz. Böylece dondurma, riskten kaçış aracına dönüşmez (YF-07).

## 5. NPC çalışanlar

Oyunun en özgün sistemlerinden biri bu. Rakiplerde benzerinin olmadığını düşünüyoruz; bu, rakip incelemesiyle doğrulanacak.

### 5.1 Tek çalışan modeli

Dükkân çalışanı, taksi şoförü, kurye: bütün NPC çalışanlar aynı modeli kullanır. Maaş, ruh hali, karakter ve verim tablosu herkes için aynıdır (ORTAK-008). Eski belgedeki "taksi şoförü kârın %75'ini verir" kuralı kaldırıldı.

### 5.2 Üç maaş yolu

| Yol | Maliyet | Oyundayken yükün |
|---|---|---|
| **Kendin ödersin** | Taban maaş | Her maaş gününde telefondan tek dokunuşla ödersin |
| **Kısmi yetkili NPC** | Taban × 1,25 | Her 5 üretim gününde bir onay |
| **Tam yetkili muhasebeci** | Taban × 1,5 + net kârın %5'i | Yok, tamamen otomatik |

Bu tablo oyunun dürüst "kolaylık satın alma" eksenidir ve tamamen oyun içi parayla işler.

### 5.3 Maaş atlanırsa: karakterler

Karakteri işe alırken göremezsin, ama ipucu toplayabilirsin (§5.4). Karakter sonuçları yalnız oyundayken yaşanan ihmalden doğar.

**Fırsatçı.** Maaşını kasadan kendisi alır ve çalışmaya devam eder. Bu çekim defterde **"açıklanmamış çekim"** satırı olarak görünür. Fark edip uyarırsan davranışını düzeltir; tekrar ederse onu çıkarabilirsin.

**Şerefli.** Tazminat talep eder. Talep karşılanmazsa otomatik bir iş uyuşmazlığı kararı çıkar (`09` §3): tazminat hesabından kesilir ve çalışan ayrılır.

**Sadık.** İlk kaçırılan maaşı idare eder. İkincisinde ayrılır ve seni bir daha işveren olarak kabul etmez.

### 5.4 İşe alım: ipucu ve deneme

- **Aday kartı:** Görünüm, deneyim ve beklenen maaş görünür; karakter görünmez.
- **Referans kontrolü:** Küçük bir ücret ve 2 dakikalık beklemeyle adayın karakteri hakkında **doğru bir ipucu** alırsın, örneğin "Önceki işvereni: 'Parası gecikince sesini çıkarmadı.'"
- **Deneme süresi:** İlk üretim günü boyunca çalışanı bedelsiz bırakabilirsin.

Böylece karakter bir şans oyunu olmaktan çıkar ve bir bilgi oyunu olur (Kural 1 ve Kural 7, ORTAK-016).

### 5.5 Ruh hali ve iz

Her NPC çalışanın üzerinde küçük bir gösterge bulunur: memnun, huzursuz veya kırgın. Gösterge sebebi söylemez. Sebep, telefonun **Çalışanlar** sekmesindeki çalışan notlarında sonradan okunur, örneğin "Son maaş bir oyun günü gecikti." Oyuncu sebebi kendisi keşfeder, ama keşfedebileceği bir iz her zaman vardır.

### 5.6 Verim

| Kim çalışıyor | Brüt katkı |
|---|---|
| Oyuncu bizzat | %100 |
| Memnun NPC | %35 |
| Huzursuz NPC | %20 |
| Kırgın NPC | %10 ve fırsatçıysa çekim riski |

Maaş ayrı bir giderdir. Başlangıç hedefi: memnun bir NPC'nin maaş sonrası net katkısı, sahibinin aktif net kazancının yaklaşık %25–30'u olsun. Otomasyon zenginleştirmez, serbest bırakır.

## 6. İş aileleri ve meslek hatları

Her hat aynı üç aşamayı izler: **kendin yap → devret → sistem kur.** İşletmeler altı aileye ayrılır: perakende, üretim, atölye, ulaşım ve lojistik, hizmet, proje. Her ailenin kendi kararları ve kendi risk profili vardır. Tam katalog ve ilk yayın adayları `10-IS-VE-MESLEK-KATALOGU.md`'de.

Örnek hatlar:

- **Ulaşım:** Kiralık araçla taksi sür → kendi taksin ve NPC şoför → filo (araç sayısı seviye hattına bağlı).
- **Perakende:** Tezgâh → dükkân → mağaza → ikinci şube.
- **Atölye:** Tamirhane tezgâhı → servis noktası → birden fazla usta.
- **Proje (müteahhitlik):** Hazır onaylı planlardan proje seç, keşif yap, ekip ve malzeme teslimini organize et, kalite kontrolünden geç. Serbest inşa aracı yoktur. Ana risk yanlış keşif, gecikme ve yeniden iş yapmaktır; malzeme hırsızlığı çekirdek döngü değildir (UK-02).
- **Kolluk:** Devriye ve vaka → uzmanlık (Trafik, Mali Şube, Olay Yeri) → kendi biriminin NPC memurlarını, ekipmanını ve bütçesini yönet.
- **Suç:** Küçük iş → aracı ağı → kendi aklama kanalın (`02-ENVANTER-VE-SUC.md`).

## 7. Polis ve kamu meslekleri neden beklemez

Sunucuda oyuncu polis olmasa da oyun durmaz. **NPC devriyeler her zaman vardır.** Seviye 1–2 olaylara tepki verirler; yavaştırlar ve kandırılabilirler. Oyuncu polis azaldıkça **şehir alarm seviyesi** NPC müdahale gücünü artırır (`02` §9.3).

Oyuncu polis girdiğinde NPC'lerin yerini almaz, **onları yönetir**. Birimi büyüdükçe daha çok NPC memur, daha iyi ekipman ve kendi karakolu olur. Polis de bir tycoon'dur.

Suç işlenmeyen saatlerde polis ve FCU **NPC vakalarıyla** çalışır: kurallı, çözülebilir, bazen suçsuzlukla sonuçlanan dosyalar (`02` §12.4). Sağlık ekipleri, itfaiye ve cezaevi görevlileri de NPC olaylarıyla işler (`10` §5).

## 8. Ev ve yaşam alanı

**Mimari karar (K1):** Ev, kapıdan girilen **örneklenmiş iç mekândır**. Dış cephe (apartman veya site girişi) herkese ortaktır. Kapıdan girdiğinde senin iç mekânın yüklenir ve bu her sunucuda aynıdır. Paralel sunucu sorunu evde bu şekilde hiç oluşmaz (ORTAK-042).

**Ev sistemi (K5):** İç mekân, mobilya yerleştirme, depolama ve ev kasası. Misafirler yalnız davetle girer. Ev kasası ilk sürümde güvenlidir; ev hırsızlığı ertelendi.

**Yayın sonrası:** Bahçe, mangal, komşuluk, misafir ağırlama, evde kişisel hatıralar.

Ev bir tycoon dalı değil, **duygusal çapadır**. Oyuncunun geri gelmek için parasal olmayan bir sebebi olur.

## 9. Oyun içi telefon

İşletme yönetiminin tamamı oyuncunun telefonundan yapılır.

Sekmeler: **Mesajlar**, **Banka**, **İşletmelerim**, **Çalışanlar**, **Araçlarım**, **Ev**, **Rehber**, **Dosyalarım**.

Telefon envanterde 1 birim yer kaplar. Telefonu olmayan oyuncu işletmesini **uzaktan** yönetemez; bu telefonun tek bedelidir. **Ayarlar, yardım, kurallar ve raporlama telefonda değildir.** Bunlar her zaman ayrı menüden erişilir (ORTAK-021).

## 10. İlerleme

Seviye yok. Üç bağımsız hat var.

**Ruhsatlar.** Sürücü sınıfları, ticaret ruhsatları, silah ruhsatı. Her biri kısa bir sınav göreviyle alınır. Silah ruhsatı pahalıdır ve temiz sicil ister (`02` §7.1).

**Meslek kıdemi.** Her hatta ayrıdır. Polis rütbesi ile market kıdemi birbirinden bağımsızdır.

**İtibar.** İki kutupludur: **yasal itibar** ve **sokak itibarı**. Yasal itibar iyi krediler, ucuz ruhsat ve NPC saygısı açar. Sokak itibarı daha iyi aracılar ve daha büyük işler açar. Biri artarken diğeri yavaşça düşer.

İtibarın görünür bir karşılığı vardır: NPC'ler sana davranışlarını değiştirir. Yüksek yasal itibarlı oyuncunun çantası NPC polis tarafından daha az sorulur. Yüksek sokak itibarlı oyuncuya NPC esnaf farklı fiyat verir.

## 11. Geri dönüş: çekiciler ve baskılar

Geri dönüşün ağırlığı **çekicilerde** olmalıdır, kayıp korkusunda değil (ORTAK-027).

**Çekiciler:**
- **Dönüş özeti.** Girişte tek ekran: çevrimdışı kazanç, çalışanlarındaki değişim, dosyaların, yeni hedeflerin (`06` §4.8).
- **Karar anları.** Terfi isteyen çalışan, gelen bir sözleşme teklifi, açılabilecek bir şube.
- **Görünür hedefler.** "Dükkâna 3.200 ₡ kaldı."
- **Mahalle sıralamaları** ve haftalık şehir etkinlikleri (K5+).
- **Kişisel şehir hafızası** (yayın sonrası): ilk müşterin, ilk çalışanın, ilk şuben.

**Baskılar:** Yalnız sen oyundayken işler. Maaş günü, dolan kasa, huzursuzlanan çalışan. Oyunda değilken hiçbiri birikmez (§4).

## 12. 100 saatlik oyuncu

Bu profil oyunun tavanını tarif eder; denge buradan geri hesaplanır.

100 saat oynamış bir oyuncu milyarder değildir. Şunlara sahiptir:

- Farklı ailelerden iki veya üç işletme, en az biri 4–5. seviyede
- Düzenlenmiş, mobilyalı bir ev
- İki veya üç araç
- Karakterlerini tanıdığı dört-beş NPC çalışan
- Temiz sicil ya da kapanmış birkaç dosya
- Belki ruhsatlı, pahalı bir silah

Neden geri gelir? Çünkü açılacak bir şube, büyütülecek bir ekip, kazanılacak bir sıralama ve bitirilecek bir sözleşme vardır. Kaybetmekten korktuğu için değil.

## 13. Katmanlar

Katman planının tek kaynağı `07-YOL-HARITASI.md`. Kısa özet:

K0 mikro prototip · K1 kalıcılık ve yerleşim · K2 sivil çeşitlilik · K3 envanter ve sınırlı suç · K4 adalet · K5 geniş kapalı test · K6 ilk yayın · yayın sonrası.

**Kapsam dışı:** Havalimanı ve uçaklar, serbest inşa araçları, çok katlı iç mekânlı gökdelenler, bar ve alkol.

## 14. Karar günlüğü

| Karar | Gerekçe | Kimlik |
|---|---|---|
| Suç omurga değil, seçenek | Polissiz sunucuda oyun ölüyordu | v2 |
| İşletme kaydının tek yazarı var | Paralel sunucularda çift gelir ve veri çakışması | ORTAK-001 |
| Yuva sınıfları ve çevrimiçi işletmeye göre kapasite | 14 cephe başarı senaryosunda yetmiyordu | ORTAK-002 |
| Çevrimdışı işletme soyulamaz | Oyunda olmayana zarar verilmez; veri basitliği | ORTAK-038 |
| İlk oturum tezgâh sahipliğiyle biter | Ürünün değeri erken anlaşılsın | ORTAK-026 |
| Dört zaman birimi, üretim gününe bağlı gider | 30 oyun günü = 24 gerçek saat; sınav dönemi sorunu | ORTAK-003 |
| 30 gün sonra uyku, silme yok | Birikimi silen tycoon hayatta kalmaz | v2 |
| Kira yok, üretim gününe bağlı ruhsat | Ceza likiditeye vurmalı, varlığa değil | v2 + ORTAK-003 |
| Robux ile işletme hakkı yok | Ek hak ekonomik güçtür | ORTAK-010 |
| Tek çalışan modeli | Taksi %75 otomasyon yasasını deliyordu | ORTAK-008 |
| Karakter ipucu ve deneme süresi | Gizli rastgelelik değil, bilgi oyunu | ORTAK-016 |
| Ev örneklenmiş iç mekândır | Paralel sunucu sorunu evde hiç oluşmaz | ORTAK-042 |
| Ayarlar telefondan bağımsız | Erişilebilirlik envantere bağlanmaz | ORTAK-021 |
| Polis de tycoon | Bekleme odası problemini kökten çözer | v2 |
