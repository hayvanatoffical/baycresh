# BAYCREST K0.3 — Final kaynak denetimi

**Tarih:** 26 Eylül 2026  
**Kaynak sürümü:** `K0-market-0.3.0`  
**Durum:** **KAYNAK PAKETİ HAZIR · K0 OYUNCU KAPISI HENÜZ GEÇMEDİ**  
**Kanonik kapsam:** `KARARLAR.md` → `EKIP/07-YOL-HARITASI.md` §2 → ilgili `EKIP/01`, `03`, `04`, `05`, `06` belgeleri.

Bu rapor ZIP içindeki kaynak ve belge tutarlılığını kapatır. Roblox Studio'da gerçek Play oturumu, Android cihaz profili ve üç bağımsız katılımcının 20 dakikalık davranış testi bu işlem sırasında çalıştırılmadı. Bu nedenle `UYGULANDI` ile `DOĞRULANDI` statüleri birbirine karıştırılmaz.

## 1. Prototip sözleşmesine uyum

| K0 kanonik şartı | K0.3 kaynaktaki karşılığı | Kaynak statüsü |
|---|---|---|
| Tek sokak / tek tezgâh / tek satıcı | `Workspace/BlackstoneBazaar_K0`; server tek owner atar, diğer oyuncular gözlemci olur | Uygulandı; Studio yeniden smoke-test bekliyor |
| Polis, suç, silah yok | Aktif `GAME/src` bu sistemleri içermez | Uyumlu |
| İlk 5 dakikada sahiplik | Claim ücretsiz ve ilk ana hedeftir; pazar kaydı sahiplikten sonra gelir | Uygulandı; gerçek süre ölçülecek |
| İki stok seçeneği + görünür talep | Portakal/ekmek, 60 sn talep döngüsü, talep ürünü `%15` fiyat avantajı | Uygulandı; denge hipotezdir |
| Açıklanabilir pazarlık | `SIKI / ORTA / ESNEK` bütçe sinyali; karar anında gizli `CounterAcceptChance` yok | Uygulandı |
| Görünür seviye 2 büyümesi | Kapasite ve ikinci raf görünürlüğü; K0 maliyeti config'te ayrı | Uygulandı |
| NPC çalışan + maaş günü | Kasiyer yatırımı, vardiya süresi ve ücret gideri | Uygulandı |
| 20 dakikalık davranış testi | 1.200 sn hedef, görünmeyen sayaç, server özet logu; oyun 20 dk'da durmaz | Uygulandı; katılımcı testi bekliyor |
| Production ekonomisi K0'dan ayrı | `K0MarketConfig.Production` ve `.Prototype` ayrımı | Uyumlu |

Zayıflık raporundaki ayrı `0B` çanta/polis deneyi **K0.3'e birleştirilmedi**. Bunun nedeni kanonik `EKIP/07` §2'nin K0 için açıkça polis/suç/silah yasağı koymasıdır. 0B ileride ayrı, atılabilir bir deney olarak açılabilir; K0'ın sahiplik sonucunu kirletmez.


### K0 kapsamını bozan bir ekonomi kenar durumu giderildi

Önceki K0.2 ayarında pazar kaydı 540 saniyede (9 dk) bitiyordu. Kayıt bittiğinde ticaret tamamen durduğu için oyuncunun kasası yenileme ücretinin altındaysa K0 içinde yeni gelir üretecek yol kalmıyordu. Dahası iki yenileme, 20 dakikalık testin asıl sorusu olan sahiplik–stok–pazarlık–büyüme döngüsüne gereksiz sürtünme ekliyordu. K0.3 `PermitPeriodSeconds` değerini **1320 saniyeye (22 dk)** taşır: kanonik K0 kapısı tamamlanır, oyuncu gönüllü devam ederse yenileme mekaniği hemen sonrasında görülebilir. Production üretim günü/ruhsat kuralı değiştirilmedi.

