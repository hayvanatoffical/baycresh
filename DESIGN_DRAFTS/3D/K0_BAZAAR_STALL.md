# 3D-K0-001 — Blackstone Bazaar satış tezgâhı

**Durum:** ADAY (Studio'da; cihaz ve haklar QA bekliyor) · **Katman:** K0 · **Öncelik:** P0  
**Karar bağları:** `EKIP/07` §2, `EKIP/01` §2.3, `EKIP/05` §2.4 ve §8.  
**Amaç:** Tek oyuncunun NPC müşteriye ürün verip para almasını, tezgâhını seviye 2'ye çıkarmasını ve bir çalışanla maaş döngüsünü görmesini sağlamak.

## Oynanış yüzeyleri

| Yüzey | Görev | Gri kutu kabulü |
|---|---|---|
| Müşteri önü | NPC kuyruğu ve etkileşim | NPC yaklaşır, oyuncu erişir, yol kapanmaz |
| Satış düzlemi | Ürün verme / para alma animasyonu | Animasyon elleri tezgâhı kesmez; işlem noktası belirgindir |
| Oyuncu arkası | Satıcı hareket ve çalışan konumu | Oyuncu ile NPC çalışan birbirini kilitlemez |
| Tabela yuvası | İşletme kimliği | Şablon metin için boş alan; varlığa serbest metin gömülmez |
| Stok/iyileştirme alanı | Seviye 1→2 görsel değişim | Aynı fiziksel yuva ölçüsü korunur; kazanç kuralını geometri değiştirmez |

## Ölçek ve modüler arayüz

- K0'da **tek** işlevsel tezgâh yapılır. `05`'teki 24 tezgâhlık sunucu kapasitesi sonraki yerleşim tasarımına ait hedef sayıdır; K0'da 24 adet üretim gerekmez.
- İlk gri kutuda dış sınır 16 × 12 stud, tente yüksekliği 9,6 stud ve tezgâh üstü 3,2 stud olarak uygulandı. Bunlar animasyon ve kamera testinden sonra yeniden ayarlanabilir.
- Seviye 1 ve 2 aynı taban, pivot, giriş ve tabela bağlantısını kullanır. Seviye 2 yalnız onaylı görsel/işlevsel eklerle ayrışır.
- Tente ve dekor, gündüz/akşam ışığında müşteriyi veya ürün görünürlüğünü kapatamaz.

## Görsel yön

Kirli krem (`#E8DCC8`) ana gövde, soluk terrakota (`#C97B5A`) seçili vurgu, kiremit kırmızısı (`#A34A32`) tente adayıdır. Nihai kombinasyon `EKIP/05` §1.3 paleti ve sokak bütünlüğüne göre seçilir. Büyük logo, gerçek marka, serbest oyuncu metni, alkol/kan/gore görseli yoktur.

## Teknik taslak

- İlk gri kutu Roblox `Part` nesneleriyle; özel mesh ancak oynanış ölçüsü sabitlendikten sonra.
- Sabit dekor `Anchored`; temas etmeyen tente/dekorun gereksiz çarpışması kapalı. Satış düzlemi ve yol çarpışması ayrı test edilir.
- İlk kaynak `GAME/SCENE_BUILD.lua`; sonraki sanat katmanı `GAME/STALL_ART_BUILD.lua`, `GAME/ART_V2_FIX.lua` ve görsel referansa göre yeniden kurulan `GAME/STALL_ART_V3.lua`. İki Roblox Studio AI mesh denemesi canlı sahneden çıkarıldı. Artık görünür K0 tezgâhı dış model ve doku gerektirmeyen yerel `Part`/`Gui` yapısıdır. Deneme varlıklarının ID'leri `PRODUCTION/ASSET_PROVENANCE.md` içinde korunur.
- AI mesh üretilirse aday statüsünde kalır; [QA](../../AI_CONTEXT/3D_MODELING/QA_CHECKLIST.md) ve lisans/köken kaydından geçer.

## Kabul senaryosu

1. Oyuncu spawn noktasından tezgâha yürür; nereden satış yapılacağını yardım olmadan bulur.
2. NPC müşteri tezgâha gelir, sıraya girer, satış işlemi ve para geri bildirimi görünür.
3. Oyuncu tezgâhı seviye 2 yapar; tezgâhın dış yuva ölçüsü değişmez ve etkileşim noktası kaybolmaz.
4. NPC çalışan yerleşir; satış/maaş animasyonu tezgâh geometrisiyle çakışmaz.
5. Gündüz ve akşam, oyun kamerasında okunabilirlik; hedef Android cihazda ilk performans kaydı alınır.

**Durum kanıtı:** Roblox place ID `83986068176961` içinde `Workspace/BlackstoneBazaar_K0/Stall_01`. Sahiplik tabelası, tezgâha bağlı 3D ürünler, seviye 2 raf/fener ve ürün paketi animasyonu Studio Play ile denendi. Kullanıcının üç kişilik tatmin testi, karakter animasyonu, iki ışık koşulu ve Android QA bekliyor. [Sanat/oynanış kontrolü](../../PRODUCTION/K0_ART_PLAYCHECK_2026-09-25.md).

**Referansın 3D karşılığı:** `STALL_ART_V3.lua` ile mevcut 16 × 12 stud yuvada eğimli kırmızı/krem tente, krem direk/metal başlık, taş kaide ve döşeme kenarı, ahşap panolu tezgâh, ürün kasaları ve seviye 2'de yoğun teşhir, ekmek sepeti, zeytin bannerı, sarımsak ve sarmaşık kurulmuştur. Tekil test sahnesinde 371 BasePart sayıldı; bu sayı 24 tezgâha ölçekleme onayı değildir. [V3 kontrolü](../../PRODUCTION/K0_3D_ART_V3_2026-09-25.md).
