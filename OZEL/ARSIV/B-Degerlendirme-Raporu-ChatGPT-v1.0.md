# BAYCREST — İnceleme, kullanıcı kararları ve geliştirme raporu

**Rapor sürümü:** 1.0  
**Tarih:** 24 Eylül 2026  
**Hazırlayan:** Bu sohbetin ilk bağımsız değerlendiricisi — ChatGPT/Codex  
**Amaç:** BAYCREST-v2.zip dosyasını ayrıca inceleyen ikinci yapay zekâya, bu sohbetteki bulguları, kullanıcı kararlarını ve bunlardan türetilen tasarım önerilerini eksiksiz aktarabilmek.  
**Durum:** İnceleme ve karar aktarımı. Kaynak ZIP ve içindeki belgeler düzenlenmedi. Oyun kodu yazılmadı veya çalıştırılmadı.

## 1. İkinci değerlendirici için okuma talimatı

Bu rapor, kaynak ZIP'in yerine geçen yeni bir ürün şartnamesi değildir. ZIP'teki tasarım, ilk bağımsız inceleme ve kullanıcının sonradan yaptığı açıklamalar arasında bir köprüdür. Kendi incelemenle karşılaştır; aynı görüşü iki yapay zekânın paylaşmasını doğruluk kanıtı kabul etme.

Özellikle şu ayrımları koru:

- **BELGE:** BAYCREST-v2.zip içinde açıkça yazan mevcut tasarım.
- **BULGU:** İlk değerlendiricinin belge karşılaştırmasından, hesaplamadan veya dış kaynak kontrolünden çıkardığı sonuç.
- **UK:** Kullanıcının bu sohbette açıkça ifade ettiği karar.
- **DK:** Kullanıcının öneri ve seçim yetkisini devretmesi üzerine benimsenen çalışma yönü. Kullanıcının tek tek söylediği bir özellik gibi aktarılmamalıdır.
- **TY:** Yeni türetilmiş tasarım önerisi. Kullanıcının genel yetkilendirmesi altında önerilen başlangıç çözümüdür; özellikle sayısal değerleri prototipte sınanmalıdır.
- **AÇIK:** Mevcut kanıtlarla kesinleştirilemeyen veya prototipten sonra belirlenecek konu.

Kullanıcı, cevaplamadığı tercihlerde ilk değerlendiricinin önerilerini kabul edeceğini bildirmiştir. Bu, önerilen yönler için ilerleme yetkisi verir; ölçülmemiş performans, süre, maliyet veya başarı garantisi oluşturmaz. Yeni rapordaki sayısal örnekler nihai denge değeri değildir.

Kullanıcının açık kararları, bu rapordaki tasarım önerilerinden ve eski ZIP'in çelişen hükümlerinden üstündür. Yeni kararları kaynak belgelere uygulama aşaması ayrıca yürütülecektir. Bu teslim yalnızca rapordur.

## 2. İnceleme kapsamı ve doğrulama sınırı

ZIP'teki 13 Markdown belgenin tamamı okundu. Toplam 2.694 satır ve sıkıştırılmamış 109.722 bayt metin bulunmaktadır. ZIP'in bütünlük kontrolü başarılıdır. Bozuk, şifreli veya okunamayan dosya saptanmadı. Arşivde üç dizin kaydı ve 13 dosya vardır.

| Dosya | Satır | Kapsam |
|---|---:|---|
| OKU-ONCE.md | 60 | Paket, sürüm ve belge haritası |
| EKIP/00-BASLA-BURADAN.md | 114 | Vizyon, temel ilkeler, kapsam |
| EKIP/01-SAHIPLIK-VE-ISLETME.md | 237 | Sahiplik, işletmeler, NPC çalışanlar, ilerleme |
| EKIP/02-ENVANTER-VE-SUC.md | 313 | Envanter, görünürlük, suç, denetim |
| EKIP/03-EKONOMI.md | 191 | Gelir, gider, denge, Robux |
| EKIP/04-TEKNIK.md | 295 | Servisler, veri, NPC, güvenlik |
| EKIP/05-HARITA-SANAT-ANIMASYON.md | 290 | Harita, sanat, araçlar, animasyon |
| EKIP/06-ARAYUZ-VE-SES.md | 204 | Arayüz, etkileşim, dil, ses |
| EKIP/07-YOL-HARITASI.md | 239 | Aşamalar, kapılar, ekip, ölçümler |
| EKIP/08-SOZLUK.md | 142 | Kavramlar ve isimlendirme |
| OZEL/A1-AI-IS-AKISI.md | 195 | Yapay zekâ ve Studio iş akışı |
| OZEL/A2-PROMPT-KUTUPHANESI.md | 263 | Geliştirme ve inceleme şablonları |
| OZEL/A3-PLATFORM-VE-PARA.md | 151 | Yayın, yaş, gelir ve pazarlama |

Paketin genel sürümü 2.0'dır; OZEL belgeleri 1.0 başlığı taşır. Ayrı sürümlenme mümkün olduğundan bu durum tek başına hata sayılmadı; ileride paket manifestinde açıklanmalıdır.

Arşivde çalıştırılabilir oyun kaynakları, Roblox sahnesi, gerçek varlık dosyaları veya doğrulanmış performans/test sonuçları yoktur. Markdown içindeki kod parçaları, uygulanmış yazılımın varlığını kanıtlamaz. Bu rapordaki teknik riskler tasarım riskleridir; oyunda gerçekten gözlenmiş çalışma hataları gibi aktarılmamalıdır.

Referanslarda `01 §2`, EKIP/01-SAHIPLIK-VE-ISLETME.md dosyasının ikinci bölümünü ifade eder. A1–A3 referansları OZEL klasöründedir.

## 3. Projenin anlaşılan kimliği

### 3.1 Belgelerde açıkça bulunanlar

Baycrest, Verania adlı kurgusal ülkenin stilize Akdeniz liman şehrinde geçen Roblox şehir hayatı oyunudur. Ana döngü **sahiplen → büyüt → otomatikleştir → yeni bir şey sahiplen** şeklindedir. İşletme, çalışan, araç ve ev sahipliği önemlidir. Suç isteğe bağlıdır. Polislik ve mali soruşturma ayrı oyun alanlarıdır.

Farklılaşma girişimleri, bedende fiziksel konumu olan envanter; eşyaların görünürlüğü; NPC tanıklığı; işletme cirosuna bağlı kirli para sistemi ve mali denetimdir. Kalıcı varlıkların normal oyun cezaları yüzünden tamamen silinmemesi temel ilkedir.

Mobil öncelikli arayüz, İngilizce birincil ve Türkçe ikincil dil, stilize görsel yön, NPC destekli düşük nüfuslu şehir planlanmaktadır. A3'te 16+ ürün hedefi seçilmiştir. Uçak, havalimanı, serbest inşa aracı ve büyük iç mekânlı gökdelenler kapsam dışıdır.

### 3.2 İlk değerlendiricinin çıkarımı

En güçlü değer önerisi, oyuncunun şehirde kendisine ait ve gelişimini görebildiği bir hayat kurmasıdır. Çanta, tanık ve denetim bunu zenginleştiren sistemlerdir. Belgelerde suç tarafı, yasal işletmeciliğin günlük kararlarından daha ayrıntılıdır. Sivil yaşama da eşdeğer oyun derinliği verilmelidir.

### 3.3 Doğrulanmamış varsayımlar

"Rakiplerde yok", "oyuncuların %60–70'i ciddi suç işlemez", "asıl gelir özel sunuculardan gelir", belirli NPC kapasiteleri ve çok kısa varlık üretim süreleri proje verisiyle kanıtlanmamıştır. Bunlar rakip incelemesi, kullanıcı testi veya teknik ölçüm gerektiren hipotezlerdir.

## 4. Kullanıcının son mesajından kesin kararlar

Aşağıdakiler anlamı korunarak aktarılmıştır; yazım hataları düzeltilmiştir. Kullanıcının “soyulma riski” bağlamındaki örneği, müteahhitliğin kalas çalınmasına indirgenmemesidir.

| Kimlik | Açık kullanıcı kararı | Tasarıma etkisi |
|---|---|---|
| UK-01 | Cevaplanmayan tercihlerde önerilen yön kabul edilecek. | Rutin tasarım seçimlerinde tekrar onay istemeden gerekçeli varsayımlarla ilerlenebilir. |
| UK-02 | Her meslek veya işletme aynı soyulma riski altında olmayacak. | Riskler iş koluna göre ayrılacak; müteahhitlik için zorunlu malzeme hırsızlığı çekirdek döngü yapılmayacak. |
| UK-03 | Kurgusal ülkenin anayasası olacak. | Suç, yetki ve ceza sistemi kurallı bir oyun hukukuna bağlanacak. |
| UK-04 | Mahkeme mimarisi değerlendirilecek; oyuncu katılmasa veya çevrimdışı olsa bile dava ilerleyip sonuçlanabilecek. | Dava akışı oyuncunun çevrimiçi olmasına bağımlı olmayacak. |
| UK-05 | Doğru delillere dayanan karar oyuncuyu hapse gönderebilecek. | Delil, karar ve infaz birbirinden ayrılacak; sırf katılmama suç kanıtı olmayacak. |
| UK-06 | Hapisten birden fazla çıkış yolu olacak; çıkmak tek hamlede çok kolay olmayacak. | Normal tahliye, koşullu tahliye, itiraz ve kaçış farklı kurallara bağlanacak. |
| UK-07 | Hapisten kaçan oyuncu hakkında kaçış raporu oluşacak. | Kaçış sunucu değiştirerek silinemeyen, fakat sonsuz cezaya da dönüşmeyen bir vaka olacak. |
| UK-08 | Cezalar ve süreler çok ağır olmayacak. | Kısa, ölçülü ve anlaşılır yaptırımlar tercih edilecek. |
| UK-09 | Ekibin gerçek üretim kapasitesi ilk küçük prototipte öğrenilecek. | Kişi/saat, kesin bitiş tarihi ve bütçe tahmini şimdi uydurulmayacak. |
| UK-10 | Hapishane, adalet sarayı ve yeterli işletme alanı harita planında bulunmalı. | Şehir planı mevcut birkaç dükkân cephesiyle sınırlanmayacak; kurum alanları ayrılacak. |
| UK-11 | İşletme seçenekleri dar olmamalı; yeni işletme ve özellik fikirleri geliştirilmeli. | Geniş ürün kataloğu, ortak altyapı ve aşamalı uygulanma birlikte planlanacak. |
| UK-12 | Bu sohbetin incelemesi, fikirleri ve kullanıcı kararları indirilebilir raporla ikinci yapay zekâya aktarılacak. | Bu dosya, ortak değerlendirme ve hibritleme girdisidir. |

