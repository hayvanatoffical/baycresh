# 3D teknik standardı — Roblox Studio

**Durum:** Üretim standardı ve ölçülecek hipotezler · 25 Eylül 2026. Roblox'un [genel mesh şartları](https://create.roblox.com/docs/art/modeling/specifications), [Blender aktarım kılavuzu](https://create.roblox.com/docs/art/blender) ve [performans kılavuzu](https://create.roblox.com/docs/performance-optimization/improve) temel alınır. Platform sınırları yayından önce tekrar kontrol edilir.

## 1. Dosya, ölçek ve eksen

- Roblox Studio Importer `.gltf/.glb`, `.fbx` ve `.obj` biçimlerini destekler. Çok parçalı varlıklar bir `Model` altında düzenlenir.
- Kaynak dosya, seçilen export ve Studio içindeki nesne adı aynı asset kimliğiyle ilişkilendirilir. Dosya adında Türkçe karakter, boşluk ve sürüm karmaşası kullanılmaz.
- Blender→Studio için import önizlemesinde **World Forward = Front**, **World Up = Top**, **Scale Unit = Stud** kontrol edilir. FBX'te ölçek için `FBX Unit Scale` kullanılır; sonuç Studio'da bir referans karakter/kapı ile ölçülür.
- Pivot, tekrar yerleştirme ve 4 stud ızgarasına oturacak şekilde tasarlanır. Dönen/eklemli parçalarda pivot, animasyon eksenine karşılık gelir. Import sonrası pivot ve yön ekran görüntüsüyle doğrulanır.

## 2. Geometri ve topoloji

- Roblox'un **tekil mesh için platform üst sınırı 20.000 üçgendir**; avatar ve aksesuarlar için ayrı kurallar vardır. Bu bir performans hedefi değildir. Baycrest üretim bütçesi, varlık sınıfı ve gerçek cihaz ölçümünden sonra belirlenir.
- Genel mesh, Roblox'un tarif ettiği kapalı hacim, geçerli yüzler ve uygun topoloji koşullarını karşılar. N-gon/arka yüz/geçersiz normal ve sıfır kalınlık import öncesi kontrol edilir.
- Küçük detaylar oynanışta görünmüyorsa geometri yerine paylaşılan doku/malzeme veya basit parça ile çözülür. Aynı modül tek asset ID ile çoğaltılır; her kopya yeniden yüklenmez.
- Animasyonlu varlıkta kemik ve rig şartları ayrıca değerlendirilir; prop standardı karakter/aksesuar standardının yerine geçmez.

## 3. Malzeme ve doku

- `05` §1.3 paleti renk referansıdır. Yoğun PBR ayrıntısı stil gerekçesiyle değil, görünürlük ve cihaz maliyetiyle değerlendirilir.
- Küçük prop için **512×512 veya altı başlangıç noktasıdır**; bu Roblox'un her varlık için zorunlu üst sınırı değildir. Kamera mesafesi, ekrandaki fiziksel boyut ve bellek ölçümü gerekirse farklı boyutu haklı çıkarır.
- Aynı yüzey için tekrar tekrar yeni doku/mesh ID yükleme. Tek doku ve renk varyasyonu veya trim sheet, tekrar kullanılan modüllerde tercih edilir.
- Gerçek marka, plaka, kurum amblemi veya telifli görsel kaynak dosyaya gömülmez. Varlık kökeni `PRODUCTION/ASSET_PROVENANCE.md` içine yazılır.

## 4. Çarpışma ve sahne maliyeti

- Dekoratif, dokunulmayan parçaların `CanCollide`, `CanTouch`, `CanQuery` ayarları kullanım amacına göre kapatılır. Çarpışma gereken nesnede en basit yeterli şekil seçilir; karmaşık mesh çarpışması gerekçelendirilir.
- Oyuncu ve NPC'nin temas ettiği kapı, tezgâh, raf, merdiven ve kaldırım yalnız görsel değil, hareket testiyle kabul edilir.
- Tekrarlanan aynı mesh ve materyali yeniden kullanmak çizim çağrılarını azaltabilir. Bölgeyi tek seferde benzersiz mesh'lerle import etmek, tekrar kullanımını bozabilir.
- Parça sayısı, doku çözünürlüğü ve FPS tek başına kaliteyi açıklamaz. Studio/cihaz testinde FPS, bellek, çizim çağrısı, yükleme ve fizik gecikmesi birlikte kaydedilir (`04` §13).

## 5. Kabul ölçümü

| Kanıt | Nasıl kaydedilir |
|---|---|
| Kaynak ve export | Dosya adı, format, ölçü, üçgen sayısı, tarih |
| Studio örneği | Place adı/ID, Explorer yolu, asset ID (varsa) |
| Oynanış | K0/K1 senaryosu, giriş/çıkış, oyuncu/NPC temas testi |
| Görsel | Gündüz ve akşam/gece; gerçek oyun kamerası ve mobil ekran |
| Performans | Cihaz modeli, sahne, oyuncu sayısı, FPS/bellek/profiler bulgusu |
| Haklar | Kaynak, lisans, kullanım kapsamı, kanıt bağlantısı |

Eksik ölçüm `TBD` olarak kalır; uydurulmuş rakam `geçti` sayılmaz.

