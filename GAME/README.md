# Baycrest K0 — Roblox Studio prototip kaynakları

**Kaynak sürümü:** `K0-market-0.4.1` · 26 Eylül 2026  
**Studio hedefi:** place ID `83986068176961`, `Workspace/BlackstoneBazaar_K0`  
**Durum:** K0.3 denetlendi; iki oyun-durduran hata giderildi (K0.4). K0.4 kaynağı başsız harness'te çalıştırıldı; harness'in düşürdüğü beş hata ve eşlik eden telemetri eksikleri giderildi (K0.4.1). Bu ZIP'in üretilmesi Studio place'inin otomatik olarak güncellendiği veya oyuncu testinin geçtiği anlamına gelmez.

K0'ın tek sorusu: **“Oyuncu ilk dakikalarda bir şeye sahip olup, görünür kararlarla büyütmek istiyor mu?”** Polis, suç, silah, kalıcı veri ve büyük şehir bu prototipin kapsamı değildir.

## Aktif runtime

Studio'ya aktif olarak yalnız şu üç kaynak kurulmalıdır:

| Yerel kaynak | Studio yolu | Rol |
|---|---|---|
| `src/ReplicatedStorage/K0MarketConfig.lua` | `ReplicatedStorage/K0MarketConfig` | Production / Prototype sayılarını ayırır |
| `src/ServerScriptService/K0Market.server.lua` | `ServerScriptService/K0Market` | Tek sunucu-yetkili K0 runtime |
| `src/StarterPlayerScripts/K0MarketHUD.client.lua` | `StarterPlayer/StarterPlayerScripts/K0MarketHUD` | Mobil/PC arayüzü; yalnız istek yollar |

Eski `K0Game`, `K0HUD` ve `K0Config` kaynakları çifte runtime ve aynı Attribute/Prompt alanlarına iki yazar riski yarattığı için `GAME/legacy/` altına taşındı. **Aktif place'te eski `K0Game`/`K0HUD` ile yeni `K0Market` birlikte çalıştırılmamalıdır.**

## Sahne kurulum kaynakları

- `SCENE_BUILD.lua`: ilk gri kutu.
- `STALL_ART_BUILD.lua`, `ART_V2_FIX.lua`, `STALL_ART_V3.lua`: tezgâh sanat katmanı.
- `MARKET_SYSTEM_BUILD.lua`: pazar yönetimi, toptancı, ürün gösterimleri ve talep panosunu yeni sahneye ekler.
- `K0_MARKET_V3_MIGRATION.lua`: mevcut `MarketSystem` kurulmuş bir place'e talep panosu ve güncel prompt metinlerini idempotent biçimde ekler; eski `K0Game` / `K0HUD` scriptleri hâlâ aktifse devre dışı bırakır.

## Yeni K0 akışı

1. Oyuncu tezgâhı **ücretsiz ve hemen sahiplenir**. İlk sahiplik ekonomi grind'ının arkasına saklanmaz.
2. Pazar Yönetimi'nde 70 ₡ prototip kayıt bedeli ödenir.
3. Oyuncu görünür talep panosuna bakıp **portakal veya ekmek stokuna** para bağlar.
4. Talep yaklaşık 60 saniyede bir değişir; talep gören ürünün dünya fiyat etiketi ve teklif fiyatı `%15` artar.
5. Normal alıcı etiketi kabul eder. Pazarlıkçıda oyuncu düşük garantili teklifi kabul eder, bütçe sinyaline göre daha yüksek karşı teklif verir veya satışı reddeder.
6. 250 ₡ prototip maliyetiyle seviye 2 kapasitesi açılır. Sonra 60 ₡ yatırım ile kasiyer alınabilir; maaş işletme gideridir.
7. K0 testinde pazar kaydı 22 dakika sürer; 20 dakikalık kapı ölçümünü bölmez. Oyuncu testten sonra devam ederse süre sonunda sahiplik/stok silinmeden **ticaret askıya alınır** ve yenilemeyle devam eder.
8. **K0.4:** stok yenileme artık tam paket zorunluluğu taşımıyor; rafa sığan kadar, aynı birim fiyatından alınıyor (portakal 6 ₡/kg, ekmek 8 ₡/adet).
9. **K0.4:** kayıt borcu varken toptancı tezgâhları kapanmıyor, **geri alım** moduna geçiyor. Oyuncu stoğunu etiketin %50'sine tasfiye edip kaydı yenileyebiliyor. Parası ve stoğu bitmişse oturum başına **bir kez** kayıt **ücretsiz** yenileniyor (**K0.4.1**; K0.4'te kasayı sıfırlıyordu) ve bu olay telemetriye yazılıyor.
10. **K0.4.1:** rafı boş oyuncunun yükseltme, kasiyer veya maaş ödemesi, ödeme sonrası kasası en ucuz birimin (6 ₡) altında kalacaksa reddedilir ve oyuncuya önce stok alması söylenir. Stoksuz tezgâha müşteri gelmediği için bu durum oturumu bitirirdi.