### 4.1 Önceki yedi sorunun durumu

| Önceki konu | Son durum |
|---|---|
| Sivil oyuncunun suç riski | UK-02 ile güncellendi: herkese aynı risk yok; sektöre göre anlamlı risk. |
| Çevrimdışı işletme kaybı | Kullanıcı özel olarak çevrimdışı mahkeme/infaz istedi. Bu, çevrimdışı soygun talebi değildir. İlk sürüm için önceki sınırlı kazanç ve korunan işletme önerisi DK olarak korunuyor. |
| İlk sahipliğin zamanı | İlk oturumda küçük sahiplik deneyimi DK olarak kabul ediliyor; kesin dakika prototipte belirlenecek. |
| Oyuncu polisin yetkisi | Sistem doğrulamalı yetki DK olarak kabul ediliyor; mahkeme ve infazla tamamlanıyor. |
| Ekip kapasitesi | UK-09: ilk küçük prototipte ölçülecek. |
| Ücretli ekonomik kapasite | Eşit ekonomik potansiyel, kozmetik/topluluk araçları yönü DK olarak kabul ediliyor. |
| Korunacak ve eklenecek fikirler | Anayasa, mahkeme, hapishane, kaçış raporu, kısa cezalar, geniş işletme kataloğu ve mesleğe özgü riskler UK olarak eklendi. |

## 5. Korunacak güçlü fikirler

1. **Kalıcı sahiplik:** Normal oyun cezaları veya ara verme nedeniyle evin, şirketin ve aracın tamamen silinmemesi.
2. **Görünürlüğün oyun kuralı olması:** Gizli bilgi istemciye yayılmadan, oyuncunun gördüğünden karar üretmesi.
3. **Düşük nüfusta işleyen şehir:** NPC'lerin gerçek oyuncu yokluğunda asgari hizmeti sürdürmesi.
4. **Farklı polislik deneyimleri:** Takip, trafik ve mali soruşturmanın farklı becerileri ödüllendirmesi.
5. **Küçük prototiple öğrenme:** Çekirdek oyun ve ekibin kapasitesi ölçülmeden büyük süre taahhüdü verilmemesi.
6. **Sivil yaşama öncelik:** Suç işlemeyen oyuncunun kendi başına anlamlı ve çeşitli hedeflere sahip olması.

## 6. İlk bağımsız incelemenin 26 bulgusu ve güncel durumu

Bu bölüm önceki sohbet raporunun içerik olarak aktarımıdır. Kimlikler korunmuştur. Her bulguya kullanıcı açıklamalarından sonraki durum eklenmiştir.

### BC-01 — Cephe dağıtımı ve paralel sunucular

- **Dayanak:** 01 §2; 04 §3; 05 §2.3.
- **Tespit:** Ayrılan oyuncunun cephesi serbest bırakılmıyor. Sunucu geçmişte girip çıkan oyuncuların işletmeleriyle dolabilir. Aynı işletmenin farklı sunuculardaki kopyalarının kazanç veya soygun işlemesi, tek kalıcı kayıtla çatışır. Kapasite, işletme sayısı yerine işletme sahibi sayısıyla hesaplanmış.
- **Öneri:** Şirket kimliğini fiziksel cepheden ayır; gerçek işletme durumunun tek yetkili yazarı olsun. Çevrimdışı kazancı kayıt üzerinden hesapla. Boş yer kalmadığında alternatif yerleşim sağla; gelir hakkını belirsiz kuyruğa bağlama.
- **Gerekçe:** Çifte gelir, çelişen stok ve dolu sunucu sorununu önler.
- **Bedel/risk:** Gerçek çevrimdışı soygun korunursa sunucular arası işlem maliyeti artar.
- **Öncelik/durum:** Kritik. DK kabul; UK-10 nedeniyle daha geniş kapasite planıyla geliştirildi. Mahkeme kayıtları ayrı yaşam döngüsüne sahip olacak.

### BC-02 — Ekonomi aritmetiği ve gelir birimi

- **Dayanak:** 03 §3–6; 01 §4.4.
- **Tespit:** 85 × 0,35 × 480 = 14.280 Crown. Bu, 20 dakikalık 1.700 Crown aktif kazançtan az değildir; aynı üçüncü seviye işletmede 168 dakikaya eşittir. Ciro, ücret, gider ve net kâr birbirine karışıyor.
- **Öneri:** Yasal satış, stok maliyeti, ücret, ruhsat/gider ve net kârı ayrı hesapla. Aktif, NPC ve çevrimdışı üretim aynı hesap sözleşmesini kullansın.
- **Gerekçe:** Fiyat, büyüme ve suç dengesi doğru temele oturur.
- **Bedel/risk:** Mevcut sayılar ve ilerleme süreleri yeniden hesaplanmalı.
- **Öncelik/durum:** Kritik. DK kabul; yeni kesin denge rakamı belirlenmedi.

### BC-03 — Kasa, çevrimdışı birikim ve soygun ödülü

- **Dayanak:** 02 §12; 03 §4–5.
- **Tespit:** Son 10 dakikanın gelirini kasada tutup fazlasını bankaya aktarma, sekiz saatlik çevrimdışı kasa birikimi ve 8.000–90.000 Crown soygun hedefleri aynı modelde açıklanmıyor. Gelir kasa akışına eşitse 35 × 10 = 350 Crown; 15.000 Crown bakkal kasasıyla uyuşmaz. Ciro farklıysa dönüşüm eksiktir.
- **Öneri:** Soyulabilir kasa, korunan kazanç ve çevrimdışı birikimi ayrı tanımla. Sistem hedefleri ile oyuncu işletmelerini ayır. Sigortayı benzersiz olaya ve doğrulanmış kayba bağla.
- **Gerekçe:** Mağdurun kaybı ve saldırganın ödülü öngörülebilir olur.
- **Bedel/risk:** Anlaşmalı soygun/tekrar sigorta ödemesi kontrolleri gerekir.
- **Öncelik/durum:** Kritik. UK-02 ile geliştirildi: her sektörde soyulabilir kasa bulunmayacak.

### BC-04 — Aklama kotası ve risk sınırı

- **Dayanak:** 02 §9–10; 03 §4.2, §10; 06 §4.4.
- **Tespit:** %20 bir yerde risksiz bölge, başka yerde kesin tavan. %20–40 riskli alan böylece erişilemez olabilir. Başkasının parasının kotası ve oyuncunun kendi kotası birlikte açıklanmamış; aklanan tutarın ciroya eklenmesi kendi kendini büyüten kapasite üretebilir.
- **Öneri:** Kotayı doğrulanmış yasal satışlara bağla. İşletmenin bütün kaynakları ortak kotayı kullansın. Risksiz/riskli/yasak miktar farklı kavramlar olsun; dönem sınırı sunucu değişimiyle sıfırlanmasın.
- **Gerekçe:** Ekonomi açığı ve anlamsız kesin güvenli rutin azaltılır.
- **Bedel/risk:** Formül, arayüz ve işlem kaydı yeniden tasarlanır.
- **Öncelik/durum:** Kritik. DK kabul. Suç tanımı ve mahkeme deliliyle ilişki kurulacak.

### BC-05 — Çanta sorgusu ve ret hakkı

- **Dayanak:** 02 §4, §8, §10.2; 06 §4.1.
- **Tespit:** Ret suç değilken denetim dayanağına dönüşebiliyor. Polis tekrar tekrar sorarak kendi gerekçesini oluşturabilir. Süre aşımı ve bağlantı sorunu ret sayılıyor; uzaklaşma otomatik aranma üretiyor.
- **Öneri:** Gönüllü soru, gerekçeli durdurma ve kanıta bağlı müdahaleyi ayır. Ret tek başına suç veya mahkûmiyet gerekçesi olmasın. Tekrar sınırı ve bağlantı davranışı tanımla.
- **Gerekçe:** Polis rolü taciz veya zorunlu itaat mekanizmasına dönüşmez.
- **Bedel/risk:** Alternatif delil toplama akışları gerekir.
- **Öncelik/durum:** Kritik. DK kabul; UK-03 anayasasının temel güvencelerinden biri yapıldı.

### BC-06 — Suçun sonuç ve toparlanma akışı

- **Dayanak:** 02 §6–10; 01 §5.1, §8.
- **Tespit:** Ölüm, teslim, bağlantı kopması, rol/sunucu değişimi, delil yetersizliği, tahliye ve eşya iadesi tamamlanmamış. Oyuncu kendi dosyasını polis rolünde yönetebilir.
- **Öneri:** Olay → delil → dosya → karar → infaz → kapanış akışı kur. Aktif vaka rol değişiminde silinmesin. Kişi kendi dosyasını soruşturamasın.
- **Gerekçe:** Cezadan kaçış açıkları ve kilitlenmiş oyuncu durumları azalır.
- **Bedel/risk:** İlk sürümde az sayıda suç ve ceza ile başlanmalı.
- **Öncelik/durum:** İlk suç sürümü için gerekli. UK-03–08 ile genişletildi; ayrıntılar bölüm 8'de.

### BC-07 — Bilgi görünürlüğü ve tanık kayıtları

- **Dayanak:** 02 §4.2, §7; 04 §1; 05 §7.4; A2 §3.
- **Tespit:** Açık çanta/bagaj çevreye görünür denirken teknik şema yalnızca sahibi ve polise izin veriyor. Tanık robot resmi olay anı yerine canlı avatar olarak tarif edilmiş. Görülen nakit ile suç bağlantısı ayrılmamış.
- **Öneri:** Sahip, polis, yakındaki oyuncu, NPC ve kamera için bilgi erişim matrisi oluştur. Tanık olay anının görünümünü saklasın. Kimlik, miktar ve suçla bağlantı ayrı kanıtlar olsun.
- **Gerekçe:** Bilgi oyunu ve mahkeme aynı gerçekliğe dayanır.
- **Bedel/risk:** Menzil, görüş hattı ve izin süresi yönetimi gerekir; açıklanmış bilgi istemciden geri alınmış sayılamaz.
- **Öncelik/durum:** Kritik. DK kabul; mahkeme delil modelinin temeli.

### BC-08 — Envanterin sivil kullanım yükü

