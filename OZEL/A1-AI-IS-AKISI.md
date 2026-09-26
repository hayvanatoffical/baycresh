# A1 — Yapay Zekâ İş Akışı

**Sürüm:** 3.0 · 24 Eylül 2026
**Okuyucu:** Sadece sen. Ekiple paylaşılmaz.
**Bağlı kararlar:** ORTAK-013, 015, 030

Bu belge iki soruyu cevaplar: hangi araç ne yapar ve arkadaşlarına bunu nasıl öğretirsin.

---

## 1. Kurulum: MCP artık ayrıca kurulmuyor

**Eski bilgi kullanma.** İnternetteki rehberlerin çoğu `studio-rust-mcp-server` adlı ayrı bir program indirmenizi söylüyor. O depo arşivlendi ve Roblox yerleşik sunucuyu öneriyor. Doğru yol artık Studio'nun içinde.

**Adımlar:**

1. Roblox Studio'yu en son sürüme güncelle
2. Assistant'ı aç
3. **… → Manage MCP Servers**
4. **Enable Studio as MCP server** anahtarını aç
5. Açılan panelde hızlı bağlantı listesinden istemcini seç

Liste desteklenen istemcileri gösterir. İstemcin listede yoksa aynı panelde JSON yapılandırması ve CLI komutu da var. Sunucu stdio üzerinden çalışır.

**Bağlantıyı doğrula:** Aynı panelde yeşil gösterge ve bağlı istemci sayısı görünür.

**Birden fazla Studio penceresi:** Tek istemciyi aynı anda birkaç Studio oturumuna bağlayabilirsin. Hangisinin hangisi olduğunu listeleme aracıyla görür, aktif olanı seçersin.

**Güvenlik:** Bağlanan istemci açık projeni okuyabilir ve değiştirebilir. Yalnız güvendiğin istemciyi bağla.

## 2. Sunucunun yapabildikleri

Çoğu kişinin bilmediği kısım bu: sunucu yalnız kod yazmıyor.

**Kod:** Script okuma, çok noktalı düzenleme, isimle arama, tüm script'lerde desen arama.

**Varlık üretimi:** Metinden dokulu 3D mesh, özel malzeme varyantı, ilkel parçalardan prosedürel model, Creator Store ve envanterde varlık arama, varlık ekleme, görsel yükleme.

**Veri modeli:** Hiyerarşiyi gezme, nesne inceleme, karmaşık çok adımlı işler için alt ajan başlatma.

**Luau çalıştırma:** Edit, Client veya Server bağlamında kod koşturma.

**Ve en önemlisi — oynatma:** Test modunu başlatma ve durdurma, konsol çıktısı okuma, ekran görüntüsü alma, karakteri yürütme, tuş basma ve metin yazma, fare tıklama ve sürükleme.

**Not:** Araç adları Studio sürümleri arasında değişiyor. Bu belgeye araç adı yazmak yerine Roblox'un Studio MCP dokümantasyonuna bak. Yetenek listesi yukarıdaki gibi kalıyor.

**Bunun anlamı:** `04-TEKNIK.md` §14'teki "yapay zekâ test edebilir" cümlesi buradan geliyor. Eski belgelerdeki "yapay zekâ test edemez" bilgisi artık yanlış.

## 3. Otomatik regresyon testi

Projenin en büyük gizli avantajı bu ve neredeyse kimse kullanmıyor.

Her sistem bittiğinde bir test senaryosu yazdır. Örnek:

> Bu senaryoyu çalıştır ve sonucu raporla:
> 1. Test modunu başlat
> 2. Karakteri Blackstone Bazaar'daki tezgâha yürüt
> 3. Tezgâha tıkla, satışı başlat
> 4. 5 müşteri işle
> 5. Konsol çıktısını oku, kırmızı hata var mı?
> 6. Ekran görüntüsü al
> 7. Test modunu durdur
>
> Sonuç: geçti veya kaldı; hata varsa satır numarasıyla.

Bu senaryoları bir klasörde biriktir ve her hafta hepsini birden koştur. Acemi ekiplerde en sık görülen felaket — "geçen hafta çalışan şey bugün bozulmuş" — böylece ortadan kalkar.

**K1 biter bitmez kur.** Sonra kurmaya çalışmak çok geç olur.

Öncelikli regresyon senaryoları: veri kaydı, yuva atama, aklama kotası, çatışma bağlam kuralı, yaralı ve hastane akışı, adalet zinciri.

## 4. Katman ayrımı: ne AI yapar, ne yapmaz

