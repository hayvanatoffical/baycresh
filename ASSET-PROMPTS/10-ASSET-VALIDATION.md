# 10 — Varlık kabul kontrol listesi

**Durum:** TASLAK · K0.4

Her üretilen varlık bu listeden geçer. Liste doldurulmadan hiçbir varlık `PRODUCTION/ASSET_PROVENANCE.md`'ye **ADAY** olarak yazılamaz.

## Kullanım

1. Varlık üretilir.
2. Bu dosyanın ilgili bölümü kopyalanıp doldurulur.
3. Sonuç `PRODUCTION/` altında varlık kaydına eklenir.
4. Bir madde **HAYIR** ise varlık reddedilir veya düzeltilip yeniden değerlendirilir. "Sonra bakarız" bir sonuç değildir.

Durum etiketleri `PRODUCTION` ile aynıdır: `SOURCE VERIFIED`, `STATIC VERIFIED`, `SCENARIO VERIFIED`, `STUDIO PENDING`, `DEVICE PENDING`.

---

## A — Bütün varlıklar için ortak

| # | Kontrol | E/H | Not |
|---|---|---|---|
| A1 | Varlık kimliği (`ENV-*`, `PROP-*`, `ICON-*` …) prompt dosyasındakiyle birebir aynı | | |
| A2 | Dosya adı varlık kimliğiyle eşleşiyor | | |
| A3 | `11-LICENSE-AND-PROVENANCE.md` kaydı **üretimden önce** açılmıştı | | |
| A4 | Araç ve plan (ücretsiz/ücretli) kayıtlı | | |
| A5 | Kullanılan girdi (referans görsel, prompt) kayıtlı ve hakkı temiz | | |
| A6 | Lisans durumu `UNKNOWN` değil | | |
| A7 | Atıf gerekiyorsa atıf metni hazır ve nereye konacağı belli | | |
| A8 | Gerçek kişi benzerliği / üçüncü taraf IP taşımıyor | | |
| A9 | Stil ailesine uyuyor (`08-MATERIALS-TEXTURES.md`) | | |
| A10 | Bu varlık K0 kapsamında gerçekten gerekli (yeni özellik getirmiyor) | | |

---

## B — 3D model (karakter, çevre, prop)

| # | Kontrol | E/H | Not |
|---|---|---|---|
| B1 | Ölçek doğru: stud referansına göre ölçüldü | | |
| B2 | Pivot doğru yerde (prompt dosyasında belirtilen nokta) | | |
| B3 | Yön doğru: müşteri/ön yüz +Z, +Y yukarı | | |
| B4 | Topoloji temiz: yırtık yüzey, çift vertex, ters normal yok | | |
| B5 | Üçgen sayısı hedefin içinde — **ölçülmüş değer yazıldı** | | |
| B6 | Malzeme sayısı hedefin içinde | | |
| B7 | Doku çözünürlüğü hedefin içinde | | |
| B8 | UV: 0-1 alanında, çakışan kabuk yok (aynalama hariç) | | |
| B9 | Dokuda pişmiş gölge / AO / highlight **yok** | | |
| B10 | Çarpışma: yürüme yüzeyi basit kutu, dekoratif geometri çarpışmasız | | |
| B11 | Modüler ise 8 stud ızgarasına oturuyor, komşusuyla boşluksuz | | |
| B12 | İçinde çalıştırılabilir script **yok** | | |
| B13 | Boş yüzey gerçekten boş (tabela/pano üstünde modellenmiş yazı yok) | | |

### B ek — karakter

| # | Kontrol | E/H | Not |
|---|---|---|---|
| BC1 | A-pose, T-pose değil | | |
| BC2 | Aksesuarlar ayrı mesh ve doğru adlandırılmış | | |
| BC3 | Omuz/dirsek/diz/kalçada deformasyon halkaları var | | |
| BC4 | Gövde ile aksesuar iç içe geçmiyor | | |
| BC5 | R15 rig'e bağlanabilir oran | | |
| BC6 | Rig'lendiyse: dirsek/diz/omuz 35°'de eklem açılmıyor | | |
| BC7 | Rol silueti 64 px yükseklikte ayırt ediliyor (alıcı / pazarlıkçı / kasiyer) | | |

---

## C — Animasyon

