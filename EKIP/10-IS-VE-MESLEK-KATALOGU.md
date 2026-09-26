# BAYCREST — İş ve Meslek Kataloğu

**Sürüm:** 3.0 · 24 Eylül 2026 · **Yeni belge**
**Durum:** Ürün vizyonu ve aday kapsam; katalogdaki her dal için yayın taahhüdü yoktur.
**Okuyucu:** Tasarımcı ve yönetici
**Ön koşul:** `00`, `01`
**Bağlı kararlar:** UK-02, UK-11 · ORTAK-025, 033, 034, 040, 041, 051

---

## 1. Amaç ve uyarı

UK-11 geniş bir işletme seçeneği istiyor. Bu belge o vizyonu tanımlar.

> **Uyarı:** Bu katalog aynı anda üretilecek 24 bağımsız sistem değildir. **Bir ürün vizyonudur.** Her dal oynanabilir karar bakımından ayrışır, ama altı ortak iş ailesinin altyapısını paylaşır. İlk yayına hangi dalların gireceği, K0'da ölçülen gerçek üretim hızına göre belirlenir (UK-09, AÇIK-07).

Bir dalın katalogda olması, yayına gireceği sözü değildir.

## 2. Altı iş ailesi

Çeşitliliği üretilebilir kılan şey ortak altyapıdır. Her aile kendi çekirdek kararını taşır; hepsi aynı kasa mini oyununa indirilmez.

| Aile | Çekirdek kararı | Ortak bileşenler | Başlangıç marjı | Nakit riski |
|---|---|---|---|---|
| **Perakende** | Ne satacağım, ne kadar stoklayacağım | Stok, raf, kasa, müşteri sırası | %40 | Var |
| **Üretim** | Ne kadar üreteceğim, ne zaman | Tarif, parti, süre, bozulma | %45 | Perakende satış varsa |
| **Atölye** | Neyin arızası ne, hangi parça | Teşhis, parça, iş sırası, kalite | %50 | Yok |
| **Ulaşım ve lojistik** | Hangi rota, hangi sıra | Rota, araç, yakıt, teslim süresi | %35 | Yok |
| **Hizmet** | Hangi randevu, hangi kapasite | Randevu, ekip, memnuniyet | %55 | Yok |
| **Proje** | Keşif doğru mu, ekip yeter mi | Plan, keşif, ekip, aşama, teslim | %50 | Yok |

Her ailenin beş seviyeli bir büyüme hattı vardır (`01` §3.3). Yapı aynı, içerik farklıdır.

## 3. İşletme kataloğu

