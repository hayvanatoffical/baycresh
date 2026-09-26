# BAYCREST v3 — Tam Zayıflık, Eğlence ve Uygulama Sırası İncelemesi

**Tarih:** 24 Eylül 2026  
**Kaynak:** BAYCREST-v3.zip içindeki 18 Markdown dosyasının tamamı.  
**Durum:** Tasarım incelemesi ve sonraki belge düzenlemesi için çalışma emri. Oyun kodu, gerçek oyuncu testi ve performans ölçümü incelenmedi; ZIP'te bunlar bulunmuyor.

## 0. Bu dosyanın amacı ve nasıl kullanılacağı

Bu dosya bir yıkım listesi değildir. Baycrest'in geniş vizyonunu koruyup oyuncuya erken ve güçlü bir deneyim sunmak için **neyin yanlış, zayıf, eksik, erken veya yanlış sırada olduğunu** gösterir. Sonraki düzenleyici her bulguyu kaynak belgelerde somut bir değişikliğe çevirmeli; yalnızca bu dosyayı başka kelimelerle özetlememelidir.

**Karar hiyerarşisi:** KARARLAR.md içindeki UK kullanıcı kararları korunur. Aşağıdaki değişiklikler öneridir; UK olarak yeniden etiketlenmez. UK ile uygulama arasında gerçek bir çatışma varsa kullanıcı kararını gizlice değiştirmek yerine çatışma açıkça yazılır. Sayılar başlangıç hipotezidir; test edilmeden vaat veya garantiye dönüştürülmez. Arşiv raporu tarihsel kayıttır, yeni sürümün normatif belgesi değildir.

**Bulgu türleri:** **Çelişki** aynı pakette uyuşmayan hükümler; **hesap/teknik** uygulanınca hata doğurabilecek tanım; **oyun tasarımı** gözlenmeden kesin hüküm verilemeyen ama güçlü gerekçeli risk; **ölçüm** oyun testinde cevaplanacak soru; **dış doğrulama** platform veya piyasa bilgisi.

**Öncelik:** **P0** ilgili katmana girmeden çöz; **P1** kapalı testten önce çöz; **P2** genişleme/yayın için çöz; **P3** yayın sonrası aday. Bir madde farklı aşamalarda kısmen çözülebilir.

**Belge kısaltmaları:** 00–10, EKIP klasöründeki numaralı belgeler; A1–A3, OZEL klasöründeki belgeler. KARARLAR, kök karar dosyasıdır. Bölüm numaraları mevcut v3 sürümünü gösterir; düzenlemeden sonra başlıkla da aranmalıdır.

### Korunacak temel kararlar

1. Sahiplen → büyüt → devret → yeni bir şey sahiplen ana döngüsü.
2. Suç isteğe bağlıdır; her iş kolunun ana riski soygun değildir.
3. Kimse ölmez; silah pahalı, hasar düşük, hastane vardır.
4. Verania Anayasası, mahkeme, delile dayalı karar, çevrimdışı süren dava, kısa ceza ve birden fazla çıkış yolu vardır.
5. Kaçış rapor bırakır; meşru ev, araç ve işletme normal ceza yüzünden silinmez.
6. Geniş iş kataloğu vizyon olarak kalır; katalogdaki bir satır otomatik yayın taahhüdü değildir.
7. Roblox parasına yargı veya ekonomik güç satılmaz.

## 1. Yönetici kararı: şimdi ne yapılmalı?

**Öneri:** Projeyi tek bir dev şehir oyunu olarak başlatmayın. Önce iki ayrı oynanabilir hipotezi sınayın: **(A) küçük bir işletmeye sahip olup karar vererek büyütmek** ve **(B) görünür eşya, polis gerekçesi ve tanığın yarattığı bilgi gerilimi**. A tutmuyorsa suç onu kurtarmaz; B tutmuyorsa pahalı adalet mimarisi farklılaşma yaratmaz. İkisi de tutarsa sistemler ortak bir şehirde birleştirilir.

İlk test için görsel kalite, 24 iş kolu, 70 fiziksel yuva ve mahkeme binası gerekmez. İlk testte oyuncunun **isteyerek tekrar ettiği davranış** gerekir. Sonraki katmana geçiş, yalnız ekip içinde “güzel olmuş” denmesine değil gözlenen davranışa bağlanır.

### Önerilen teslim sırası

| Sıra | Oynanabilir teslim | Öğrenilecek soru | Bu aşamada bulunmayan şey |
|---|---|---|---|
| 0A | Gri kutu çarşı, küçük tezgâh, talep/tedarik kararı, satış, görünür yükseltme | İlk 5 ve 20 dakikada sahiplik ve karar tatmin ediyor mu? | Polis, suç, silah, büyük harita |
| 0B | Ayrı gri kutu: iki oyuncu, bir NPC, çanta gösterme/reddetme, gözlem ve gerekçe | Taraflar gerçekten rol yapıp tekrar denemek istiyor mu? | Kalıcı para ve tam mahkeme |
| 1 | Veri güvenliği, tek işletme kaydı, küçük fiziksel yuva havuzu, çalışan veya taksiyle ilk devir | Oyuncu ertesi gün dönüyor ve kaydı güvenle duruyor mu? | 70 yuva, beş tam seviye, bütün meslekler |
| 2 | Kararları farklı ikinci iş ailesi ve tek NPC alternatifli tedarik işi | İki rol gerçekten farklı oynanıyor ve birbirine ihtiyaç duyuyor mu? | 24 iş kolunun üretimi |
| 3A | Beden envanteri, çanta, polis gerekçesi, taciz engelleri | İmza anı anlaşılır ve masum oyuncu güvenli mi? | Silah/aklama/FCU'yu aynı teslimde bitirme şartı |
| 3B | Tek NPC soygun hedefi, tanık, yaralı ve sağlık akışı, temel para ayrımı | Gerilim ve sonuçlar eğlenceli, adil ve kısa mı? | Çoklu soygun hedefi |
| 3C | Tek mali vaka ve defter bulmacası | Mali soruşturma gerçekten karar üretiyor mu? | Büyük ekonomik ağ |
| 4 | Çok küçük suç kataloğu ile delil, karar, savunma, infaz ve tek kaçış rotası | Karar anlaşılır, ceza ve kaçış oynanır mı? | Sekiz suçun tamamını ve üç tahliye görevini aynı gün teslim etme |
| 5–6 | Veriye göre seçilen iş kolları, performans, moderasyon, pazarlama ve ilk yayın | Başka oyuncular da tekrar geliyor mu; oyun sürdürülebiliyor mu? | Katalogdaki her fikrin yayına alınması |

Bu sıra **nihai süre veya değişmiş UK kararı değildir**. Her katman tamamlandığında gerçek üretim hızıyla yeniden planlanır. Mahkeme ve hapishane harita planında baştan yer alır; oynanabilir sistemin yapımı önceki testlerin sonucuna bağlanır.

### 1.1 Özelliklerin önerilen bağımlılık sırası

**K0A:** Tek pazar tezgâhı, görünür talep, stok/servis kararı, ilk sahiplik, bir yükseltme, bir çalışan önizlemesi, mobil arayüz. **K0B:** Aynı oyuna entegre edilmesi gerekmeyen ayrı çanta–polis–tanık etkileşim deneyi. İkisi oynanabilir bulunmadan sonraki büyük sistemler zorunlu üretim listesine alınmaz.

**K1:** Kritik veri kaydı ve işlem kimliği → tek işletme yazarı → erişilebilir gerçek tezgâh yuvaları → basit rehber → ilk çalışan ve otomasyon → taksi → çevrimdışı hesap ve dönüş özeti. Ev için yalnız veri sözleşmesi; dekorlu ev sistemi daha sonra.

**K2:** Kararları marketten farklı tamirhane → erişilebilir küçük depo → tek stok teslim sözleşmesi ve kurye → üç mesleğin ekonomik karşılaştırması. **K3A:** Envanter ve görünürlük → üç polis etkileşimi → masumiyet/taciz testi. **K3B:** Tek NPC hedefi → tanık ve maskenin bedeli → düşük hasarlı müdahale → yaralı/hastane/sağlık → geçici sonuç kartı. **K3C:** Kirli para ve tek gerçek aklama kararı → denetim kaydı → bir FCU bulmacası. K3 alt kısımlarının tek teslim olarak açılması şart değildir.

**K4:** Olay/kimlik kanıtı → savunma ve çevrimdışı temsil → gerekçeli karar ve düzeltme → kısa infaz → bir kaçış ve raporu. V3'teki sekiz suç normatif katalogda tutulabilir; ilk oynanabilir adalet testinde az sayıda tam uygulanmış suç yeterlidir. **K5:** oyuncu testiyle seçilen yeni iş dalları, ev, Oldport'un tam görünümü, ek NPC hedefleri, araç ve performans. **K6:** bağımsız kullanıcı testi, moderasyon, platform şartları, lokalizasyon, geri alma prosedürü, pazarlama ve yayın.

### 1.2 Katalogdaki bütün işletmeler için ilk önerilen yer

Bu tablo **işi silme veya yayın sözü değildir**. “Aday” dalın ilk oynanabilir testten sonra üretime alınabileceği anlamındadır. Her dal, OYN-05 ve SIRA-07'deki oynanış sözleşmesi ile kabul kapısından geçer.