| # | Kontrol | E/H | Not |
|---|---|---|---|
| C1 | 30 fps | | |
| C2 | **Root motion yok**; kök klip boyunca orijinde | | |
| C3 | Loop ise ilk ve son kare aynı, döngüde zıplama yok | | |
| C4 | Non-loop ise idle duruşunda başlıyor ve bitiyor | | |
| C5 | Süre tabloda belirtilen aralıkta | | |
| C6 | Omuz/kalça rotasyonu 35°'yi aşmıyor | | |
| C7 | Parmak / yüz eklemi kullanılmamış | | |
| C8 | Studio'da `KeyframeSequence` olarak açılıyor | | |
| C9 | Grup sahipliği planlanıyorsa grup altına yüklendi | | |

---

## D — Ses (SFX / müzik / vokal)

| # | Kontrol | E/H | Not |
|---|---|---|---|
| D1 | Mono, 48 kHz | | |
| D2 | Tepe seviyesi ≤ −3 dBFS | | |
| D3 | Baştaki sessizlik ≤ 10 ms | | |
| D4 | Süre tabloda belirtilen aralıkta | | |
| D5 | Ana enerji 400 Hz – 5 kHz (telefon hoparlöründe duyuluyor) | | |
| D6 | **Telefon hoparlöründe dinlendi**, laptop/kulaklıkla değil | | |
| D7 | Loop ise dikişsiz; fade-in/fade-out yok | | |
| D8 | Müzikte vokal yok | | |
| D9 | 20 kez arka arkaya dinlendi, rahatsız etmiyor | | |
| D10 | Diğer katmanlarla birlikte çalındığında çamurlaşmıyor | | |
| D11 | Roblox moderasyonundan geçti | | |

---

## E — UI ikonu

| # | Kontrol | E/H | Not |
|---|---|---|---|
| E1 | 24×24 px'te ne olduğu anlaşılıyor | | |
| E2 | **Telefon ekranında** 24 px'te bakıldı | | |
| E3 | Çizgi kalınlığı ≥ 2 px | | |
| E4 | Şeffaf arka plan, kenar boşluğu var | | |
| E5 | En fazla iki renk | | |
| E6 | **Gri tonlamada** hâlâ ayırt ediliyor | | |
| E7 | Portakal/ekmek biçimle ayrılıyor, renkle değil | | |
| E8 | Bütçe sinyalleri (SIKI/ORTA/ESNEK) biçimle ayrılıyor | | |
| E9 | İçinde metin/rakam yok | | |

---

## F — Oynanış okunabilirliği (bütün görsel varlıklar)

Bu bölüm en çok atlanan ve en çok işe yarayan bölümdür.

| # | Kontrol | E/H | Not |
|---|---|---|---|
| F1 | Varlık oyun içi normal mesafeden (8–15 stud) ne olduğunu söylüyor | | |
| F2 | Telefon ekranında, hareket hâlinde bakıldığında okunuyor | | |
| F3 | Stok dolu / boş ayrımı görülebiliyor | | |
| F4 | Seviye 1 / seviye 2 ayrımı görülebiliyor | | |
| F5 | Talep gören ürün ayırt edilebiliyor | | |
| F6 | Kayıt borcu durumu görülebiliyor (K0.4) | | |
| F7 | Varlık, karar anında dikkat çalmıyor (süsse süs gibi duruyor) | | |

---

## G — Performans

| # | Kontrol | E/H | Not |
|---|---|---|---|
| G1 | Sahneye eklendikten sonra Studio'da FPS ölçüldü — **değer yazıldı** | | |
| G2 | Android cihazda ölçüldü — **cihaz modeli ve değer yazıldı** | | |
| G3 | Çizim çağrısı artışı kabul edilebilir | | |
| G4 | Doku belleği artışı kabul edilebilir | | |

**G bölümü doldurulmadan hiçbir varlık `DOĞRULANDI` sayılamaz.** Ölçülmemiş performans, `AGENTS.md` kural 6 gereği platform garantisi olarak yazılamaz.

---

## Reddetme kriterleri (tartışmasız)

Aşağıdakilerden biri varsa varlık reddedilir:

- Lisans durumu `UNKNOWN / REVIEW REQUIRED`.
- Ücretsiz plandan üretilmiş ve o planın ticari kullanımı yok.
- Atıf zorunlu ama atıf yeri belirlenmemiş.
- Dokuda pişmiş aydınlatma var.
- Karakterde root motion var.
- İkon gri tonlamada ayırt edilemiyor.
- İçinde çalıştırılabilir script var.
- 24 px / 15 stud okunabilirlik testinden geçmedi.