- **Dayanak:** 01 §7; 02 §2–3; 04 §4; 08 §8.
- **Tespit:** İki cep, telefon/kimlik/anahtar/cüzdan için yetersiz olabilir. Uzun eşyanın elde kullanımı ve yarım nakit slotu tanımsız. Kılıfsız silahın otomatik ele geçmesi yanlış arayüz hareketini suç olayına çevirebilir.
- **Öneri:** Kimlik/anahtarlık gibi temel işlevleri sadeleştir. Kullanım ve taşıma durumlarını ayır. Nakit yığınları ve yuvarlama kuralı belirle. Tehlikeli görünürlük değişimini önceden göster; başarısız işlem eşyayı kaybettirmesin.
- **Gerekçe:** Anlamlı seçim korunurken angarya azalır.
- **Bedel/risk:** Bazı fiziksel gerçekçilik ayrıntıları sadeleşir.
- **Öncelik/durum:** İlk sürüm için gerekli. DK kabul.

### BC-09 — Zaman, borç ve çevrimdışı ceza

- **Dayanak:** 01 §3.2, §4, §9; 03 §5–6; 05 §1.4.
- **Tespit:** Gün 48 dakika, aylık maaş/ruhsat var. Ay 30 oyun günü kabul edilirse 24 gerçek saate gelir. Uzun ara, koruma ilkesine rağmen ağır borç ve çalışan kaybı üretebilir. Gizli maaş kesintileri açıklanabilir sonuç ilkesiyle gerilimli.
- **Öneri:** Görsel gün, ekonomik dönem, dava süresi ve infaz süresini ayır. Üretim durduğunda gider sınırsız birikmesin; açık hesap dökümü ve işletmeyi dondurma olsun.
- **Gerekçe:** Oyuna dönüş yalnızca cezadan kaçınmaya dayanmaz.
- **Bedel/risk:** Giriş baskısı azalır; olumlu hedefler güçlendirilmelidir.
- **Öncelik/durum:** Kritik. DK kabul. UK-04 gereği mahkeme çevrimdışı ilerler; bu, işletme borcunun sınırsız ilerlemesi anlamına gelmez.

### BC-10 — Servete bağlı otomatik fiyatlandırma

- **Dayanak:** 03 §8; 07 §9.
- **Tespit:** Eski oyuncunun zenginliği başlangıç fiyatlarını artırırsa yeni oyuncu cezalandırılır. Ortalama birkaç aşırı hesaptan etkilenebilir. Para üretimi/yok oluşu oranında 1,2 eşiği tek başına enflasyon kanıtı değildir.
- **Öneri:** Başlangıç fiyatlarını sabit tut; oyuncuları ilerleme aşamalarına ayırarak satın alma süresi, net gelir ve servet dağılımını izle. Transferi para üretiminden ayır.
- **Gerekçe:** Müdahale gerçek sorunu hedefler.
- **Bedel/risk:** Daha anlamlı telemetri ve insan değerlendirmesi gerekir.
- **Öncelik/durum:** Kritik. DK kabul.

### BC-11 — Robux ile işletme slotu avantajı

- **Dayanak:** 01 §3.1; 03 §2, §9.
- **Tespit:** Aynı net getirili iki işletmeye üçüncüsünün eklenmesi işletme gelirini %50 artırır. "Daha geniş kazanmak" toplam ilerlemeyi hızlandırıyorsa ekonomik avantajdır.
- **Öneri:** Eşit ekonomik potansiyel için ücretli üretim slotu kaldırılıp kozmetik ve topluluk araçları değerlendirilir. Ücretli kapasite korunursa avantaj olduğu açıkça kabul edilmelidir.
- **Gerekçe:** Ürün vaadi ve gelir modeli tutarlı olur.
- **Bedel/risk:** Kozmetik talebi ölçülmelidir.
- **Öncelik/durum:** Kritik. UK-01 kapsamında DK olarak eşit ekonomik potansiyel yönü seçildi. Robux ile tahliye veya yargısal avantaj önerilmiyor.

### BC-12 — Özel sunucuların kalıcı ekonomisi

- **Dayanak:** 03 §9; 07 §5; A3 §4; kaynak K05.
- **Tespit:** Yerleşik özel sunucu sistemi Game Pass değil aboneliktir. Yönetici komutlarının kalıcı para ve sahipliğe etkisi tanımlanmamış.
- **Öneri:** Standart özel sunucu ekonomisini serbest RP/deneme modundan ayır. Serbest mod kazancı genel ekonomiye taşınmasın. Yetkiler tek tek tanımlansın.
- **Gerekçe:** Topluluk araçları genel ekonomiyi bozamaz.
- **Bedel/risk:** Ayrı kayıt alanı ve açık mod göstergesi gerekir.
- **Öncelik/durum:** Özel sunucular açılmadan gerekli. DK kabul; özel sunucu yöneticisi kalıcı ekonomide keyfî mahkûmiyet veremez.

### BC-13 — Kalıcı işlem bütünlüğü

- **Dayanak:** 04 §6; 02 §9.3, §12; kaynak K06.
- **Tespit:** pcall, oturum kilidi ve kayıt aralığı iki taraflı ödemenin yarım kalmasını çözmez. Kirli para hem envanter hem ayrı bakiye olarak tutulursa farklı doğruluk kaynakları doğar.
- **Öneri:** Para/eşya için tek esas kayıt; işlem kimliği; tekrar uygulamayı önleme; yarım işlemi kurtarma; kritik satın alma ve aktarım kontrolleri oluştur.
- **Gerekçe:** Çoğaltma ve karşılıksız kayıp azalır.
- **Bedel/risk:** İlave kayıt ve kurtarma mantığı gerekir. UpdateAsync tek başına çok kayıtlı işlemi atomik yapmaz.
- **Öncelik/durum:** Kritik. DK kabul; ceza, tahliye ve kaçış işlemleri de tekrar uygulanamaz olmalı.

### BC-14 — İstemci güvenliği kurallarının kapsamı

- **Dayanak:** 04 §1, §10; A2 §2–4; kaynak K07.
- **Tespit:** İstemciden hiçbir miktar/konum gelmemesi gereksiz genellemedir. İstemci niyet bildirebilir; sunucu doğrulamadan kabul edemez. Tek fonksiyon diğer veri sızıntısı yollarını kapatmaz.
- **Öneri:** Tür, değer, sahiplik, mesafe, yetki, sıklık ve tekrar kontrollerini işlem bazında yaz. Gizli içeriği ortak nesne/Attributes üzerinden sızdırma. Sunucuya özel bilgileri ortak ayarlardan ayır.
- **Gerekçe:** Güvenlik kelime aramaktan davranış doğrulamaya geçer.
- **Bedel/risk:** Her etkileşim için açık sözleşme gerekir.
- **Öncelik/durum:** İlk sürüm için gerekli. DK kabul.

### BC-15 — Mesajlar, tabelalar ve moderasyon

- **Dayanak:** 01 §7; 04 §3.1; 05 §2.3; 06 §4.7; kaynak K08–K09.
- **Tespit:** Planlanan serbest metinler için filtreleme, engelleme, şikâyet ve saklama kuralları eksik.
- **Öneri:** Mesajlaşmayı uygun Roblox sohbet altyapısına bağla; tabelaları sunucuda filtrele. Engelleme bütün mesaj yüzeylerinde geçerli olsun. Filtre hata verince ham metin yayımlanmasın. Moderasyon kayıtlarının erişimi ve saklama süresi sınırlansın.
- **Gerekçe:** Mevcut sosyal özelliklerin güvenli işletilmesi sağlanır.
- **Bedel/risk:** Moderasyon ve arayüz işi artar.
- **Öncelik/durum:** İlk sürüm için gerekli. DK kabul; mahkeme salonu sohbeti de bu kapsamdadır.

### BC-16 — NPC performansı ve animasyon yanlışı

- **Dayanak:** 04 §5, §8; 05 §4, §5.4; kaynak K10.
- **Tespit:** Humanoid olmadan Animator kullanılamaz ifadesi yanlış; AnimationController ile mümkündür. 100–150 NPC kapasitesi ve görünüm çeşitliliğinin sıfır maliyeti ölçülmemiştir.
- **Öneri:** Yaya, müşteri ve polis için uygun farklı temsil kullan. Gerektiğinde sınırlı dinamik hareketi değerlendir. Bellek, ağ, animasyon ve görüş kontrollerini gerçek cihazda ölç.
- **Gerekçe:** Yanlış yasaklar ve temelsiz kapasite vaadi kalkar.
- **Bedel/risk:** Küçük karşılaştırma prototipi gerekir.
- **Öncelik/durum:** Kritik teknik düzeltme. DK kabul; gardiyan/tutuklu NPC'ler aynı bütçeye dâhil.

### BC-17 — İlk sahiplik deneyimi ve pazarlama

- **Dayanak:** 01 §1; 07 §10; A3 §5.
- **Tespit:** İlk işletme 3–5 saatte, asıl iki varlık anı 7. saatte; hedef oturum 8–15 dakika. Tanıtımın hayat kurmayı vurgulaması istenirken örnek videolar yalnızca suç üzerinedir.
- **Öneri:** İlk oturumda küçük kalıcı sahiplik ve iş devri tattır. Büyük işletmeyi uzun vadeli hedef olarak koru. Tanıtımda sivil büyüme ve riskli yaşam birlikte temsil edilsin.
- **Gerekçe:** Ürünün değeri erken anlaşılır.
- **Bedel/risk:** Erken sahiplik büyük hedefin değerini azaltmayacak şekilde test edilmeli.
- **Öncelik/durum:** İlk sürüm için gerekli. DK kabul; ilk sahipliğin kesin süresi AÇIK.

### BC-18 — Mesleklerin eksik oynanış sözleşmeleri

- **Dayanak:** 01 §3.3, §5; 02 §11; 07 §5.
- **Tespit:** İtfaiye, tamirci, galerici ve polis yönetimi için günlük kararlar eksik. Aynı kasa/raf hattı her sektöre uymuyor. Suç yokken FCU dosyasının kaynağı tanımlanmamış.
- **Öneri:** Her meslekte eylem, karar, başarısızlık, devir ve düşük nüfus davranışı yazılsın. Ortak altyapı farklı iş döngülerini desteklesin.
- **Gerekçe:** Çeşitlilik yalnızca tabela değişimine dönüşmez.
- **Bedel/risk:** Her dal için tasarım ve test gerekir.
- **Öncelik/durum:** İlk sürüm için gerekli. UK-11 ile genişletildi; katalog bölüm 10'da, aşamalı uygulanma bölüm 12'de.

### BC-19 — Aşama kapıları ve ölçüm