| Kod | İşletme | İlk aday aşama | Ön koşul / öncelik gerekçesi |
|---|---|---|---|
| IS-01 | Bakkal / market | K0A | Sahiplik döngüsünü kanıtlar. |
| IS-02 | Fırın / pastane | K5 adayı | Talep, stok, parti üretimi ve teslim çalışınca. |
| IS-03 | Kafe / restoran | Yayın sonrası | Üretim, servis ve randevu akışı birlikte gerekir. |
| IS-04 | Manav / balık pazarı | Yayın sonrası | Perakendeden ayrışan tazelik/bozulma kararı kanıtlanınca. |
| IS-05 | Terzi / giyim | Yayın sonrası | Atölye ile giyim kataloğu birlikte olgunlaşınca. |
| IS-06 | Mobilya / dekor | Yayın sonrası | Ev ve teslimat sistemi tamamlanınca. |
| IS-07 | Elektronik bakım | Yayın sonrası | Tamirhanenin teşhis altyapısı gerçek çeşitlilik yaratınca. |
| IS-08 | Araç tamirhanesi | K2 | Markete karşıt, teşhis ve yeniden iş döngüsü. |
| IS-09 | Oto bakım | Yayın sonrası | Tamirhaneye yeni karar katıyorsa; yalnız tema değişimiyse eklenmez. |
| IS-10 | Galeri | K5 adayı | Araç ekonomisi ve stok sermayesi çalışınca. |
| IS-11 | Taksi | K1 | İlk araç devri ve mobil meslek. |
| IS-12 | Minibüs / servis | K5 adayı | Taksi rotasından farklı kapasite ve sefer kararı varsa. |
| IS-13 | Kurye / kargo | K2 | Tek stok tesliminin oyuncu yüzü; depo erişilebilir olmalı. |
| IS-14 | Depo / dağıtım | Yayın sonrası | Tek teslimden sonra yeterli farklı müşteri ve sevkiyat olunca. |
| IS-15 | Toptancı / tedarik | K5 adayı | Birden çok işletme gerçek tedarik kararı yaratınca. |
| IS-16 | Müteahhitlik | K5 deney adayı | Ayrı gri kutuda keşif, ekip, kalite ve gecikme eğlenceli bulununca; soygun ana risk olmaz. |
| IS-17 | İç mimari / tadilat | Yayın sonrası | Ev sistemi ve onaylı proje parçaları oluşunca. |
| IS-18 | Tesis bakım / temizlik | Yayın sonrası | Kurumsal sözleşmeler anlamlı iş listesi üretince. |
| IS-19 | Peyzaj | Yayın sonrası | Ev/bahçe ve bakım takvimi birlikte olunca. |
| IS-20 | Tabela / baskı | Yayın sonrası | Onaylı şablonlar ve teslimat iş ailesinden farklı karar sununca. |
| IS-21 | Etkinlik organizasyonu | Yayın sonrası | Mahalle talebi ve sözleşme altyapısı hazır olunca. |
| IS-22 | Fotoğraf / şehir turu | Yayın sonrası | Harita keşfi ve grup akışı kendi başına eğlenceli olunca. |
| IS-23 | Emlak danışmanlığı | Yayın sonrası | Ev ve işletme arzı artınca; fiziksel yuva tekeli yaratmadan. |
| IS-24 | Güvenlik kurulum | Yayın sonrası | Kamera/alarm tasarımı karar üretiyorsa; müşteri görüntüsü yetkisi verilmeden. |

**Kamu meslekleri:** BMP devriye **K3A**, sağlık/ambulans **K3B**, FCU **K3C**, cezaevi görevlisi **K4**, itfaiye **K5 veya sonrası** (önce yangın/denetim olayı oynanmalı), avukatlık **yayın sonrası** (NPC temsil ücretsiz kalır). Her aşamada oyuncu rolü yoksa NPC hizmeti boşluğu doldurur; NPC gerçek mesleği anlamsız kılacak kadar güçlü olmamalı.

**Ertelenmiş bağlar:** Ev hırsızlığı, araç hırsızlığı, oyuncu istihdamı, daha geniş kaçışlar, tam şehir sözleşmeleri, sahte defter ve kişisel şehir hafızasının büyük sürümü kendi ön koşulu doğrulanmadan canlı ekonomi içine alınmaz. Bu fikirler KARARLAR.md'de tarihsel statüsüyle izlenir.

## 2. Oyuncunun içine gireceği deneyim: ana tasarım açıkları

### OYN-01 — İlk sahiplik çok geç, K0 testi kendi hedefini ölçemiyor — P0 · Çelişki

**Mevcut:** 01 §1 ilk tezgâhı 30–45 dakikaya koyuyor; 03 §5 tezgâh fiyatı 1.500 ₡. Kiralık taksinin 30 ₡/dk geliriyle bu fiyat 50 dakika sürer; kasiyerlik performansı süreyi değiştirebilir ama başlangıç kaynakları net değil. 07 §2 ise K0'da her kişiye 20 dakikalık test yaptırıyor. Böyle bir test, belirtilen tezgâh sahipliği anına hiç ulaşmadan bitebilir.

**Oyuncuya etkisi:** Tanıtılan sahiplik oyunu yerine önce uzun bir para biriktirme oyunu oynar. İlk terk oranı artabilir; K0 kapısı yanlış şeyi ölçer.

**Düzeltme:** İlk oturumda tezgâhı **ilk 5 dakika civarında denenecek bir hedef** yapın: başlangıçta küçük bir yuva, düşük giriş maliyeti veya kısa bir sahiplik görevi. İlk 15–20 dakikada iki karar, görünür bir yükseltme ve çalışanı işe alma önizlemesi olsun. Bu dakikalar test hipotezidir, doğrulanmış oyuncu tercihi değildir. K0 testini aynı giriş akışı üzerinde çalıştırın; tezgâhı hiç açamayan kişi sayısını ayrı yazın.

**Belgeler:** 01 §1, 03 §5 ve §14, 07 §2, 06 §4.12, 00 §3, KARARLAR ORTAK-026. UK kararını değiştirmez.

### OYN-02 — K0'daki eylem, anlamlı karardan çok işlem tekrarı olabilir — P0 · Oyun tasarımı

**Mevcut:** NPC müşteri gelir, ürün verilir, para alınır, seviye yükseltilir. “Ne seçerim ve seçtiğimin sonucu ne olur?” açık değil.

**Düzeltme:** Bir tezgâhta yalnız iki veya üç gerçek karar bırakın: görünür talebe göre sınırlı stok seçimi; kısa müşteri sırasına karşı fiyat/servis dengesi; kazancı stok, görsel yükseltme veya çalışan hazırlığına yatırma. Her kararın bedeli ve geri bildirimi aynı oturumda görülmeli. Oyuncuyu sürekli tuş basarak bekletmeyin; birkaç işlemden sonra yeni bir durum oluşsun.

**Doğrulama:** Oyuncuya açıklama yapmadan “hangi kararı verdin ve sonuç neydi?” diye sorun. Cevap yalnız “ürün verdim, para aldım” ise döngü henüz yeterli değildir.

**Belgeler:** 01 §1 ve §3, 07 §2, 10 IS-01, 06 §4.12.

### OYN-03 — İlk on dakika oyunun ana vaadini göstermiyor — P0 · Oyun tasarımı

**Mevcut:** 01 §1'de kiralık taksi ve NPC market kasiyerliği var; oyuncu henüz sahibi değil. Üstelik K0'da taksi bulunmuyor.

**Düzeltme:** İlk deneyimde bir kısa görev oyuncuyu çarşı tezgâhına götürsün ve sahibi yapsın. Taksi, sahiplikten sonra alternatif ilk meslek veya ikinci gelir yolu olarak açılsın. K0 prototipi ile yayın oyununun öğretici akışı ayrıysa ikisi arasındaki fark ve testin neyi ölçmediği yazılsın.

**Belgeler:** 01 §1, 07 §2–3, 10 §7, 06 §4.12.

### OYN-04 — Farklılaşma oyuncuya geç gösteriliyor — P0 · Yanlış ilerleme sırası

**Mevcut:** Çanta, tanık, sorgu ve mahkeme oyunun imzası; bunların büyük kısmı K3–K4'te. K1'in ağır veri ve yuva mimarisi tamamlanana kadar farklılaşma oynanmamış olacak.

**Düzeltme:** 0B deneyini ana projeden bağımsız ve atılabilir yapın. Bir oyuncu çantayı göstersin/reddetsin, diğeri gerekçe arasın, NPC sınırlı bilgi versin. Eğlence gözlenmeden bütün polis/adalet servislerini kurmayın. Başarılı deney ana oyunun K3 sistemlerine teknik şartname olur.

**Belgeler:** 00 §3, 02 §4–5, 05 §5.1, 07 §2–6, A3 §5.

### OYN-05 — “Her yol bir imparatorluğa çıkar” hedefiyle günlük kararlar arasında boşluk var — P1 · Oyun tasarımı

**Mevcut:** Polis birim, suçlu ağ, taksici filo yönetiyor; fakat bu yolların dakikalık eylemi, 20 dakikalık hedefi, 5 saatlik açılımı ve düşük nüfus davranışı eşit ayrıntıda anlatılmıyor.

**Düzeltme:** İlk yayına aday **her** rol için tek sayfalık oynanış sözleşmesi yazın: amaç, üç temel eylem, iki anlamlı tercih, başarısızlık/telafi, oyuncu yoksa NPC çözümü, devretme sınırı, 5/20/120 dakikalık ilerleme ve farklı rollerle temas noktası. “Tıkla, para kazan, seviye atla” dışında bir karar üretmeyen dalı başka tabelayla çoğaltmayın.

**Belgeler:** 01 §6–7, 10 §2–8, 07 §4–7.

### OYN-06 — Sivil tarafta oyuncular arası ihtiyaç zayıf — P1 · Oyun tasarımı

**Mevcut:** Bir NPC alternatifinin bulunması doğru, fakat her iş yalnız NPC ile daha rahat çalışıyorsa gerçek oyuncuların bir araya gelmesi için neden kalmayabilir. Suç dışı sosyal anlar nadirleşir.

**Düzeltme:** İlk bağ olarak bir görünür stok teslimi seçin: market sahibi teslim zamanı ile ücret seçer; kurye rota ve birkaç işi birleştirme kararı verir. NPC her zaman işi yapar; oyuncu kurye daha hızlı, daha kişisel veya daha esnek bir sonuç verir. Oyuncu–oyuncu zorunlu bağımlılığı yaratmayın. İleride tamirhane–taksi, fırın–market gibi iki yönlü anlaşmaları aynı sözleşme altyapısında deneyin.

**Belgeler:** 10 §6, 01 §6, 03 §5, 07 §4.

### OYN-07 — 24 iş fikriyle 6–8 işlik ilk yayın hedefi hâlâ çok büyük olabilir — P1 · Kapsam

**Mevcut:** Altı ortak aile doğru düşünülmüş; buna rağmen her işin özgün arayüzü, mekânı, sesi, dengesi, hatası ve test senaryosu var. Ortak altyapı otomatik olarak eğlenceli çeşitlilik üretmez.

**Düzeltme:** İlk yayın için **üç tam oynanabilir ve farklı dal** asgari ürün adayı: market, taksi, tamirhane. Dördüncü dal yalnız üçü bağımsız oyuncu testinde çalışırsa eklenir. 6–8 sayısı büyüme hedefi olarak korunur; garanti yayın koşulu değildir. Katalogdaki 24 dal vizyon belgesinde kalır. Müteahhitlik kullanıcı için değerli bir fikir olduğundan silinmez; ayrı gri kutu proje deneyinden sonra yayına aday olur.

**Belgeler:** 07 §7–8, 10 §1, §3, §7, KARARLAR ORTAK-025 ve AÇIK-07. “Alt sınır 3” korunur.