| AI tamamen yapar | AI taslak atar, insan bitirir | AI hiç dokunmaz |
|---|---|---|
| Prop modelleri, dokular, malzemeler | Bina kütleleri | **Oyun ikonu ve kapak görseli** |
| Ses efekti seçimi ve yerleştirme | Harita krokisi | **Trailer ve teaser** |
| Kod ve refaktör | Öncelik 2–3 animasyonlar | **İmza animasyonları** (Öncelik 1) |
| Test senaryoları ve regresyon | UI düzeni | "Bu eğlenceli mi" kararı |
| Çeviri (EN/TR) | Denge tabloları | Katman geçiş kararları |
| **Ekonomi simülasyon kodu** | Simülasyon sonuçlarının yorumu | Değişmez kuralların yorumu |
| NPC görünüm varyasyonları | Sokak isimleri | Anayasa ve ceza tasarımı |
| Belge tutarlılık taraması | Suç kataloğu taslağı | Yeni ad seçimi ve marka kontrolü |

> **Sürüm 3.0 düzeltmesi:** Eski belgede "AI ekonomiyi simüle edemez" yazıyordu. Bu yanlış. AI simülasyonu **yazabilir**; senin yapamayacağın şey bu değil, **sonuçları yorumlamak ve karar vermektir.** `03-EKONOMI.md` §15'teki modeli AI'ya yazdır, sonucu kendin oku.

### 4.1 İkon ve trailer kuralı

Oyun ikonu ve tanıtım videosu **yapay zekâ hissiyatı vermemeli.** Roblox kitlesi bunu fark ediyor ve fark ettiği anda oyunu ciddiye almıyor.

**Çözüm AI ile daha iyi görsel üretmek değil. Çözüm görselin gerçekten oyundan gelmesi.**

- İkon: oyunun içinden, akşam üstü ışığında, kamera açısı ayarlanmış ekran görüntüsü
- Trailer: oyun içi çekim, gerçek oynanış
- Üzerine yalnız yazı ve basit düzenleme

Bu üç şeyi aynı anda sağlar: gerçek görünür, bedava olur ve Roblox'un "kapakta olmayan şeyi gösterme" kuralına uyar.

**Kapak görseli suç göstermemeli** (`A3` §5). Göstermesi gereken: iki işletmesi, evi ve arabası olan bir oyuncu. Akşam üstü ışığında.

**Kısa video için en güçlü dört an:**

1. Polisin çanta sorması ve oyuncunun reddetmesi — 15 saniyede mekaniği anlatır
2. NPC tanığın soyguncunun yüzünü polise tarif etmesi
3. Denetim dosyasının açılması ve tutarsızlığın bulunması
4. **Mahkeme kararının okunması ve tokmak sesi**

Dördü de rakiplerde nadirdir; bunu yayından önce birkaç rakip oyunu inceleyerek doğrula. **Kovalamaca videosu çekme;** o alanda herkes var.

### 4.2 Stilize sanat yönünün üretim faydası

`05` belgesinde stilize yön seçildi. Ortak palet, siluet ve modüler ölçü, farklı kaynaklardan gelen varlıkların tutarlı görünmesini kolaylaştırır. AI varlığındaki topoloji, ölçek veya stil kusuru gizlenmiş sayılmaz; `AI_CONTEXT/3D_MODELING/QA_CHECKLIST.md` ile incelenir.

## 5. Ücretsiz araç yığını ve tuzaklar

Claude ve GPT abonelikleri dışında her şey ücretsiz olacak. Neyin gerçekten ücretsiz olduğu konusunda dikkat gerekiyor.

### 5.1 Güvenli ve ücretsiz

| Araç | Ne için |
|---|---|
| Studio gömülü MCP | Kod, varlık üretimi, test — omurga |
| Creator Store lisanslı ses kütüphanesi | Profesyonel SFX ve müzik |
| Creator Store ücretsiz modeller | Lisans kontrolü şart, script'leri sil |
| Blender | 3D modelleme |
| Rojo ve Git | Sürüm kontrolü, AI'nın dosyaları okuması |

### 5.2 Ücretsiz planı ticari kullanıma kapalı olanlar

**Bu en önemli tuzak.** Game Pass sattığın an oyunun ticari olur. Ticari lisansı olmayan bir sesi veya görseli kullanırsan hem hukuki hem platform riski alırsın.

Bilinen örnek: bazı AI ses araçlarının ücretsiz planı ticari lisans içermez ve üretilen içerik ticari amaçla kullanılamaz.

**Kural:** Bir AI ses veya görsel aracı kullanmadan önce tek soruyu sor — *ücretsiz planın ticari lisansı var mı?* Cevap "hayır" veya belirsizse kullanma. Lisans şartları hızlı değişir; her çeyrekte kontrol et (`A3` §7).