- **Dayanak:** 01 §10; 07 §2–6, §10.
- **Tespit:** Katman 2 çok fazla sistemi tek kapıda topluyor. On kişilik testte bir kişi geri dönüş oranını 10 puan değiştirir; tek eşik güçlü kanıt değildir. Performans kontrolü geç kalıyor.
- **Öneri:** Envanter/sorgu, soygun/tanık, mali soruşturma ve adaleti ayrı doğrula. Ekonomi kayıtlarını erken başlat. Küçük örneklemde gözlem, daha geniş testte oranlar kullan.
- **Gerekçe:** Sorunun kaynağı anlaşılır.
- **Bedel/risk:** Daha fazla küçük kontrol noktası gerekir.
- **Öncelik/durum:** Gerekli. UK-09 doğrultusunda kaynak kapasitesi prototipte ölçülecek.

### BC-20 — Ekip, sürüm kontrolü ve AI sözleşmeleri

- **Dayanak:** 04 §9; 07 §7–8; A1; A2.
- **Tespit:** Rojo/Git, Team Create ve MCP değişikliklerinin tek doğruluk kaynağı açıklanmamış. Hatalı tasarım kuralları promptlarda mutlaklaştırılmış. AI'nın hiç ekonomi simülasyonu yapamayacağı ve tüm belgeleri okumanın daima kötü olduğu iddiaları fazla geneldir.
- **Öneri:** Kod/sahne için esas kaynak, sorumlu, inceleyen ve yayımlayan tanımlansın. Karar kimlikleri ve değişiklik günlüğü olsun. AI araç çıktısı, gerçek test ve insan tasarım kararı ayrıştırılsın.
- **Gerekçe:** Ekip ve farklı yapay zekâlar birbirinin değişikliğini ezmez.
- **Bedel/risk:** Küçük ve sürdürülebilir inceleme disiplini gerekir.
- **Öncelik/durum:** Gerekli. DK kabul; ikinci AI ile hibritleme bu rapordaki kimlikleri korumalı.

### BC-21 — Güncel platform ve mevzuat bilgileri

- **Dayanak:** A3 §1–4; 00 §6; kaynak K01–K05, K11–K14.
- **Tespit:** 500 oynanış, yaş etiketleri, DevEx yaşı, ücretsiz grup ve Türkiye düzenlemesi hakkında önemli uyuşmazlıklar var. Kontroller bölüm 7'de.
- **Öneri:** Platform zorunluluğu, proje tercihi ve varsayımı ayır. Tarihli kaynak ver; yayın öncesi değişken koşulları tekrar kontrol et.
- **Gerekçe:** Kitle ve bütçe yanlış dayanaklarla sınırlandırılmaz.
- **Bedel/risk:** Resmî kaynaklar arasında bile ayrıntı farkı olabilir; belirsizlik gizlenmemeli.
- **Öncelik/durum:** Kritik. DK kabul. Kurgusal Verania hukukuyla gerçek platform kuralları karıştırılmayacak.

### BC-22 — İsimlendirme ve kesinlik dili

- **Dayanak:** 00 §5–6; 05 §7; 06 §1–2; 08; A1; kaynak K15–K16.
- **Tespit:** Anadol ve Kartal gerçek otomotiv adlarıyla çakışıyor. Dört HUD öğesi sınırına karşı beş öğe var. Şüphe hem görünür hem gizli anlatılıyor. Takvimsiz planda iki haftalık prototip ifadesi duruyor.
- **Öneri:** İsim, kavram ve sayısal kuralları tek referanstan yönet. Çözüldü/bedava/rakipsiz/kesin ifadelerini kanıt seviyesine göre düzenle.
- **Gerekçe:** Yanlış kesinlik uygulama gereksinimine dönüşmez.
- **Bedel/risk:** İsim değişiklikleri tüm belgelerde birlikte uygulanmalı.
- **Öncelik/durum:** Gerekli. DK kabul; bu bulgu hukuki marka ihlali kararı değildir.

### BC-23 — Şehir sözleşmeleri

- **Dayanak:** İlk değerlendiricinin yeni önerisi; 01 §5, 02 §9.3.
- **Tespit/fırsat:** Yasal meslekler arasında karşılıklı ihtiyaç zayıf.
- **Öneri:** Stok taşıma, bakım, dekorasyon ve hizmet işlerini standart sözleşmelerle bağla. Ücret önceden ayrılır; teslim sunucuda doğrulanır. Oyuncu yoksa NPC alternatifi vardır.
- **Gerekçe:** Sosyal oyun polis–suçlu karşılaşması dışında gelişir.
- **Bedel/risk:** Ödeme/teslim bütünlüğü ve anlaşmalı ödül üretimi kontrolü gerekir.
- **Öncelik/durum:** Sonraki aşama; küçük örneği erken denenebilir. DK yön olarak kabul; UK-11 ile geliştirildi.

### BC-24 — İşletme uzmanlaşması

- **Dayanak:** İlk değerlendiricinin yeni önerisi; 01 §3.3, §9.
- **Tespit/fırsat:** Ortak beş seviye hattı uzun vadede tekdüzeleşebilir.
- **Öneri:** Mahalle hizmeti, yüksek hacim veya uzman ürün gibi bedelli tercihler; stok ve müşteri davranışını değiştirsin.
- **Gerekçe:** Sürekli yeni slot eklemeden kişisel kimlik ve uzun vadeli karar oluşur.
- **Bedel/risk:** Denge ve içerik üretimi artar; ilk denemede iki seçenek yeterlidir.
- **Öncelik/durum:** Sonraki aşama. DK yön olarak kabul; her sektör aynı uzmanlıkları kullanmayacak.

### BC-25 — Kişisel şehir hafızası

- **Dayanak:** İlk değerlendiricinin yeni önerisi; 01 §4, §6; 06 §7.4.
- **Tespit/fırsat:** Geri dönüş motivasyonu borç ve kayıp baskısına fazla bağlı.
- **Öneri:** İlk müşteri, çalışan, şube ve başarılar için sınırlı kişisel geçmiş; düzenli müşteriler; açık davranışlarla gelişen çalışan ilişkisi; evde hatıralar.
- **Gerekçe:** Birikim yalnızca sayı olmaz.
- **Bedel/risk:** Metin, çeviri ve küçük kalıcı kayıt maliyeti vardır.
- **Öncelik/durum:** Sonraki aşama. DK yön olarak kabul.

### BC-26 — Çözülebilir NPC soruşturma dosyaları

- **Dayanak:** İlk değerlendiricinin yeni önerisi; 02 §10–11.
- **Tespit/fırsat:** Suç işlenmeyen sunucuda FCU işsiz kalabilir; gerçek oyuncuya dayanaksız dosya üretilemez.
- **Öneri:** Kurallı NPC vakaları: zaman çizelgesi, ifade ve işlem kayıtları. Bazı vakalar suçsuzlukla sonuçlanır. Doğru kapatma da başarıdır.
- **Gerekçe:** Düşük nüfusta anlamlı soruşturma ve eğitim sağlar.
- **Bedel/risk:** Vakalar çözülebilir ve tekrar hissi sınırlı olmalı; çalışma anında üretken AI zorunlu değildir.
- **Öncelik/durum:** Deneysel prototip. DK yön olarak kabul; NPC mahkeme vakalarına bağlanabilir.

## 7. Önceki dış kaynak kontrolünün aktarımı

Bu bölüm ilk incelemede erişilmiş kaynaklara dayanır. Rapor hazırlanırken ikinci bir güncellik taraması yapılmadı. Tarih 24 Eylül 2026'dır. Yayın koşulları ileride yeniden kontrol edilmelidir.

| ZIP'teki iddia | Kontrol sonucu | Kaynak |
|---|---|---|
| Kids/Select eşiği 500 uygun oynanış | Erişilen resmî sayfa 60 günde 250 uygun benzersiz oynanış belirtiyor. | K01 |
| Aktif Plus yeterli, yalnızca Premium iki aylık | Erişilen yayın sayfası Plus veya Premium için iki kesintisiz ay; alternatif 1.000 Robux ücret veriyor. | K02 |
| Moderate yalnızca 16+, Restricted 17+ | Moderate uygunlukla Select 9–15 kitlesine de açılabilir; Restricted 18+. | K03 |
| DevEx için 18 yaş | DevEx asgari yaşı 13; diğer uygunluk şartları ayrıca geçerli. Wallet ayrı değerlendirilmelidir. | K04 |
| Grup kurmak ücretsiz | Resmî destek sayfası topluluk oluşturma için 100 Robux belirtiyor. | K11 |
| 7578 sayılı kanun 1 Mayıs'ta tüm oyunlara 15 yaş yasağı getirdi | İncelenen metinde 15 yaş hükmü sosyal ağ sağlayıcılar için; oyun platformları ayrı maddede. 22–23. maddelerin yürürlüğü yayımdan altı ay sonra. Bu metinden tüm oyunlar için anlatılan genel sonuç çıkarılamıyor. | K12–K13 |
| Roblox 18 Haziran'da Türkiye'de açıldı | Haber kaynağı destekliyor; gerçek yerel bağlantı testi yapılmadı. e-Devlet token/ilk uygulayan platform ayrıntıları birincil kaynakla doğrulanamadı. | K14 |
| Studio gömülü MCP ve listelenen test araçları | Kurulum ve ana araç listesi resmî dokümantasyonla destekleniyor. | K17 |
| Humanoid olmadan Animator kullanılamaz | AnimationController ve Animator ile mümkündür. | K10 |

İade koşullarında resmî yayın sayfalarının ayrıntıları arasında farklılık gözlendi. Bu nedenle para iadesi için tek ve kesin süre sözü verilmemelidir. “Yalnızca Creator Store sesi kullanmak” gibi bir proje tercihi de tek yasal/teknik seçenekmiş gibi yazılmamalıdır.

## 8. TY-01 — Anayasa, mahkeme ve infaz mimarisi

**Kaynak:** UK-03–08, BC-05–07, BC-09, BC-13–15.  
**Tür:** Kullanıcı kararlarından türetilen oyun tasarımı. Gerçek ülke hukukunu açıklamaz.  
**Öncelik:** İlk suç sürümünden önce küçük, kurallı örneği doğrulanmalı.  
**Bedel/risk:** Delil, karar, veri tutarlılığı ve kaçış davranışını birlikte sınamak gerekir. Serbest insan takdiri kötüye kullanım riskini artırır.

### 8.1 Temel karar

Mahkeme mimarisi önerilmektedir. Başlangıçta sunucunun doğruladığı kurallarla çalışan NPC yargılama sistemi kullanılmalıdır. Oyuncular polis, tanık ve daha sonra avukat olarak katkıda bulunabilir. Bir oyuncunun diğerine sınırsız hapis cezası verebildiği yapı önerilmiyor.

