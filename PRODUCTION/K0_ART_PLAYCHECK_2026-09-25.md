# K0 sahiplik ve sanat dikey kesiti — 25 Eylül 2026

**Tarihsel ArtV2 kontrolü:** Bu dosyadaki iki AI mesh kullanım satırı kayıt anını anlatır. Sonraki ArtV3 sürümünde her iki aday canlı sahneden çıkarıldı; güncel durum [K0 3D ArtV3 kontrolünde](K0_3D_ART_V3_2026-09-25.md).

**Prototip sorusu:** “Bir şeye sahip olup büyütmek tatmin ediyor mu?” (`EKIP/07` §2). Bu kontrol, deneyimin oyuncuya sunulabilecek kadar okunur olup olmadığını inceler; tatmin sonucunu yalnız gerçek katılımcılar ölçebilir.

**Studio hedefi:** place ID `83986068176961`, `Workspace/BlackstoneBazaar_K0`. Yerel kaynak ve asset yolları [GAME](../GAME/README.md) içinde.

> **Tarihsel runtime notu:** Bu playcheck `K0Game/K0HUD` döneminde kaydedildi. Sonraki K0.2 yeniden yapılandırmasında aktif runtime `K0Market/K0MarketHUD` oldu; güncel paket K0.3 kaynaklarını kullanır; bu dosyadaki `K0Game` referansları test anını anlatır.

## Kurulan varlık ve anlar

| An | Oyuncunun gördüğü değişim | Uygulama |
|---|---|---|
| İlk sahiplik | Boş sahiplik tabelası oyuncu adı ve seviyesiyle değişir; soluk tente kiremit kırmızısına döner | `NameSign/ClaimPrompt`, `K0Game` |
| İlk satış | Ürün paketi tezgahtan müşteriye gider; dünyada kazanılan ₡ belirir; HUD ilerleme çubuğu dolar | `K0Game`, `K0HUD` |
| Büyütme | Aynı 16 × 12 stud yuvada ikinci teşhir, ürün yoğunluğu, pennant ve sıcak fenerler görünür | `Stall_01/Level2Shelf` |
| Çalışan | Kasiyer tezgâh arkasına yerleşir ve müşteriye otomatik satış yapabilir | `Worker_K0` |
| Maaş | Oyuncu ücret tabelasında ödeme yapar; kasa düşer, vardiya yeniden başlar | `PayBoard` |

Görsel referans [K0_STALL_LEVELS_v1.png](../GAME/assets/concept/K0_STALL_LEVELS_v1.png) built-in imagegen ile üretildi; oyuna resim olarak yüklenmedi. İki küçük Roblox AI mesh (`CitrusCrate_AI`, `BreadBasket_AI`) ve geri kalan kodla yapılmış Part/Gui varlıkları oyunda kullanılıyor. Promptlar [prompt kaydında](../GAME/assets/concept/K0_STALL_LEVELS_v1.prompt.md), varlık ID'leri [köken kaydında](ASSET_PROVENANCE.md).

## Studio Play kanıtı

- Sahiplenmeden önce müşteri gelmedi; `ClaimPrompt` açıktı, seviye 2 ve ekmek sepeti gizliydi.
- Sahiplenme `E` ile çalıştı; tabela oyuncu adı ve `SEVİYE 1` gösterdi, müşteri akışı başladı.
- Normal K0 ayarıyla ilk satış kasayı `0 → 250 ₡` yaptı; HUD hedefi `4.750 ₡` ve ilerlemeyi `%5` gösterdi. Son Play konsolunda script hatası yoktu.
- Geçici `SaleReward=6000` testinde seviye 2 için `5.000 ₡` kesildi; ekmek mesh'i göründü, fener açıldı, tabela `SEVİYE 2` oldu.
- Geçici kısa vardiyada kasiyer otomatik satış yaptı, maaş günü `134 ₡` olarak açıldı ve ödeme sonrası borç sıfırlandı. Geçici değerler tekrar normal `SaleReward=250`, `ShiftSeconds=180`, `WorkerServeSeconds=7` değerlerine alındı.
- Tabela arka yüzüne de yazı eklendi; çarpışma kapatılınca oyuncu etkileşimde panonun üzerine çıkmadı. Fener parlaklığı düşürüldü.

## Açık doğrulama

- 3 ayrı katılımcı × 20 dakika, kendiliğinden devam ve ertesi gün dönüş: **ölçülmedi**. K0 ürün kapısı hâlâ açık.
- Gerçek Android ekranı, FPS/bellek, dokunmatik istem ve iki ışık koşulu: **ölçülmedi**.
- AI mesh üçgen sayısı ve varlık hakları: **doğrulanmadı**. K0 varlıkları `ADAY` statüsünde kalır.
- Anlık ürün paketi animasyonu var; karakterin kol/ürün verme animasyonu ve müzik/ses varlığı henüz yok.
- Ekonomi hâlâ test için sıkıştırılmıştır. Denge kararı bu kayıttan çıkarılmaz.

**Sonuç:** Sahiplik ve yükseltme gözle görülen, oyuncu tarafından tetiklenen anlara dönüştü. “Tatmin ediyor mu?” sorusunun yanıtı gerçek oyuncu testinden sonra yazılacak.