**Lisans kaydı tut.** Kullandığın her dış varlık için kaynak, lisans ve tarih yaz. Kanonik üretim kaydı `PRODUCTION/ASSET_PROVENANCE.md`; sağlayıcı bazlı hak/atıf kontrolü `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` dosyasındadır. “Ücretsiz” veya “AI üretti” ibaresi ticari kullanım kanıtı sayılmaz.

### 5.3 Animasyon için ücretsiz yollar

Tam ücretsiz ve sınırsız bir metin-animasyon yolu yok. Gerçekçi seçenekler:

- Studio içi AI animasyon eklentileri, ücretsiz başlangıç kredisiyle
- Studio Animation Editor: ücretsiz, yavaş, ama **imza animasyonları için zaten elle yapılmalı**
- Creator Store hazır animasyonlar: yürüme, koşma, idle için yeterli
- Blender ve hazır mocap kütüphaneleri: R15'e retarget derdi var

**Plan:** `05` §5.1'deki imza animasyonlarını elle yap. Geri kalanı ücretsiz araçlarla doldur.

## 6. Arkadaşlarına AI öğretme

Bu belgenin en pratik kısmı. Ekibin çoğu muhtemelen yapay zekâyı "soru sorulan şey" olarak biliyor, "iş yaptırılan şey" olarak değil.

### 6.1 Tek oturumluk öğretim planı

30 dakika, herkes bilgisayar başında.

1. Studio MCP'yi bağlat, yeşil göstergeyi gördür
2. Basit bir iş yaptır: "ReplicatedStorage'da Ortak adında bir klasör oluştur" — nesnenin Explorer'da belirdiğini görsünler
3. Bir iş daha: "bu klasörün içine Ayarlar adında bir ModuleScript ekle ve içine şu tabloyu yaz"
4. Bir hata yaptır ve düzelttir
5. Sonra kendi başlarına bir şey denesinler

Beşinci adımdan sonra çoğu kişi kendi yolunu bulur. Asıl engel teknik değil, **"yapabilirim" hissi.**

### 6.2 Dört kural, ezberlensin

**Bağlam ver.** "Market soygunu sistemi yaz" kötü. Belgeyi yükle, hangi servise bağlanacağını söyle, kısıtları yaz.

**Adım adım iste.** Numaralı liste hâlinde ne olacağını yaz. AI bütün işi bir seferde iyi yapmaz.

**Her seferinde sor:** *"Bu kodu hile yapan biri nasıl kötüye kullanır?"* Bu tek soru, projede en çok hata yakalayan şey olacak.

**Kararı sen ver.** AI seçenek üretir, sen seçersin. Seçimi `KARARLAR.md`'ye yaz.

### 6.3 Belge yükleme haritası

Tek kaynak `00-BASLA-BURADAN.md` §10'dur. Burada tekrarlanmaz; gruba o tabloyu sabitle.

Tüm belgeleri birden yüklemek çoğu işte cevabı zayıflatır, çünkü dikkat dağılır. Tek istisna: **belge tutarlılık kontrolü.** O işte tüm paket yüklenir.

## 7. Neyi asla AI'ya bırakma

**Değişmez kuralların yorumu.** AI "bu kumar sayılır mı" sorusuna güvenilir cevap vermez. Şüphedeysen yapma.

**Denge kararları.** AI simülasyonu yazar ve sayı üretir, ama hangi sayının doğru olduğuna telemetri ve sen karar verirsin.

**Anayasa ve ceza tasarımı.** Bir cezanın "adil hissettirip hissettirmediği" insan yargısıdır.

**Yeni ad seçimi.** Marka çakışmasını AI güvenilir biçimde bilmez. Her yeni ad elle aranır (`08` §12).

**"Yeter" kararı.** AI bir sistemi sonsuza kadar iyileştirmeyi önerir. Ne zaman durulacağına insan karar verir.

**Kapsam.** AI her fikre "harika, şunu da ekleyelim" der. Katman kuralı senin elinde.

## 8. İkinci bir yapay zekâyla çalışma

Bu paket iki bağımsız değerlendirmeden geçti ve ikisi birleştirildi. Tekrarlarsan:

1. **Bağımsız başlat.** İkinci AI'ya birinci AI'nın çıktısını başta verme.
2. **Kimlikleri koru.** Her bulgunun bir kodu olsun; birleştirirken eşleştirme bu kodlarla yapılır.
3. **Aynı şeyi söylemeleri doğruluk kanıtı değildir.** İki model aynı eğitim verisinden aynı hatayı öğrenmiş olabilir.
4. **Çelişkileri görünür kıl.** `KARARLAR.md` §4 bunun örneğidir.
5. **Kararı sen ver.** İki AI'nın hemfikir olduğu bir öneriyi de reddedebilirsin; gerekçeni yaz.