Anayasa uzun bir hukuk ansiklopedisi olmamalı. Oyuncunun davranış sonucunu öngörmesini sağlayan kısa üst kurallar, suç/yaptırım tablosu ve kurum yetkileri yeterlidir. Arayüzde özet, ayrıntıda açıklama sunulabilir.

### 8.2 Kurgusal anayasa için önerilen 12 ilke

| Madde | İlke | Oyun karşılığı |
|---|---|---|
| V-A01 | Mülkiyetin devamlılığı | Normal oyun cezaları şirket, ev ve aracın kalıcı sahipliğini silmez. |
| V-A02 | Delile bağlı sorumluluk | Şüphe, maske, yüksek nakit veya sorguya ret tek başına mahkûmiyet değildir. |
| V-A03 | Açık suç tanımı | Eylem, gerekli şartlar ve yaptırım aralığı oyuncuya anlaşılır biçimde gösterilir. |
| V-A04 | Ölçülülük | Küçük ihlal hapisle karşılanmaz; yaptırım kısa ve sınırlıdır. |
| V-A05 | Savunma ve temsil | Oyuncunun savunma sunma yolu vardır; yokluğunda ücretsiz NPC temsilci bulunur. |
| V-A06 | Yoklukta işlem | Çevrimdışı olmak süreci durdurmaz; katılmamak suçluluk kanıtı değildir. |
| V-A07 | Çıkar çatışmasının önlenmesi | Kişi kendi dosyasını veya doğrudan taraf olduğu vakayı yönetemez. |
| V-A08 | Gerekçeli karar | Hangi delilin hangi oyun kuralını karşıladığı karar ekranında açıklanır. |
| V-A09 | İtiraz ve düzeltme | Yanlış kimlik, eksik bağlam veya sistem hatası için sınırlı itiraz vardır. |
| V-A10 | Aynı işlem bir kez | Aynı olay için tekrar tekrar para kesilemez veya hapis eklenemez. |
| V-A11 | Eşit yargısal erişim | Robux ödemesi delili, yargıyı, ceza süresini veya kaçış kolaylığını değiştirmez. |
| V-A12 | Oyun hukukunun sınırı | Platform güvenliği, hile yaptırımı ve moderasyon oyun mahkemesinden ayrıdır; mahkeme bu kuralları geçersiz kılamaz. |

Suçtan elde edildiği doğrulanmış nakdin iadesi veya hile kaynaklı bir kaydın geri alınması, meşru ve kalıcı mülkiyetin normal ceza olarak silinmesiyle aynı şey değildir. Bu istisnalar açık ve dar yazılmalı; “her şey her koşulda kalır” ifadesi hileli kazancı dokunulmaz yapmamalıdır.

### 8.3 Kanun ve kural katmanları

1. Anayasa: yukarıdaki temel güvenceler.
2. Suç ve yaptırım kataloğu: eylem kimliği, gerekli şart, delil türü, yaptırım aralığı.
3. Kurum yetkileri: polis, mali şube, mahkeme, cezaevi.
4. İşletme/sözleşme kuralları: teslim, ücret, kalite ve izin yükümlülükleri.
5. Sunucu topluluğu kuralları: genel platform kurallarını aşamaz; kalıcı ekonomide keyfî ceza yetkisi oluşturamaz.

İlk sürümde bütün küçük anlaşmazlıklar mahkemeye taşınmamalı. Basit hizmet uyuşmazlıkları otomatik sözleşme çözümüyle; ciddi suç vakaları mahkemeyle sonuçlanabilir. Böylece adalet sarayı gündelik işlemler için tek zorunlu kuyruk olmaz.

### 8.4 Dosyanın yaşam döngüsü

| Durum | İşlem | Sonraki olasılık |
|---|---|---|
| Olay kaydı | Sunucu doğrulanabilir olayı kaydeder. | İlk inceleme |
| İlk inceleme | Delil yeterliliği ve suç tanımı eşleştirilir. | Kapanış veya soruşturma |
| Soruşturma | Tanık, kamera ve işlem kayıtları birleştirilir. | Delil yetersizliği veya iddia |
| Bildirim/savunma | Oyuncuya dosya özeti ve katılım/temsil seçeneği sunulur. | Duruşma veya dosya üzerinden değerlendirme |
| Karar | Kurallı sistem delili değerlendirir. | Beraat, para/hizmet yaptırımı veya kısa hapis |
| İnfaz | Karar, kimliğiyle bir kez uygulanır. | Sürenin bitmesi, koşullu tahliye, itiraz sonucu veya kaçış |
| Kapanış | Aktif kısıtlar kaldırılır; gerekli sınırlı geçmiş saklanır. | Yeni ve bağımsız olay yoksa yeniden ceza yok |

Bir tanık hatalı veya bulanık tarif verdiyse bu kesin kimlik bilgisi gibi kullanılamaz. Oyuncunun serbest metin suçlaması, tek başına mekanik mahkûmiyet üretemez. Sistem delilleri olay anını saklamalı; avatarın sonradan değişmesi geçmiş tanığı değiştirmemelidir.

### 8.5 Çevrimdışı duruşma ve temsil

- Oyuncu çevrimdışı olsa da dosya ilerleyebilir ve karar verilebilir.
- Katılmayan kişi için ücretsiz NPC temsilci asgari savunma kontrollerini yapar.
- Kayıtta “oyuncu bizzat katıldı” yazılmaz; **temsil yoluyla / yokluğunda sonuçlandı** şeklinde doğru durum tutulur. Böylece kullanıcının “gelmese de süreç gerçekleşsin” isteği karşılanır.
- Çevrimdışı kaldığı için ek suç veya ek para cezası oluşmaz.
- Girişte suçlama, delil özeti, karar, süre ve itiraz yolu tek bir özet ekranda sunulur.
- Bildirim sessizce geçip oyuncuyu belirsiz bir hücreye bırakmamalı; kişi durumunu anlayabilmelidir.

### 8.6 Hafif ceza ve zaman önerisi

Ceza süreleri henüz ölçülmedi. Aşağıdaki rakamlar yalnızca ilk oyun testinde karşılaştırılabilecek **TY başlangıç aralıklarıdır**, kullanıcı tarafından tek tek belirlenmiş süreler değildir:

| Olay türü | Başlangıç yaklaşımı | Test aralığı |
|---|---|---|
| Küçük ve ilk ihlal | Uyarı, kısa görev veya ölçülü para cezası | Hapis yok |
| Hapis gerektiren hafif suç | Kısa infaz | 1–3 gerçek dakika |
| Daha ciddi fakat standart oyun suçu | Kısa infaz + gerekirse likidite yaptırımı | 3–6 gerçek dakika |
| Birkaç ağırlaştırıcı içeren oyun vakası | Gerekçeli üst aralık | 6–10 gerçek dakika |

Olağan oyun vakasında tek kesintisiz infazın yaklaşık 10 dakikayı aşmaması bir ilk test önerisidir. Nihai üst sınır, oyuncunun deneyimi ve kaçış döngüsü test edilince kararlaştırılır. Her ihlali üst üste ekleyip saatlerce hapis üretmek önerilmiyor. Hile/hesap yaptırımları bu tablonun dışındaki moderasyon konusudur.

**Çalışma tercihi:** Kaçak durumda olmayan oyuncunun kısa infaz süresi çevrimdışıyken de geçer. Giriş anında süre kalmışsa cezaevinde başlar; bitmişse serbest olarak başlar ve karar özetini görür. Bu tercih, UK-08'deki hafif ceza isteğiyle uyumludur. Oyuncu cezasını tamamlamak için uzun süre ekrana bakmaya zorlanmaz.

Bu, hapisteyken otomatik “çık” düğmesi olduğu anlamına gelmez: çevrimiçi oyuncu için çıkışın koşulu, süre veya geçerli tahliye kararıdır. Oyundan çıkıp dönmek dosyayı silmez; yalnızca gerçek zaman ilerler.

### 8.7 Farklı çıkış yolları

| Yol | Koşul | Bedel ve sınır |
|---|---|---|
| Normal tahliye | İnfaz süresinin tamamlanması | En güvenilir yol; ücretsizdir. |
| Koşullu erken tahliye | Uygun suç türü ve kısa, doğrulanmış rehabilitasyon/cezaevi görevi | Sınırlı indirim; tekrar görev spam'i ile sıfır süre oluşturulmaz. |
| Başarılı itiraz | Yanlış kimlik, yetersiz delil veya karar hatasının gösterilmesi | Suçlunun para ödeyerek kararı silmesi değildir; kabul edilen itiraz düzeltme kaydı üretir. |
| Hapishaneden kaçış | Çok adımlı, oyun içinde gözlenebilir kaçış senaryosunun tamamlanması | Yeni kaçış kaydı ve yakalanma riski oluşur; tek düğme veya ücretli ürün değildir. |
| Hüküm öncesi serbestlik/kefalet | Yalnızca uygun yargılama aşaması | Nihai mahkûmiyeti silmez. İlk sürüm için zorunlu değildir; ekonomik üstünlüğe dönüşürse kullanılmamalıdır. |

İlk sürümde normal tahliye, bir koşullu tahliye görevi, temel itiraz ve tek iyi test edilmiş kaçış senaryosu yeterlidir. Çok sayıda kaçış rotası, bütün çekirdek akış çalıştıktan sonra eklenebilir.

### 8.8 Kaçış raporu

Kaçış başarıyla tamamlandığında sunucu bir kez kaçış olayı üretir. Rapor, kişi/vaka kimliği, kaçış zamanı, son doğrulanmış görünüm ve son görüldüğü konumu içerir. Sürekli ve nedensiz canlı GPS gerekmez; yeni gözlemler geldikçe konum güncellenir.

Kaçış anında kalan infaz süresi kaydedilir. **Kaçak durumdayken infaz sayacı durur**; çevrimdışı kalıp dönmek kaçış kaydını veya kalan süreyi silmez. Yeniden yakalanınca kalan süre ve sınırlı kaçış yaptırımı, toplam üst sınırla değerlendirilir. Aynı kaçış için her girişte yeni ceza yazılmaz.

Teslim olmak ile yakalanmak farklı sonuç verebilir; teslim, daha hafif ek yaptırım için değerlendirilebilir. Kaçış dosyası çözüldüğünde aktif aranma kaldırılır. Oyuncu sonsuza kadar kaçak veya ekonomik olarak dışlanmış kalmaz.

### 8.9 Teknik temsil ve çevrimdışı işlem