Bu akıştaki `70 / 250 / 60 / 45 ₡`, `%15` ve sıkıştırılmış süreler **K0 playtest değeridir**. `K0MarketConfig.Production` altında tutulan kanonik ekonomi değerlerinin yerine geçmez.

## K0'da giderilen kod zayıflıkları

- Eski ve yeni iki runtime'ın aynı Prompt/Attribute/leaderstats alanlarına yazma riski kaldırıldı.
- Sahiplik ilk dakikaya taşındı; izin ve stok sahiplikten sonra geliyor.
- Tekrarlı “E bas, para al” yerine görünür talep, stok seçimi ve pazarlık kararı eklendi.
- Pazarlık sonucundaki gizli `CounterAcceptChance` kaldırıldı. Müşteri bütçesi müşteri doğarken sabitlenir ve oyuncuya `SIKI / ORTA / ESNEK` sinyali verilir; karar anında rastgele yazı-tura atılmaz.
- Ruhsat/kayıt borcu varken satış ve stok yenileme gerçekten askıya alınır; önceki sürümde satış devam ederken yalnız yükseltme engellenebiliyordu.
- `ciro`, `işletme gideri`, `işletme sonucu` ve `yatırım` ayrı tutulur; “net” kelimesi iki farklı hesabı anlatmaz.
- Owner ayrıldığında nil-owner yarışları temizlenir ve sıradaki oyuncu yeni tek satıcı olarak atanabilir.
- İlk müşteri stok seçimi yapılmadan spawn olmaz; stoktan sonra diğer ürüne gelen karşılanamayan talep yine karar geri bildirimi olarak kalabilir.
- Studio place'inde eski `K0Game` hâlâ aktifse yeni runtime açık uyarı verir; migration scripti legacy server/client scriptlerini devre dışı bırakır.
- `leaderstats` tekrar oluşturulmaz; var olan klasör/değer yeniden kullanılır.
- HUD küçük ekranlara göre ölçeklenir ve dokunmatik `Activated` yolunu korur.
- İlk sahiplenme, ilk stok, teklif açma, ilk karar, satış, yükseltme ve çalışan süreleri oturum içi Attribute olarak kaydedilir; stok/talep uyumu ve pazarlık karar sayaçları da gözlem için tutulur. Bu kalıcı telemetri değildir.
- Oynanış rastgeleliği dekoratif kalabalıktan ayrılmış ve sabit K0 test seed'ine bağlanmıştır; üç bağımsız testçi daha karşılaştırılabilir koşullarda oynar.
- 20 dakikalık hedef sürede server Output'a özet satırı yazılır; oyun otomatik durmaz ki “kendiliğinden devam” davranışı bozulmasın.
- Pazar kaydı süresi 22 dakikaya çıkarıldı. Önceki 9 dakikalık süre K0 kapısında gereksiz iki yenileme ve nakit yetersizse geri dönüş yolu olmayan askıya alınma riski yaratıyordu; yenileme davranışı 20 dakikalık çekirdek ölçümden sonraya taşındı.
- Aynı sürümde ikinci bir `K0Market` kopyası da runtime kilidiyle hata verir; yalnız farklı sürüm çakışması değil aynı sürüm kopyası da yakalanır.
- Mobil dar ekranda pazarlık düğmeleri tek satırda küçülmek yerine dikey ve daha büyük dokunma hedeflerine dönüşür.
- HUD ve dünya panolarındaki prototip ücretleri mümkün olduğunca `K0MarketConfig` üzerinden okunur; sayı sürüklenmesi azaltılır.

## K0.4'te giderilen kod zayıflıkları

- **Raf kilidi.** `WholesaleBundle == Level1Capacity` olduğu için, tam paket alımı zorunluluğu rafta tek birim kaldığında yenilemeyi imkânsız kılıyordu. Ölçüldü: 20 dakikada 12 kaçan satış, oyuncu dakikalarca hiçbir müşteriyi karşılayamıyor. Artık rafa sığan kadar alınıyor; aynı ölçümde kaçan satış 0'a indi.
- **Kayıt çıkmazı.** Kayıt bitip kasa yetersiz kalınca ticaret duruyor ve gelir yolu kalmıyordu: kalıcı kilit. Simülasyonda altı politikanın üçü t=1328s'de kilitlendi. Tasfiye çıkışı ve sınırlı kurtarma eklendi; kilit 0'a indi.
- **Tohumlu akış sapması.** Müşteri döngüsü ticaret kapalıyken de RNG'den çekim yapıyordu; ayrıca `pickOffer` içindeki bir zar yalnız stok boşken atılıyordu. İkisi de kapatıldı; hızı farklı testçiler artık aynı müşteri ve bütçe sinyali dizisini görüyor.
- **RemoteEvent hız sınırı.** `K0MarketDecision` sınırsız trafik kabul ediyordu. Oyuncu başına jeton kovası eklendi (3 saniyede 6 karar); NaN ve ondalık teklif kimlikleri reddediliyor.
- **Eski prompt metni.** Müşteri ayrıldıktan sonra tezgâh eski siparişi ilan etmeye devam ediyordu; temizleniyor.

