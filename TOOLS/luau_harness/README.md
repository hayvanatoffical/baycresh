# K0 başsız Luau harness'i — doğrulamanın 3. katmanı

**Durum:** Doğrulama aracı · K0.4.1 ile eklendi · 26 Eylül 2026
**Çalıştırma:** `python3 TOOLS/run_luau_harness.py` (kök dizinden)

## Ne yapar

Gerçek K0 kaynaklarını değiştirmeden, Roblox motorunun bu kaynakların kullandığı kısmını taklit eden sahte bir motorda ve sanal saatle çalıştırır:

- Sahne kurucuları: `SCENE_BUILD`, `STALL_ART_BUILD`, `ART_V2_FIX`, `STALL_ART_V3`, `MARKET_SYSTEM_BUILD`
- Migration: `K0_MARKET_V3_MIGRATION`
- Aktif runtime: `K0MarketConfig`, `K0Market.server`, `K0MarketHUD.client`
- Eski runtime (`GAME/legacy/`): yalnız devre dışı bırakıldığını kanıtlamak için

Senaryolar oyuncu gibi davranır: yürür, `ProximityPrompt` tetikler, HUD düğmelerine basar, `RemoteEvent` gönderir, oyundan çıkar. Sonuçlar sunucu attribute'larından, Output satırlarından ve HUD metinlerinden okunur.

1. katman (`validate_package.py`) metni inceler. 2. katman (`simulate_k0.py` ve `scenarios_k0.py`) ekonomiyi Python'da yeniden modeller. Bu katman ise **kaynağın kendisini** çalıştırır. Bu yüzden sırf kaynağı okuyarak veya modelleyerek görülemeyen hataları yakalar: sinyal sırası, devir yarışı, çift çalışan migration, HUD taşması.

## Ne yapmaz — sınırlar

Bu araç **Roblox Studio değildir**. Buradaki bir PASS, `STUDIO PENDING` ve `DEVICE PENDING` statülerini kaldırmaz.

- Fizik, çarpışma, render, ses ve ağ gecikmesi yok. `Sound:Play()` ses çıkarmaz; yalnız hangi istemcinin hangi sesi çaldığı kaydedilir (H18). Sunucu ve istemci aynı DataModel'i paylaşır; replikasyon anlık ve kusursuzdur.
- `Random` deterministik bir yedektir, Roblox'un PCG üreteciyle **bit düzeyinde aynı değildir**. Tohumlu müşteri dizisi burada kendi içinde karşılaştırılabilir, ama Studio'daki diziyle aynı değildir.
- Motor API'si yalnız kaynakların kullandığı yüzey kadar taklit edilir. Bilinmeyen üye veya yanlış tip Roblox'taki gibi hata verir. Bu yüzden bir yazım hatası sessizce geçmez. Yine de taklit edilen davranış belgelere göre yazılmıştır; motorun kendisi değildir.
- `PlayerRemoving` ile `Parent` değişiminin sırası gibi motor ayrıntıları gerçek Roblox'ta **doğrulanmadı**.
- HUD metin sığdırma kontrolü (H12, H15) bir **tahmindir**: karakter genişliği ortalama bir glif ölçüsüyle hesaplanır. Gerçek font ölçümü değildir.
- H19'un siluet farkı figür parçalarının önden ve yandan izdüşümüdür (0,1 stud ızgara). Render, ışık ve ekran boyutu yoktur; "telefonda ayırt ediliyor" anlamına gelmez. Eşikler (alıcı/pazarlıkçı %12, diğer çiftler %5) figürlerin yeniden aynılaşmasını yakalayan gerilemeye karşı korumadır.
- "Part yazımı" sayacı yalnız harness içindeki özellik yazımlarını sayar. Cihaz FPS'i, ağ bant genişliği veya bellek hakkında bir şey **söylemez**.
- K0.4.2 ses gruplaması, bir sunucu güncellemesindeki attribute değişikliklerinin istemcide `task.defer` işi çalışmadan önce birlikte uygulandığını varsayar. Harness bunu iki sinyal modunda da sağlar; gerçek replikasyonda **doğrulanmadı**. Varsayım yanlışsa en kötü sonuç, bir bildirim sesinin başka bir sesle birlikte çalmasıdır.
- `os.clock()` sanal saate bağlıdır. Luau belgelerindeki "süre ölçümü için zaman damgası" tanımına göre duvar saati gibi davrandığı varsayılır.

## Kurulum

Luau CLI gerekir (`luau` ve sözdizimi kontrolü için `luau-compile`). Resmî sürümler: <https://github.com/luau-lang/luau/releases>. İkili dosyayı `PATH` üzerine veya `/tmp/luaubin/` altına koyun. CLI bulunamazsa araç `SKIP` yazar ve 2 koduyla çıkar. `build_package.py` bu durumu "ATLANDI" olarak açıkça raporlar.

## Kullanım

```bash
python3 TOOLS/run_luau_harness.py                    # tüm senaryolar, iki sinyal modu
python3 TOOLS/run_luau_harness.py H07 H14            # yalnız seçilenler
python3 TOOLS/run_luau_harness.py --mode Deferred    # tek sinyal modu
python3 TOOLS/run_luau_harness.py --echo             # kaynakların print çıktısını da göster
python3 TOOLS/run_luau_harness.py --keep             # üretilen tek dosyalık paketi _bundle.luau olarak sakla
python3 TOOLS/run_luau_harness.py --dump-scene       # yalnız sahne ağacını yaz (TOOLS/build_place.py karşılaştırması için)
```