Bu yapı mutlaka ayrı bir dış sunucu veya sürekli çalışan AI gerektirmez. Ancak Roblox oyun sunucusu kapalıyken kendi kendine çalışıyormuş gibi davranılamaz. Çözüm:

- Dava kaydı işletme profilinden ayrı bir kimlikle tutulur: caseId, olaylar, delil referansları, taraflar, kural sürümü ve durum.
- Karar; verdictId, gerekçe ve uygulanma durumu taşır. Infaz aynı karar kimliğiyle yalnızca bir kez uygulanır.
- Planlanmış değerlendirme zamanı ile gerçekten işlendiği zaman ayrı kaydedilir. Gecikmiş işlemler yetkili sunucu aktif olduğunda değerlendirilir; sahte oyuncu katılımı veya sahte fiziksel olay üretilmez.
- Sanal zaman etkisi kullanılacaksa önceden belirlenen kural ve effectiveAt alanıyla açıkça temsil edilir; işlem günlüğünde processedAt ayrıca bulunur.
- Yetki/kilit mekanizması iki sunucunun aynı dava hakkında farklı sonuçlar yazmasını önler.
- Cezaevi durumu profil yüklendiğinde kayıtla uzlaştırılır. Sunucu değiştirme, avatar resetleme, ölüm ve yeniden giriş infazı sıfırlamaz.
- İlk uygulamada bu bileşenler tek bir AdaletServisi içinde modüller olabilir. Her kavram için ayrı mikroservis gerekmiyor.

### 8.10 Adalet için asgari kabul senaryoları

1. Masum kişi yalnızca çanta göstermediği için hapse girmiyor.
2. Yeterli delili olmayan dosya kapanıyor.
3. Çevrimdışı kişi ücretsiz temsil ile sonuç alabiliyor.
4. Aynı karar iki sunucuda iki kez para kesmiyor veya süre eklemiyor.
5. Kişi kendi dosyasını polis/avukat rolünde değiştiremiyor.
6. Normal ceza çevrimdışıyken doğru süre hesabıyla ilerliyor.
7. Süresi biten kişi girişte tekrar hücreye kilitlenmiyor.
8. Kaçış bir rapor oluşturuyor; tekrar giriş raporu silmiyor.
9. Kaçış sırasındaki bağlantı kesintisi yeni bir kaçış başarısı üretmiyor.
10. Yanlış karar düzeltildiğinde kısıtlar kaldırılıyor ve gerekli oyun içi telafi değerlendiriliyor.

Bu senaryolar önerilen test planıdır; çalıştırılmış test sonuçları değildir.

## 9. TY-02 — Her sektöre aynı soygun riskini uygulamayan model

**Kaynak:** UK-02; BC-03, BC-18, BC-23.  
**Öncelik:** İşletme tasarımının temel kuralı.  
**Bedel/risk:** Her sektöre farklı başarısızlık tasarlamak gerekir; ortak sözleşme ve görev altyapısı bu maliyeti azaltır.

Risk dört gruba ayrılmalıdır:

| Risk türü | Örnek | Koruma |
|---|---|---|
| Operasyonel | Stok yetişmemesi, yanlış plan, düşük kalite, araç bakım ihtiyacı | Önceden görülebilen bilgi, sınırlı zarar ve telafi işi |
| Ticari | Yanlış ürün seçimi, düşük talep, sözleşme hedefini kaçırma | Anlaşılır talep bilgisi, sabit başlangıç maliyetleri |
| Hukuki | Kanıtlı sözleşme ihlali veya suçla bağlantılı işlem | Delile bağlı süreç, itiraz, ölçülü yaptırım |
| Suç kaynaklı | Soyulabilir nakit veya açıkça seçilmiş yüksek riskli taşıma | Sınırlı kayıp, hedef koruması, sigorta ve müdahale |

**Müteahhitlik örneği:** Oyuncu hazır onaylı plandan proje seçer, keşif yapar, iş sırasını ve ekibini belirler, malzeme teslimini organize eder, kalite kontrolünden geçer. Ana risk yanlış keşif, gecikme ve yeniden iş yapma maliyetidir. Kalas çalınması zorunlu eğlence kaynağı değildir. Temel malzeme stoğu başka oyuncunun rastgele saldırısıyla sürekli yok edilemez.

Bazı perakende kasaları sınırlı nakit riskine açık olabilir. Büyük ve riskli soygun ödülleri, oyuncunun bütün işletmesini tehdit etmek yerine NPC/sistem hedeflerinde yoğunlaştırılabilir. Yasal taşıma varsayılan olarak suç görevi değildir; özellikle riskli bir sözleşme seçiliyorsa bunun koşulları başlangıçta açıklanmalıdır.

Tekrarlanan mağduriyet için hedefe özgü koruma uygulanmalı: aynı işletmeye kısa aralıkla baskın engeli, kayıp tavanı, yeni işletmenin öğrenme koruması ve olay sonrası toparlanma. Koruma, suç işleyip anında güvenli moda geçme açığı yaratmamalı; aktif suç vakasında geçiş şartları tanımlanmalıdır.

## 10. TY-03 — Geniş işletme ve meslek kataloğu

**Kaynak:** UK-10–11; BC-18, BC-23–25.  
**Amaç:** Farklı oyuncu tercihlerine hitap eden geniş bir ürün vizyonu.  
**Bedel/risk:** Aşağıdaki katalog aynı anda üretilecek 24 bağımsız sistem değildir. Ortak altyapı kullanılmalı; her dal oynanabilir karar bakımından ayrışmalıdır.

### 10.1 İşletme seçenekleri

| Kod | İşletme | Oyuncunun anlamlı kararı | Büyüme yönü | Başlıca risk | Altyapı ailesi |
|---|---|---|---|---|---|
| IS-01 | Bakkal / market | Ürün karması, raf ve sipariş zamanı | Şube, uzman ürün, lojistik | Stok ve sınırlı kasa kaybı | Perakende |
| IS-02 | Fırın / pastane | Parti miktarı ve teslim sırası | Üretim hattı, kurumsal sipariş | İsraf ve zamanlama | Üretim + perakende |
| IS-03 | Kafe / küçük restoran | Menü, servis akışı, masa planı | Paket servis, ikinci şube | Servis ve müşteri memnuniyeti | Hizmet + üretim |
| IS-04 | Manav / balık pazarı | Tazelik ve tedarik dengesi | Özel ürün ve toptan satış | Bozulma; sınırlı ve görünür | Perakende |
| IS-05 | Terzi / giyim mağazası | Hazır tasarım, sipariş uyumu | Koleksiyon ve ekip | Sipariş/kalite uyuşmazlığı | Atölye + perakende |
| IS-06 | Mobilya / ev dekorasyonu | Oda ihtiyacına uygun paket | Sergi, teslimat, tasarım ekibi | Yanlış ölçü veya teslim | Perakende + proje |
| IS-07 | Elektronik bakım dükkânı | Arıza teşhisi ve parça seçimi | Uzman tezgâh, teknisyen | Yanlış teşhis ve yeniden iş | Atölye |
| IS-08 | Araç tamirhanesi | Teşhis, onarım ve iş sırası | Birden çok servis noktası | Süre/kalite; eşyanın kalıcı silinmesi yok | Atölye |
| IS-09 | Oto bakım / detaylı temizlik | Uygun bakım paketi ve randevu | Filo anlaşmaları | Kapasite ve memnuniyet | Hizmet |
| IS-10 | Galeri / araç aracılığı | Talebe uygun araç, stok maliyeti | Showroom ve satış ekibi | Sermayenin stokta beklemesi | Perakende |
| IS-11 | Taksi işletmesi | Rota, vardiya ve araç dağılımı | Şoförlü filo | Yakıt, bakım, hizmet süresi | Ulaşım |
| IS-12 | Minibüs / servis işletmesi | Hat ve sefer planı | Yeni hat ve araç | Talep, gecikme ve kapasite | Ulaşım |
| IS-13 | Kurye / kargo | Rota ve iş birleştirme | Depo, dağıtım ekibi | Geç/yanlış teslim | Lojistik |
| IS-14 | Depo / dağıtım merkezi | Yerleşim ve sevkiyat sırası | Daha çok müşteri ve bölge | Kapasite ve iş akışı | Lojistik |
| IS-15 | Toptancı / tedarik işletmesi | Talep tahmini ve alım planı | İşletmeler arası anlaşmalar | Fazla veya eksik stok | Lojistik + perakende |
| IS-16 | Müteahhitlik | Keşif, onaylı plan, ekip ve teslim | Daha büyük hazır projeler | Gecikme, kalite, yeniden iş | Proje |
| IS-17 | İç mimari / tadilat | Onaylı parçalardan oda planı | Tasarım ekibi ve portföy | Bütçe ve müşteri hedefi | Proje |
| IS-18 | Tesis bakım / temizlik | İş listesi ve ekip rotası | Sürekli bakım sözleşmesi | Kalite ve kapasite | Hizmet |
| IS-19 | Peyzaj / bahçe bakımı | Hazır bitki planı ve bakım | Site/kurum sözleşmeleri | Bakım takvimi ve kalite | Proje + hizmet |
| IS-20 | Tabela / baskı atölyesi | Moderasyonlu hazır şablon ve teslim | Kurumsal sipariş | Hatalı tasarım veya gecikme | Atölye |
| IS-21 | Etkinlik organizasyonu | Hazır etkinlik paketi ve kaynak planı | Şehir etkinlikleri | Koordinasyon ve kapasite | Proje + hizmet |
| IS-22 | Fotoğraf / şehir turu | Rota, çekim hedefi, grup akışı | Tur ekibi ve koleksiyon | Hizmet süresi ve memnuniyet | Hizmet + ulaşım |
| IS-23 | Emlak danışmanlığı | İhtiyaca uygun mevcut mülkü eşleştirme | Danışman ekibi | Yanlış eşleştirme; tapu/cephe kurallarıyla uyum | Hizmet |
| IS-24 | Güvenlik kurulum işletmesi | Kamera/alarm kapsamı ve bakım | Kurumsal bakım ağı | Yanlış kurulum ve kör nokta | Atölye + hizmet |

IS-10'da ilk sürüm için NPC ile standart fiyat aralığında satış, serbest oyuncular arası araç piyasasından daha yönetilebilirdir. IS-23 oyuncuya küresel fiziksel cephe tekeli satmamalıdır. IS-24 müşterinin kamera gizliliğini ihlal eden sınırsız izleme yetkisi vermemelidir.

### 10.2 Ticari işletme olmayan meslekler