Ayrıntı ve ölçüm tabloları: [`../PRODUCTION/K0.4_IMPLEMENTATION_REPORT.md`](../PRODUCTION/K0.4_IMPLEMENTATION_REPORT.md). K0.4 mutlak sayıları iyimser bir modelden geliyordu; düzeltilmiş hâli K0.4.1 raporu §5'tedir.

## K0.4.1'de giderilen kod zayıflıkları

Hepsi başsız Luau harness'inde (`python3 ../TOOLS/run_luau_harness.py`) önce eski kaynakta düşürüldü, sonra düzeltildi. Harness Studio değildir.

- **Kurtarma kasayı sıfırlıyordu.** Kurtarılan oyuncu 0 ₡ ile kalıyor ve stok alamıyordu; kurtarma, önlemesi gereken çıkmazı üretiyordu. Artık kayıt ücreti siliniyor.
- **Harcama oyuncuyu stoksuz ve parasız bırakabiliyordu.** Yükseltme, kasiyer, maaş ve yenileme için ortak `wouldStrand` koruması eklendi.
- **Sahip devri ayrılan oyuncuya dönebiliyordu.** Devir ayrılan oyuncuyu atlıyor. Gerçek motor sırası Studio'da iki oyuncuyla doğrulanacak.
- **Kalıcı çıkmaz sessizdi.** Artık bir kez `dead_end` satırı, `K0DeadEndSeconds` ve özet satırında `deadEnd=` yazılıyor.
- **Studio Stop'ta özet yazılmıyordu.** `BindToClose` ile `summary reason=server_close`; son özet oturum başına bir kez.
- **Migration talep panosuna ikinci metin katmanı ekliyordu.** Aynı yüzdeki SurfaceGui yeniden kullanılıyor.
- **HUD sonuç satırı taşıyordu (tahmin).** İki satıra bölündü; bildirim kutusu 4 satır, süre metin uzunluğuna göre.
- **NPC hareketi her parçayı ayrı yazıyordu.** Parçalar köke weld'li, yalnız kök tween'leniyor. Cihaz etkisi ölçülmedi.
- **Dekoratif yayalar `K0Passers` sayacını şişiriyordu**; yükseltme/kasiyer/maaş tabela fiyatları artık config'ten yazılıyor.

Ayrıntı: [`../PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md`](../PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md). Açık tasarım sorusu (talep panosu ödüllendirilmiyor): aynı rapor §4.

## Studio'ya geçiş sırası

1. Place'in kopyasını alın.
2. Eski `ServerScriptService/K0Game` ve `StarterPlayerScripts/K0HUD` aktifse devre dışı bırakın veya kaldırın.
3. Yukarıdaki üç aktif kaynağı yerleştirin.
4. Mevcut sahnede `K0_MARKET_V3_MIGRATION.lua`; temiz sahnede `MARKET_SYSTEM_BUILD.lua` çalıştırın.
5. Play ile en az şu smoke akışını geçin: sahiplen → kayıt → iki stoktan biri → müşteri teklifi → pazarlık → seviye 2 → kasiyer → maaş. Kayıt yenilemeyi ayrıca doğrulamak isterseniz Edit-mode smoke kopyasında süreyi geçici düşürün; kaydedilen K0.3 değeri 22 dakikadır.
6. Konsolda tek `Baycrest K0 market server ready K0-market-0.4.1` satırı bulunmalı; eski `Baycrest K0 server ready` runtime'ı çalışmamalı.
6b. **K0.4 kontrolü:** toptancı promptu `ActionText` alanına çalışma zamanında yazıyor ("Stok al" / "Tasfiye et"). Sahne kurucular K0.3 döneminde yazıldığı için ilk kontrol edilecek nokta burasıdır.
6c. **K0.4.1 kontrolü:** NPC parçaları köke `WeldConstraint` ile bağlı. İlk müşteri ve yaya **tek parça** yürümeli; dağılan veya düşen parça varsa test durur. Adımlar: [`../PRODUCTION/K0.4_NEXT_TEST_PLAN.md`](../PRODUCTION/K0.4_NEXT_TEST_PLAN.md) Aşama 0 ve 2d.
7. Android ve üç bağımsız 20 dakikalık ürün testi yapılmadan `DOĞRULANDI` yazmayın.

## Bilinen sınırlar

K0 hâlâ tek satıcılı, bellekte yaşayan bir prototiptir. DataStore, işlem kimliği, oturumlar arası geri dönüş, gerçek R15 NPC rig/animasyonları, çok oyunculu işletme yazarlığı ve gerçek cihaz performansı K0.4.1 kaynak paketinde çözülmüş sayılmaz. Güncel liste: [`../PRODUCTION/K0.4_KNOWN_LIMITATIONS.md`](../PRODUCTION/K0.4_KNOWN_LIMITATIONS.md). Bunlar sonraki katmanların veya Studio/cihaz QA'nın işidir.