### OYN-08 — Beş seviyenin hepsi aynı kararların daha büyük sayıları olmamalı — P1 · Oyun tasarımı

**Mevcut:** Seviye artışı çoğunlukla daha büyük kasa, NPC yuvası ve bina ölçeği olarak tarif ediliyor. 100 saat oynayan için daha büyük rakam tek başına hedef olmayabilir.

**Düzeltme:** Her seviyeye **yeni davranış** ekleyin: seviye 1 tek ürün ve müşteri; 2 stok kararı; 3 sipariş ve güvenlik tercihi; 4 çalışan devri ve yeni müşteri tipi; 5 ikinci şube veya kurumsal sözleşme. İş ailesine göre aynı mekanikleri kopyalamayın. Dekorun ve müşterinin davranış değişiminin ekranda görünmesini sağlayın.

**Belgeler:** 01 §3.3 ve §12, 10 §2–3, 03 §5.

### OYN-09 — Uzun vadede yalnız yeni şube ve fiyat çıkışı yeterli olmayabilir — P2 · Oyun tasarımı

**Mevcut:** 100 saatlik profil iki üç işletme, ev ve birkaç çalışan anlatıyor; fakat oyuncunun bu varlıklarla kurduğu kişisel bağ, mahalle etkisi ve anlatılabilir başarı daha sonra gelecek.

**Düzeltme:** “Kişisel şehir hafızası”nın tamamını erken yapmayın; ucuz iki izi erken deneyin: ilk müşterinin adı ve ilk çalışanın işe giriş tarihi. Dekoratif bir ödül veya fotoğraf duvarı gibi görünür karşılık ekleyin. Görev listesi yerine oyuncunun anlattığı küçük hikâyeler üretmeye çalışın. Bu bir K1 zorunluluğu değil, geri dönüş testi başarısızsa denenecek seçenek.

**Belgeler:** 01 §8, §11–12, 06 §4.8, 10 §9.

### OYN-10 — “Risksiz aklama” ve çok belirgin sayaç gerilimi azaltabilir — P1 · Oyun tasarımı

**Mevcut:** 02 §11 ve 03 §7.4, yasal satışın ilk %20'sini risksiz ve sayısal olarak görünür yapıyor. Bilgi oyununda oyuncu her seferinde tam güvenli düğmeye basıp aynı optimumu tekrarlayabilir.

**Düzeltme:** Oranları hemen gizli rastgeleliğe çevirmeyin. Önce 0B/3C testinde oyuncu aklama kararını neden verdiğini ve riskli bölgeye hiç girip girmediğini gözlemleyin. Risksiz bölüm her zaman kullanılıyorsa düşük hacim, taşıma masrafı, zamanı tüketen işlem veya işletme tercihi gibi **önceden açıklanan bedeller** deneyin. Gizli ve açıklamasız ceza Kural 7'yi ihlal eder.

**Belgeler:** 02 §11–12, 03 §7, 06 §4.9.

### OYN-11 — Polis gücünün sınırlandırılması doğru, rolün becerisi ayrıca tasarlanmalı — P1 · Oyun tasarımı

**Mevcut:** Gerekçe ve delil kapıları tacizi önlüyor. Eğer bütün düğmeler sistem tarafından hazır açılıyor, robot resim otomatik doğru kişiyi işaretliyorsa polis “doğru butona basan görevli”ye dönüşebilir.

**Düzeltme:** Polis için bir beceri döngüsü yazın: olayı gözlemle, iki olası izi seç, bir tanığı doğrula, eşleşmeyi gerekçelendir, dosyayı sun. Yanlış ama dürüst eşleşme oyuncuyu kalıcı olarak cezalandırmasın; memur izinlerini keyfî kapatacak otomatik ceza yerine eğitim ve tekrar kalitesi de değerlendirilsin. NPC vakalarında beraat doğru sonuç olabilsin.

**Belgeler:** 01 §7, 02 §5, §8, §12.4, 09 §5.

### OYN-12 — “Kimse ölmez” kuralına uygun çatışma yine de sıkıcı veya tacize açık olabilir — P1 · Ölçüm

**Mevcut:** Tabancayla en az dokuz isabet, 20 saniye sonra yenilenme; yaralı oyuncu 45 saniye bekleyip 30 saniye tedavi görebilir. Düşük hasar kararı korunmalı, fakat uzun isabet takası ile 75 saniyeye yaklaşan pasif bekleme oyuncuya ağır gelebilir.

**Düzeltme:** Hasarı yükseltmeden çatışmanın amacını ele geçirme, kaçış, siper ve yardım kararlarına kaydırın. Yaralı oyuncuya yardım çağrısı ve takım bilgisi gibi kısa aktif seçenekler verin. Toplam zorunlu bekleme ve sağlığa dönüş süresini gerçek testte ölçün; sayılar henüz “adil” kabul edilmesin. Masumun eşya kaybetmemesi korunur.

**Belgeler:** 02 §7, 03 §14, 06 §4.5, 09 §7.

### OYN-13 — Mahkeme oyuncu açısından yalnız bir sonuç ekranı olabilir — P1 · Oyun tasarımı

**Mevcut:** İtiraz seçenekleri sunucunun zaten bildiği yanlış kimlik, meşru müdafaa ve sistem hatası kontrollerini seçiyor. NPC temsilci oyuncu yokken aynı kontrolleri yapıyor. Oyuncunun duruşmaya katılmasının anlamı çok sınırlı kalabilir.

**Düzeltme:** Kişinin katılımını hak kaybı yaratmadan **anlama ve anlatma** fırsatına çevirin: kanıt zaman çizelgesini görme, bir bağlamı işaretleme, dosyada zaten bulunan ama gözden kaçan çelişkiyi gösterme. NPC temsilci asgari savunmayı eksiksiz yapmalı; katılım beraat için gizli zorunluluk olmamalı. Duruşmanın oynanabilirliği kanıtlanmazsa kısa dosya üzerinden karar, fiziksel salondan daha dürüst bir sunumdur.

**Belgeler:** 09 §5–8, 06 §4.7, 04 §9.

### OYN-14 — On dakikalık tavan ve uzun kaçaklık kaçışı anlamsızlaştırabilir — P1 · Ölçüm

**Mevcut:** Çok adımlı kaçışa karşı normal ceza en çok 10 dakika; çevrimdışı süre de sayılıyor. Kaçaklık 30 çevrimiçi dakika sürebiliyor. Oyuncu çıkış yapıp dönerek normal cezayı bitirmeyi daha cazip bulabilir.

**Düzeltme:** Çevrimdışı infazın sayılması ve kısa ceza UK kararlarının uygulanmasıdır, kaldırılmamalı. Kaçış döngüsünü herkesin zorunlu çıkış yolu saymayın; beceri, hikâye ve risk isteyen isteğe bağlı bir deney olsun. Gri kutuda tek kaçış rotasının tamamlanma süresini ve kaçmayı seçenlerin oranını ölçün. Kimse seçmiyorsa rota, süre ve sonuçları iyileştirin; sırf ceza büyüsün diye 10 dakika tavanını uzatmayın.

**Belgeler:** 09 §9–11, 03 §14, 07 §6.

### OYN-15 — Oyuncuya suç pazarlaması ile sivil çekirdeğin tanıtımı ayrışmış — P2 · Konumlandırma

**Mevcut:** A3 §5 “kapak suç göstermemeli” diyor; aynı bölüm ve A1, en güçlü kısa video anları olarak çanta, tanık, denetim ve mahkemeyi sıralıyor. Mutlak yasak, imzayı keşfedilmez kılabilir.

**Düzeltme:** Oyunda gerçekten bulunan sahnelerle iki dürüst tanıtım yönü sınayın: sahiplik/büyüme ve şehirde kararın sonucu. Kapak, yalnız soygun vaadi vermeden bir oyuncunun işletmesi ile çanta etkileşimini birlikte gösterebilir. Henüz oyunda olmayan mahkemeyi kapakta göstermeyin. Başlık ve görsel testlerinin tıklama yanında ilk 3 dakika terk ve ertesi gün dönüş etkisini birlikte okuyun.

**Belgeler:** A1 §4.1, A3 §5, 00 §3, 07 §8.

## 3. Katmanlar arasındaki gerçek çelişkiler ve yanlış ilerleme sırası

### SIRA-01 — K2 teslimi Oldport'a bağlı, Oldport K5'te açılıyor — P0 · Çelişki

**Mevcut:** 10 §6, K2 stok tesliminin Oldport deposundan geldiğini söylüyor. 05 §2.2 ve 07 §7, Oldport'u K5'e koyuyor. K2 kurye görevi tanımlı başlangıç noktasına sahip değil.

**Düzeltme:** K2'de Blackstone/Ironhill yakınında küçük geçici depo kullanın **veya** Oldport'un yalnız bir gri kutu depo ve yol koridorunu K2'ye çekin. Sonraki aşamada kalıcı Oldport görseline geçin. Üç belgede aynı adresi yazın.

**Belgeler:** 05 §2.2, 07 §4 ve §7, 10 §6, 08 §1.

### SIRA-02 — K3 suç ekonomisi Oldport aracısını kullanıyor, bölge K5'te — P0 · Çelişki

**Mevcut:** 02 §7.1 ve §11.1, kaçak silah ve kirli para alışverişini Oldport aracısına bağlıyor. Harita sırası Oldport'u iki katman sonra getiriyor.

**Düzeltme:** K3 için küçük, sınırlı erişimli bir Oldport sokak prototipi açın veya aracıyı K3'te erişilen Ironhill'e geçici taşıyın. İlk seçeneğin üretim ve telefon maliyetini ölçün; hangi çözüm seçilirse belgeleri aynı anda güncelleyin.

**Belgeler:** 02 §7 ve §11, 05 §2.2 ve §2.5, 07 §5 ve §7.

### SIRA-03 — K1'de beş seviye sözü var, gerekli fiziksel cepheler sonra geliyor — P0 · Çelişki

**Mevcut:** 07 §3 “işletme büyüme hattı (5 seviye)” diyor. 01 §3.3'te 3–4. seviye standart, 5. seviye büyük cephe istiyor. Ironhill standart cephelerinin çoğu K3; büyük cephelerin oynanabilirlik kapsamı da net değil.

**Düzeltme:** K1'de ilk iki seviyeyi tam yapıp 3–5 için yalnız veri şemasını hazırlayın **veya** K1'e birer gri kutu üst seviye yuva ekleyin. Oyuncuya “açık ama mekânsız” yükseltme satmayın. Her seviye için “veri modeli var / testte oynanabilir / yayımlanmış” durumunu ayrı gösterin.

