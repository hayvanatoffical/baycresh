# K0 Luau kaynak yeniden yapılandırması — 25 Eylül 2026

**Durum:** `UYGULANDI` yalnız kaynak ZIP'i açısından; **Studio ve gerçek cihazda henüz DOĞRULANMADI.**  
**Hedef:** K0 0A sahiplik hipotezini zayıflık raporundaki OYN-01–03 yönüne yaklaştırmak ve mevcut Luau çift-runtime/ekonomi tutarsızlıklarını kaldırmak.

> **Ardıl sürüm:** Bu dosya K0.2 tarihsel değişiklik kaydıdır. Aktif kaynak `K0-market-0.3.0`; güncel kapsam ve statik kabul kanıtı [`K0_FINAL_AUDIT_2026-09-26.md`](K0_FINAL_AUDIT_2026-09-26.md) dosyasındadır.

## Değiştirilen kaynaklar

- `GAME/src/ReplicatedStorage/K0MarketConfig.lua`
- `GAME/src/ServerScriptService/K0Market.server.lua`
- `GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua`
- `GAME/MARKET_SYSTEM_BUILD.lua`
- yeni `GAME/K0_MARKET_V2_MIGRATION.lua`
- eski `K0Game.server.lua`, `K0HUD.client.lua` ve `K0Config.lua` → `GAME/legacy/`
- `GAME/README.md`, `EKIP/01`, `EKIP/07`, `PRODUCTION/K0_TEST_RECORD_TEMPLATE.md`

## Giderilen başlıca kod riskleri

| Risk | Kaynaktaki sorun | Yeni davranış |
|---|---|---|
| Çift runtime | `K0Game` ve `K0Market` aynı Prompt/Attribute alanlarına yazabiliyordu | Aktif kaynak tek `K0Market`; eskiler arşivde |
| Sahipliğin gecikmesi | İzin → tezgâh → stok zinciri oyunun vaadini geciktiriyordu | Tezgâh önce ücretsiz sahiplenilir; ekonomi adımları sonra gelir |
| Mekanik tekrar | Satışın ana kararı çoğunlukla “E bas” idi | Talep, stok seçimi ve pazarlık kararı eklendi |
| Gizli pazarlık RNG'si | `CounterAcceptChance` karar anında görünmez rastgelelikti | Müşteri bütçesi doğuşta sabitlenir; `SIKI/ORTA/ESNEK` sinyali verilir |
| Borçta satış | Ruhsat borcu satışın kendisini durdurmuyordu | Borçta satış/restock/yeni müşteri askıya alınır; varlık silinmez |
| “Net” belirsizliği | Ciro/gider/nakit/yatırım tek bakışta ayrılmıyordu | `OperatingCost`, `OperatingResult`, `InvestmentSpent` ayrı Attribute |
| Owner ayrılışı | Async visitor akışında `owner=nil` iken dünya senkronu hata verebilirdi | Dünya metni nil-safe; aktör temizliği ve sonraki owner seçimi var |
| leaderstats çakışması | Her runtime yeni `leaderstats` oluşturabiliyordu | Var olan klasör/değer yeniden kullanılır |
| Mobil HUD | Sabit piksel paneller küçük ekranda taşabilirdi | Viewport tabanlı `UIScale`; butonlarda `Activated` korunur |
| Test kanıtı | İlk sahiplik/satış/yükseltme zamanı elle tahmin ediliyordu | Oturum içi milestone Attribute ve server logları eklenir |
| Stoktan önce müşteri | İzin sonrası oyuncu stok kararını vermeden müşteri akışı başlayabiliyordu | İlk müşteri en az bir stok kararı sonrası doğar; sonrasında yanlış stok seçiminin kayıp talep geri bildirimi korunur |
| Eski place runtime'ı | Kaynakta legacy arşivlense bile Studio kopyasında `K0Game/K0HUD` etkin kalabilirdi | Migration bunları devre dışı bırakır; yeni server da etkin legacy `K0Game` görürse uyarır |

## Bilerek çözülmeyenler

- DataStore / K1 kalıcılığı
- Çoklu işletme ve gerçek çok oyunculu tek-yazar mimarisi
- R15 rigli gerçek NPC model/animasyonları
- Android FPS/bellek ve dokunmatik cihaz doğrulaması
- Üç bağımsız oyuncunun 20 dakikalık davranış testi
- Production ekonomisinin dengesi

Bunlar yapılmadan bu değişiklik `DOĞRULANDI` değildir.

## Studio smoke kabulü

1. Aktif place'te yalnız `K0Market` server runtime'ı bulunur.
2. Oyuncu ilk dakikada tezgâhı sahiplenebilir.
3. Kayıt yapılmadan satış/restock başlamaz; kayıt sonrası iki stok seçeneği çalışır.
4. Talep panosu ve dünya fiyat etiketleri talep değişince güncellenir.
5. Pazarlıkçı sinyali HUD'da görünür; aynı teklif için karar anında yeni rastgelelik üretilmez.
6. Kayıt süresi bittiğinde ticaret askıya alınır; yenileme sonrası aynı sahiplik/stokla sürer.
7. Seviye 2, kasiyer ve maaş akışı çalışır.
8. Owner ayrılınca runtime hata vermeden temizlenir; kalan oyunculardan biri yeni test sahibi olur.
9. Konsolda legacy K0 runtime çıktısı bulunmaz.
