# BAYCREST — Değişiklik Günlüğü

## 26 Eylül 2026 — K0.4.1: kaynağın çalıştırılarak denetlenmesi

K0.4 kaynağı bu kez okunarak veya modellenerek değil, **çalıştırılarak** denetlendi. Roblox Studio erişimi olmadığı için gerçek sahne kurucularını, migration'ı ve K0 runtime'ını sahte bir motorda, sanal saatle ve oyuncu gibi davranarak çalıştıran başsız bir harness kuruldu. Yeni oyun özelliği eklenmedi; fiyat, kapasite ve oranlar değişmedi. Ayrıntı: [`PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md`](PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md).

- **Kurtarma kasayı sıfırlıyordu (kritik).** K0.4 kurtarması kaydı "mevcut kasayla" yeniliyor ve kasayı 0 ₡'ye indiriyordu. Rafı boş oyuncu stok alamıyor, müşteri gelmiyordu: çıkmazı önlemek için eklenen güvenlik ağı çıkmazı üretiyordu. Artık kayıt ücreti siliniyor; oturum başına sınır ve telemetri korundu.
- **Stoksuz harcama çıkmazı giderildi.** Yükseltme, kasiyer, maaş ve yenileme, rafı boş oyuncuyu bir birimin (6 ₡) altında bırakabiliyordu. Ortak koruma ödemeyi reddediyor ve oyuncuya önce stok almasını söylüyor.
- **Sahip devri düzeltildi.** Sahip ayrılınca tezgâh ayrılan oyuncuya geri verilebiliyor, kalan oyuncular izleyici kalıyordu. Devir artık ayrılan oyuncuyu atlıyor. Gerçek motor sırası iki oyunculu Studio testiyle doğrulanacak.
- **Çıkmaz görünür kılındı.** Kurtarma harcandıktan sonra oluşabilecek kalıcı çıkmaz bir kez `dead_end` satırıyla, `K0DeadEndSeconds` attribute'uyla ve özet satırındaki `deadEnd=` alanıyla raporlanıyor. Studio'da Stop'a basınca da `summary reason=server_close` yazılıyor.
- **Migration, HUD ve NPC.** Migration talep panosuna ikinci metin katmanı eklemiyor. HUD sonuç satırı iki satıra bölündü, bildirim kutusu büyüdü. NPC parçaları köke weld'lendi ve yalnız kök hareket ediyor; harness'teki parça yazımı 20 dakikada 382 227'den 81 276'ya indi (cihaz etkisi ölçülmedi). Dekoratif yayalar artık müşteri sayacına girmiyor; tabela fiyatları config'ten yazılıyor.
- **Doğrulama aracı düzeltildi.** Python modeli müşterileri anlık geliyor sayıyordu ve akışı ~2 kat iyimser ölçüyordu: 20 dakikada 55 satış, gerçek kaynakla ölçülen 25. Model kaynaktaki sıralı müşteri döngüsüne göre düzeltildi. K0.4 raporlarına düzeltme notu eklendi; K0.4'ün karşılaştırmalı sonuçları yön olarak geçerli kaldı.
- **Açık tasarım bulgusu (sahip kararı).** Talep panosunu izlemek şu ayarla ekonomide ödüllendirilmiyor. K0.4 bunu tek tohumla ölçüp geçmişti; çok tohumla geri çekildi. Seçenekler ölçüldü, hiçbiri uygulanmadı: `KARARLAR.md` AÇIK-13.
- **Üçüncü doğrulama katmanı.** `TOOLS/run_luau_harness.py` ve `TOOLS/luau_harness/` (16 senaryo, iki sinyal modu). Aynı harness eski K0.4.0 kaynağında 26 çalıştırmanın 10'unda düşüyor, K0.4.1'de 26/26 geçiyor. Sonuç: statik PASS, senaryo 19/20 + 1 açık tasarım bulgusu, harness 26/26 PASS.
- **Durum:** `SOURCE VERIFIED` · `STATIC VERIFIED` · `SCENARIO VERIFIED` · `HARNESS VERIFIED` · **`STUDIO PENDING`** · **`DEVICE PENDING`**. Harness Roblox Studio değildir. Plan: [`PRODUCTION/K0.4_NEXT_TEST_PLAN.md`](PRODUCTION/K0.4_NEXT_TEST_PLAN.md) (Aşama 2d eklendi).