| Kod | İşletme | Aile | Oyuncunun anlamlı kararı | Büyüme yönü | Başlıca risk | Katman |
|---|---|---|---|---|---|---|
| IS-01 | Bakkal / market | Perakende | Ürün karması, raf ve sipariş zamanı | Şube, lojistik | Stok, sınırlı kasa | **K0** |
| IS-02 | Fırın / pastane | Üretim | Parti miktarı ve teslim sırası | Üretim hattı, kurumsal sipariş | İsraf, zamanlama | K5 |
| IS-03 | Kafe / küçük restoran | Hizmet + üretim | Menü, servis akışı, masa planı | Paket servis, ikinci şube | Servis süresi, memnuniyet | Y.S. |
| IS-04 | Manav / balık pazarı | Perakende | Tazelik ve tedarik dengesi | Özel ürün, toptan | Bozulma; görünür ve sınırlı | Y.S. |
| IS-05 | Terzi / giyim mağazası | Atölye + perakende | Hazır tasarım, sipariş uyumu | Koleksiyon, ekip | Sipariş ve kalite uyuşmazlığı | Y.S. |
| IS-06 | Mobilya / ev dekorasyonu | Perakende + proje | Oda ihtiyacına uygun paket | Sergi, teslimat | Yanlış ölçü, teslim | Y.S. |
| IS-07 | Elektronik bakım dükkânı | Atölye | Arıza teşhisi, parça seçimi | Uzman tezgâh, teknisyen | Yanlış teşhis, yeniden iş | Y.S. |
| IS-08 | Araç tamirhanesi | Atölye | Teşhis, onarım, iş sırası | Çok servis noktası | Süre ve kalite | **K2** |
| IS-09 | Oto bakım / detaylı temizlik | Hizmet | Bakım paketi, randevu | Filo anlaşmaları | Kapasite, memnuniyet | Y.S. |
| IS-10 | Galeri / araç aracılığı | Perakende | Talebe uygun araç, stok maliyeti | Showroom, satış ekibi | Sermayenin stokta beklemesi | K5 |
| IS-11 | Taksi işletmesi | Ulaşım | Rota, vardiya, araç dağılımı | Şoförlü filo | Yakıt, bakım, hizmet süresi | **K1** |
| IS-12 | Minibüs / servis | Ulaşım | Hat ve sefer planı | Yeni hat ve araç | Talep, gecikme, kapasite | K5 |
| IS-13 | Kurye / kargo | Lojistik | Rota ve iş birleştirme | Depo, dağıtım ekibi | Geç veya yanlış teslim | **K2** |
| IS-14 | Depo / dağıtım merkezi | Lojistik | Yerleşim, sevkiyat sırası | Daha çok müşteri ve bölge | Kapasite, iş akışı | Y.S. |
| IS-15 | Toptancı / tedarik | Lojistik + perakende | Talep tahmini, alım planı | İşletmeler arası anlaşmalar | Fazla veya eksik stok | K5 |
| IS-16 | Müteahhitlik | Proje | Keşif, onaylı plan, ekip, teslim | Daha büyük projeler | Gecikme, kalite, yeniden iş | K5 |
| IS-17 | İç mimari / tadilat | Proje | Onaylı parçalardan oda planı | Tasarım ekibi, portföy | Bütçe, müşteri hedefi | Y.S. |
| IS-18 | Tesis bakım / temizlik | Hizmet | İş listesi, ekip rotası | Sürekli bakım sözleşmesi | Kalite, kapasite | Y.S. |
| IS-19 | Peyzaj / bahçe bakımı | Proje + hizmet | Hazır bitki planı, bakım | Site ve kurum sözleşmeleri | Bakım takvimi | Y.S. |
| IS-20 | Tabela / baskı atölyesi | Atölye | Onaylı şablon ve teslim | Kurumsal sipariş | Hatalı tasarım, gecikme | Y.S. |
| IS-21 | Etkinlik organizasyonu | Proje + hizmet | Hazır etkinlik paketi, kaynak planı | Şehir etkinlikleri | Koordinasyon | Y.S. |
| IS-22 | Fotoğraf / şehir turu | Hizmet + ulaşım | Rota, çekim hedefi, grup akışı | Tur ekibi | Hizmet süresi | Y.S. |
| IS-23 | Emlak danışmanlığı | Hizmet | İhtiyaca uygun mevcut mülkü eşleştirme | Danışman ekibi | Yanlış eşleştirme | Y.S. |
| IS-24 | Güvenlik kurulum işletmesi | Atölye + hizmet | Kamera ve alarm kapsamı, bakım | Kurumsal bakım ağı | Yanlış kurulum, kör nokta | Y.S. |

**Y.S.** = yayın sonrası adayı.

**Özel sınırlar:**

- **IS-10:** İlk sürümde araçlar NPC'ye standart fiyat aralığında satılır. Serbest oyuncular arası araç piyasası ertelenir; fiyat manipülasyonu ve dolandırıcılık riski yüksektir.
- **IS-20:** Tabela atölyesi serbest metin üretmez. Onaylı şablonlar ve sınırlı kelime havuzu kullanılır (`06` §7.2).
- **IS-23:** Emlak danışmanı oyuncuya fiziksel yuva tekeli satamaz. Yalnız mevcut ve boş mülkleri eşleştirir.
- **IS-24:** Güvenlik işletmesi müşterisinin kamerasını izleme yetkisi kazanmaz. Yalnız kurar ve bakımını yapar.
- **Silah satışı hiçbir oyuncu işletmesinde yoktur.** Ruhsatlı silah yalnız NPC satış noktasından alınır (`02` §7.1).

## 4. Risk profilleri (UK-02)