Bir Roblox place'i `Workspace.SignalBehavior` ayarına göre ertelenmiş (`Deferred`) veya anlık (`Immediate`) sinyal davranışıyla çalışabilir. Test edilecek place'in hangisini kullandığı bu pakette doğrulanmadı. Bu yüzden sıraya bağlı hataları yakalamak için davranış senaryoları iki modda da çalışır. Çıkış kodu: 0 = PASS, 1 = en az bir kontrol başarısız, 2 = Luau CLI yok.

## Dosyalar

| Dosya | İş |
|---|---|
| `engine.luau` | Sahte motor: veri tipleri, Instance ağacı, özellik doğrulaması, sinyaller (Deferred/Immediate), `task` zamanlayıcısı, TweenService, ProximityPrompt, RemoteEvent, WeldConstraint montajı, sanal saat |
| `k0_world.luau` | Place kurulumu ve oyuncu eylemleri: sahneyi kur, runtime'ı yükle, oyuncu ekle/çıkar, yürü, prompt tetikle, düğmeye bas, metin sığdırma tahmini |
| `k0_scenarios.luau` | H01–H19 senaryoları, sahne dökümü ve sonuç raporu |
| `../run_luau_harness.py` | Kaynakları ve harness dosyalarını tek Luau programında birleştirir ve çalıştırır |

## Senaryolar

| Kimlik | Konu | Mod |
|---|---|---|
| H01 | Sahne sözleşmesi: kurucular ve runtime hatasız başlar | iki mod |
| H02 | Kurucular ve migration iki kez çalışınca kopya üretmez | Deferred |
| H03 | Eski runtime devre dışı bırakılır veya yüksek sesle raporlanır | Deferred |
| H04 | Test planı 1. aşama akışı: prompt ve HUD üzerinden | iki mod |
| H05 | B1: yarı boş raf kısmen doldurulabilir | iki mod |
| H06 | B2: kayıt bitimi → tasfiye → yenileme | iki mod |
| H07 | Tek kurtarmadan sonra oyuncu yeniden ticaret yapabilir; ikinci çıkmaz raporlanır | iki mod |
| H08 | Karar RemoteEvent'i: doğrulama ve hız sınırı | iki mod |
| H09 | Sahip ayrılınca sıradaki oyuncuya devir | iki mod |
| H10 | Tohumlu karşılaştırılabilirlik: testçi hızı müşteri dizisini kaydırmaz | Deferred |
| H11 | 20 dakikalık dengeli oturum: özet satırı, kilometre taşları, değişmezler, yazım sayacı, sunucu kapanışında tek `server_close` özeti | iki mod |
| H12 | HUD yerleşimi: teklif kartı durumları ve metin sığdırma tahmini (PC ve iki telefon boyutu) | Deferred |
| H13 | 40 dakikalık rastgele oturum: rastgele prompt ve bozuk RemoteEvent verisi | iki mod |
| H14 | Harcama oyuncuyu stoksuz ve parasız bırakamaz (yükseltme, kasiyer, maaş, yenileme) | iki mod |
| H15 | Görülen her bildirim, yardım ve hedef metni kutusuna sığar (tahmin) | Deferred |
| H16 | Ölçüm: talep panosunu izlemenin gerçek runtime'daki değeri (12 tohum) | Deferred |
| H17 | Bulut smoke görev betiği (`TOOLS/place_build/cloud_smoke.luau`) bu place'te geçer; Roblox'a gönderilmeden önce betiğin kendisi denetlenir | iki mod |
| H18 | K0.4.2 sesleri: katılımda ses yok; her olay tek ses (bildirim sesi başka sesle birlikte susar, kayıt bitimi red sesini bastırır); 25 dakikalık oturumda ses sayısı olay sayısına eşit; izleyici ses duymaz; devirde eski durum çalınmaz; boş `Id` ses nesnesi bile oluşturmaz | iki mod |
| H19 | K0.4.3 okunabilirlik: her figür doğduğu rolle çizilir ve her teklif kendi türündeki figürden gelir; roller izdüşümde birbirinden ayrılır; HUD ikonları satıcıda görünür, izleyicide gizli; teklif kartında ürün ikonu ve bütçe göstergesi duruma uyar, doluluk SIKI < ORTA < ESNEK; kasiyer önlüklü | iki mod |

H16 bir ölçümdür. Sonucu not olarak yazar, geçme koşulu değildir. Tasarım yorumu [`PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md`](../../PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md) §4'tedir.

## Yeni senaryo eklerken

- Beklenen davranışı `GAME/README.md`, `PRODUCTION/K0.4_NEXT_TEST_PLAN.md` veya uygulama raporundan alın; harness'i kaynağa uydurmak için yazmayın.
- Başarısız bir kontrol ya kaynak hatasıdır ya harness hatasıdır. İkisi ayrılana kadar incelenir; susturulmaz.
- Süreyi kısaltmak için `configPatch` kullanın. Bu, test planındaki Edit modu kopyasının karşılığıdır ve yalnız `Prototype` bloğunu değiştirir; kaynak dosyaya dokunmaz.
