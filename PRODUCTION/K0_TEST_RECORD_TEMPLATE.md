# K0 test kaydı — doldurulacak şablon

**Kaynak hedefi:** `K0-market-0.3.0`  
**Durum:** Şablon; yapılmış test veya oyuncu sonucu içermez. Her test sürümü için ayrı kopya oluşturulur. Kapı kararı `EKIP/07-YOL-HARITASI.md` §2'ye dayanır.

> K0.3 kontrollü oynanış RNG seed'i kullanır ve her test sahibi atandığında aynı ekonomi dizisini baştan başlatır. Dekoratif kalabalık RNG'si ayrıdır. Katılımcıya 20 dakikalık geri sayım gösterilmez; süre dolduğunda oyun durmaz. Böylece “süre bitince kendiliğinden devam” davranışı daha az yönlendirilir.

| Alan | Kayıt |
|---|---|
| Build / place adı ve ID | TBD |
| Kaynak sürümü / commit | `K0-market-0.3.0` / TBD |
| Test tarihi ve saat dilimi | TBD |
| Test edilen değişiklikler | TBD |
| Cihaz / giriş yöntemi | TBD |
| Testi yürüten / gözlemci | TBD |
| Üç katılımcı (anonim kimlik) | TBD |
| Katılımcılar özellik geliştiricisi mi? | TBD |
| Studio Output / video / ekran kaydı kanıtı | TBD |

## Katılımcı davranışı

| Kimlik | 20 dk tamamlandı mı? | İstenmeden devam etti mi? | Nerede durdu? | Ertesi gün hatırlatılmadan döndü mü? | Teknik hata / not |
|---|---|---|---|---|---|
| T1 | Ölçülmedi | Ölçülmedi | — | Ölçülmedi | — |
| T2 | Ölçülmedi | Ölçülmedi | — | Ölçülmedi | — |
| T3 | Ölçülmedi | Ölçülmedi | — | Ölçülmedi | — |

## K0.3 zaman ve karar gözlemleri

| Gözlem / Attribute | T1 | T2 | T3 |
|---|---|---|---|
| İlk sahiplik — `K0FirstClaimSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk stok alımı — `K0FirstStockSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk teklif açma — `K0FirstOfferSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk karar — `K0FirstDecisionSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk satış — `K0FirstSaleSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk yükseltme — `K0FirstUpgradeSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| İlk kasiyer — `K0FirstHireSeconds` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Toplam stok alımı — `K0StockPurchases` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Talebe uygun stok alımı — `K0DemandAlignedPurchases` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Kabul — `K0AcceptCount` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Karşı teklif — `K0CounterCount` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Başarılı / başarısız karşı teklif — `K0CounterSuccess` / `K0CounterFailure` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Ret — `K0DeclineCount` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Pazar kaydı yenileme — `K0PermitRenewals` (20 dk sonrası devamda görülebilir) | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| Maaş ödeme — `K0WagePayments` | Ölçülmedi | Ölçülmedi | Ölçülmedi |
| 20 dk hedefi — `K0SessionTargetReached` | Ölçülmedi | Ölçülmedi | Ölçülmedi |

Sayaçlar **başarı skoru değildir**; gözlemci notunun yerine geçmez. Özellikle “talebe uygun stok” ve pazarlık sayıları, oyuncunun neden o kararı verdiği sorusuyla birlikte yorumlanır.

## Açık uçlu gözlem notları

- İlk 5 dakika içinde “bunun sahibi benim” hissini ne oluşturdu / bozdu?
- Talep panosunu kendi başına fark etti mi; stok kararını onunla ilişkilendirdi mi?
- Pazarlıkta `SIKI / ORTA / ESNEK` sinyalini nasıl yorumladı?
- Seviye 2'nin yalnız sayı değil görünür kapasite artışı olduğunu fark etti mi?
- Kasiyerin gelir değil yatırım + ücret yükü olduğunu anladı mı?
- 20 dakika dolduktan sonra davranışında dış yönlendirme olmadan ne oldu?

## Teknik kanıt

- Tek aktif runtime ve konsol başlangıç satırı: **ölçülmedi** — kanıt yeri:
- Sahiplen → kayıt → stok → teklif → karar → satış: **ölçülmedi** — kanıt yeri:
- Seviye 2 → kasiyer → maaş: **ölçülmedi** — kanıt yeri:
- Pazar kaydı bitişi → ticaret duruşu → yenileme: **ayrı smoke; 20 dk K0 kapısının dışında** — kanıt yeri:
- Owner ayrılışı → yeni owner devri / hata yok: **ölçülmedi** — kanıt yeri:
- 20. dakikada `[Baycrest K0] summary reason=target_20m ...`: **ölçülmedi** — kanıt yeri:
- Konsol hata/warn kaydı: **ölçülmedi** — kanıt yeri:
- Android FPS / bellek / dokunmatik: **ölçülmedi** — cihaz ve sahne:
- Veri kaydı/geri dönüş: **K1 kapsamı; K0'da beklenmez**.

## Kapı kararı

`GEÇTİ / İYİLEŞTİR VE TEKRARLA / DURDUR VE YENİ HİPOTEZ / HENÜZ TEST EDİLMEDİ`

**Gerekçe:**  
**Ham gözlem kanıtları:**  
**Açık hatalar:**  
**Sonraki deney:**  
**Karar veren / tarih:**