**Belgeler:** 01 §3.3, 05 §2.2–2.4, 07 §3–5.

### SIRA-04 — 70 yuva K1'in gerçek kapasitesi gibi yazılmış — P0 · Çelişki

**Mevcut:** 01 §2.3 ve 04 §5.2, sunucu başına 70 başlangıç yuvası hesabı yapıyor. Bu sayı Oldport sanayi yuvalarını ve sonradan açılan bölgelerdeki cepheleri kapsıyor. K1'de erişilebilir sınıf başına gerçek kapasite çok daha düşük.

**Düzeltme:** Tek “70” yerine **katman × yuva sınıfı × oyuncu sunucusu üst sınırı** tablosu çıkarın. Her aşamada o anda erişilebilen yuvalarla talebi sınayın. Uzaktan hizmet bir emniyet ağı olabilir; oyuncunun ana işinin sistematik olarak görünmez olmasını normal kapasite saymayın.

**Belgeler:** 01 §2.3–2.4, 04 §5, 05 §2.4, 07 §3 ve §5.

### SIRA-05 — K3'ün geçici cezası anayasa vaadiyle uyuşmuyor — P0 · Çelişki

**Mevcut:** 07 §5 ve 09 §15, K3'te yakalanan oyuncuya otomatik para cezası ve bir dakika gözaltı yazıyor. Delil, temsil, itiraz ve gerekçeli kararın tamamı K4'e bırakılıyor.

**Düzeltme:** K3 testinde kalıcı hüküm ve sicil üretmeyin; olay sonunda açık bir test sonucu kartı ve kısa oyun içi müdahale gösterin. Kalıcı mali yaptırım isteniyorsa minimum delil, kimlik bağı, açıklama ve düzeltme yolu aynı teslimde gelmeli. Gözaltını mahkûmiyet diye kaydetmeyin.

**Belgeler:** 09 §2, §5–8, §15; 07 §5–6; 06 §4.2 ve §4.7.

### SIRA-06 — Altı rol grubu için zorunlu ikili ekipler ve yedi kişi uyuşmuyor — P1 · Organizasyon

**Mevcut:** 07 §10 “tek kişilik rol yok, ikili gruplar” diyor ve altı farklı grup listeliyor. Yedi kişilik ekibin her bir grubu kalıcı ikiliyle doldurması mümkün değil. Aynı belgenin sonu “yedi küçük çıktı” derken altı örnek görev yazıyor.

**Düzeltme:** Altı başlık uzmanlık alanı olsun, altı sabit ikili olmasın. Yedi kişiye her katmanda birincil sorumlu ve ikinci inceleyen atayın; aynı kişi sınırlı sayıda küçük görevi paylaşabilir. Karar ve kod incelemesi tek bir kişinin yokluğunda durmamalı. Son satırdaki sayı düzeltilmeli.

**Belgeler:** 07 §10 ve §14, DEGISIKLIK-GUNLUGU ilgili satır.

### SIRA-07 — Geniş katalog ile ilk yayının asgari kalitesi açıkça ayrılmalı — P1 · Organizasyon

**Mevcut:** 10, 24 dalı vizyon sayıyor; 07 yine 6–8 dal hedefliyor. Ölçüm yetmezse üçe inme izni var, ama hangi dalın “tam oynanabilir” kabul edileceği davranış düzeyinde tanımlanmıyor.

**Düzeltme:** Bir dalın bitmiş sayılma ölçütüne ilk beş dakika, iki özgün karar, ekonomi girdisi/çıktısı, düşük nüfus alternatifi, telefon arayüzü, hata/telafi, telefon performansı ve dış oyuncu testi ekleyin. Yarım dalı yayın sayısına dahil etmeyin. K0 kapasite sonucuyla listeyi yeniden sıralayın.

**Belgeler:** 10 §1, §7–8, 07 §7 ve §10.3.

## 4. Ekonomi ve ilerleme: sayılar yerine oyuncu yolları

### EKO-01 — “Net kazanç” aynı yerde iki farklı anlam taşıyor — P0 · Hesap

**Mevcut:** 03 §3, net kârı bütün giderler çıktıktan sonraki tutar diye tanımlıyor. §5'teki 85 ₡/dk ise “maaşlar düşülmeden önce net” diye adlandırılıyor. §6 ve §7 otomasyon ile suç oranını bu değerden türetiyor. Farklı iş ailelerinin marjları da nihai net ile satış arasında geçiş yapıyor.

**Düzeltme:** Satış cirosu, ürün maliyeti sonrası katkı, NPC ücretleri, ruhsat/sigorta ve **oyuncunun eline geçen net** ayrı alanlar olsun. Aktif iş ile NPC işinin aynı temel satış üretiminden hangi oranla türediği tabloda gösterilsin. Suç/temiz servet kıyası gerçek oyuncu neti ve yatırılan sermaye ile tekrar hesaplansın. Ekonomi modeli çalıştırılmadan 1,42 sonucuna “denge sağlandı” denmesin.

**Belgeler:** 03 §3, §5–7, §10, §14–15; 01 §5.6; 10 §2; 06 §4.9.

### EKO-02 — Yükseltme süreleri giderler hesaba katılmadan kesinleşmiş gibi duruyor — P0 · Hesap

**Mevcut:** 03 §5, seviye 5 için 150.000 ₡ maliyet ve 110 ₡/dk seviye 4 gelirini kullanıp yaklaşık 25 saat yazıyor. Basit bölme 150.000 / (110 × 60) = yaklaşık **22,7 saat**. Maaş, ruhsat ve aktif/otomatik üretim eklenirse süre başka olur. Bir oyuncunun aynı anda taksi ve mağaza çalıştırması da değiştirir.

**Düzeltme:** Her seviye için tek formül değil üç yol çıkarın: yalnız aktif, karışık aktif/NPC ve düşük süreli oyuncu. Başlangıç nakdi, stok harcaması, yükseltme nedeniyle duran üretim ve çevrimdışı kazanç varsayımlarını yazın. “45–55 saatte varış” gibi ifadeleri model ve gözlem gelene kadar aralık hipotezi diye etiketleyin.

**Belgeler:** 01 §1, §3 ve §12; 03 §5, §14–15.

### EKO-03 — Aynı mesleğin gelir tavanı farklı işlerin seçim değerini bozabilir — P1 · Ölçüm

**Mevcut:** Seviye 5 işletme 140 ₡/dk, aktif polis 60, FCU 65, sağlık 50; sermaye gereksinimi ve otomasyon farkları net değil. Tek “dakika başı” sayıdan bir mesleğin değerini çıkarmak mümkün değil.

**Düzeltme:** Rol seçimini net servet, edinim maliyeti, risk, beceri gereksinimi, eğlence, NPC devri ve sosyal katkı birlikte değerlendirecek arketip testi kurun. Kamu mesleğinde yüksek ödeme üzerinden çift hesap ve olay üretme istismarlarını da modelleyin. Mesleklerin aynı para vermesi şart değil; değersiz hissedilmemesi şart.

**Belgeler:** 03 §5, §12 ve §15; 10 §5; 01 §6–7.

### EKO-04 — Kaynak sınırında verimin düşmesi oyuncuya sürpriz olmamalı — P1 · Oyun tasarımı

**Mevcut:** 03 §12 her gelir kaynağına saatlik üst sınır koyuyor, fakat seviyeye, oyuncunun ne yaptığına ve gelir türüne göre sınır şekli belirlenmemiş.

**Düzeltme:** Sınırları “çok oynadın, artık daha az kazan” cezasına çevirmeyin. Aynı eylemin tekrarı yerine yeni karar veya başka iş rotası teklif eden yumuşak azalan verim kullanın; ilk dakikada kuralı açıklayın. Mikro prototipte sınır şart değil; ekonomi istismarı görülürse belirli kaynaklara uygulanır.

**Belgeler:** 03 §12 ve §14; 06 §4.2; 01 §6.

### EKO-05 — Çevrimdışı gelir, gider ve aktif üretim aynı hesap zincirine bağlanmalı — P0 · Hesap/teknik

**Mevcut:** 01 §4 gelir ve giderin birlikte ilerlediğini; 03 §6.2 çevrimdışı yüzdelerin maaş ve ruhsat sonrası net olduğunu söylüyor. Tahsilat yetmezse dinlenme, üretim günü hesabının kesirli kalması ve geri girişte ödeme sırası açık bir örnekle anlatılmıyor.

**Düzeltme:** Son kayıt zamanı, 8 saat penceresi, mevcut stok, çalışan, kısmi üretim günü, ücret, ruhsat, tahsilat ve durma koşulu için üç zaman çizelgesi örneği yazın: bir saat sonra dönüş; 12 saat sonra dönüş; stok/para biterken dönüş. Hiçbir durumda hem formül geliri hem sunucuda çalışan NPC geliri aynı aralığa yazılmasın. Dondurma ve infaz bu hesapla uzlaştırılsın.

**Belgeler:** 01 §4, 03 §3, §6 ve §10, 04 §4.

### EKO-06 — Suç yolunun üst sınırı yalnız tek dükkân örneğiyle kanıtlanmıyor — P1 · Hesap

**Mevcut:** 03 §7.1, seviye 3 dükkân üzerinden yaklaşık 1,42 oranı türetiyor. Dört işletme hakkı, başkasının kotası, suçun yapılma süresi, yakalanma kaybı ve kirli paranın yasa dışı tüketimi bu tek hesapta yok.

**Düzeltme:** 03 §15'te sözü edilen beş arketipi gerçekten simüle edin; birden çok işletme, farklı günlük oynama süresi, değişen suç başarısı ve alt hesap/özel sunucu davranışını dahil edin. 1,2–1,5 hedefi sonuç değil test bandıdır; bu bant oyuncuların suç rolünü hiç seçmemesine yol açarsa oyundaki karar zenginliğiyle birlikte değerlendirin.

**Belgeler:** 03 §7, §12 ve §15; 02 §10–12.

### EKO-07 — Anlaşmalı istismarda “arkadaş değil” yeterli koruma değil — P1 · Teknik/ölçüm

**Mevcut:** Sigorta, polis ödülü ve sözleşme için arkadaşlık veya son yedi günlük transfer ilişkisi kontrol ediliyor. İki yeni hesap arkadaş değilse ilişkiyi bu şartlar yakalamaz; aynı ev veya ağ üzerinden oynayan dürüst kullanıcılar da otomatik suçlu sayılmamalı.

