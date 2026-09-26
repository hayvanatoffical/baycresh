# 00 — Varlık üretim hattı

**Durum:** TASLAK · K0.4 · 26 Eylül 2026
**Kapsam:** Katman 0 (Blackstone Bazaar, tek tezgâh). K1+ varlıkları bu klasörün konusu değildir.

Bu klasör **varlık üretmez**. Başka yapay zekâ araçlarına verilecek üretim promptlarını ve kabul ölçütlerini tutar. Görsel, model, ses ve müzik ayrı oturumlarda üretilir; buradaki dosyalar o oturumların girdisidir.

## Neden bu klasör var

K0 kaynak paketinde NPC'ler ve tezgâh, Luau içinde `Part` ilkelleriyle kuruluyor (`GAME/STALL_ART_V3.lua`, `K0Market.server.lua` içindeki `makeNpc`). Bu, oynanışı test etmek için yeterli ama sanat yönü taşımıyor. Gerçek varlıklara geçerken üretim isteklerinin dağınık promptlarla yapılması iki somut risk doğurur:

1. **Ölçek ve stil tutarsızlığı.** Farklı oturumlarda üretilen modeller aynı dünyada bir araya gelmez.
2. **Hak belirsizliği.** Hangi aracın hangi planıyla üretildiği kaydedilmezse varlık yayına giremez.

Bu klasör ikisini de prompt düzeyinde kapatır.

## Dosya haritası

| Dosya | İçerik |
|---|---|
| `01-3D-CHARACTERS.md` | NPC karakter referans ve model promptları |
| `02-3D-ENVIRONMENT.md` | Tezgâh, cephe, kaldırım, sokak modülleri |
| `03-3D-PROPS.md` | Ekmek, portakal, kasa, raf, tabela, ödeme objeleri |
| `04-ANIMATION.md` | R15 varsayımıyla minimum animasyon seti |
| `05-MUSIC.md` | Ortam müziği ve kısa sting'ler |
| `06-SFX.md` | Satış, pazarlık, arayüz, para sesleri |
| `07-UI-ICONOGRAPHY.md` | HUD ikonları ve durum göstergeleri |
| `08-MATERIALS-TEXTURES.md` | Malzeme ailesi ve doku promptları |
| `09-VOICE-OPTIONAL.md` | Seslendirme değerlendirmesi |
| `10-ASSET-VALIDATION.md` | Her varlık için kabul kontrol listesi |
| `11-LICENSE-AND-PROVENANCE.md` | Lisans doğrulaması ve köken kaydı |

## Üretim sırası

K0'ın ihtiyacı olan sıra, oyuncunun ilk 20 dakikada gördüğü sırayla aynıdır:

1. **Tezgâh ve ürün propları** (`03`, `02`) — oyuncunun sahiplendiği şey.
2. **Müşteri NPC'si** (`01`) — kararın karşı tarafı.
3. **UI ikonları** (`07`) — kararın okunabilirliği.
4. **SFX** (`06`) — kararın geri bildirimi.
5. **Animasyon** (`04`) — NPC'nin inandırıcılığı.
6. **Müzik** (`05`) — en son; oynanışı bozmaz.

Bu sıra bilinçlidir: K0'ın test ettiği soru "oyuncu karar veriyor mu"dur. Müzik bu soruyu etkilemez, propların okunabilirliği etkiler.

## Değişmez kurallar

Aşağıdakiler her prompt dosyasında tekrar edilir çünkü üretim oturumları bağlamı taşımaz.

**Ölçek.** Roblox stud birimi esastır. 1 stud ≈ 28 cm. Yetişkin R15 karakter ≈ 5 stud boyundadır. Bütün çevre ve prop ölçüleri bu referansa göre verilir; "gerçekçi santimetre" verilmez.

**Mobil öncelik.** K0 hedef cihazı Android telefondur. Üçgen sayısı, doku çözünürlüğü ve malzeme sayısı bu varsayımla istenir. Ölçülmemiş performans değeri hiçbir belgede garanti olarak yazılmaz.

**Okunabilirlik siluetten gelir.** Küçük ekranda ayırt edilmesi gereken her obje (ekmek / portakal, dolu raf / boş raf, seviye 1 / seviye 2) önce silueti, sonra rengiyle ayrılmalıdır. Yalnız renge dayanan ayrım kabul edilmez.

**Tek stil ailesi.** Hafif stilize, yumuşak kenarlı, orta doygunlukta. Foto-gerçekçilik ve aşırı çizgi-roman stili dışıdır. Stil referansı `08-MATERIALS-TEXTURES.md`'dedir.

**Hak kaydı üretimden önce.** Bir varlık üretilmeden önce `11-LICENSE-AND-PROVENANCE.md` içindeki provenance kaydı açılır. Kayıt açılmadan üretilen varlık yayın adayı sayılmaz.

## Prompt yazım biçimi

Her prompt dosyası şu bölümleri taşır:

- **Gameplay purpose** — varlığın oyundaki işi. Süsleme ise açıkça öyle yazılır.
- **Prompt** — araca verilecek metin. Türkçe bağlam, İngilizce prompt (görsel/3D araçları İngilizce'de daha kararlı).
- **Teknik şart** — ölçü, topoloji, pivot, malzeme, doku.
- **Kabul ölçütü** — `10-ASSET-VALIDATION.md`'ye bağlanır.
- **Tool adaptation** — araca özel not gerekiyorsa ayrı başlık olarak.

Promptlar tek bir araca bağlı yazılmaz. Araç adı gerektiğinde "tool adaptation" notuna düşülür, ana promptun içine gömülmez.

## Bu klasörün doğrulama sınırı

Buradaki hiçbir prompt Studio'da denenmemiştir. Üçgen, doku ve FPS şartları **hedeftir**, ölçüm değildir. Üretilen ilk varlık Studio'ya alındığında `10-ASSET-VALIDATION.md` doldurulur ve gerçek ölçümler `PRODUCTION/ASSET_PROVENANCE.md`'ye yazılır.
