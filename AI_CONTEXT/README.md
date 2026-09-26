# AI_CONTEXT — Görev yönlendirme

**Durum:** Kanonik belgelerden türetilmiş çalışma bağlamı · 25 Eylül 2026. Bu klasör yeni ürün kararı koymaz.

## Okuma sırası

1. [PROJECT_BRIEF.md](PROJECT_BRIEF.md) ile ürünün kapsamını ve mevcut durumunu öğren.
2. Görevin ilgili satırındaki **kanonik** belgeleri aç. Çelişkide [KARARLAR.md](../KARARLAR.md) geçerlidir.
3. Roblox Studio işlemi varsa [ROBLOX_WORKFLOW.md](ROBLOX_WORKFLOW.md); 3D işi varsa [3D_MODELING/PIPELINE.md](3D_MODELING/PIPELINE.md) ve ilgili taslağı aç.
4. Çıktıda neyin taslak, neyin uygulama, neyin test edilmiş sonuç olduğunu ayrı yaz.

K0'ın güncel kaynak akışı [GAME](../GAME/README.md), K0.3 son kaynak denetimi [PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md](../PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md), önceki K0.2 yeniden yapılandırma kaydı [PRODUCTION/K0_CODE_REWORK_2026-09-25.md](../PRODUCTION/K0_CODE_REWORK_2026-09-25.md) ve tarihsel Studio teknik kontrolü [PRODUCTION/K0_TECHNICAL_CHECK_2026-09-25.md](../PRODUCTION/K0_TECHNICAL_CHECK_2026-09-25.md) içindedir. K0.3 Studio/Android ve üç bağımsız oyuncu kabul sonuçları henüz yoktur. AI/3D araç seçerken [AI lisans matrisi](../PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md) ile [hak/atıf standardı](../PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md) birlikte okunur.

| Görev | Gerekli kanonik bağlam | Ek çalışma belgesi |
|---|---|---|
| K0 oynanış / tezgâh | `EKIP/00`, `01`, `03`, `07` | `DESIGN_DRAFTS/3D/K0_BAZAAR_STALL.md` |
| Harita gri kutu | `EKIP/00`, `05`, `07` | `DESIGN_DRAFTS/3D/K0_BAZAAR_GREYBOX.md` |
| 3D mesh ve prop | `EKIP/00`, `05` | `3D_MODELING/PIPELINE.md`, `TECHNICAL_STANDARD.md`, `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` |
| Sunucu kodu / veri | `EKIP/00`, `04`, ilgili sistem | `ROBLOX_WORKFLOW.md` |
| Ekonomi | `EKIP/00`, `03`, karar kaydı | Model ve telemetri kanıtı |
| Suç / polis | `EKIP/00`, `02`, `09`, `04` | K3 kapsamı; K0'a taşınmaz |
| Arayüz / ses | `EKIP/00`, `06` | `PRODUCTION/ASSET_PROVENANCE.md` |
| Tasarım kararı | Karar kaydı, ilgili `EKIP/` | `DOKUMAN-YONETIMI.md` |

## Her AI görevi için kısa sözleşme

```text
Görev: [tek somut çıktı]
Hedef katman: [K0–K6]
Hedef konum: [dosya veya doğrulanmış Studio place]
Kaynaklar: [karar kimlikleri + ilgili kanonik bölümler]
Kabul ölçütü: [gözlenebilir davranış/ölçüm]
Yasak kapsam: [bu görevde yapılmayacak sistemler]
Kanıt: [dosya, test, ekran görüntüsü, cihaz/oturum]
```

Belirsiz konular için karar uydurma. Somut taslağı üret, `TBD` noktalarını doğrulama yöntemiyle işaretle ve gerekli kararı görünür kıl. `OZEL/` içeriğini ekip çıktısına veya bu klasöre taşımadan önce proje sahibinin açık talimatını ara.