**Düzeltme:** Önce **olay başına toplam üretilebilen yeni parayı** sınırlayın ve işlem grafiğini telemetriyle izleyin. Açıkça aynı iki hesabın tekrar ettiği kazanç akışına yumuşak sınır ve insan incelemesi getirin. Arkadaşlık tek başına kanıt veya cezalandırma sebebi olmasın; sigorta ret sebebi oyuncuya açıklansın.

**Belgeler:** 02 §10.5, 09 §13, 10 §6, 03 §7 ve §12.

### EKO-08 — Kozmetik ve özel sunucu gelirleri doğrulanmış talep değil — P2 · Dış doğrulama

**Mevcut:** 03 §13 ve A3 §4 uzun ürün listesi veriyor. Oyuncunun araç kaplaması, ek radyo veya yönetim paketi için ödeme isteği ölçülmedi. İlk sürümde hepsini yapmak bakım ve lisans yükü getirir.

**Düzeltme:** İlk yayında en fazla bir veya iki güçlü kozmetik kategori ve gerçek topluluk talebi varsa özel sunucu yönetimi denenir. Satın alma dönüşümü ile oyuncu güveni birlikte izlenir. Robux ile ekonomik slot ve yargı avantajı yasağı korunur. Gelir tahmini veri gelmeden yazılmaz.

**Belgeler:** 03 §13, A3 §4–5, 07 §7–8.

## 5. Teknik kayıt, güvenlik ve adalet: uygulama öncesi şartlar

### TEK-01 — Kirli nakit örnek veri şemasında iki yerde duruyor — P0 · Çelişki

**Mevcut:** 04 §4.1 profil örneğinde “kirliNakit = 0” var. Aynı dosyanın §4.4'ü “kirli nakit yalnız envanterde tutulur; ayrı bakiye yok” diyor.

**Düzeltme:** Profildeki yinelenen alanı kaldırın veya yalnız envanterden türetilen, kaydedilmeyen bir görünüm olarak adlandırın. Banka, cüzdan, işletme tahsilatı ve kirli nakit için sahiplik/aktarma diyagramı yazın. Eski kayıt göçü tanımlayın.

**Belgeler:** 04 §4.1, §4.4, §6; 02 §2.4 ve §11; 03 §2.

### TEK-02 — Olay kutusunun tek doğruluk kaynağı belirsiz — P0 · Teknik

**Mevcut:** 04 §4.1 olay kutusunu oyuncu profil alanı olarak gösterirken §4.3 onu ayrı DataStore anahtarı sayıyor. Başka sunucular ekliyor, girişte oyuncu servisi işliyor; okuma, onay, hata ve tekrar aynı örnekte tarif edilmemiş.

**Düzeltme:** Kutuyu kalıcı ayrı anahtar olarak modelleyin; profil alanı gerekiyorsa sadece işlenmiş olay kimlikleri ve özet tutun. Birden çok üreticinin aynı anahtara eklemesini güvenli güncelleme ile yapın; **ekle → yükle → idempotent uygula → uygulandığını kaydet → kutudan temizle** dizisindeki her çökme noktasını tasarlayın. Sınırsız büyüme için saklama ve bölme kuralı yazın.

**Belgeler:** 04 §4.1–4.4 ve §9; 01 §2.2; 09 §7–9.

### TEK-03 — İki aşamalı işlem taslakta var, hata durumları eksik — P0 · Teknik

**Mevcut:** 04 §4.4 “rezerve, sonra onay; girişte kurtar” diyor. Alıcı çevrimdışıyken, işlemin biri onaylanıp diğeri yazılmamışken veya veri servisi hata verince kime ne gösterileceği yok.

**Düzeltme:** Para transferi, sigorta, aklama ve para cezası için ayrı işlem sözleşmesi yazın: işlem kimliği, ön koşullar, rezerve edilen varlık, iki tarafın yazma sırası, kalıcı sonuç durumu, tekrar deneme, geri alma/telafi ve oyuncuya gösterilecek bildirim. Bir anahtar üzerindeki güncelleme, iki farklı anahtarı kendiliğinden atomik yapmaz. Aynı kimlikle art arda üç girişte de ikinci ödeme oluşmamalı.

**Belgeler:** 04 §4.4–4.5; 02 §10–11; 03 §9; 09 §13–14.

### TEK-04 — İki dakikalık otomatik kayıt ile “sıfır veri kaybı” kapısı aynı anlamda değil — P0 · Çelişki

**Mevcut:** 04 §4.5 her 120 saniyede ve çıkışta kayıt öneriyor; §14.1 zorla kapatınca son iki dakikanın kaybolup kaybolmadığını soruyor; 07 §3 kapı eşiğini sıfır veri kaybı yapıyor. Sıradan ara kayıt, ani çökmede son değişiklikleri garanti etmez.

**Düzeltme:** Kritik satın alma, ödül, eşya aktarımı ve mahkeme yaptırımını dayanıklı işlem olarak ayrıca yazın; yalnız ekran güncellemesine güvenmeyin. Kontrol noktalı sıradan durum ile hiçbir koşulda iki kez üretilemeyecek ekonomik işlem farkını belirleyin. Test kapısında “sıfır kayıp”ı, tanımlanmış kritik işlemlerin güvenle sonuçlanması olarak ölçün; test sayısı tek başına ispat sayılmasın.

**Belgeler:** 04 §4.4–4.5 ve §14; 07 §3 ve §8.

### TEK-05 — Çevrimdışı mahkeme için sürekli çalışan sunucu varsayılmamalı — P0 · Teknik

**Mevcut:** 04 §9 adalet kuyruğunu çalışan sunucunun işleyeceğini söylüyor. Oyun sunucusu kalmadığında 10 dakika sonra kendiliğinden duruşma çalıştıran bir süreç garanti edilmiyor.

**Düzeltme:** Kayıtta **planlanan zaman**, **işlenen zaman** ve kararın **etkin zamanı** ayrı tutulsun. Oyun sunucusu sonraki kez aktif olduğunda gecikmiş dosyayı kurallı biçimde işlesin; girişte sonuç doğru görünsün. Duruşmanın tam belirtilen dakikada fiziksel olarak oynandığı iddia edilmesin. İşlem gecikmesi sanığa ek ceza oluşturmasın. Kural sürümü dosyayla dondurulsun.

**Belgeler:** 04 §9, 09 §7–9, 06 §4.7–4.8.

### TEK-06 — Tanık kaydının gerçek oyuncu kimliğini bilmesi soruşturmayı kısa devre edebilir — P1 · Teknik/oyun tasarımı

**Mevcut:** 09 §5.3 ve 04 §9.2, tanık delilinde kaynak oyuncu kimliği olduğunu ve mahkemenin bunu doğruladığını söylüyor. Güvenlik için yararlı; polis/mahkeme görünümünde kimliğin ne zaman açıldığı belirsiz. Sunucu gerçeği erkenden karar vericiye gösterirse robot resim ve eşleştirme oyunu dekor olur.

**Düzeltme:** İç sistemdeki gerçek UserId yalnız **yanlış kişiyi cezalandırmama güvenlik kontrolü** olsun. Oyuncu polis yalnız olay anı görüntüsü, mesafe, kamera, plaka ve bağımsız gözlem görsün. Aynı olaydan türeyen iki kaydı iki bağımsız tanık diye saymayın. Mahkeme delilin hem olayla hem sanıkla bağını kapalı kayıtta doğrulasın; kararda hangi gözlenebilir delilin sonuca götürdüğünü anlatsın.

**Belgeler:** 02 §8, 09 §5, 04 §8–9, 06 §4.4.

### TEK-07 — NPC sayıları ve “Humanoid asla kullanma” bir ölçümün yerine geçmiş — P1 · Teknik

**Mevcut:** 04 §8'de 40 ve 100–150 NPC tahmini ölçülmemiş. Bütün NPC'lere Humanoid yasağı konuyor. Yaya, müşteri, ambulans ve hareketli görevli aynı teknik gereksinimde olmayabilir.

**Düzeltme:** Hedef cihazlarda ayrı karşılaştırma yapın: durağan müşteri, yaya, devriye ve özel etkileşim NPC'si. Ekranda görünen ve sunucuda aktif NPC için ayrı bütçe koyun. Basit modeller çoğunluk için tercih olabilir; istisna gerekiyorsa ölçerek seçin. 120 eşzamanlı hareketli NPC ve 8.000 parça hedefleri kanıtlanana kadar bütçe hipotezi olarak yazılsın.

**Belgeler:** 04 §8 ve §13; 05 §3–4; 07 §3, §7–8.

### TEK-08 — Veri ve yuva yönetimi oyuncunun gözünden doğrulanmalı — P1 · Teknik/UX

**Mevcut:** Tek yazarlı işletme sağlam bir başlangıç. Ancak sunucu değişince tercih edilen adres dolabiliyor; son çare “uzaktan hizmet”te işletme hiç görünmeden tam gelir üretiyor. Sahiplik vaadinin sokaktaki karşılığı kaybolabilir.

**Düzeltme:** Testlerde adres değişimi, uzak işletme yüzdesi ve “işletmemi bulamıyorum” sözlerini ölçün. Her oyuncunun **bir ana işletmesini** mümkün olduğunca fiziksel gösterecek öncelik kuralını sınayın. Diğer işletmeler için pasaj, ortak bina veya küçük vitrin özetini düşünün. Gelir hakkını mekânsal kapasiteye bağlamama kararı korunur.

**Belgeler:** 01 §2.3–2.5; 04 §5; 06 §4.10; 05 §2.4.

### TEK-09 — Güvenlik kontrol listesi tek başına güvenlik kanıtı değil — P1 · Teknik

**Mevcut:** Yedi uzak çağrı kontrolü ve sunucuda hesap ilkesi doğru. Fakat her eylem için miktar, mesafe, durum, zaman, kilit ve hak sahibinin hangi anda doğrulandığı ayrı yazılmadı. AI'nın “kontroller var” demesi davranış testi değildir.

**Düzeltme:** En az satın alma, envanter taşıma, kasa çekme, polis arama, tanık ekleme, dava açma, para transferi, sağlık ödülü ve araç bagajı için istemci isteği/sunucu doğrulaması/ret sonucu tabloları yazın. Uzak mesafe, iki kez tıklama, yeniden bağlanma, sunucu değiştirme ve iki hesapla denemeler otomatik test edilmeli.

**Belgeler:** 04 §1, §2, §4, §14; A2 §2, §6.

### TEK-10 — Özel sunucu ile genel ekonominin birleştiği noktalar belirsiz — P2 · Teknik