## 2. Kod ve mimari denetimi

Aktif runtime yalnız üç kaynaktır: config, server, HUD. Eski `K0Config/K0Game/K0HUD` yalnız `GAME/legacy/` altında tutulur. Server ayrıca kopyalanmış bir Studio place'inde legacy `K0Game` açık kalırsa uyarı verir; `K0_MARKET_V3_MIGRATION.lua` legacy server/client scriptlerini devre dışı bırakır.

K0.3 server-authoritative sınırı şu davranışları doğrular: RemoteEvent kararı yalnız test sahibi için, satış noktasına yeterince yakınken, ticaret aktifken, teklif açıkken, teklif ID'si eşleşirken ve action izin listesinde ise işlenir. `counter` eylemi yalnız pazarlıkçı müşteride kabul edilir. Nakit, stok, teklif fiyatı, çalışan ve yatırım sonuçları istemciden alınmaz.

Aynı sürümden ikinci server runtime'ın sessizce çalışmasını önlemek için sahne altında `__K0MarketRuntimeLock` kullanılır. `leaderstats` yeniden yaratılmaz. Owner ayrılışında NPC/worker temizliği ve yeni owner devri bulunur.

## 3. Kontrollü test ölçümü

Gameplay RNG ile dekoratif kalabalık RNG'si ayrıdır. Her yeni test sahibi atandığında gameplay RNG `PlaytestSeed` ile yeniden başlatılır; bu, üç küçük K0 oturumunun aynı başlangıç dizisine daha yakın koşullarda karşılaştırılmasını sağlar. Bu seed production davranışı değildir.

Oturumda şu ilk-an ve sayaç alanları tutulur: sahiplik, ilk stok, ilk teklif, ilk karar, ilk satış, ilk yükseltme, ilk kasiyer; stok alımı ve talebe uygun stok sayısı; kabul/karşı teklif/ret; başarılı/başarısız karşı teklif; kayıt yenileme; maaş ödeme. 20. dakikada Output'a tek satırlık özet yazılır. Sayaçlar kalıcı oyuncu analitiği değildir ve `EKIP/07`'deki gerçek davranış gözleminin yerine geçmez.

`PRODUCTION/K0_TEST_RECORD_TEMPLATE.md` K0.3 alanlarıyla eşleştirilmiştir. Katılımcıya geri sayım gösterilmez; 20 dakika dolunca oyun devam eder ki “kendiliğinden devam etti mi?” gözlemi mümkün olsun.

## 4. Mobil ve UX denetimi

HUD prototip fiyatlarını `K0MarketConfig` üzerinden okur. Dar viewport'ta üç pazarlık düğmesi küçük tek satır yerine dikey büyük dokunma hedeflerine dönüşür ve `Activated` kullanılır. Buna rağmen gerçek Android dokunma, safe-area, FPS ve bellek davranışı yalnız kaynak incelemesiyle doğrulanamaz; cihaz testi açıktır.

Dünya panolarındaki pazar kaydı, toptan stok ve fiyat bilgisi runtime config'ten güncellenir. Böylece K0 tuning sırasında sahne metni ile kod sayısının sürüklenmesi azaltılır.

## 5. AI, lisans ve varlık kökeni

`PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` yeni yayın kapısıdır; `PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md` araç-plan bazlı çalışma matrisidir. Bir AI/üçüncü taraf varlıkta girdi hakkı, çıktı hakkı, atıf, yeniden dağıtım, Roblox uyumu ve provenance kaydı birlikte aranır. `PRODUCTION/ASSET_PROVENANCE.md` gerçek varlık kayıt defteridir.

