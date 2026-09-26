# Baycrest K0 — Roblox Studio prototip kaynakları

**Kaynak sürümü:** `K0-market-0.3.0` · 26 Eylül 2026  
**Studio hedefi:** place ID `83986068176961`, `Workspace/BlackstoneBazaar_K0`  
**Durum:** Kaynak paketi yeniden yapılandırıldı. Bu ZIP'in üretilmesi Studio place'inin otomatik olarak güncellendiği veya oyuncu testinin geçtiği anlamına gelmez.

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
7. K0.3 testinde pazar kaydı 22 dakika sürer; 20 dakikalık kapı ölçümünü bölmez. Oyuncu testten sonra devam ederse süre sonunda sahiplik/stok silinmeden **ticaret askıya alınır** ve yenilemeyle devam eder.

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

## Studio'ya geçiş sırası

1. Place'in kopyasını alın.
2. Eski `ServerScriptService/K0Game` ve `StarterPlayerScripts/K0HUD` aktifse devre dışı bırakın veya kaldırın.
3. Yukarıdaki üç aktif kaynağı yerleştirin.
4. Mevcut sahnede `K0_MARKET_V3_MIGRATION.lua`; temiz sahnede `MARKET_SYSTEM_BUILD.lua` çalıştırın.
5. Play ile en az şu smoke akışını geçin: sahiplen → kayıt → iki stoktan biri → müşteri teklifi → pazarlık → seviye 2 → kasiyer → maaş. Kayıt yenilemeyi ayrıca doğrulamak isterseniz Edit-mode smoke kopyasında süreyi geçici düşürün; kaydedilen K0.3 değeri 22 dakikadır.
6. Konsolda tek `Baycrest K0 market server ready K0-market-0.3.0` satırı bulunmalı; eski `Baycrest K0 server ready` runtime'ı çalışmamalı.
7. Android ve üç bağımsız 20 dakikalık ürün testi yapılmadan `DOĞRULANDI` yazmayın.

## Bilinen sınırlar

K0 hâlâ tek satıcılı, bellekte yaşayan bir prototiptir. DataStore, işlem kimliği, oturumlar arası geri dönüş, gerçek R15 NPC rig/animasyonları, çok oyunculu işletme yazarlığı ve gerçek cihaz performansı K0.3 kaynak paketinde çözülmüş sayılmaz. Bunlar sonraki katmanların veya Studio/cihaz QA'nın işidir.