**Mevcut:** Standart özel sunucu kalıcı ekonomiyi paylaşıyor, ama soygun ödülü %50. Serbest RP modu ayrı kayıt alanı. Oyuncu aynı araç ve işletmeyi iki modda nasıl görür; hangi şeyin kopya, hangisinin kalıcı olduğu anlatılmıyor.

**Düzeltme:** Mod geçişinde para, envanter, işletme, dava, kıyafet, ev ve satın alınan kozmetik için bir taşıma matrisi yazın. Serbest mod başından sonuna görünür olsun; kalıcı ekonomiye tek bir ödül veya ceza sızmasın. Bu özellik ilk yayın için gerekli değilse gelir beklentisi nedeniyle aceleye alınmasın.

**Belgeler:** 03 §13, 04 §12, 06 §4, A3 §4.

### TEK-11 — Bütün sayıları ortak Ayarlar dosyasına koyma kuralı gizli sistemi açığa çıkarabilir — P0 · Çelişki

**Mevcut:** 03 ve 04, bütün sayısal değerleri ReplicatedStorage içindeki Ayarlar.lua dosyasına koyuyor. Aynı teknik belge şüphe, NPC karakteri ve gizli kayıtların istemciye hiç gönderilmemesini istiyor. Ortak konfigürasyon istemcinin okuyabileceği alandadır.

**Düzeltme:** Oyun sırasında oyuncunun bilmesi gereken fiyat, kapasite, süre ve açık kurallar ile sunucuya özel gizli ağırlık ve istismar eşiklerini ayırın. Açık değerler ortak ayarda; gizli değerler sunucu tarafındaki ayrı ayarda olsun. Aklama için gösterilmesi zorunlu yüzde gibi değerleri yanlışlıkla gizlemeyin. “Bütün sayılar tek dosyada” yerine “her değerin tek yetkili tanımı var” ilkesini yazın.

**Belgeler:** 03 giriş ve §14; 04 §1–3; 02 §9; A2 §1–2; 08 §6.

### TEK-12 — NPC vakalarının tekrar hissi ve yanlış kanıt üretimi ölçülmüyor — P2 · Oyun tasarımı/teknik

**Mevcut:** FCU ve polise NPC dosyaları veriliyor; vaka üretim kuralları, tekrar sınırı ve suçsuzluk oranının oyuncunun davranışını nasıl etkilediği tarif edilmiyor.

**Düzeltme:** İlk sürümde az sayıda elle tasarlanmış, açıklanabilir şablon kullanın. Bir olayın tek doğru çözümü ve gerekçesi olsun; oyuncunun yalnız menüyü rastgele deneme yoluyla başarı kazanmasını engelleyin. Beraat de görev başarısı sayılmalı. Şablon sayısını oyuncu testinde tekrar hissi görüldüğünde artırın; çalışma anında üretken AI şartı koymayın.

**Belgeler:** 02 §12.4, 09 §5–8, 10 §5, 07 §5–7.

## 6. Arayüz, erişilebilirlik, taciz ve günlük akış

### UX-01 — Sekiz telefon sekmesi yeni oyuncuya aynı anda yüklenmemeli — P0 · Oyun tasarımı

**Mevcut:** İlk günden Mesajlar, Banka, İşletmelerim, Çalışanlar, Araçlarım, Ev, Rehber ve Dosyalarım bir arada tanımlı. Yeni oyuncu yalnız tezgâhı anlamaya çalışırken gelecekteki sistemleri de görür.

**Düzeltme:** İşlevleri satın alınan ve açılan sistemle bağlamsal gösterin. Başlangıçta para, tezgâh, basit harita ve ayarlar yeterli; çalışan, araç ve dava ancak ilk ilgili olayda belirir. Menülerin gizlenmesi erişilebilirliği bozmamalı: Yardım, Ayarlar, Kurallar ve Raporla her zaman bağımsız erişimde kalır.

**Belgeler:** 01 §9, 06 §1–4 ve §5, 07 §2–3.

### UX-02 — Telefon eşyası, kritik hukuki ve güvenlik erişimini engellememeli — P1 · Oyun tasarımı

**Mevcut:** Telefon bir envanter birimi, yoksa uzaktan yönetim yok. Dosyalarım ve dava savunması telefondan erişilebiliyor; mahkûmun telefonu yalnız okuma modunda. Telefon kayıp, eller kapalı veya oyuncu cezaevindeyken savunma ve itirazın erişim yolu açık değil.

**Düzeltme:** Telefonun fiziksel maliyeti yalnız **işletme uzaktan yönetimine** uygulansın. Dosya bildirimi, itiraz, kurallar, engelleme ve raporlama ayrı sistem menüsünden veya mahkeme/cezaevi terminalinden erişilsin. Yaralı oyuncu korunma ve güvenlik bilgilerini telefon olmadan görsün. Her eylemin “telefon yok” durumunu yazın.

**Belgeler:** 01 §9; 02 §7; 06 §4.5–4.13; 09 §8–12.

### UX-03 — Masaüstü tuş istemi mobil öncelik ilkesiyle çakışıyor — P1 · Çelişki

**Mevcut:** 06 §1 mobil öncelik diyor; HUD örneği “E — Kasayı aç”. Bu ifade dokunmatik oyuncuya eylemin yerini anlatmıyor.

**Düzeltme:** Eylem istemi giriş aygıtına göre değişsin: dokunmatik düğme, gamepad simgesi veya klavye tuşu. 44×44 dokunma alanı hedefi gerçek ekran ölçüsü ve farklı çözünürlüklerde sınansın. Envanter sürükleme, araç sürüşü ve polis panik ekranı gerçek telefonda denenmeden bitmiş sayılmasın.

**Belgeler:** 06 §2–5; 04 §13–14; 07 §8.

### UX-04 — “Şüphe gizli” ile “her kaybın açıklaması var” ilişkisi sınanmalı — P1 · UX/adalet

**Mevcut:** Oyuncu şüpheyi anlık görmüyor, bazen kaydı ancak dosyası açılınca okuyor. Sistem kaydı hatalıysa oyuncu davranışının sonucunu çok geç anlayabilir.

**Düzeltme:** Gizli puanı göstermeden gözlenebilir işaret verin: NPC bakışı, kısa diyalog, “bu kıyafet burada dikkat çekebilir” önizlemesi. Gerekçeli durdurmada ilgili gözlemi gösterin; yanlış şüphe kaydı için erişilebilir düzeltme yolu tanımlayın. Ret hakkı ve hukuki delil sınırı değişmez.

**Belgeler:** 00 Kural 7; 02 §3, §5, §9; 06 §1–4.

### UX-05 — Nakit fiziği sivil oyuncuya angarya yükleyebilir — P1 · Oyun tasarımı

**Mevcut:** Büyük temiz nakit çanta gerektiriyor; cüzdan 2.500 ₡, telefon bir birim. Nakit taşıma suçta anlamlı olabilir, ama dürüst işletmecinin her satın alma öncesi para destesi taşıması amaçlanmıyor.

**Düzeltme:** Meşru büyük alışveriş ve maaşı varsayılan olarak bankadan güvenli ödetin. Fiziksel temiz nakit yalnız kasadan tahsilat, oyuncuya elden ödeme veya gönüllü taşıma durumlarında karar üretsin. Yeni oyuncu için cüzdan ve telefonun sürekli düzenlenmesi gerekip gerekmediğini test edin; suçtaki çanta gerilimini koruyun.

**Belgeler:** 02 §2 ve §6; 03 §2–3; 06 §3 ve §4.9.

### UX-06 — Polis sorgusu tacizi yalnız süre sınırıyla bitmez — P1 · Sosyal güvenlik

**Mevcut:** Aynı memura ve gerekçeye bekleme süresi var, ama farklı memurlar, rol değişimi, aynı yerde blokaj ve sürekli takip edilme için bütün davranış sınırları açık değil. Maske ve görünür silah gerekçeleri sürekli durdurma döngüsü doğurabilir.

**Düzeltme:** Oyuncu bazlı toplam müdahale sıklığı, farklı memurların ortak gerekçe tüketimi, görev değişimi istismarı, görüş ve kaçış yolları test edilsin. Masum oyuncunun bir oturum boyunca **işini yapabildiği** davranış testi şart olsun. Polis yetkisi kötüye kullanım kaydı açık ve itiraz edilebilir olsun. Güvenli bölge, aranan kişiye nasıl uygulanır sorusu ayrı kural kartıyla açıklansın.

**Belgeler:** 02 §5 ve §7.7; 09 §4–5; 06 §4.1 ve §7; 07 §5.

### UX-07 — Cezanın kısa olması tek başına adil hissettirmez — P1 · Ölçüm

**Mevcut:** Mahkeme ayrıntılı delil gösteriyor; buna rağmen oyuncu önce neden durdurulduğunu, ne zaman savunma yapacağını, hapse girdikten sonra ne yapabileceğini anlayamazsa beş dakika çok uzun hissedilebilir.

**Düzeltme:** Her dosyayı oyuncu dilinde dört adımda gösterin: ne oldu, hangi delil var, hangi kural uygulandı, şimdi hangi seçeneklerin var. Ekranı başka bir oyuncuya gösterip “neden bu sonuç çıktı?” sorusunu cevaplayıp cevaplayamadığını ölçün. Dava metnini hukuk kitabı gibi değil, kısa zaman çizelgesi gibi sunun; ayrıntı isteyene açılır.

**Belgeler:** 09 §2, §7–12; 06 §4.2 ve §4.7; 07 §6.

## 7. Şehir, görünürlük ve canlılık

### HAR-01 — Küçük şehir ile 70 fiziksel işletme çelişebilir — P1 · Harita/performans

**Mevcut:** Şehir bir uçtan diğerine araçla 2–2,5 dakika; tam vizyonda 70 yuva, kurumlar, yollar, NPC'ler ve araçlar bulunuyor. Yuva sayısını karşılamak için oyuncuyu uzun ve boş yollara veya aşırı sıkışık sokaklara zorlayabilirsiniz.

**Düzeltme:** Haritayı ilk önce oyuncunun karşılaşacağı üç merkez etrafında kurun: çarşı, kurum meydanı, meslek/teslim noktası. İşletme başına benzersiz bina yerine pasaj, standart iç mekân ve ortak adres kullanın. Gerçek telefon performansı ve yaya/araç yolculuk süreleriyle eşzamanlı ölçün. 70 bir hedef üst sınırdır, ilk haritanın inşa listesi değildir.

**Belgeler:** 01 §2.3, 05 §2, 04 §5 ve §13.