- **BMP devriye/trafik:** Doğrulanmış ihlal, yönlendirme, güvenli müdahale; yalnızca oyuncu beklemez, NPC vaka bulunur.
- **FCU:** İşlem kayıtları, tanık ve mali dosyalar; başarı sadece ceza vermek değildir.
- **İtfaiye:** NPC olayları, ekipman kontrolü ve kurtarma; başka oyuncunun şirketini kalıcı yok eden yangın zorunlu değildir.
- **Sağlık/ambulans:** Doğrulanmış olay, sınırlı müdahale, taşıma; iki hesabın birbirini yaralayıp sınırsız ödül kazanması engellenir.
- **Cezaevi görevlisi:** Görev listesi ve kaçış olayları; ceza süresini keyfî uzatamaz.
- **Hukuk/avukatlık:** Sonraki aşamada delil düzenleme ve savunma; ücretsiz NPC temsilin yerine zorunlu ücret kapısı olmaz.

Oyuncu hâkimliği ilk sürümde önerilmiyor. Daha sonra düşünülürse bağlayıcı ceza seçimi, delil ve süre kurallarının dışında olamaz. Hâkim rolü eklenmese de mahkeme sistemi eksik sayılmaz.

### 10.3 Çeşitliliği üretilebilir kılan ortak altyapı

Altı ortak iş ailesi yeterli bir başlangıçtır: perakende, üretim, atölye, ulaşım/lojistik, hizmet ve proje. Ortak sipariş, çalışan, stok, teslimat, kalite ve ödeme bileşenleri kullanılabilir. Fakat hepsini aynı kasa minioyununa indirmek doğru değildir.

İlk genel test için perakende, ulaşım, bakım, yemek, kurye ve proje ailesini temsil eden yaklaşık 6–8 erişilebilir iş kolu bir **ürün hedefi** olarak ele alınabilir. İlk küçük prototip yalnızca bir çekirdek döngüyü sınar. Genel teste hangi dalların yetişeceği UK-09 gereği gerçek üretim hızı görülünce belirlenir. Katalogdaki her dal ilk yayına verilmiş söz değildir.

## 11. TY-04 — Harita, kurumlar ve işletme kapasitesi

**Kaynak:** UK-10–11; BC-01, BC-16, BC-18.  
**Öncelik:** Ana harita planında şimdi yer ayrılmalı; ayrıntılı binalar aşamalı üretilmeli.  
**Bedel/risk:** Çok geniş harita oyuncuları seyreltir; çok sayıda sürekli simüle edilen iç mekân telefon performansını düşürebilir.

### 11.1 Kurumların konumu

- **Adalet sarayı:** Blackstone'da karakola erişilebilir, ayrı kimliği olan kurum. Başlangıçta giriş, başvuru ekranı, bir duruşma salonu ve bekleme alanı yeterli.
- **Hapishane:** Yoğun şehir çekirdeğinin dışında, ulaşılabilir kurum bölgesinde. İlk sürümde sınırlı hücre alanı, ortak alan, görev alanı ve bir kontrollü kaçış senaryosu.
- **Kısa gözaltı alanı:** Karakolda; mahkûmiyet ile aynı durum değildir. Gereksiz uzun ön tutma oluşturmaz.
- **Ticaret/ruhsat hizmeti:** Başlangıç işletme ve sözleşme işlemlerinin kısa, anlaşılır merkezi; her ödeme için fiziksel sıra gerekmez.

Kullanıcının “haritanın dışında” ifadesi, mevcut merkez/ilk taslak dışında hapishane ve adalet yerleşimi ihtiyacı olarak yorumlandı. Ayrı bir Roblox place zorunlu kabul edilmedi. İlk tercih aynı şehir sahnesinde, streaming ile kurum bölgesidir. Ayrı place ancak ölçülen ihtiyaç varsa düşünülmelidir.

### 11.2 İşletme alanları

Yalnızca 14 standart + 6 büyük cepheye güvenilmemeli. Kapasite işletme sahibi sayısına değil, eşzamanlı aktif fiziksel işletme ihtiyacına göre hesaplanmalı. Kişinin ikinci/üçüncü işletmesi ve farklı boyut gereksinimleri hesaba katılmalıdır.

Önerilen model:

1. Sokakta görünür ana işletmeler: standart küçük, orta ve büyük yuvalar.
2. Pasaj/iş merkezi: sınırlı dış bina içinde oyuncuya atanabilen bağımsız iç birimler.
3. Sanayi/ticaret alanı: atölye, depo, müteahhitlik ofisi ve lojistik yuvaları.
4. Mobil işletmeler: taksi, kurye ve bazı servisler için başlangıçta ayrı dükkân zorunlu değil.
5. Şirket rehberi: işletme kimliği sabit; geçerli adres ve yol tarifi sunucuya göre güncellenir.

Örnek kapasite hesabı: 40 oyuncunun %40'ı ikişer işletme işletiyorsa 32 fiziksel talep oluşabilir. Bu tahmin garanti değildir; herkesin sahip olması durumunu da taşma çözümü karşılamalıdır. Katalogdaki her iş kolu için ayrı bina yapmak zorunlu değildir; uyumlu şablonlar aynı boyut ailesini paylaşabilir.

Oyuncu “adres dolu” diye satın aldığı işletmeyi süresiz açamamalı. Önce tercihli adres, sonra eşdeğer yuva, sonra iş merkezi/alternatif yerleşim sağlanmalıdır. Ek işletmelerin ne kadarının fiziksel olarak gösterileceğiyle toplam sahiplik ve kazanç hakkı birbirinden ayrılmalı; bu sınır kullanıcıya açık olmalıdır.

Şehir büyüklüğü yalnızca stud sayısıyla belirlenmemeli. İş yoğunluğu, yürüme mesafesi, araç rotası, mobil yük ve insanların karşılaşma sıklığı ölçülmelidir. Hapishane/adalet alanları planlanırken gereksiz uzun zorunlu yolculuk yerine gerektiğinde NPC ulaşımı sağlanabilir.

## 12. TY-05 — Ek özellikler ve uygulama sırası

### 12.1 Yeni özellik önerileri

| Kimlik | Fikir | İhtiyaç ve somut davranış | Bedel/risk | Aşama |
|---|---|---|---|---|
| YF-01 | Şirket ve hizmet rehberi | Oyuncu mevcut işletmeyi, açık hizmeti ve güncel adresi bulur. Dinamik cephe sorununun kullanıcı yüzüdür. | Yanlış/eski adres ve gizlilik kontrolü | İlk çok oyunculu işletme sürümü |
| YF-02 | Kısa iş ortaklığı | İşletme sahibi sınırlı görev yetkisi verir; ortak tam banka erişimi almaz. | Yetki sınırları ve iptal davranışı | Sonraki aşama |
| YF-03 | Tedarikçi teklifleri | Oyuncu fiyat, teslim süresi ve güvenilirlik arasında seçim yapar. | Serbest piyasa yerine önce NPC teklifleri | İlk geniş işletme testi |
| YF-04 | Görünür kalite kontrolü | Müteahhit ve tamirci yapılan işi önceden açıklanan hedeflere göre teslim eder. | Tekrarlanan tıklama minioyununa dönüşmemeli | Proje/atölye prototipi |
| YF-05 | Mahalle talep olayları | Hazır festival veya yoğunluk olayı bazı hizmetlere geçici talep yaratır. | Sınırlı ödül ve tekrar istismarı | Sonraki aşama |
| YF-06 | Oyuna dönüş özeti | İşletme, çalışan, dava ve yeni hedefler tek kısa özetle gösterilir. | Bildirim yığınına dönüşmemeli | İlk kalıcı veri sürümü |
| YF-07 | İzin/dondurma modu | Aktif suç dosyasını silmeden işletme üretim ve giderini kontrollü durdurur. | Risk başladıktan sonra anlık kaçış aracı olamaz | İlk çevrimdışı ekonomi sürümü |
| YF-08 | Olay açıklama kartı | Ceza, para kaybı ve ret işlemi nedenini, süresini ve çözüm yolunu gösterir. | Hassas delili herkese sızdırmamalı | İlk suç/adalet sürümü |

Bu fikirler yeni üretim taahhüdü değildir. UK-01 ve UK-11 doğrultusunda seçilmiş başlangıç yönleridir; ikinci değerlendirici maliyet/fayda açısından eleştirebilir.

### 12.2 Güncellenmiş aşama düzeni

| Aşama | İçerik | Geçişte cevaplanacak soru |
|---|---|---|
| P0 — Küçük prototip | Tek işletme, küçük sahiplik, bir büyütme, bir NPC devir | Eğlenceli mi; ekip gerçekte ne hızda ve kalitede üretiyor? |
| P1 — Kalıcılık ve yerleşim | Veri, tek yetkili işletme, cephe/alternatif yer, temel rehber | Çıkış/giriş ve çok oyunculu kullanımda sahiplik korunuyor mu? |
| P2 — Sivil çeşitlilik | Bir karşıt meslek döngüsü, örneğin atölye veya proje; kısa sözleşme | Farklı meslek gerçekten farklı karar üretiyor mu? |
| P3 — Envanter ve sınırlı suç | Çanta, görünürlük, bir soygun hedefi, tanık, polis kuralları | Oyuncu riski anlıyor mu; masum kişi taciz edilebiliyor mu? |
| P4 — Adalet prototipi | Bir salon, basit cezaevi, delil/karar, çevrimdışı temsil, tahliye, tek kaçış | Karar adil ve anlaşılır mı; kısa ceza/kaçış döngüsü çalışıyor mu? |
| P5 — Geniş kapalı test | İş kataloğunun seçilen dalları, gerekli kurumlar, çok oyunculu ekonomi | Çeşitlilik, nüfus, telefon performansı ve veri bütünlüğü birlikte çalışıyor mu? |
| P6 — Yayın adayı | Diller, moderasyon, içerik etiketleri, gelir modeli, kurtarma süreçleri | Ürün güvenli, anlaşılır ve sürdürülebilir biçimde işletilebiliyor mu? |

Hapishane ve adalet sarayı ana planda erken yer alır; ayrıntılı mimari ve dekor üretimi oynanış prototipinden sonra yapılır. Bu, kurumları vizyondan çıkarmak değildir. Gri kutu hâlinde erken test etmek, sonradan bütün binayı değiştirme maliyetini azaltır.

İlk prototipte ölçülecek kapasite: kişi başı fiilî çalışma süresi; bir oynanabilir özelliğin üretim süresi; inceleme/düzeltme yükü; ekip içi bağımlılık; gerçek telefon sonuçları. Bu bilgi görülmeden kesin yayın tarihi verilmez.