---

## 26 Eylül 2026 — K0.4 prototip sertleştirmesi

K0.3 kaynak paketi bağımsız olarak denetlendi. **İki oyun-durduran hata** bulundu, ölçülerek kanıtlandı ve giderildi. Yeni oyun özelliği eklenmedi; K0 kapsamı büyütülmedi. Ayrıntı: [`PRODUCTION/K0.4_IMPLEMENTATION_REPORT.md`](PRODUCTION/K0.4_IMPLEMENTATION_REPORT.md).

- **Raf kilidi giderildi (kritik).** Her iki üründe `WholesaleBundle == Level1Capacity` olduğu için, tam paket alımı zorunluluğu rafta tek birim kaldığında yenilemeyi matematiksel olarak imkânsız kılıyordu; oyuncu elindeki son birimi satana kadar müşterileri karşılayamıyordu. Artık rafa sığan kadar, aynı birim fiyatından alım yapılıyor (portakal 6 ₡/kg, ekmek 8 ₡/adet). Ölçülen etki (1200s, aynı seed): satış 16 → 55, kaçan satış 12 → 0.
- **Kayıt çıkmazı giderildi (kritik).** Kayıt süresi bitip kasa 70 ₡'nin altına düştüğünde ticaret duruyor, dolayısıyla gelir elde etmenin hiçbir yolu kalmıyordu: kalıcı kilit. Simülasyonda altı oyuncu politikasının üçü t=1328s'de kilitlendi. Artık kayıt borcu varken toptancı geri alım moduna geçiyor (etiketin %50'si) ve oyuncu zararına satıp devam edebiliyor; parası ve stoğu bitmişse oturum başına bir kez kayıt mevcut kasayla yenileniyor. Kurtarma olayı `K0RescueGrants` telemetrisine ve sunucu Output'una yazılıyor. 2400s ölçümünde kilitlenen politika sayısı 3/6 → 0/6.
- **Tohumlu test karşılaştırılabilirliği gerçekten sağlandı.** `PlaytestSeed` "üç testçi karşılaştırılabilir koşullarda oynar" iddiasını taşıyordu ama kaynak bunu vermiyordu: müşteri döngüsü ticaret kapalıyken de akıştan çekim yapıyor, `pickOffer` içindeki bir zar yalnız stok boşken atılıyordu. İkisi de kapatıldı. Artık hızı farklı iki testçi **aynı müşteri türü ve aynı bütçe sinyali dizisiyle** karşılaşıyor. İstenen ürün hâlâ stok durumuna bağlı — bu tasarım gereğidir ve [`K0.4_KNOWN_LIMITATIONS.md`](PRODUCTION/K0.4_KNOWN_LIMITATIONS.md) §5'te kayıtlı.
- **RemoteEvent sertleştirildi.** `K0MarketDecision` sahiplik, mesafe, tip ve kimlik doğruluyordu ama sınırsız trafik kabul ediyordu; Roblox'un resmî güvenlik rehberi doğrulama ile hız sınırlamasını birlikte birincil savunma sayıyor. Oyuncu başına jeton kovası eklendi (3 saniyede 6 karar). NaN ve ondalık teklif kimlikleri de reddediliyor.
- **Müşteri ayrıldıktan sonra tezgâhta kalan eski sipariş metni temizleniyor.**
- **Araştırıldı, hata değil.** `os.clock()` standart Lua'da CPU zamanıdır ama Luau resmî dokümantasyonu bunu "süre ölçümü için yüksek çözünürlüklü zaman damgası" olarak tanımlıyor; mevcut kullanım doğru, değişiklik yapılmadı. Kasiyerin "otomatik kazanma düğmesi" olup olmadığı ölçüldü: 2400s'de kasiyerli işletme sonucu 897 ₡, kasiyersiz 1257 ₡ — kasiyer net getiriyi düşürüyor, gerçek bir yatırım kararı. Değişiklik yapılmadı.
- **Ertelendi.** Pazarlıkta tek bir yuvarlama deliği: etiket 16 ₡ olduğunda `round(16×0.90) = round(16×0.86)`, yani SIKI bütçeli müşteri de karşı teklifi kabul ediyor. Diğer dokuz fiyatta SIKI %90 oranında reddediyor. Düzeltmek ekonomi oranı değiştirmeyi gerektirir; `KARARLAR.md` kararı olmadan yapılmadı.
- **Çift doğrulama kuruldu.** `TOOLS/validate_package.py` genişletildi: ürün değişmezleri, attribute üretici/tüketici eşleşmesi, RemoteEvent eylem eşleşmesi, config alan tüketimi, özet format/argüman sayısı ve **gerçek Luau derleyicisiyle** sözdizimi kontrolü. K0.3'ün raf kilidi deseni kaynağa dönerse doğrulayıcı hata veriyor. `TOOLS/simulate_k0.py` (ekonomi modeli) ve `TOOLS/scenarios_k0.py` (20 zorunlu senaryo, GIVEN/WHEN/THEN/FAILURE MODE) eklendi. Sonuç: statik PASS, senaryo 20/20 PASS.
- **`ASSET-PROMPTS/` eklendi (12 dosya).** Sonraki AI oturumlarına verilecek 3D, animasyon, müzik, SFX, UI ve malzeme promptları; varlık kabul listesi ve provenance şablonu. Bu oturumda **hiçbir varlık üretilmedi**. Seslendirme K0 için gerekçesiyle **önerilmiyor**.
- **Lisans doğrulaması.** Suno resmî Terms: ücretsiz plan yalnız "personal and non-commercial", ücretli planda haklar kullanıcıya devrediliyor, ancak her iki planda da telifin oluşacağı garanti edilmiyor. Meshy resmî şartları: ücretsiz plan çıktısı CC BY 4.0, **atıf zorunlu**; ücretli planda atıf gerekmiyor. Udio ve seçilmemiş araçlar `UNKNOWN / REVIEW REQUIRED` — kullanılamaz.
- **Durum:** `SOURCE VERIFIED` · `STATIC VERIFIED` · `SCENARIO VERIFIED` · **`STUDIO PENDING`** · **`DEVICE PENDING`**. Bu sürüm Studio'da çalıştırılmadı, Android'de ölçülmedi, oyuncu testinden geçmedi. Plan: [`PRODUCTION/K0.4_NEXT_TEST_PLAN.md`](PRODUCTION/K0.4_NEXT_TEST_PLAN.md).

---

## 26 Eylül 2026 — K0.3 final kaynak denetimi

- Aktif K0 kaynak sürümü `K0-market-0.3.0` olarak sabitlendi; gameplay RNG her test sahibi için aynı seed ile yeniden başlıyor, dekoratif RNG ayrıldı.
- RemoteEvent karar doğrulaması sıkılaştırıldı; pazarlıkçı olmayan müşteride sahte `counter` isteği sunucuda reddediliyor. Aynı sürüm çift-runtime kilidi ve legacy runtime uyarısı korunuyor.
- İlk sahiplik, stok, teklif, karar, satış, yükseltme ve çalışan süreleri ile stok/pazarlık/kayıt/maaş sayaçları test kanıtı için genişletildi. 20 dakikada server özeti yazılıyor; oyun durmuyor ve oyuncuya geri sayım gösterilmiyor.
- 9 dakikalık K0 pazar kaydı süresi 22 dakikaya taşındı. Böylece 20 dakikalık çekirdek kapı iki yenilemeyle bölünmiyor ve düşük nakitte K0 içinde geri dönüşsüz askıya alınma riski kapı ölçümünden çıkarılıyor; production ruhsat kuralı değişmedi.
- Mobil teklif paneli dar ekranda büyük/dikey dokunma hedeflerine geçti; prototip ücret metinleri config'ten okunuyor.
- `PRODUCTION/K0_TEST_RECORD_TEMPLATE.md` K0.3 ölçüm alanlarıyla güncellendi; 25 Eylül K0.2 ve teknik kontrol belgeleri tarihsel kayıt olarak işaretlendi.
- AI/üçüncü taraf varlıklar için girdi hakkı, çıktı hakkı, atıf, yeniden dağıtım, Roblox uyumu ve provenance kapılarını tanımlayan `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` eklendi ve varlık pipeline'ına bağlandı. OpenAI, Roblox AI, Creator Store, Meshy, Tripo ve ElevenLabs için araç/plan ayrımını gösteren `PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md` eklendi.
- `PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md` ve `TOOLS/validate_package.py` eklendi. Statik paket tutarlılığı ayrı, Studio/Android/oyuncu doğrulaması ayrı statü olarak tutuluyor.
- Kanonik K0 kuralı gereği polis/suç/silah K0.3'e eklenmedi. Zayıflık raporundaki 0B fikri, istenirse ayrı deney olarak ele alınacak; sahiplik K0 sonucuyla karıştırılmayacak.

---

## 25 Eylül 2026 — K0 Luau prototip yeniden yapılandırması

- 8 MB `BAYCREST.zip` kaynak paketi içindeki K0 Luau akışı zayıflık planına göre yeniden düzenlendi.
- Aktif K0 runtime `K0Market` altında tekilleştirildi; eski `K0Game` ve `K0HUD` kaynakları `GAME/legacy/` altına taşındı.
- İlk sahiplik ekonomi engelinin önüne alındı; görünür talep, iki stok kararı ve açıklanabilir pazarlık sinyali eklendi.
- Gizli `CounterAcceptChance` kaldırıldı; teklif müşterinin doğuşunda sabitlenen bütçe profiline bağlandı.
- Pazar kaydı borcunda ticaret askıya alınıyor; sahiplik ve stok silinmiyor.
- Ciro, işletme gideri, işletme sonucu ve yatırım ayrı tutuldu; owner ayrılışı ve leaderstats çakışması sertleştirildi.
- HUD küçük ekranlara göre ölçekleniyor; K0 milestone süreleri test gözlemi için Attribute olarak sunuluyor.
- `K0_MARKET_V2_MIGRATION.lua`, yeni üretim kaydı ve K0.2 test gözlem alanları eklendi; migration eski `K0Game/K0HUD` runtime'ını devre dışı bırakıyor ve yeni server etkin legacy runtime görürse uyarıyor.
- İlk müşteri artık oyuncu en az bir stok kararı vermeden başlamıyor; stoktan sonra karşılanamayan alternatif ürün talepleri karar geri bildirimi olarak korunuyor.
- Bu tur kaynak ZIP üzerinde uygulandı; Roblox Studio, Android ve üç bağımsız oyuncu testi henüz doğrulanmadı.

---

## 25 Eylül 2026 — Üretim dokümantasyonu düzeni

- 3.0 ürün kararları korunarak `README.md`, `DOKUMAN-YONETIMI.md` ve `DOKUMAN-DENETIMI.md` eklendi.
- AI görev rotası, Roblox MCP çalışma akışı ve 3D üretim/QA standardı `AI_CONTEXT/` altında yazıldı.
- İlk K0/K1 sahne ve varlık brief'leri `DESIGN_DRAFTS/` altında `TASLAK` statüsüyle açıldı; köken ve test şablonları `PRODUCTION/` altına eklendi.
- K0 kapısındaki üç testçi/“ikisi de” uyumsuzluğu, hatalı karar bağlantısı, özel belgelere ekip bağımlılığı ve ölçülmemiş performans rakamlarının sunumu düzeltildi.
- Oyun kodu, Studio içeriği ve ürün kararları bu dokümantasyon turunda değiştirilmedi.

---

**Sürüm 2.0 → 3.0 · 24 Eylül 2026**

Bu dosya, sürüm 2.0 paketine göre ne değiştiğini dosya dosya gösterir. Kararların gerekçeleri `KARARLAR.md`'dedir.

---

## Paket yapısı

| Değişiklik | Dosya |
|---|---|
| **Yeni** | `KARARLAR.md` — tek karar kaynağı |
| **Yeni** | `EKIP/09-ADALET-VE-ANAYASA.md` |
| **Yeni** | `EKIP/10-IS-VE-MESLEK-KATALOGU.md` |
| **Yeni** | `DEGISIKLIK-GUNLUGU.md` |
| **Yeni** | `OZEL/ARSIV/B-Degerlendirme-Raporu-ChatGPT-v1.0.md` |
| Güncellendi | Diğer 13 belgenin tamamı; hepsi sürüm 3.0 |

OZEL belgeleri artık paketle aynı sürüm numarasını taşıyor (eskiden 1.0'dı).

---

## Kullanıcı kararlarının uygulandığı yerler

| Karar | Nerede uygulandı |
|---|---|
| UK-13 Silahlar pahalıdır | `02` §7.1, `03` §8, `03` §14 |
| UK-14 Kimse ölmez, yaralanır ve hastaneye gider | `00` Kural 6, `02` §7.4–7.5, `05` §1.5, `05` §2.3, `10` MS-03 |
| UK-15 Yüksek hasar yok | `02` §7.2, `03` §14 |
| UK-02 Mesleğe göre risk | `02` §10, `10` §4 |
| UK-03 Anayasa | `09` §2 |
| UK-04 Çevrimdışı mahkeme | `09` §8.3, `04` §9.3 |
| UK-05 Delile dayalı hapis | `09` §5 |
| UK-06 Birden çok çıkış yolu | `09` §10 |
| UK-07 Kaçış raporu | `09` §11 |
| UK-08 Hafif cezalar | `09` §6, §9 |
| UK-09 Kapasite prototipte ölçülür | `07` §2 |
| UK-10 Kurumlar haritada | `05` §2.3 |
| UK-11 Geniş işletme kataloğu | `10` |

---

## Dosya dosya değişiklikler

### `OKU-ONCE.md`
Yeni belge haritası, karar kaydı vurgusu, doğrulama sınırı bölümü.

### `00-BASLA-BURADAN.md`
- Değişmez kurallar 7'den 8'e çıktı. Kural 6 yeniden yazıldı (ölüm ve yüksek hasar yasağı). Kural 7 yeniden yazıldı: gizli bilgi sonradan okunabilir iz bırakır. Kural 8 eklendi: Robux ile güç satılmaz.
- Kural 1'e "sonucu gizli rastgelelikle belirlenen satın alma" netleştirmesi eklendi.
- Kural 2 esnetildi: Creator Store varsayılan kaynak; başka kaynak ancak belgelenmiş ticari lisansla.
- Kural 3 "tanınmış gerçek marka" olarak netleşti ve marka arama süreci eklendi.
- Kural 5'e ibadethanelerin güvenli bölge olduğu eklendi.
- Beşinci tasarım ilkesi eklendi: risk mesleğe göre değişir.
- Yeni bölüm 7: Verania Anayasası özeti.
- Yeni bölüm 8: konumlandırma, kitle, topluluk sahipliği, para konuşması (eskiden yalnız OZEL'deydi).
- İsim tablosuna Bazaar, Wrenmoor, mahkeme, cezaevi, hastane eklendi.
- "İsimlerin tamamı İngilizce" ifadesi düzeltildi: yer ve kurum adları İngilizce, marka adları kurgusal olmak şartıyla serbest.
- Belge yükleme haritası tek kaynak hâline getirildi.

### `01-SAHIPLIK-VE-ISLETME.md`
- **Tek yazar kuralı** ve olay kutusu eklendi.
- Cephe sistemi **beş yuva sınıfına** dönüştü; kapasite çevrimiçi işletme sayısına göre hesaplanıyor.
- Beş adımlı yerleşim akışı ve "uzaktan hizmet" durumu eklendi; oyuncu artık kuyruğa alınmıyor.
- Şirket rehberi eklendi.
- İlk 10 saat tablosu yeniden yazıldı: **ilk oturum tezgâh sahipliğiyle bitiyor.**
- Yeni bölüm 4: dört zaman birimi, maaş günü, çevrimdışı pencere, dondurma modu.
- Taksi şoförünün %75 payı kaldırıldı; **tek çalışan modeli** geldi.
- Çalışan işe alımına referans kontrolü ve deneme süresi eklendi; fırsatçının çekimi defterde görünüyor.
- Robux ile işletme slotu kaldırıldı.
- Ev: örneklenmiş iç mekân kararı yazıldı.
- Telefondan ayarlar çıkarıldı.
- Yeni bölüm 11: geri dönüş çekicileri.
- Meslek hatları iş ailelerine bağlandı.

### `02-ENVANTER-VE-SUC.md`
- Adı "Envanter, Güvenlik ve Suç" oldu.
- Slot yerine **birim** modeli. Temel eşyalar (kimlik, cüzdan, anahtarlık) yer tutmuyor. Cüzdan 2.500 ₡'ye kadar nakit taşıyor.
- Riskli taşımada **önizleme ve onay** eklendi; eşya sessizce ele geçmiyor.
- Yeni bölüm 4: bilgi erişim matrisi.
- Polis etkileşimi **üç kademeye** ayrıldı; bekleme süreleri ve yetki puanı eklendi.
- **Yeni bölüm 7: silah, hasar, yaralanma, hastane.** Bağlam kuralı, yaralı durumu, hastane, düşen eşyalar, güvenli bölgeler, yeni oyuncu koruması. Pompalı tüfek kaldırıldı. NPC'ler hasar almıyor.
- Robot resim artık olay anının görüntüsü; RP kıyafet katmanı eklendi.
- Şehir alarm seviyesi eklendi.
- Yeni bölüm 10: dört risk türü, sektöre göre soyulabilir kasa, NPC şehir hedefleri, hedef koruması, anlaşmalı soygun kontrolü.
- Aklama: kota yasal satışa bağlandı, üç risk bölgesi tanımlandı, aklanan para ciroya sayılmıyor.
- FCU'ya çıkar çatışması kuralları, NPC vakaları ve defter bulmacası eklendi.
- Ceza bölümü `09`'a bağlandı; dar istisnalar yazıldı.

### `03-EKONOMI.md`
- Yeni bölüm 3: **hesap sözleşmesi** (ciro, maliyet, ücret, gider, net).
- **Çarpma hatası düzeltildi:** "14.000 ₡, 20 dakikadan az" ifadesi yanlıştı.
- Çevrimdışı model değişti: net %10 / %5, 8 saatlik pencere.
- Suç bölümü yeniden yazıldı: **1,2–1,5 temiz servet oranı hedefi** ve türetme hesabı.
- Soygun tablosu NPC şehir hedeflerine taşındı; değerler düşürüldü.
- Oyuncu kasası tavanları eklendi.
- Yeni bölüm 8: silah maliyetleri.
- Yeni bölüm 9: sağlık, ceza ve sigorta.
- Servete endeksli fiyat kaldırıldı; giriş fiyatları sabit, prestij endeksi medyana bağlı.
- Telemetri kohort ölçütlerine geçti; basılan/yok edilen oranı alarm ölçütü olmaktan çıktı.
- Robux tablosu yenilendi; işletme slotu kaldırıldı, özel sunucu abonelik olarak düzeltildi.
- `Ayarlar.lua` büyüdü ve çatışma, sağlık, adalet değerlerini kapsıyor.
- Yeni bölüm 15: ekonomi modeli şartı.

### `04-TEKNIK.md`
- "İstemciden hiçbir miktar gelmez" genellemesi **yedi kontrol** listesine dönüştü.
- Sızıntı yolları genişletildi: Attribute, etiket, ReplicatedStorage.
- Yeni bölüm: **tek yazar kuralı**, olay kutusu, adalet kuyruğu ve kilit.
- Yeni `IslemServisi`: işlem kimliği, rezerve-onay deseni, kurtarma. `UpdateAsync`'in sınırı yazıldı.
- Yeni `CatismaServisi` ve `ModerasyonServisi`. Yeni `AdaletServisi`.
- **`Humanoid.Died` tetiklenmemeli** notu eklendi.
- NPC animasyonu: `AnimationController` düzeltmesi.
- Yol ağı üzerinde arama; "çalışma anında yol bulma yok" kuralının çelişkisi giderildi.
- NPC kapasitesi "ölçülecek" olarak işaretlendi.
- Ev iç mekânı mimarisi yazıldı.
- Metin filtresi, tabela şablonu, engelleme ve raporlama kuralları eklendi.
- Özel sunucu modları ve yönetici yetki sınırları yazıldı.
- Test bölümüne adalet protokolü eklendi.
- Yeni bölüm 15: tek doğruluk kaynağı tablosu.
- AI hata tablosuna yedi yeni satır eklendi.

### `05-HARITA-SANAT-ANIMASYON.md`
- **Ölçek stud yerine yolculuk süresiyle** tanımlandı; 2.000 stud değeri iptal edildi.
- Yeni §1.5: şiddetin görsel dili (kan yok, sakin ambulans, abartısız silah efekti).
- Bölge listesine Blackstone Bazaar, Blackstone Arcade ve Wrenmoor eklendi.
- Yeni §2.3: beş kurum ve ilk sürüm kapsamları.
- Cephe bölümü **yuva sınıflarına** dönüştü.
- İbadethaneler güvenli bölge oldu.
- Yeni §4.1: RP kıyafet katmanı.
- Animasyon listesi büyüdü: yaralı çökme, yerde bekleme, ilk yardım, sedye, duruşma, cezaevi görevleri. Katman sütunu eklendi.
- NPC animasyonu düzeltmesi.
- **Marka değişikliği:** Anadol → Ova Motors, Kartal → Siper. Ambulans önceliği 1'e çıktı.
- Bagaj 12'den 24 birime geçti.
- "20 bina 3 saatte" gibi ölçülmemiş vaatler kaldırıldı.

### `06-ARAYUZ-VE-SES.md`
- HUD kuralı 4'ten 5 öğeye çıktı ve tam liste yazıldı. Şüphe çelişkisi giderildi.
- Durum rozeti eklendi: aranma, infaz veya kaçak.
- Envanter ekranı birimlere geçti; göz simgeleri renk, simge ve metin birlikte.
- Riskli taşıma önizlemesi eklendi.
- Polis ekranı üç kademeye ayrıldı; pasif butonların sebebi yazılıyor.
- **Yeni ekranlar:** olay açıklama kartı, yaralı ekranı, hastane çıkışı, adalet ekranları, dönüş özeti, şirket rehberi, defter bulmacası.
- İşletme yönetimine hesap sözleşmesi satırları ve kota göstergesi eklendi.
- Ayarlar telefondan çıkarıldı.
- Yeni bölüm 5: erişilebilirlik.
- Yeni §7.2: metin filtreleme, tabela şablonu, engelleme, raporlama.
- Ses: dördüncü imza sesi (tokmak), sağlık ve adalet sesleri, Creator Store kuralının esnetilmiş hâli.

### `07-YOL-HARITASI.md`
- Katman yapısı 5'ten **7'ye** çıktı (K0–K6). Eski Katman 2 üçe bölündü.
- Kapılarda beyan yerine davranış ölçülüyor.
- K0'a kapasite ölçümü eklendi (UK-09).
- K3 kapısına taciz testi ve çatışma testi eklendi.
- K4 kapısı 13 kabul senaryosuna bağlandı.
- Yayın kontrol listesi büyüdü: alkol, hangout, filtre, engelleme, ekonomi modeli, topluluk sahipliği, gelir paylaşımı, marka araması.
- Risk listesine adalet sisteminin büyümesi ve taciz eklendi.
- Başarı ölçütlerine ilk oturum sahipliği ve suç oranı eklendi.
- Küçük örneklemde oran kullanılmaması kuralı yazıldı.
- "Katman 0 (2 hafta)" ifadesi kaldırıldı.

### `08-SOZLUK.md`
- Yeni bölümler: zaman birimleri, adalet terimleri, sağlık ve çatışma terimleri, karar kimlikleri.
- Eşya sınıflarına birim sütunu ve "Temel" sınıfı eklendi.
- Kod adı kuralı netleşti: servis adları da Türkçe.
- Marka tablosu güncellendi ve değişiklik notu eklendi.
- Yasak isimlere "yeni ad koyma süreci" eklendi.
- Yer adlarına Bazaar, Arcade, Wrenmoor eklendi.

### `OZEL/A1-AI-IS-AKISI.md`
- **"AI ekonomiyi simüle edemez" iddiası düzeltildi.** AI simülasyonu yazar, insan yorumlar.
- MCP araç adları yerine yetenek listesi; dokümantasyona yönlendirme.
- Regresyon testine öncelikli senaryolar eklendi.
- Dördüncü video anı (mahkeme) eklendi.
- "Rakipsiz" iddiaları "doğrula" olarak işaretlendi.
- Lisans kaydı tutma kuralı eklendi.
- Belge yükleme haritası `00`'a bağlandı; tekrar kaldırıldı.
- Yeni bölüm 8: ikinci bir yapay zekâyla çalışma yöntemi.

### `OZEL/A2-PROMPT-KUTUPHANESI.md`
- Oturum açılışı yeni kurallarla güncellendi.
- Servis şablonuna yedi kontrol, işlem kimliği ve AnimationController eklendi.
- **Yeni şablon 4:** çatışma, sağlık ve hastane.
- **Yeni şablon 5:** adalet sistemi.
- Envanter şablonu birimlere ve onay akışına güncellendi.
- Kod incelemesi 8'den 12 maddeye çıktı.
- Ekonomi şablonuna model kurma bölümü eklendi.
- Belge güncellemeye **tam tarama** şablonu eklendi.
- Kaçınılacak kalıplara üç yeni satır eklendi.

### `OZEL/A3-PLATFORM-VE-PARA.md`
Beş düzeltme yapıldı:

| Konu | Eski (yanlış) | Yeni (doğrulandı) |
|---|---|---|
| Yayın eşiği | 500 oynanış | 250 oynanış |
| Restricted etiket | 17+ | 18+ |
| Moderate etiket | Yalnız 16+ | 9–15 yaş Select'e de açılabilir |
| DevEx yaşı | 18 | 13 |
| Topluluk kurma | Bedava | 100 Robux |

- Yaş kontrolünde 18 yaş altı için yüz tahmini seçeneği eklendi.
- 50.000 Robux hızlandırılmış inceleme seçeneği eklendi.
- Özel sunucu Game Pass'ten aylık aboneliğe düzeltildi.
- Türkiye erişimi **[ÇELİŞKİLİ]** olarak işaretlendi.
- 7578 sayılı Kanun'un oyun platformlarını ayrı düzenlediği ve teknik hükümlerin Kasım 2026'da yürürlüğe gireceği yazıldı.
- Hangout sınıflandırması ve alkol kuralı eklendi.
- ABD 18+ DevEx oranı fırsatı eklendi.
- Her satır [DOĞRULANDI] / [ÇELİŞKİLİ] / [VARSAYIM] olarak işaretlendi.
- Yeni bölüm 6: Baycrest ve Blackstone adlarının marka riski.

---

## Belge içi tutarlılık düzeltmeleri

| Sorun | Çözüm |
|---|---|
| "Katman 0 (2 hafta)" ile "takvim yok" çelişkisi | Süre kaldırıldı |
| K0'da "harita yok" ile "Blackstone Çarşı var" çelişkisi | "Gri kutu tek sokak" olarak birleştirildi |
| Cephe dağıtımı K1'de, cepheler K2–K3'te | Tezgâhlar K0–K1'e, standart cepheler K3'e |
| Şüphe "gösterilir" / "gösterilmez" çelişkisi | `06` §1 ve §2 uyumlu hâle getirildi |
| HUD'da 4 öğe kuralı, 5 öğe listesi | Kural 5'e çıkarıldı |
| "Sınıf adları İngilizce" ile Türkçe servis adları | Tek kural: servis adları Türkçe |
| `gorunurEnvaniteriHesapla` yazım hatası | Düzeltildi |
| Ses kuralı ile "AI ses efekti yapar" çelişkisi | Kural 2 esnetildi, AI tablosu düzeltildi |
| İki farklı belge yükleme haritası | Tek kaynak: `00` §10 |
| "Köy bakkalı" hedefi K4 bölgesinde | NPC mahalle bakkalı K3'e taşındı |
| "Yedi küçük çıktı", altı rol | Altı rol, altı çıktı |
| "Araç asla alınmaz" ile "araç çalınırsa bagaj gider" | Araç hırsızlığı kapsamdan çıkarıldı |
| Ev sisteminde paralel sunucu sorunu | Örneklenmiş iç mekân kararı |
| İbadethanelerde suç engeli yok | Güvenli bölge |
| "Kamera silme" animasyonunun karşılığı yok | Listeden çıkarıldı; yerine adalet animasyonları |
| NPC verim tablosu iki belgede | Yalnız `03`'te; `01` referans veriyor |
| OZEL 1.0 / EKIP 2.0 sürüm farkı | Hepsi 3.0 |

---

## Elenen fikirler

Çevrimdışı soygun · Oyuncu hâkim · Robux ile işletme slotu · Pompalı tüfek · Taksi şoförüne %75 pay · Servete endeksli giriş fiyatları · Serbest metinli tabela · Anadol ve Kartal marka adları

## Ertelenen fikirler

İşletme uzmanlaşması · Oyuncu dükkânlarının gizleme ekipmanı satması · Oyuncu istihdamı · Kısa iş ortaklığı · Tedarikçi teklifleri · Görünür kalite kontrolü · Mahalle talep olayları · Kefalet · Avukatlık · Çanta kapkaçı · Sahte defter · Tanık satın alma · Kişisel şehir hafızası · Ev hırsızlığı · Araç hırsızlığı

Tam gerekçeler: `KARARLAR.md` §5.

---

## Açık kalan konular

`KARARLAR.md` §6'da 12 madde izleniyor. İkisi kullanıcı kararı gerektiriyor:

- **AÇIK-01:** "Baycrest" ve "Blackstone" adlarının marka riski
- **AÇIK-09:** Tüm yaşlara açılma kararı (Katman 6)