### HAR-02 — Şehir boşken NPC varlığı işlevsel görünmeyebilir — P1 · Oyun tasarımı

**Mevcut:** Jenerik NPC dükkânları boş cepheleri dolduruyor; NPC devriye ve müşteriler var. Fakat oyuncu onlarla anlamlı küçük etkileşim kurmuyorsa kalabalık bir dekor gibi hissedilir.

**Düzeltme:** Az sayıda NPC'ye okunabilir rutin ve tepki verin: aynı müşterinin tekrar gelişi, mağaza talebinin değişmesi, tanığın korkması, devriyenin sokağı dolaşması. Görünüm sayısından önce davranış sayısını ve performansı ölçün. Kişisel şehir hafızasının küçük sürümü burada değer katabilir.

**Belgeler:** 01 §5 ve §11; 02 §8; 04 §8; 05 §4.

### HAR-03 — Dinamik adres sosyal hafızayı zayıflatabilir — P1 · Oyun tasarımı

**Mevcut:** Tercihli adres başka sunucuda doluysa işletme başka bir cepheye taşınıyor. Rehber güncel adresi gösteriyor ama arkadaş “senin dükkânın Ironhill No. 7” diye hatırladığında aynı yere gidemeyebilir.

**Düzeltme:** Kalıcı işletme kimliği, değişken mevcut adres ve davetle kolay yol bulma birlikte çalışsın. İlk ana işletmenin tercihli yuvasını koruma olasılığını artıran, başkalarını bekletmeyen bir yerleşim önceliği deneyin. Rehberde “bu sunucudaki konum” sözü açık olsun; çevrimdışı salt okunur vitrin “sahibi şu an burada” izlenimi vermesin.

**Belgeler:** 01 §2, 04 §5, 06 §4.10, 05 §2.4.

### HAR-04 — Kurum binaları yapıldığı hâlde oyuncu onları kullanmayabilir — P2 · Oyun tasarımı

**Mevcut:** Adalet sarayı, hastane ve ruhsat ofisi haritada yer alıyor; savunma ve işlemler uzaktan da yapılabiliyor. Binaya zorla yürütmek akışı yavaşlatır; hiç gerek bırakmamak emeği görünmez yapar.

**Düzeltme:** Zorunlu sıra değil, binayı ziyaret etmek için görünür neden verin: ilk ruhsatın kısa töreni, delil panosunun görsel anlatımı, sağlık oyuncusunun ambulans garajı, cezaevi kaçışının mekâna bağlı oluşu. Günlük tekrar işlemlerini uzaktan bırakın. Giriş–işlem–çıkış süresini test edin.

**Belgeler:** 05 §2.3, 09 §4 ve §8, 01 §10, 06 §4.

### HAR-05 — Stilize sanat tutarlılık ister; “AI kusurlarını gizleme” hedef olmamalı — P2 · Sanat yönetimi

**Mevcut:** 05 ve A1 stilize yönü haklı olarak seçiyor, fakat gerekçelerden biri AI varlık kusurlarının daha az fark edilmesi. Tutarsız oran, okunmayan tabela ve farklı ışık yine görünür.

**Düzeltme:** Tek sayfalık görünüm kılavuzu: silüet, ölçek, renk, malzeme, sokak okunurluğu, plaka/tabela mesafesi ve telefondaki kontrast. Üretilen her varlık oyundaki ekran görüntüsünde incelensin. Başarılı birkaç modüler varlık, çok sayıda farklı ama uyumsuz modelden değerlidir.

**Belgeler:** 05 §1, §3 ve §7; A1 §4–5; 06 §6.

## 8. Ekip, araçlar, platform ve yayın gerçekliği

### IS-01 — Uzun belge paketi ekipte uygulanabilir görev listesine dönüşmüyor — P0 · Organizasyon

**Mevcut:** 18 dosya kararları iyi belgeliyor, ama yedi kişinin bu hafta yapacağı iş, bağımlılığı, kimin inceleyeceği ve oynanabilir sonucu ayrı bir görev kartı biçiminde yok.

**Düzeltme:** Her katman için en fazla birkaç aktif görev: amaç, dosya/sahne sahibi, kabul davranışı, inceleyen, test cihazı ve bitiş kanıtı. Tek bir karar günlüğü korunur; aynı işi iki AI veya iki kişi ayrı dallarda yapmamalı. Sınav dönemi ve gerçek haftalık saat K0 sonunda ölçülür. “Bu hafta herkes bir şey yapsın” iyi başlangıçtır, kalıcı proje yönetimi değildir.

**Belgeler:** 07 §2, §10 ve §14; 04 §15; A1 §6.

### IS-02 — AI'nın “kodu tamamen yapması” kalite sorumluluğunu belirsiz bırakıyor — P0 · Organizasyon

**Mevcut:** A1 §4 AI için “kod ve refaktör tamamen yapar” diyor; 04 §2 ve §14, görünürlük servisinin elle incelenmesini ve kötü niyetli testi zorunlu kılıyor. İki ifade birlikte yanlış güven verebilir.

**Düzeltme:** AI kod taslağı/uygulaması üretir; insan **davranışı, sunucu yetkisini, kayıt sonuçlarını ve gerçek cihazı** inceler. Her değişiklikte bir yapıcı, farklı bir inceleyen ve çalıştırılmış bir kabul denemesi olsun. Otomatik testler hata yakalar; eğlence kararı için insan testi şart.

**Belgeler:** A1 §3–4 ve §6, A2 §2, §6–7, 04 §14–16.

### IS-03 — Kod ve sahnenin iki ayrı esas kaynak olması senkron kaybı yaratabilir — P1 · Teknik

**Mevcut:** 04 §15 kodu Git/Rojo, sahne ve varlıkları yayımlanan place olarak tanımlıyor; haftalık yedek öneriyor. Studio'da yapılan bir değişiklik koddaki beklentiyle eşleşmeyebilir.

**Düzeltme:** Her oynanabilir teslim için eşleşen Git revizyonu, place sürümü ve kullanılan varlık listesi kaydedilsin. Kritik sahne değişiminden sonra geri alınabilir anlık yedek alınsın. Kimin yayımlama yetkisi olduğu ve hatalı sürümden dönüş yöntemi yazılsın. Aynı script'i iki kişi eşzamanlı düzenlemesin.

**Belgeler:** 04 §15, 07 §10, A1 §5.

### IS-04 — K0'daki üç arkadaş testi talebi göstermez — P0 · Ölçüm

**Mevcut:** Üç kişinin 20 dakikadan sonra devamı ve ertesi gün dönüşü ilk eğlence işareti olabilir, fakat arkadaş desteği, birlikte geliştirme isteği ve çok küçük örneklem sonucu çarpıtır.

**Düzeltme:** K0 testiyle yalnız büyük sorunları ve ekip hızını öğrenin. K1/K2'den sonra ekiple ilişkisi olmayan hedef oyuncuların giriş, ilk sahiplik, ilk karar, sıkılma ve ertesi gün geri gelme davranışını kaydedin. Küçük testte oranları kesin başarı eşiği yapmayın. Başarısızsa aynı döngüyü düzeltin; yeni sistem ekleyerek veriyi örtmeyin.

**Belgeler:** 07 §2–4 ve §12; 03 §12; 00 §11.

### IS-05 — Ölçüm planı yalnız D1 ve servetle bitmemeli — P1 · Ölçüm

**Mevcut:** 07 §12 D1/D7, oturum, işletme sahipliği ve suç oranını hedefliyor. Hangi erken adımda oyuncunun kaybedildiği ve özel iş ailesine göre fark açıklanmıyor.

**Düzeltme:** İlk oturum hunisi: oyuna giriş → ilk eylem → ilk karar → tezgâh sahibi → ilk yükseltme → isteyerek başka işe geçiş. İlk 60 ve 180 saniye terk, seçim süresi, tekrar oynanan eylem, ertesi gün dönüş ve cihaz türü ayrı izlenir. Nitel gözlemlerle birlikte yorumlanır. Roblox'un güncel benzer oyun kıyasları anlamlı oyuncu trafiği oluştuktan sonra kullanılır; küçük testte kendi ham sayılarınızı saklayın.

**Belgeler:** 07 §2 ve §12, 03 §12, 04 §14, 06 §4.12.

### IS-06 — İlk 30 gün haftalık güncelleme sözü ekip kapasitesi görülmeden veriliyor — P2 · Organizasyon

**Mevcut:** 07 §9 ilk 30 gün haftada en az bir güncelleme istiyor; aynı belge gerçek üretim süresi bilinmeden takvim verilmemesini doğru biçimde söylüyor.

**Düzeltme:** Yayın öncesi birkaç doğrulanmış küçük güncellemeyi hazır tutun; güncelleme sıklığını K0–K5'te ölçülen sürdürülebilir hıza bağlayın. Hata onarımı ve veri güvenliği, yeni içerik takviminden önce gelir. “Haftalık güncelleme” vaat değil hedef olsun.

**Belgeler:** 07 giriş, §9–11, A3 §5.

### IS-07 — Platform, bölge, yaş ve ücret bilgileri tarihli kontrol olarak kalmalı — P2 · Dış doğrulama

**Mevcut:** A3 çok sayıda güncel Roblox ve Türkiye bilgisini içeriyor ve bazılarını [ÇELİŞKİLİ]/[VARSAYIM] işaretliyor. Yaş etiketinin oyuncu havuzuna etkisi ve yayımlama koşulları değişebilir. 16+ hedefi bir ürün tercihidir, 16 yaş altının hiçbir ilgisi olamayacağı kanıtı değildir.

**Düzeltme:** A3'ün doğrulama durumlarını silmeyin. Yayından hemen önce doğrudan resmî Roblox yayın, olgunluk, DevEx ve özel sunucu sayfalarını; Türkiye erişimini gerçek bağlantı ve güncel resmî kaynaktan kontrol edin. Kitle kararını oyuncu testiyle ilişkilendirin. Marka isimlerini ve ses/varlık lisanslarını ayrıca doğrulayın. Bu çalışma dosyası hukuki uygunluk belgesi değildir.

**Belgeler:** A3 §1–7, 00 §5–8, 05 §7, 07 §8, 08 §12.

### IS-08 — Ekip sahipliği ve gelir paylaşımı somutlaşmadan para vaadi verilmemeli — P1 · Organizasyon

**Mevcut:** Topluluk sahipliği ve yazılı paylaşım uyarısı doğru; ayrılan üyenin yaptığı kod/varlık, erişim, karar ve gelir hesabı somut anlaşmaya bırakılmış.