26 Eylül 2026 kontrolünde OpenAI bireysel Kullanım Şartları, kullanıcı ile OpenAI arasında gerekli girdi haklarının kullanıcı sorumluluğunda olduğunu ve izin verilen ölçüde çıktının kullanıcıya ait olduğunu belirtir. Roblox Terms of Use, kendi AI Features kullanımlarında prompt/output sorumluluğunu yaratıcıya bırakır ve provenance/metadata etiketlerinin kaldırılmasını yasaklar. Creator Store koşulları ise alınan varlık için Roblox Studio ve Roblox Experiences kullanım lisansı verir; başka bir yaratıcının Restricted bağımlılığını yeniden dağıtma/satma serbestisi vermez.

**Yayın kuralı:** Sağlayıcı koşulları değişebildiği için bu kontrol K6/yayın ayında tekrar yapılır. “AI üretti”, “ücretsizdi” veya “Creator Store'daydı” tek başına ticari hak kanıtı değildir.

## 6. Statik kabul kapısı

Paketle birlikte `TOOLS/validate_package.py` gelir. Bu araç:

- gerekli K0.3 dosyalarını ve sürüm tutarlılığını,
- `GAME/src` altında tam üç aktif runtime Lua dosyası bulunduğunu,
- retired `K0Config/K0Game/K0HUD` kaynaklarının yalnız legacy altında kaldığını,
- aktif runtime'da `CounterAcceptChance` bulunmadığını,
- seed/runtime lock/K0.3 ölçüm alanlarının bulunduğunu,
- göreli Markdown bağlantılarının kırık olmadığını

kontrol eder. Bu statik denetim **Luau derleyicisi veya Roblox Studio Play testi değildir**.

Son paketleme öncesi denetim sonucu `PRODUCTION/STATIC_VALIDATION_2026-09-26.txt` içinde **PASS** olarak saklanır. `PRODUCTION/PACKAGE_MANIFEST_SHA256.txt` ise manifest dosyasının kendisi hariç paketteki bütün dosyaların SHA-256 özetini taşır; ZIP aktarımından sonra dosya bütünlüğünü karşılaştırmak için kullanılabilir.

## 7. K0.3'ü Studio'ya alma ve smoke sırası

1. Place'in geri döndürülebilir kopyasını alın.
2. `K0_MARKET_V3_MIGRATION.lua` çalıştırın; legacy `K0Game/K0HUD` etkin kalmasın.
3. `GAME/src` içindeki üç güncel kaynağı Studio'daki karşılıklarına uygulayın.
4. Play: sahiplen → kayıt → stok → teklif → kabul/karşı teklif/ret → satış → seviye 2 → kasiyer → maaş. Yenileme mekaniğini ayrıca doğrulamak için test kopyasında permit süresini geçici düşürün; kaydedilen K0.3 22 dakikadır.
5. Owner ayrılışı ve ikinci oyuncuya owner devrini ayrı test edin.
6. Output'ta yalnız güncel başlangıç sürümünü ve 20. dakika özetini doğrulayın; hata/warn kaydını saklayın.
7. Bir Android cihazda aynı akışı, dokunmatik hedefleri ve profiler değerlerini kaydedin.
8. Son olarak üç bağımsız katılımcı testini `K0_TEST_RECORD_TEMPLATE.md` ile yürütün. Kapı sonucu ancak bundan sonra yazılır.

## 8. Kapanmayan maddeler

Bunlar hata diye gizlenmemiş, kapsam gereği açık bırakılmıştır: DataStore/oturum kilidi/işlem kimliği K1; gerçek çok oyunculu işletme yazarlığı K1; R15 rigli/animasyonlu üretim NPC'leri sanat pipeline'ı; Android performans kanıtı cihaz QA; üç bağımsız testçinin 20 dakika + ertesi gün davranışı K0 ürün kapısı; production ekonomi dengesi ayrı ekonomi modelidir.

**Nihai kaynak kararı:** K0.3 ZIP'i dokümanların kanonik K0 kapsamına göre kurulabilir ve test edilebilir bir **kaynak adayıdır**. `DOĞRULANDI` etiketi yalnız Studio + cihaz + oyuncu kanıtları geldikten sonra kullanılmalıdır.