Her aile farklı bir risk taşır. Bu, "her meslek aynı soyulma riski altında değildir" kararının uygulanmasıdır.

| Aile | Operasyonel | Ticari | Hukuki | Suç kaynaklı |
|---|---|---|---|---|
| Perakende | Stok tükenmesi | Yanlış ürün karması | Aklama denetimi | **Sınırlı, sigortalı kasa** |
| Üretim | İsraf, yanlış zamanlama | Talep düşüşü | Kalite şikâyeti | Perakende satış varsa sınırlı kasa |
| Atölye | Yanlış teşhis, yeniden iş | Boş kapasite | Kalite uyuşmazlığı | **Yok** |
| Ulaşım ve lojistik | Yakıt, bakım, gecikme | Boş sefer | Trafik ihlali | **Yalnız bilinçli riskli sözleşmede** |
| Hizmet | Randevu çakışması | Düşük memnuniyet | Sözleşme ihlali | **Yok** |
| Proje | Yanlış keşif, gecikme | Kaçırılan hedef | Teslim uyuşmazlığı | **Yok** |

**Riskli taşıma sözleşmesi:** Ulaşım ve lojistik işletmeleri, normalden yüksek ücretli ama içeriği belirsiz bir taşıma sözleşmesini **bilinçli olarak** kabul edebilir. Koşullar kabul ekranında açıkça yazar. Yasal taşıma varsayılan olarak bir suç görevi değildir.

**Tekrarlanan mağduriyet koruması:** Aynı işletmeye 30 dakikada bir defadan fazla baskın yapılamaz. Kayıp tavanlıdır. Yeni işletmenin 2 saatlik koruması vardır. Koruma, suç işleyip anında güvenli moda geçme açığı yaratmaz: aktif suç dosyası olan oyuncu dondurma moduna geçemez.

## 5. Ticari işletme olmayan meslekler

| Kod | Meslek | Ne yapar | Sınırı | Katman |
|---|---|---|---|---|
| MS-01 | BMP devriye ve trafik | Doğrulanmış ihlal, yönlendirme, güvenli müdahale, NPC vakaları | Ceza veremez, süre belirleyemez | K3 |
| MS-02 | FCU | İşlem kayıtları, defter bulmacası, mali dosyalar | Dayanaksız denetim açamaz; kendi bağlantılı dosyalarına bakamaz | K3 |
| MS-03 | **Sağlık ve ambulans** | Doğrulanmış olaya gitme, ilk yardım, hastaneye taşıma | Ödül yalnız doğrulanmış olayda ve kurban başına sınırlı | K3 |
| MS-04 | Cezaevi görevlisi | Görev listesi, kaçış olayları, kabul ve tahliye işlemleri | Ceza süresini uzatamaz | K4 |
| MS-05 | İtfaiye | NPC yangın olayları, ekipman kontrolü, kurtarma | Başka oyuncunun işletmesini kalıcı yok eden yangın yok | K5 |
| MS-06 | Avukatlık | Delil düzenleme, savunma | Ücretsiz NPC temsilin yerine zorunlu ücret kapısı olamaz | Y.S. |

**Sağlık mesleği UK-14'ün doğrudan sonucudur.** Ölüm yerine yaralanma olduğu için sağlık ekibi gerçek ve sürekli bir işe sahiptir: bir oyuncuyu yaralı durumdan kaldırmak, onun hastaneye gitmesini engeller. Bu, polis–suçlu ekseninin dışındaki en değerli kamu rolüdür.

**Oyuncu hâkimliği yoktur** (ORTAK-039). Mahkeme kurallı bir NPC sistemidir; hâkim rolünün olmaması mahkemeyi eksik yapmaz.

## 6. İşletmeler arası bağ

Katalogdaki dalların birbirine ihtiyacı olmalıdır; yoksa çeşitlilik yalnızca tabela değişimi olur.

**K2'de tek örnek:** **Stok teslimi.** Perakende işletmesinin stoğu Oldport deposundan gelir. Teslimi bir oyuncu kurye veya kamyonet sahibi yapabilir. Yapmazsa NPC yapar, ama daha yavaş ve daha pahalıdır (ORTAK-033).