**Düzeltme:** Üretim rolü, varlık kullanım izni, hesap erişimi, ayrılma ve yayın yetkisini basit yazılı anlaşmada netleştirin; 18 yaş altı üyelerin velileriyle uygun süreç yürütün. Oyun ilk küçük testi yapmadan bekletilmesin, fakat gelir ve ortak mülkiyet oluşmadan bu başlık kapatılmasın.

**Belgeler:** 00 §8, 07 §10, A3 §1 ve §4.

## 9. Dosya dosya değişiklik haritası

Bu tablo sonraki düzenleyicinin **hangi belgeyi neden açacağını** gösterir. Önce KARARLAR içindeki UK ve ORTAK hükümlerini kontrol edin; yeni bir öneriyi kullanıcı kararı gibi göstermeyin.

| Dosya | Zorunlu işlem |
|---|---|
| **OKU-ONCE.md** | Yeni iyileştirme dosyasının rolünü belirt; “tasarım doğrulandı” ifadesini oyun testi sanılmayacak şekilde koru. |
| **KARARLAR.md** | UK kayıtlarına dokunmadan yeni kararlar için kimlik, kaynak, gerekçe, test sonucu ve etkilenen belge alanı ekle. Açık konuları aşama kapısına bağla. |
| **DEGISIKLIK-GUNLUGU.md** | v3 → sonraki sürüm değişimlerini dosya dosya yaz; tarihsel v2 → v3 kaydını silme. “Yedi çıktı” hatasını düzelt. |
| **EKIP/00** | İlk 5 dakika değer önerisini ve iki oynanabilir hipotezi netleştir; imza sistemlerini “hedeflenen ve test edilecek” olarak anlat. Sekiz değişmez kuralı koru. |
| **EKIP/01** | İlk sahiplik, aktif/NPC/çevrimdışı döngü, her seviyenin yeni davranışı, ana işletmenin fiziksel görünürlüğü ve zaman çizelgeleri. |
| **EKIP/02** | Çanta deneyi, polis taciz sınırları, şüphe işaretleri, düşük hasarlı çatışmanın süresi, aklama kararının gerçek bedeli ve çok hesap istismarı. |
| **EKIP/03** | Brüt–katkı–net tanımı, tezgâh maliyeti, arketip simülasyonu, suç oranı, çevrimdışı hesap, konfigürasyonun açık/gizli ayrımı. |
| **EKIP/04** | Tek esas para kaydı, olay kutusu, işlem kurtarma, kritik kayıt, zamanlanan dava, sunucuya özel ayar, aşama bazlı performans ve gerçek davranış testleri. |
| **EKIP/05** | Katman başına erişilebilir bölge ve yuvalar, Oldport bağımlılıkları, üç yoğun merkez, kurumların isteğe bağlı kullanım değeri, görsel ölçü standardı. |
| **EKIP/06** | Kademeli telefon, mobil girdi, telefon yokken adalet/güvenlik erişimi, açıklanabilir kayıp ve kısa karar zaman çizelgesi. |
| **EKIP/07** | 0A/0B ayrımı, K1 kapasitesi, K3 alt deneyler, davranış kapıları, gerçek yedi kişilik sorumluluk dağılımı, yayın sonrası sürdürülebilir güncelleme. |
| **EKIP/08** | Yeni aşama/oyun terimlerini tek biçimde adlandır; iç ekip metnindeki gerçek adlar ile oyunda yasak olan marka kullanımını ayır. |
| **EKIP/09** | K3 geçici sonuç ile gerçek hükmü ayır, delilin iç kimlik kontrolünü oynanabilir gözlemden ayır, çevrimdışı sırayı ve itiraz erişimini belirt, kaçışı test et. |
| **EKIP/10** | Her iş için oynanış sözleşmesi, üç tam dal önceliği, K2 deponun erişilebilir yeri, sonraki 24 dalın özellik bağımlılıkları. |
| **OZEL/A1** | AI'nın kod üretimi ile insanın inceleme sorumluluğunu ayır; değişen aşamalara göre test senaryolarını düzenle. |
| **OZEL/A2** | Yeni veri şeması, sunucuya özel ayar, K3 geçici ceza ve test kapsamı değiştikten sonra promptları güncelle; promptlar eski kuralları yeniden üretmesin. |
| **OZEL/A3** | Pazarlama deneyini ve doğrulanacak gelir/yaş varsayımlarını yaz; dış koşulları yayın öncesi yeniden denetle. |
| **OZEL/ARSIV** | Tarihsel rapor olarak bırak; yeni hüküm veya uygulama talimatı için kullanma. |

## 10. Sonraki düzenleyici için uygulanacak işlem sırası

1. Kaynak v3 paketinin bir kopyası üzerinde çalış; 18 dosyanın hepsini say ve aç. Bu raporu on dokuzuncu kaynak olarak gör, fakat eski belgelerin üstünde yeni bir kullanıcı kararı sayma.
2. KARARLAR.md UK kayıtlarını koru. Çelişki, tasarım hipotezi, hesap hatası, dış doğrulama ve ölçüm isteğini birbirine karıştırma.
3. Önce **OYN-01–04, SIRA-01–05, EKO-01–02, TEK-01–06 ve TEK-11** maddelerini çöz. Bu temeller değişmeden diğer belgeye toplu metin ekleme.
4. Eğlenceyi sistem sayısıyla değil oynanabilir kararla iyileştir. Her yeni öneri için şu soruları yanıtla: Oyuncu ne seçiyor? Ne biliyor? Bedeli ne? Ne değişiyor? Arkadaşı bunu nasıl görüyor? Tek başına da çalışıyor mu?
5. İşletme kataloğundaki 24 dalı silme. Her biri için “vizyon / ayrı prototip / kapalı test / yayın” durumu koy; yalnız gerçekten tamamlananı yayın listesine al.
6. Bir sayıyı değiştirdiğinde 03 §14, örnek hesaplar, 01 ilerleme tablosu, 02 suç/sağlık, 09 ceza süreleri, 07 kapı ölçümleri ve A2 promptlarını birlikte tara.
7. Platform iddiası ekliyorsan kaynak URL, kontrol tarihi ve güven düzeyi yaz. Dış veriyi oyunda test edilmiş başarı gibi sunma.
8. Dosya dosya değişiklik listesi üret; bütün çapraz referansları, isimleri, aşama bağımlılıklarını ve örnek hesapları kontrol et.
9. Son paketi gerçek bir oyuncu ilk kez giriyormuş gibi oku. İlk 5 dakika, 20 dakika, ikinci gün, ilk iki işletme ve ilk suç/mahkeme deneyimini ayrı ayrı anlatamıyorsan düzenleme bitmedi.
10. Bir sonraki sürümün sonunda **uygulanan, ertelenen, reddedilen ve oyuncu testini bekleyen** maddeleri ayrı tabloda ver. Bütün sorunların çözüldüğünü iddia etme; oyun testi yapılmadıysa bunu açık yaz.

## 11. Test kapıları ve kabul koşulları

| Kapı | Geçmeden önce görülmesi gereken kanıt | Karar |
|---|---|---|
| **0A: sahiplik** | Ekibi tanımayan oyuncu ilk eylemi ve ilk sahiplik yolunu anlar; 20 dakika sonra neyi büyüteceğini anlatır; gerçek sıkılma noktaları kayıtlıdır. | Tutmazsa önce tezgâh döngüsünü düzelt. |
| **0B: bilgi gerilimi** | İki taraf seçimlerini gerekçelendirebilir; masum oyuncu reddetme hakkını anlar; etkileşimi yeniden oynamak isteyenler gözlenir. | Tutmazsa tam polis/mahkeme mimarisini geciktir. |
| **1: veri ve devir** | Kritik satın alma ve işlem kimliği çoklu giriş, kapanma ve hata altında çoğalmaz; oyuncu ertesi gün işletmesini bulur ve çalışana devretmenin bedelini anlar. | Kayıt güvensizse yeni iş kolu ekleme. |
| **2: çeşitlilik** | Market ile ikinci iş farklı kararlar yaratır; NPC teslim alternatifi çalışır; K2 tesliminin haritada gerçek başlangıcı vardır. | Yalnız farklı tabela çıkıyorsa dalı iyileştir. |
| **3: güven ve suç** | Suçlu riskini anlar; masum çalışabilir; polis kendine gerekçe uyduramaz; yaralanma oyuncuya aşırı bekleme cezası gibi gelmez. | Taciz ve veri açığı varsa yayına ilerleme. |
| **4: adalet** | 09 §14'ün 13 kabul senaryosu geçer; oyuncu karar sebebini kendi sözüyle açıklar; çevrimdışı infaz, itiraz ve kaçış tekrar girişte tutarlıdır. | Haksız hüküm riski varsa önce onu çöz. |
| **5–6: dış talep** | Ekip dışındaki hedef oyuncular ilk dakikalarda kalıyor, ertesi gün dönüyor; telefon performansı ölçülmüş; üç tam dal ve sosyal etkileşim değer görüyor. | Büyümeyi gözlenen davranışa göre seç. |

Bu tabloda belirli bir “başarı yüzdesi” verilmedi: v3'ün küçük örneklemleri ve gerçek oyun verisi böyle bir kesinliği desteklemiyor. Ölçüm genişlediğinde Roblox Creator Hub'daki **Retention**, **Discovery** ve **Analytics Dashboard** belgelerinin güncel tanımlarını ve benzer oyun kıyaslarını kontrol edin:

- https://create.roblox.com/docs/production/analytics/retention
- https://create.roblox.com/docs/discovery
- https://create.roblox.com/docs/production/analytics/analytics-dashboard
- Veri kaydı için: https://create.roblox.com/docs/cloud-services/data-stores

## 12. Nihai değerlendirme

Baycrest'in değeri “çok sistem var” cümlesinde değil; **oyuncunun küçük bir şeyi sahiplenip görünür kararlarla büyütmesinde ve şehrin bu kararlara anlaşılır tepki vermesinde**. Suç, tanık, mahkeme ve anayasa bu çekirdeği derinleştirebilir. Bugünkü belgelerin en büyük açığı, bu iki çekirdeğin oyuncuya geç gösterilmesi ve ikisi eğlenceli bulunmadan ağır mimarinin tamamının planlanmasıdır.

Önce iki küçük deneyin oynanabilirliğini kanıtlayın. Sonra veri, meslek çeşitliliği, suç ve adaleti ayrı kapılardan geçirin. Vizyonu küçültmek için değil, gerçekleşmesini mümkün kılmak için sırayı değiştirin.
