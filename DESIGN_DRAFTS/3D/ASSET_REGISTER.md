# 3D asset ve sahne kaydı

**Durum:** K0 tezgâhı sanat adayı ve sokak gri kutusu Studio'da; K1 cephe kiti taslak.  
**Son gözden geçirme:** 25 Eylül 2026

| Kimlik | Taslak | Katman | Öncelik | Durum | Sonraki doğrulama |
|---|---|---|---|---|---|
| 3D-K0-001 | [Bazaar tezgâhı](K0_BAZAAR_STALL.md) | K0 | P0 | ADAY | Üç oyunculu tatmin testi, iki ışık koşulu, Android ve haklar QA |
| SCN-K0-001 | [Bazaar tek sokak gri kutusu](K0_BAZAAR_GREYBOX.md) | K0 | P0 | GRİ KUTU | Yürüme süresi, kamera, Android ve üç oyuncu testi |
| 3D-K1-001 | [Modüler cephe kiti](K1_FACADE_MODULE_KIT.md) | K1 hazırlığı | P1 | TASLAK | 4 stud ızgara, beş parça ve üç bina montajı |

**P0:** K0 oynanışının çalışması için gerekli. **P1:** K1 yerleşim sisteminin temeli. Kimlik bir kez verilir, yeniden kullanılmaz. Nihai Studio varlık ID'si üretildikten sonra aynı satıra eklenir.

## Statü açıklaması

`TASLAK`: brief var. `GRİ KUTU`: hacim oyunda test edilebilir. `ADAY`: sanat/teknik üretim var. `ONAYLI`: QA incelemesi geçti. `STUDIO'DA`: doğru place'e entegre edildi. `DOĞRULANDI`: oynanış ve cihaz testi kanıtlandı.

## Değişiklik kaydı

| Tarih | Kimlik | Değişiklik | Kanıt |
|---|---|---|---|
| 2026-09-25 | Üç başlangıç satırı | K0/K1 taslak havuzu açıldı | İlgili brief'ler; Studio üretimi yok |
| 2026-09-25 | 3D-K0-001, SCN-K0-001 | Roblox place ID `83986068176961` içine gri kutu yerleştirildi | [K0 teknik kontrol](../../PRODUCTION/K0_TECHNICAL_CHECK_2026-09-25.md) |
| 2026-09-25 | 3D-K0-001 | Sahiplik, ürün teşhiri, seviye 2 dönüşümü ve iki mesh adayı eklendi | [Sanat/oynanış kontrolü](../../PRODUCTION/K0_ART_PLAYCHECK_2026-09-25.md) |
| 2026-09-25 | 3D-K0-001 | Referans görsele göre yerel 3D ArtV3 kuruldu; iki AI mesh denemesi canlı sahneden çıkarıldı | [V3 sanat ve lisans kontrolü](../../PRODUCTION/K0_3D_ART_V3_2026-09-25.md) |
