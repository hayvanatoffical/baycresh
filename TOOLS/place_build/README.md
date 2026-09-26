# K0 Studio'suz place kurulumu ve bulut smoke testi — doğrulamanın 4. ve 5. katmanı

**Durum:** Doğrulama aracı · K0.4.1 ile eklendi · 26 Eylül 2026
**Çalıştırma:** `python3 TOOLS/build_place.py` (kök dizinden), sonra isteğe bağlı `python3 TOOLS/roblox_cloud.py …`
**Sahip rehberi:** [`PRODUCTION/K0_STUDIOSUZ_TEST_YOLU.md`](../../PRODUCTION/K0_STUDIOSUZ_TEST_YOLU.md)

## Neden var

Roblox Studio yalnız Windows ve macOS'ta çalışır. Proje sahibinin şu an yalnız telefonu (Redmi, Android) var. Bu araçlar K0 place'ini Studio açmadan kurar, doğrular ve sahibin izniyle Roblox'a yükler. Sonra Roblox'un kendi sunucusunda smoke testini çalıştırır. Oyun, telefondaki Roblox uygulamasından oynanır.

## Ne yapar

**4. katman — `TOOLS/build_place.py` (çevrimdışı, Roblox hesabı gerekmez)**

- Beş sahne kurucusunu (`SCENE_BUILD`, `STALL_ART_BUILD`, `ART_V2_FIX`, `STALL_ART_V3`, `MARKET_SYSTEM_BUILD`) [Lune](https://github.com/lune-org/lune) içinde çalıştırır. Lune açık kaynaklı bir Luau çalışma ortamıdır. Roblox'un nesne modelinin açık kaynaklı karşılığını (rbx-dom) ve Roblox'un yansıma veritabanını kullanır. Bu yüzden yanlış yazılmış bir özellik adı veya yanlış tipte değer, Studio'da olduğu gibi hata verir.
- Üç aktif kaynağı Studio'daki yerlerine koyar: `ReplicatedStorage/K0MarketConfig`, `ServerScriptService/K0Market`, `StarterPlayer/StarterPlayerScripts/K0MarketHUD`.
- Her test profili için ikili bir `.rbxl` yazar: `dist/place/BAYCREST-K0.4.1-<profil>.rbxl` ve yanında `.manifest.json`.
- Her dosyayı doğrular:
  1. Her kurucu hatasız çalıştı.
  2. Dosya geri okununca nesne sayısı aynı.
  3. Her script bayt bayt aynı kaynakla yerinde.
  4. Config modülü çalışıyor ve profil yalnız istenen `Prototype` değerini değiştirdi.
  5. Sahne ağacı, Luau harness'inin aynı kaynaklardan kurduğu ağaçla aynı. İki bağımsız nesne modeli uygulaması aynı sonucu vermeli.
- Doğrulamadan geçmeyen `.rbxl` silinir. Yüklenebilecek yerde bırakılmaz.

**5. katman — `TOOLS/roblox_cloud.py` (Roblox Open Cloud, sahibin anahtarı gerekir)**

- `publish`: doğrulanmış bir `.rbxl`'i [Place Publishing API](https://create.roblox.com/docs/cloud/guides/usage-place-publishing) ile var olan bir place'e yükler.
- `smoke`: [`cloud_smoke.luau`](cloud_smoke.luau) betiğini [Luau Execution API](https://create.roblox.com/docs/cloud/features/luau-execution) ile **gerçek bir Roblox oyun sunucusunda** çalıştırır. Betik şunları yapar:
  - Kurucuları ve migration'ı gerçek motorda yeniden çalıştırır. Sahnenin değişmediğini ve kopya oluşmadığını kontrol eder.
  - Config'i `require` eder ve yüklenen profille karşılaştırır.
  - Sunucu runtime'ını başlatır. Hazır satırını, uyarıları, tabela fiyatlarını, talep panosunu ve tezgâh tabelasını okur.
- `run`: herhangi bir görev betiğini çalıştırır; logları ve dönüş değerini yazar.
- Her gönderim `dist/place/{publish|smoke}-<profil>-<UTC zaman>.json` kanıt kaydı bırakır. Anahtar bu kayıtlara yazılmaz.

## Ne yapmaz — sınırlar

Buradaki bir PASS, `STUDIO PENDING` ve `DEVICE PENDING` statülerini kaldırmaz. Yalnız telefon testinin ve sonraki Studio testinin **önünü açar**.

- **Lune Roblox motoru değildir.** Fizik, render, ağ ve script zamanlaması yok. Özellik adı ve tipi gerçek veritabanıyla denetlenir. Motorun bir değeri çalışma anında nasıl kullandığı denetlenmez.
- Lune birkaç motor yöntemini desteklemez. Kurucular için `WaitForChild` bir ara katmanla sağlanır: nesne yoksa beklemez, hata verir. `GetPivot` ve `PivotTo` desteklenmez. Aktif kurucular bunları kullanmıyor.
- Kurucular eski `Font` enum özelliğini yazar. Lune bunu dosyaya yazamaz. Bu yüzden her metin nesnesinin `FontFace` değeri `Font.fromEnum` ile aynı fonta ayarlanır. Bu bir araç sınırıdır, kaynak hatası değildir. Studio'da kaydedilen place'lerde de `FontFace` saklanır.
- Kurulan place **temiz sahnedir.** Studio place'indeki elle yerleştirilmiş AI modelleri (`AI_ASSET_PLACEMENT`) içinde yoktur. Görsel karşılaştırma bu dosyayla yapılmaz.
- Baseplate ve SpawnLocation, Studio'nun Baseplate şablonunun sade karşılığıdır. Aydınlatma ve kamera ayarları kurucuların yazdığı kadardır.
- **Luau Execution görevinde oyuncu yoktur, fizik çalışmaz ve place'teki scriptler kendiliğinden başlamaz** (Roblox belgesi). Görevdeki değişiklikler kaydedilmez. Bu yüzden smoke testi prompt, HUD, NPC yürüyüşü, dokunma veya FPS denetleyemez. Bunlar telefonda oynayarak test edilir.
- Smoke betiği DataStore, `SavePlaceAsync` veya HTTP çağırmaz.
- `test_roblox_cloud.py` istemciyi sahte bir yerel sunucuya karşı dener. Bu, Roblox'un istekleri kabul ettiğini **kanıtlamaz.** İlk gerçek çağrı sahibin anahtarıyla yapılacak. O zamana kadar 5. katmanın durumu **denenmedi**dir.

## Kurulum

Lune 0.10.5 gerekir (4. katman). Rust kuruluysa:

```bash
cargo install --locked lune --version 0.10.5
```

Resmî sürümler: <https://github.com/lune-org/lune/releases>. İkili dosyayı `PATH` üzerine, `/tmp/lunebin/lune` yoluna koyun veya `LUNE` ortam değişkeniyle gösterin. Lune bulunamazsa araç `SKIP` yazar ve 2 koduyla çıkar. Harness ağacıyla karşılaştırma için Luau CLI de gerekir (bkz. [`../luau_harness/README.md`](../luau_harness/README.md)).

5. katman yalnız Python standart kütüphanesini kullanır.

## Kullanım

```bash
python3 TOOLS/build_place.py                      # dört profil
python3 TOOLS/build_place.py permit90             # tek profil
python3 TOOLS/test_roblox_cloud.py                # istemciyi sahte sunucuya karşı dene (anahtar gerekmez)

python3 TOOLS/roblox_cloud.py status              # hangi ayarlar var (ağ çağrısı yok)
python3 TOOLS/roblox_cloud.py publish default     # KURU ÇALIŞMA: ne gönderileceğini yazar, göndermez
python3 TOOLS/roblox_cloud.py publish default --yes            # yayınla (oyuncular bu sürüme girer)
python3 TOOLS/roblox_cloud.py publish default --yes --saved    # yalnız kaydet, canlı sürümü değiştirme
python3 TOOLS/roblox_cloud.py smoke default       # son sürümde gerçek motor smoke testi
python3 TOOLS/roblox_cloud.py smoke default --place-version 12
```

Çıkış kodları: `build_place.py` 0 = PASS, 1 = FAIL, 2 = Lune yok. `roblox_cloud.py` 0 = başarılı, 1 = smoke başarısız, 2 = ayar, koruma veya ağ hatası.

## Profiller

Test planının "Edit-mode kopyasında değeri geçici olarak değiştir" adımlarının yerini alır. Kaynak dosya diskte hiç değişmez. Profil yalnız kurulan dosyadaki config'i değiştirir, ve smoke testi bunu yayınlanan place'te yeniden denetler.

| Profil | Değişiklik | Test planı adımı |
|---|---|---|
| `default` | yok | Aşama 1, 2a, 2c (normal oynanış), B12, B19, Aşama 3–4 |
| `permit90` | `PermitPeriodSeconds = 90` | 2b kayıt çıkmazı ve kurtarma |
| `cash325` | `StartingCash = 325` | 2d B11 yükseltme reddi |
| `cash385` | `StartingCash = 385` | 2d B11 kasiyer reddi |

Test profiliyle yayınlanan place'te ölçüm yapılmaz. Profil testi bitince `default` yeniden yayınlanır.

## Ortam değişkenleri

| Değişken | Anlamı |
|---|---|
| `ROBLOX_API_KEY` | Open Cloud API anahtarı. **Sohbete, dosyaya veya commit'e yazılmaz.** Ortam ayarlarına eklenir. |
| `ROBLOX_UNIVERSE_ID` | Deneyimin (experience) kimliği |
| `ROBLOX_PLACE_ID` | Yüklenecek ve görevin çalışacağı place |
| `ROBLOX_API_BASE` | Yalnız test için. Varsayılan `https://apis.roblox.com`. Yerel sunucu dışında `https` zorunlu. |
| `K0_PLACE_DIR` | Yalnız test için. `.rbxl` dosyalarının okunacağı klasör. |

**Anahtarın izinleri** (Creator Dashboard → Credentials → API Keys → Create API Key), en az yetki ilkesiyle:

- `universe-places` → **Write** (place yükleme)
- `universe.place.luau-execution-session` → **Read** ve **Write** (görev oluşturma, sonucu ve logları okuma)
- **Restrict by Experience** açık kalsın ve yalnız test place'inin deneyimi seçilsin.
- IP kısıtlaması isteğe bağlıdır. Bulut oturumunun sabit IP'si yoksa kapalı bırakılır.
- Roblox, 60 gün kullanılmayan anahtarı kendiliğinden devre dışı bırakır ([API keys](https://create.roblox.com/docs/cloud/auth/api-keys)).

## Korumalar

- `publish`, `--yes` olmadan hiçbir şey göndermez.
- Doğrulanmamış bir dosyayı veya doğrulamadan sonra değişmiş bir dosyayı (sha256 farkı) göndermez.
- Ana K0 place'i `83986068176961` üzerine `--allow-main-place` olmadan yayınlamaz. Bu karar sahibindir.
- Anahtar hiçbir çıktıda veya kanıt kaydında görünmez. Hata metinlerinden de silinir.
- 429 ve 5xx yanıtlarında 2, 4 ve 8 saniye bekleyerek yeniden dener.
- Görev betiği Roblox'un 4 MB sınırını aşarsa göndermez. Zaman aşımı en fazla 300 saniyedir.

## Dosyalar

| Dosya | İş |
|---|---|
| `build_place.luau` | Lune betiği: DataModel'i kurar, kurucuları çalıştırır, scriptleri ekler, `.rbxl` ve manifest yazar, dosyayı geri okur |
| `cloud_smoke.luau` | Luau Execution görev betiği şablonu (`--@@BUNDLE@@` işaretli) |
| `smoke_bundle.py` | Şablonu kaynaklarla tek betiğe birleştirir. Aynı metin H17'de harness'te de çalışır. |
| `../build_place.py` | Profilleri kurar, doğrular, harness ağacıyla karşılaştırır |
| `../roblox_cloud.py` | Open Cloud istemcisi: `status`, `publish`, `smoke`, `run` |
| `../test_roblox_cloud.py` | İstemcinin sahte sunucuya karşı testi (22 kontrol) |

## Smoke betiği değişince

1. `python3 TOOLS/run_luau_harness.py H17` — betik önce sahte motorda iki sinyal modunda geçmeli.
2. `python3 TOOLS/test_roblox_cloud.py` — istemci ve paketleme bozulmamalı.
3. Ancak sonra gerçek `smoke` çalıştırılır. Harness'te geçip Roblox'ta kalan bir kontrol, harness'in yanlış taklit ettiği bir motor davranışıdır. Roblox sonucu geçerlidir ve harness düzeltilir.
