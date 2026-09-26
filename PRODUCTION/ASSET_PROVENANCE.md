# Üretim varlığı köken ve lisans kaydı

**Durum:** K0 için aday varlıklar kayıtlı; yayıma yönelik hak ve cihaz QA henüz yapılmadı. Ses, görsel, mesh, animasyon ve Creator Store varlığı için bir satır açılır. Hukuki hak iddiası, kanıt dosyası veya resmî lisans bağlantısı olmadan `doğrulandı` sayılmaz.

**Güncel hak kontrolü:** [AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md](AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md). Bu belge sağlayıcı bazlı hak/atıf kapısını tanımlar; tek tek varlık satırının kanıt yükümlülüğünü kaldırmaz.

| Asset kimliği | Tür | Kaynak / üretici | URL veya kaynak dosya | Lisans ve ticari kapsam kanıtı | Alınma tarihi | Studio place / Explorer yolu / asset ID | İç script kontrolü | İnceleyen | Durum |
|---|---|---|---|---|---|---|---|---|---|
| K0-CONCEPT-001 | Görsel referans | OpenAI built-in imagegen, proje promptu | `GAME/assets/concept/K0_STALL_LEVELS_v1.png` ve `.prompt.md` | 2026-09-26 OpenAI şart kontrolü: kullanıcı/OpenAI arasında çıktı hakkı kullanıcıya atanıyor; girdi hakları kullanıcı sorumluluğunda, çıktı benzersiz olmayabilir. Doğrudan oyun varlığı değildir. Ayrıntı: `AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` | 2026-09-25 | Studio dışı konsept | Uygulanmaz | Codex ön inceleme | TASLAK / REFERANS |
| K0-MESH-001 | Dokulu mesh, turunçgil kasası | Roblox Studio AI mesh generation | Model `140361811304430`; mesh `125176847983447`; doku `116484042244112`; prompt aynı klasörde | 2026-09-26 Roblox AI Terms genel hak/provenance kuralı kontrol edildi; bu özel asset için yayın moderasyonu ve güncel asset hak durumu doğrulanmadı. Ayrıntı: `AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` | 2026-09-25 | Eskiden place `83986068176961` / `Stall_01.ArtV2.CitrusCrate_AI`; ArtV3 ile kaldırıldı | Model + MeshPart; çalıştırılabilir çocuk yok | Codex ön inceleme | CANLI SAHNEDEN ÇIKARILDI / deneme kaydı |
| K0-MESH-002 | Dokulu mesh, ekmek sepeti | Roblox Studio AI mesh generation | Model `115094943790841`; mesh `82563820320929`; doku `103569144814550`; prompt aynı klasörde | 2026-09-26 Roblox AI Terms genel hak/provenance kuralı kontrol edildi; bu özel asset için yayın moderasyonu ve güncel asset hak durumu doğrulanmadı. Ayrıntı: `AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` | 2026-09-25 | Eskiden place `83986068176961` / `Stall_01.Level2Shelf.BreadBasket_AI`; ArtV3 ile kaldırıldı | Model + MeshPart; çalıştırılabilir çocuk yok | Codex ön inceleme | CANLI SAHNEDEN ÇIKARILDI / deneme kaydı |
| K0-PART-ART-001 | Roblox Part/Gui tezgâh seti | Baycrest proje içi Luau üretimi | `GAME/SCENE_BUILD.lua`, `GAME/STALL_ART_BUILD.lua`, `GAME/ART_V2_FIX.lua` | Dışarıdan varlık kullanılmadı; proje içi üretim kaydı | 2026-09-25 | Place `83986068176961` / `Workspace.BlackstoneBazaar_K0.Stall_01` | Builder çalışma zamanı script'i bırakmadı | Codex ön inceleme | ADAY |
| K0-PART-ART-002 | Görsel referansa göre 3D tezgâh V3 | Baycrest proje içi Luau ve Roblox yerel parçaları | `GAME/STALL_ART_V3.lua`; görsel `GAME/assets/concept/K0_STALL_LEVELS_v1.png` | Dış model/doku kullanılmadı. Kaynak kod ve üretim kaydı mevcut; platform kuralları yine geçerlidir | 2026-09-25 | Place `83986068176961` / `Stall_01.ArtV3` ve `Stall_01.Level2Shelf.ArtV3`; bulut taslak kaydı bekliyor | V3 klasörleri 0 çalıştırılabilir script | Codex ön inceleme | ADAY / STUDIO'DA |

## Kayıt kuralları

- Creator Store varlığında kaynak bağlantısı, yaratıcısı, o günkü kullanım koşulu ve varlık ID'si saklanır. İçindeki script'ler incelenmeden oyun place'ine eklenmez.
- AI üretiminde kullanılan araç/model, prompt sürümü, insan düzeltmesi ve yayın kullanım hakkı ayrıca kaydedilir. Bir aracın ücretsiz planı otomatik olarak ticari hak vermez.
- Kendi üretilen varlıkta kaynak proje dosyası, dışarıdan kullanılan doku/ses referansları ve export sürümü yazılır.
- Aynı varlık tekrar kullanılırsa yeni kopya satırı yerine aynı asset ID'ye bağlanır. Asset ID değişirse nedeni belirtilir.
- Yayından önce tüm satırlar hak, moderasyon durumu ve gerçek place kullanımı bakımından yeniden kontrol edilir.
