# K0 test kaydı — doldurulacak şablon

**Kaynak hedefi:** `K0-market-0.4.7`  
**Durum:** Şablon; yapılmış test veya oyuncu sonucu içermez. Her test sürümü için ayrı kopya oluşturulur. Kapı kararı `EKIP/07-YOL-HARITASI.md` §2'ye dayanır.

> K0.3 kontrollü oynanış RNG seed'i kullanır ve her test sahibi atandığında aynı ekonomi dizisini baştan başlatır. Dekoratif kalabalık RNG'si ayrıdır. Katılımcıya 20 dakikalık geri sayım gösterilmez; süre dolduğunda oyun durmaz. Böylece “süre bitince kendiliğinden devam” davranışı daha az yönlendirilir.

| Alan | Kayıt |
|---|---|
| Build / place adı ve ID | TBD |
| Kaynak sürümü / commit | `K0-market-0.4.7` / TBD |
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
| Ekonomi çıkmazı — `K0DeadEndSeconds` (−1 = yok) | Ölçülmedi | Ölçülmedi | Ölçülmedi |

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
- Owner ayrılışı → yeni owner devri / hata yok (**K0.4.1:** iki oyunculu testte ikinci oyuncu sahip oldu mu): **ölçülmedi** — kanıt yeri:
- 20. dakikada `[Baycrest K0] summary reason=target_20m ...`: **ölçülmedi** — kanıt yeri:
- **K0.4.1 · son özet:** oturum sonunda tek `summary reason=owner_left` veya `reason=server_close` satırı: **ölçülmedi** — kanıt yeri:
- Konsol hata/warn kaydı: **ölçülmedi** — kanıt yeri:
- **K0.4 · raf yenileme:** rafta 1 birim kalınca toptancıdan alım yapılabildi mi (kısmi alım bildirimi): **ölçülmedi** — kanıt yeri:
- **K0.4 · tasfiye:** kayıt borcu varken toptancı `Tasfiye et` moduna geçti mi: **ölçülmedi** — kanıt yeri:
- **K0.4 · `liquidations=` sayacı:** özet satırından değer: **ölçülmedi**
- **K0.4 · `rescueGrants=` sayacı:** özet satırından değer: **ölçülmedi** — *sıfırdan büyükse bu oturum ekonomi dengesi açısından şüphelidir, sebebi yazılır:*
- **K0.4.1 · `deadEnd=` alanı ve `dead_end` satırı:** özet satırından değer: **ölçülmedi** — *−1 değilse oturum o saniyede kalıcı çıkmaza girmiştir; bu bir hatadır, sebebi ve `reason=` değeri yazılır:*
- **K0.4.1 · stoksuz harcama reddi:** "kasada N ₡ kalır ve rafta ürün yok" bildirimi görüldü mü, oyuncu anladı mı: **ölçülmedi** — kanıt yeri:
- **K0.4.1 · NPC hareketi:** müşteri ve yayalar tek parça hâlinde yürüyor mu (dağılan/düşen parça yok): **ölçülmedi** — kanıt yeri:
- Android FPS / bellek / dokunmatik: **ölçülmedi** — cihaz ve sahne:
- **K0.4.2 · sesler:** telefonda duyulan / duyulmayan slotlar, konsoldaki ses yükleme uyarıları, rahatsız eden ses: **ölçülmedi** — kanıt yeri:
- **K0.4.2 · ses aday onayı:** sahip her slotu Creator Store bağlantısından dinledi mi, hangileri değişecek: **yapılmadı** — `PRODUCTION/ASSET_PROVENANCE.md` durum sütunu:
- **K0.4.3 · rol siluetleri:** oyuncu pazarlıkçıyı teklif kartı açılmadan tanıdı mı (kaç müşteride sorulup kaçında doğru): **ölçülmedi** — kanıt yeri:
- **K0.4.3 · HUD ikonları ve bütçe göstergesi:** telefonda anlaşılmayan ikon, gri tonlamada karışan çift: **ölçülmedi** — ekran görüntüsü:
- **K0.4.4 · telefon düzeni:** teklif düğmelerinde yanlış basma, üst çubuğun veya zıplama düğmesinin altında kalan HUD parçası, okunamayan satır: **ölçülmedi** — ekran görüntüsü:
- **K0.4.4 · dokunmatik metinler:** telefonda tuş adı söyleyen metin veya `1/2/3` önekli düğme görüldü mü: **ölçülmedi** — kanıt yeri:
- **K0.4.4 · NPC yönü:** müşteriler yürüdüğü yöne bakıyor, tezgâhta satıcıya dönüyor mu: **ölçülmedi** — kanıt yeri:
- **K0.4.5–K0.4.6 · telefon ve ekran:** model (Ayarlar → Telefon hakkında): TBD · konsoldaki `[K0 HUD] alan …` satırı (alan, panel ölçeği, en küçük yazı): **ölçülmedi** — Redmi Note 13 Pro+ için beklenen: `alan 904x348` veya `973x379`, `panel 0.86`, `12.0 px`
- **K0.4.5 · okunabilirlik (30–40 cm):** Kasa / Pazar kaydı / Talep / stok / Satış-Ciro / Sonuç / Kasiyer / Hedef / yardım metni için "rahat / zorlanarak / okunmuyor": **ölçülmedi** — joystick altında kalan satırlar:
- **K0.4.5 · Roblox Text Size "Large":** taşan veya kesilen metin: **ölçülmedi** — ekran görüntüsü:
- **K0.4.6 · HUD boyu:** HUD pazarı gereğinden çok örtüyor mu; 111×53 px teklif düğmelerinde yanlış basma: **ölçülmedi** — ekran görüntüsü:
- **K0.4.7 · NPC animasyonu:** figürler adım atarak yürüyor, kol/bacak ayrılmıyor, figür yere batmıyor; satışta el uzatma görülüyor; müşteri yürürken FPS: **ölçülmedi** — ekran kaydı:
- **K0.4.7 · müzik aday onayı:** sahip `MUS-MARKET-DAY` ve `MUS-SALE-CUE` bağlantılarını dinledi mi; vokal, ~90 s'de kısılıp baştan başlama, satışta üç sesin çamurlaşması: **yapılmadı** — `PRODUCTION/ASSET_PROVENANCE.md` durum sütunu:
- **K0.4.7 · öncelik 2 ikonları ve fiyat etiketi:** seviye, kasiyer, onay/ok/çarpı ikonları anlaşılıyor mu; talep etiketinin ikinci satırı tezgâh önünden okunuyor mu: **ölçülmedi** — ekran görüntüsü:
- Veri kaydı/geri dönüş: **K1 kapsamı; K0'da beklenmez**.

## Kapı kararı

`GEÇTİ / İYİLEŞTİR VE TEKRARLA / DURDUR VE YENİ HİPOTEZ / HENÜZ TEST EDİLMEDİ`

**Gerekçe:**  
**Ham gözlem kanıtları:**  
**Açık hatalar:**  
**Sonraki deney:**  
**Karar veren / tarih:**