Sözleşme kuralları:

- Ücret baştan ayrılır ve teslimde sunucuda doğrulanır.
- Oyuncu yoksa her zaman bir NPC alternatifi vardır. Hiçbir işletme başka bir oyuncunun oyunda olmasına bağımlı kalmaz.
- Ödül üretimi anlaşmalı işlemlere karşı korunur: taraflar arkadaşsa veya son 7 günde transfer yaptıysa ödül düşer.

**K5 ve yayın sonrası:** Bakım, dekorasyon, kurumsal tedarik ve etkinlik sözleşmeleri.

## 7. İlk yayın kapsamı

**Hedef: 6–8 iş kolu. Alt sınır: 3.** Kesin liste K0 sonrasında belirlenir (AÇIK-07).

Önerilen çekirdek (her biri farklı bir aileyi temsil eder):

| Sıra | Dal | Aile | Neden |
|---|---|---|---|
| 1 | IS-01 Market | Perakende | Çekirdek döngü; K0'ın kendisi |
| 2 | IS-11 Taksi | Ulaşım | İlk 10 dakika ve ilk devretme |
| 3 | IS-08 Tamirhane | Atölye | Perakendeye en zıt karar yapısı; nakit riski yok |
| 4 | IS-13 Kurye | Lojistik | Stok teslimini oyunculaştırır |
| 5 | IS-02 Fırın | Üretim | Zamanlama kararı; perakendeye bağlanır |
| 6 | IS-10 Galeri | Perakende | Araç ekonomisine bağlanır |
| 7 | IS-16 Müteahhitlik | Proje | En farklı döngü; UK-02'nin örneği |
| 8 | IS-12 Minibüs | Ulaşım | Şehir içi dolaşımı canlandırır |

İlk üçü alt sınırdır. Bir dal yetişmiyorsa listeden çıkarılır, yarım bırakılmaz.

## 8. Yeni dal ekleme kuralı

Yeni bir işletme veya meslek eklenmeden önce dört soru cevaplanır:

1. **Hangi aileye ait?** Yeni bir aile gerekiyorsa muhtemelen kapsam dışıdır.
2. **Çekirdek kararı ne?** Cevap "tıkla ve para kazan" ise dal yoktur.
3. **Hangi risk türünü taşıyor?** §4'teki dört türden biri olmalıdır.
4. **Düşük nüfusta ne oluyor?** Sunucuda kimse yoksa bu dal çalışıyor mu?

Cevaplar yazılmadan dal eklenmez. Dalın kodu ve kararı `KARARLAR.md`'ye işlenir.

## 9. Ertelenen fikirler

| Kimlik | Fikir | Neden ertelendi |
|---|---|---|
| ORTAK-034 | İşletme uzmanlaşması (mahalle hizmeti, yüksek hacim, uzman ürün) | Önce temel hattın tatmin ettiği doğrulanmalı |
| ORTAK-040 | Gizleme ekipmanını oyuncu dükkânlarının satması | Fiyat manipülasyonu; önce temel ekonomi oturmalı |
| ORTAK-041 | Oyuncunun oyuncuyu işe alması | İkinci hesapla maaş istismarı riski |
| ORTAK-051 / YF-02 | Kısa iş ortaklığı, sınırlı yetki devri | Yetki sınırları ve iptal davranışı karmaşık |
| ORTAK-051 / YF-03 | Tedarikçi teklifleri (fiyat, süre, güvenilirlik) | Önce NPC teklifleriyle başlanacak |
| ORTAK-051 / YF-04 | Görünür kalite kontrolü | Tekrarlayan tıklama mini oyununa dönüşme riski |
| ORTAK-051 / YF-05 | Mahalle talep olayları ve festivaller | Tekrar istismarı; sınırlı ödül tasarımı gerekir |
| — | Kişisel şehir hafızası (ilk müşteri, ilk çalışan) | Metin, çeviri ve kalıcı kayıt maliyeti |

Bunlar elenmedi. Yayın sonrası içerik havuzudur ve `KARARLAR.md` §5'te izlenir.