## 13. Öncelikli tutarlılık ve güvenlik kabul koşulları

- Aynı işletme iki sunucuda bağımsız para basamaz.
- İşletme kotası veya dava durumu sunucu değişiminde sıfırlanamaz.
- Oyuncu parasının ve eşyasının tek esas kaydı vardır; aktarma sırasında çoğaltılamaz.
- Meşru işletme sahibi korunur; sektör dışı rastgele hırsızlık her mesleğin ana tehdidi yapılmaz.
- Suç işlemeden de para dışı ve mesleki ilerleme vardır.
- Çanta ret hakkı, zorunlu suçluluk veya otomatik mahkûmiyet doğurmaz.
- Mahkeme delili, polis şüphesi ve oyuncunun serbest metin iddiası aynı şey değildir.
- Mahkeme çevrimdışı çalışabilir; kişi katılmış gibi sahte kayıt oluşturulmaz.
- Kısa ceza, bekleme/çıkış/reset ile silinmez; geçen süre kurala göre sayılır.
- Kaçış raporu tutarlı saklanır; kaçaklık sonsuz ekonomik dışlanmaya dönüşmez.
- Robux ile hüküm, süre, delil veya kaçış üstünlüğü satın alınamaz.
- Özel sunucu yönetimi genel kalıcı ekonomiye para veya keyfî mahkûmiyet taşıyamaz.
- Sahiplik/işlem hatası ve hile kazancının düzeltilmesi, normal oyuncunun meşru varlığını ceza olarak silmekle karıştırılmaz.
- Gizli bilgi yetkisiz istemciye gönderilmez; açık çanta/bagaj ve tanık kayıtları ortak bilgi sözleşmesine uyar.
- Metinler filtrelenir; sosyal engelleme telefon ve mahkeme arayüzlerinde de uygulanır.
- Ölçülmemiş NPC kapasitesi, süre ve gelir hedefi garanti diye sunulmaz.

## 14. İkinci yapay zekâ ile ortak karar listesi yöntemi

Bu rapor hazırlanırken ikinci yapay zekânın değerlendirmesi görülmemiştir. Bu nedenle gerçek bir iki-AI uzlaşması veya hibrit karar listesi henüz oluşturulmamıştır. Aşağıdaki tablo, sonraki değerlendirmenin kullanacağı biçimdir:

| Karar kimliği | İlgili BC/UK/TY | İlk AI görüşü | İkinci AI katkısı | Kullanıcı kararı | Sonuç | Gerekçe | Etkilenen belgeler |
|---|---|---|---|---|---|---|---|
| ORTAK-001 | Örnek: BC-01, UK-10 | Bu rapordan aktar | Bağımsız değerlendirme | Açık karar varsa UK | Kabul/geliştir/ertele/ele/açık | Kanıt ve bedel | 01, 04, 05 vb. |

İkinci değerlendiriciden beklenen çalışma:

1. Kendi bulgularını BC kodlarıyla eşleştir; gerçekten yeni olanlara ayrı kimlik ver.
2. Kullanıcının UK kararlarını sessizce değiştirme. Bir kararın uygulanabilirlik sorunu varsa açıkça göster ve alternatif öner.
3. DK/TY önerilerini kanıt ve kullanıcı faydasıyla yeniden değerlendir; otomatik doğru kabul etme.
4. Aynı sorunu farklı ifadeyle anlatan maddeleri birleştir; farklı problemleri tek başlıkta kaybetme.
5. Her önemli değişiklikte avantajı, maliyeti ve hangi oyun davranışını değiştirdiğini açıkla.
6. Çözülebilecek teknik tercihler için tekrar tekrar kullanıcı onayı isteme; devredilen karar yetkisini kullan.
7. Gerçekten kullanıcı tercihi gerektiren temel deneyim çatışmaları kalırsa tek bir kısa karar listesinde topla.
8. Sonraki düzenleme aşamasında geçersiz eski hükmü yalnızca yeni açıklamayla yan yana bırakma; ilgili bütün belgeleri tutarlı güncelle.

### 14.1 Sonraki belge düzenlemesinde etkilenecek yerler

| Belge | Planlanan güncelleme alanları |
|---|---|
| OKU-ONCE | Yeni kurumlar, karar durumu ve çözülmemiş mimari iddiaları |
| 00 | Hayat kurma vaadi, mesleğe göre risk, anayasa ilkeleri, gerçek zorunluluk/proje tercihi ayrımı |
| 01 | Cephe/sahiplik, işletme katalogları, iş aileleri, çevrimdışı davranış, erken sahiplik |
| 02 | Yetki, delil, dava, infaz, kaçış, eşya ve bilgi erişimi |
| 03 | Aritmetik, ciro/net kâr, farklı riskler, ceza ve sigorta, Robux ürünleri |
| 04 | Tek yetkili kayıt, işlem kimlikleri, dava/infaz durumu, animasyon düzeltmesi, performans ölçümü |
| 05 | Adalet sarayı, hapishane, kurum alanı, işletme yuvaları ve kapasite, animasyon ihtiyaçları |
| 06 | Dava/karar/itiraz/infaz ekranları, rehber, dönüş özeti, erişilebilir etkileşimler |
| 07 | Kapasitenin prototipte öğrenilmesi, küçük aşamalar, gerçek kabul koşulları |
| 08 | Dava, delil, karar, infaz, kaçaklık ve işletme terimleri; isim tutarlılığı |
| A1 | Araç kabiliyetleri, kaynak kontrolü, AI simülasyonu/test sınırları |
| A2 | Hatalı mutlak kuralları kaldırma; karar kimliği, doğrulama ve test şablonları |
| A3 | Güncel yayın/yaş/gelir koşulları, kaynak tarihleri, belirsiz Türkiye ayrıntıları |

## 15. Açık kalan ve ölçüm gerektiren konular

Kullanıcı bunların rutin seçimlerini devretmiştir; aşağıdakiler bir onay engeli değildir. İlgili aşamada ölçülmeli veya kaynakla doğrulanmalıdır:

- Ekip kapasitesi ve ilk genel teste yetişecek iş kolları.
- Hedef cihazlarda oyuncu/NPC/araç/iç mekân bütçesi.
- İlk sahiplik süresi ve işletme fiyat eğrisi.
- Maaş/ruhsat ekonomik döneminin uzunluğu.
- Hapis aralıkları, toplam ceza tavanı ve kaçışın başarılma zorluğu.
- Dava bildirim ve savunma penceresinin uzunluğu; çevrimdışı kayıtların zaman işleme ayrıntısı.
- Fiziksel işletme ihtiyacı, bölge/yuva sayısı ve alternatif yerleşimin anlaşılabilirliği.
- Ev ve işletme iç mekânlarına başkalarının erişim sınırları.
- Gelir modelinin gerçek talebi; özel sunucu gelir payına dair varsayımlar.
- Yeni isimlerin uygunluğu ve kaynak varlıkların lisans koşulları.
- Yayın günündeki Roblox, yaş, ülke erişimi ve ödeme koşulları.

## 16. Kaynak dizini

Aşağıdaki URL'ler ilk incelemede kullanılan kaynakların aktarımıdır. “Kontrol edildi” ifadesi, kaynak sayfanın incelendiğini belirtir; oyunun uygulandığı veya Roblox hesabında yayın uygunluğunun denendiği anlamına gelmez.

- **K01 — Roblox Kids and Select:** https://create.roblox.com/docs/production/publishing/kids-and-select
- **K02 — Create and publish games and places:** https://create.roblox.com/docs/production/publishing/publish-games-and-places
- **K03 — Content maturity and compliance:** https://create.roblox.com/docs/production/promotion/content-maturity
- **K04 — DevEx Terms of Use:** https://en.help.roblox.com/hc/en-us/articles/115005718246-Developer-Exchange-Terms-of-Use
- **K05 — Private servers:** https://create.roblox.com/docs/production/monetization/private-servers
- **K06 — Data stores:** https://create.roblox.com/docs/cloud-services/data-stores
- **K07 — Securing the client-server boundary:** https://create.roblox.com/docs/scripting/security/client-server-boundary
- **K08 — Text filtering:** https://create.roblox.com/docs/ui/text-filtering
- **K09 — TextChatService:** https://create.roblox.com/docs/reference/engine/classes/TextChatService
- **K10 — Use animations:** https://create.roblox.com/docs/animation/using
- **K11 — How to create a Community:** https://en.help.roblox.com/hc/en-us/articles/203313730-How-to-create-a-Community
- **K12 — TBMM 7578 sayılı Kanun metni:** https://cdn.tbmm.gov.tr/KKBSPublicFile/D28/Y4/KanunMetni/9bf93173-7648-4771-ab36-0e45666c423d.htm
- **K13 — TBMM 7578 sayılı Kanun bilgileri:** https://www.tbmm.gov.tr/Yasama/Kanun/5F9CED52-3776-46E4-BE23-019CB8DA2666
- **K14 — Türkiye erişimine ilişkin haber, Sözcü, 18 Haziran 2026:** https://www.sozcu.com.tr/roblox-a-erisim-engeli-680-gun-sonra-kaldirildi-p329131
- **K15 — Ford Otosan tarihçe, Anadol:** https://www.fordotosan.com.tr/tr/kurumsal/ford-otosan-hakkinda/tarihce
- **K16 — Tofaş tarihçe, Kartal:** https://www.tofas.com.tr/Hakkimizda/Tarihce
- **K17 — Studio MCP server:** https://create.roblox.com/docs/studio/mcp
- **K18 — Roblox discovery:** https://create.roblox.com/docs/discovery

## 17. Teslim ve doğrulama notu

Bu dosya, kaynak ZIP'teki bütün okunabilir belgelerin önceki incelemesini ve kullanıcının son kararlarını aktaran yeni bir rapordur. Kaynak arşive değişiklik uygulanmamıştır. BC-01–BC-26 bulguları, UK-01–UK-12 kullanıcı kararları ve TY-01–TY-05 türetilmiş yönler ayrı kimliklerle korunmuştur.

Anayasa, mahkeme, çevrimdışı hüküm, kısa infaz, çıkış yolları, kaçış raporu, sektörlere göre risk, geniş işletme kataloğu ve kurum yerleşimi rapora eklenmiştir. Bunlar çalışan oyun özellikleri olarak sunulmamaktadır. Oyun testi, ekonomik simülasyon veya performans ölçümü yapılmış değildir; sayısal hesap kontrolü ile tasarım doğrulaması bu işlerden ayrıdır.
