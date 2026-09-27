# K0 — Telefonda ekran ve yazı boyutu: "okunuyor mu?"

**Durum:** Araştırma ve hesap · K0.4.5, K0.4.6 · 27 Eylül 2026 · **cihazda ölçülmedi**
**Kapsam:** K0 pazar HUD'u, Redmi telefonlar ve proje sahibinin Redmi Note 13 Pro+ 5G'si (§7), yatay ekran
**Karar:** En küçük yazı 12 px; telefon arayüzü bundan büyük yapılmaz (`KARARLAR.md` UK-19, 27 Eylül 2026).

K0.4.4 test planında "durum panelindeki yazılar telefonda okunuyor mu?" diye açık uçlu bir soru vardı. Bu belge soruyu ölçülebilir parçalara ayırıyor. Her parça web kaynağıyla ve hesapla cevaplanıyor. Sonunda cihazda neyin, nasıl kontrol edileceği yazıyor. Buradaki sayılar **hesaptır**. Kesin cevap, telefondaki konsol satırı ve oyuncunun gözüdür (§6).

## 1. Telefonun ekranı kaç piksel?

Proje sahibinin test telefonu **Redmi Note 13 Pro+ 5G**'dir; ayrıntılı hesabı §7'dedir. Güncel diğer Redmi'ler ekran bakımından iki sınıfa ayrılıyor:

| Model | Panel çözünürlüğü | Köşegen | Piksel yoğunluğu | Kaynak |
|---|---|---|---|---|
| Redmi 14C, Redmi A5 | 720 × 1640 (HD+) | 6,88" | ~260 ppi | [GSMArena 14C / A5](https://www.gsmarena.com/compare.php3?idPhone1=13737&idPhone2=13291) |
| Redmi 13C | 720 × 1600 (HD+) | 6,74" | ~260 ppi | [Wikipedia: Redmi 13C](https://en.wikipedia.org/wiki/Redmi_13C) |
| Redmi Note 14 4G | 1080 × 2400 (FHD+) | 6,67" | ~395 ppi | [GSMArena Note 14 4G](https://www.gsmarena.com/compare.php3?idPhone1=13616&idPhone2=13291) |

Model şuradan öğrenilir: **Ayarlar → Telefon hakkında**. 1080 × 2400'lük diğer Redmi Note modelleri FHD+ sınıfına girer.

## 2. Roblox bu pikselleri arayüze nasıl verir?

Roblox, telefonda arayüzü panelin gerçek pikseliyle çizmez. Bir Roblox mühendisinin DevForum açıklaması şöyle: iPhone X'in 2436 × 1125 ekranında ScreenGui'nin boyutu **812 × 375** olarak verilir, yani 3 kat küçük. Çizim ise 3 kat büyük yapılır. Roblox "yaklaşık 160 dpi'ye normalleştirmeye çalışır". Bu "Roblox pikselleri" web ve Android dünyasındaki **dp** (cihazdan bağımsız piksel) ile aynı şeydir. Aynı açıklamada, TextSize 20'nin fiziksel olarak en az ~1/8 inç (3,2 mm) olması hedeflendiği ve bundan küçüğün "iyi bir oyuncu deneyimi olmasının pek olası olmadığı" söylenir ([alıntı ve bağlantılar](https://devforum.roblox.com/t/specific-details-about-ui-scaling-best-practices/3888004); asıl ileti: [UI is really really really weird on mobile, #15](https://devforum.roblox.com/t/ui-is-really-really-really-weird-on-mobile/95626/15)).

Android'de hangi ölçeğin kullanıldığı resmî olarak yazılı değil. Bu yüzden iki sınır hesaplandı:

| Sınıf | Android yoğunluğu ile (**varsayım**: HD+ 2,0, FHD+ 2,75) | Tam 160 dpi normalleştirmeyle |
|---|---|---|
| Redmi 14C / A5 | 820 × 360 | 1009 × 443 |
| Redmi 13C | 800 × 360 | 985 × 443 |
| Redmi Note 14 4G | 873 × 393 | 972 × 437 |

Oyunda bu alandan iki şey düşer:

- **Roblox üst çubuğu:** 58 px (harness varsayımı, [DevForum](https://devforum.roblox.com/t/what-are-the-new-topbar-inset-dimensions/3237388)).
- **Kamera deliği veya çentik:** yatay ekranda bir kenardan düşer. ScreenGui'nin varsayılan `CoreUISafeInsets` ayarı hem üst çubuğu hem kamera kesiğini dışarıda bırakır ([ScreenGui.ScreenInsets](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#ScreenInsets)).

HUD bu yüzden kamera ekranını değil, kendi ScreenGui alanını (`AbsoluteSize`) okur (K0.4.4).

**Kötü durum** yoğunluklu hesaptır, çünkü o hesapta alan daha küçük çıkıyor: HD+ Redmi'de HUD'a **820 × 302 px** kalır.

## 3. Bizim en küçük yazımız bu alanda kaç piksel?

HUD'un kendi temel boyutları: kasa 23 px, sahiplik/kayıt/talep 16 px, stok 15 px, Satış/Sonuç/Kasiyer/Hedef 14 px. Yardım ve bildirim 15 px, teklif kartı 14–21 px. Telefonda panel ekrana sığmak için `UIScale` ile küçülür. Harness hesabı (H12):

| Ekran (HUD alanı) | K0.4.4 en küçük yazı | K0.4.5 en küçük yazı |
|---|---|---|
| Redmi HD+ yoğunlukla (820 × 302) | **11,1 px** | **12,4 px** |
| Redmi FHD+ yoğunlukla (873 × 335) | 12,5 px | 14,0 px |
| Redmi, tam 160 dpi (≥ 972 × 379) | 14,0 px | 14,0 px |
| Genel 18,5:9 Android (740 × 302) | 11,1 px | 12,3 px |
| Dar/eski 16:9 veya küçük telefon (568 × 262) | 8,9 px | 8,9 px (taban garanti edilmez) |

## 4. Bu kaç milimetre ve yeterli mi?

Fiziksel boy: 1 Roblox pikseli, HD+ Redmi'de yoğunluk varsayımıyla ~0,195 mm, FHD+'da ~0,177 mm, tam normalleştirmede ~0,159 mm. Değerler yazı boyutudur (em), büyük harf yüksekliği bunun ~%70'idir.

| Yazı | HD+ Redmi | FHD+ Redmi | Karşılaştırma |
|---|---|---|---|
| 11,1 px (K0.4.4) | 2,17 mm | 1,96 mm | Android'in en küçük **etiket** yazısı 11 sp; gövde yazısının altı |
| 12,4 px (K0.4.5) | 2,42 mm | 2,19 mm | Android'in en küçük **gövde** yazısı 12 sp ≈ bu telefonda 2,34 / 2,12 mm |
| 14 px | 2,74 mm | 2,48 mm | Android orta gövde yazısı 14 sp |
| 20 px | 3,91 mm | 3,54 mm | Roblox mühendisinin "iyi deneyim" alt sınırı |

Kılavuzlar:

- **Android (Material 3):** en küçük gövde yazısı `BodySmall` 12 sp, en küçük etiket `LabelSmall` 11 sp, olağan gövde 14 sp ([Material Components, Typography](https://github.com/material-components/material-components-android/blob/master/docs/theming/Typography.md)).
- **Apple:** iOS için varsayılan yazı 17 pt, en küçük yazı 11 pt ([Human Interface Guidelines, Typography](https://developer.apple.com/design/human-interface-guidelines/typography)). Apple aynı sayfada oyunlar için de bu alt sınırı gösteriyor.
- **Roblox:** yazı boyu için sayı vermiyor, yalnız "yazının okunmaz derecede küçülmesini önleyin" diyor ([Cross-platform development](https://create.roblox.com/docs/projects/cross-platform)). DevForum'daki mühendis açıklaması 20 px'i öneriyor.

**Cevap:**

- **K0.4.4: sınırda.** HD+ Redmi'de durum panelinin alt satırları 11 px'e iniyordu. Bu, Android'in etiket yazısı kadardır ama gövde metni için önerilen en küçük boyutun (12 sp) altındadır. FHD+ Redmi'de 12,5 px ile sınırın hemen üstündeydi.
- **K0.4.5: alt sınırı karşılıyor.** HUD'daki hiçbir yazı iki Redmi sınıfında da 12 px'in altına inmiyor. Bu Android'in kendi en küçük gövde yazısına eşit. **Ama rahat okuma değildir:** Roblox mühendisinin önerdiği 20 px'e yalnız kasa satırı yaklaşıyor (HD+'da 20,4 px). 14 px'lik satırlar 12,4 px'te kalıyor. Hangi boyutta durulacağı sahip kararıydı (AÇIK-15). **Karar (UK-19): 12 px yeterli, arayüz devasa olmasın.** Uygulaması §7.4'tedir.

## 5. K0.4.5'te ne değişti?

- **Yazı tabanı 12 px** (`TEXT_MIN`). K0.4.5'te başlangıç tahminiydi; K0.4.6'da proje sahibi kararı oldu (UK-19).
- **Başlık telefonda gizli.** "BAYCREST / K0 PAZAR" başlığı yalnız markadır; telefonda gizlenir ve satırlar 34 px yukarı kayar. Panelin boyu 334'ten 300 px'e iner, böylece daha az küçülür.
- **Panel yarı ekranı aşabiliyor.** Sağ sütunda yardım ve bildirim yazısı 12 px'in altına düşmediği sürece durum paneli ekranın yarısından geniş olabilir. Ekran ikisine birden yetmezse eski "yarı ekran" kuralına döner.
- **Konsol satırı.** HUD her yerleşimde bir satır yazar: `[K0 HUD] alan 820x302 telefon · panel 0.89 · en küçük yazı 12.4 px (taban 12)`. Harness bu satırın gördüğü ölçüden iyimser olmadığını denetler.
- **Harness H12** artık beş ekranda ölçüyor: PC, iki Redmi sınıfı, 740 × 360 ve 568 × 320. İki Redmi sınıfında ve 740 × 360'ta 12 px altı yazı düşürür. Üç bilinçli bozma denemesi yakalandı: eski K0.4.4 HUD, yalancı konsol satırı ve yarı ekran kuralına dönüş.

**Kapsam dışı kalan:** 16:9 ve daha dar eski telefonlarda (640 × 360 ve altı) taban tutmuyor. 640 × 360'ta hesap 10,1 px, 568 × 320'de 8,9 px. Buralarda yan yana iki sütun sığmıyor. Katlanır panel gibi bir çözüm tasarım işidir; K0'ın hedef cihazı Redmi olduğu için yapılmadı.

## 6. Cihazda nasıl cevaplanır?

Test sırasında şu sorular sorulur ve cevaplar [test kaydına](K0_TEST_RECORD_TEMPLATE.md) yazılır:

1. **Telefon modeli nedir?** Ayarlar → Telefon hakkında. Proje sahibinin telefonu: Redmi Note 13 Pro+ 5G; beklenen konsol satırı §7.5'te.
2. **Konsol satırı ne diyor?** Oyunda Roblox menüsü → Ayarlar → **Developer Console → Open** (veya sohbete `/console` yaz). Log sekmesinde `[K0 HUD] alan …` satırı bulunur ([Developer Console](https://create.roblox.com/docs/studio/developer-console)). Alan ve en küçük yazı değeri kayda geçer. Bu satır §2'deki iki tahminden hangisinin doğru olduğunu gösterir.
3. **Okunuyor mu?** Telefon normal tutuşta (yaklaşık 30–40 cm) tutulur. Şu satırların her biri için "rahat / zorlanarak / okunmuyor" yazılır: Kasa, Pazar kaydı süresi, Talep, stok, Satış/Ciro, Sonuç, Kasiyer, Hedef, yardım metni.
4. **Başparmak altında kalıyor mu?** Sol alttaki joystick kullanılırken hangi satırlar görünmez oluyor?
5. **Roblox yazı boyutu büyütülünce ne oluyor?** Roblox Ayarlar → **Text Size** (Metin boyutu) "Large" yapılır. Taşan veya kesilen yazı var mı? Roblox bu ayarı TextScaled olmayan her yazıya uygular ve kaç kat büyüttüğünü açıklamaz ([Accessibility guidelines](https://create.roblox.com/docs/production/publishing/accessibility), [duyuru](https://devforum.roblox.com/t/introducing-text-scaling-setting-studio-beta/3136967)). Harness'in "kutuya sığıyor" tahmini (H15) yalnız varsayılan boyut içindir. EKIP/06 §5 yazı boyutunun üç kademede test edilmesini ister; K0'da bu ayar o testin yerini tutar.

"Okunmuyor" cevabı çıkan satır olursa konu proje sahibine yeniden sunulur (UK-19). "Zorlanarak" cevabı kayda geçer.

## 7. Proje sahibinin telefonu: Redmi Note 13 Pro+ 5G (K0.4.6)

### 7.1 Ekran

| Özellik | Değer | Kaynak |
|---|---|---|
| Panel | 6,67" AMOLED, 120 Hz | [GSMArena](https://www.gsmarena.com/xiaomi_redmi_note_13_pro+-12572.php) |
| Çözünürlük | 1220 × 2712, 20:9, ~446 ppi | aynı |
| Fiziksel ekran (hesap) | ≈ 154,4 × 69,5 mm | 2712 / 446 ve 1220 / 446 inç |
| Kenarlar | Uzun kenarlar hafif kavisli (yatayda üst ve alt kenar) | [GSMArena incelemesi](https://www.gsmarena.com/xiaomi_redmi_note_13_pro_plus-review-2669p2.php) |
| Ön kamera | Dikeyde üst kenarın ortasında delik; yatayda sol veya sağ kenarın ortası | aynı |
| Yonga / bellek | Dimensity 7200-Ultra, 8–16 GB RAM | [GSMArena](https://www.gsmarena.com/xiaomi_redmi_note_13_pro+-12572.php) |

### 7.2 Roblox'un vereceği alan

Bu telefonun Android'deki varsayılan ölçeği resmî olarak yazılı değil. Aynı 1220 × 2712 paneli kullanan kardeş model Redmi Note 13 Pro 5G'de bir kullanıcı varsayılan "en küçük genişlik" değerini **406 dp** olarak bildiriyor ([xiaomi.eu](https://xiaomi.eu/community/threads/xiaomi-redmi-note-13-pro-5g-garnet-default-smallest-width-value.73114/)). Bu, 3,0 yoğunluğa denk gelir. Tek kullanıcı bildirimi olduğu için **varsayımdır**. İki sınır:

| Hesap | Roblox alanı (yatay) | HUD alanı (üst çubuk 58 px düşünce) | 1 Roblox pikseli |
|---|---|---|---|
| A · Android yoğunluğu 3,0 (varsayım) | 904 × 406 | 904 × 348 | 0,171 mm |
| B · Roblox'un ~160 dpi normalleştirmesi | 973 × 437 | 973 × 379 | 0,159 mm |

İki hesap bu telefonda birbirine yakın (%8). HD+ Redmi'lerde fark %20'yi geçiyordu (§2).

**Önemli sonuç:** Bu telefon, Redmi ailesinde 12 px'i **fiziksel olarak en küçük** gösteren telefondur. 12 px burada 1,9–2,05 mm'dir; HD+ Redmi'de 2,34 mm. Buna karşılık 446 ppi yüzünden harf ≈ 33–36 gerçek pikselle çizilir, HD+'da 24 pikselle. Yazı daha küçük ama daha keskindir. 12 px bu telefonda okunuyorsa diğer Redmi'lerde de okunur. Bu yüzden proje sahibinin testi kararın en sıkı sınamasıdır.

### 7.3 Yazı ve panel boyları

| Öğe | Roblox px | A (mm) | B (mm) |
|---|---|---|---|
| En küçük yazı (Sonuç, Kasiyer, Hedef, yardım) | 12 | 2,05 | 1,91 |
| Android'in en küçük gövde yazısı (12 sp) bu telefonda | 12 | 2,05 | — |
| Kasa satırı (23 × 0,857) | 19,7 | 3,37 | 3,13 |
| Durum paneli, K0.4.5 (ölçek 1) | 410 × 300 | 70 × 51 | 65 × 48 |
| **Durum paneli, K0.4.6 (ölçek 0,857)** | 351 × 257 | 60 × 44 | 56 × 41 |
| Teklif düğmesi, K0.4.6 | 111 × 53 | 19,0 × 9,1 | 17,7 × 8,4 |
| Material'in önerdiği en küçük dokunma hedefi (48 dp) | 48 | 8,2 | 7,6 |

### 7.4 K0.4.6'da ne değişti: "12 px yeterli, devasa olmasın"

K0.4.5 yalnız **alt sınır** koyuyordu: yazı 12 px'in altına inmesin. Büyük ekranda ise HUD tam boyda kalıyordu. Bu telefonda durum paneli HUD alanının %33–39'unu kaplıyordu, teklif kartı da ortada 440 × 236 px yer tutuyordu. Proje sahibi "12 px yeterli, görüntü devasa olmamalı" dedi. K0.4.6 bu yüzden 12 px'i telefonda **hedef** yapıyor. Her HUD parçası en küçük yazısı 12 px'e denk gelecek kadar ölçekleniyor, daha büyük değil:

| Parça | En küçük temel yazı | Telefondaki en büyük ölçek |
|---|---|---|
| Durum paneli | 14 px | 12 / 14 = 0,857 |
| Bildirim ve yardım | 15 px | 12 / 15 = 0,80 |
| Teklif kartı | 14 px | 12 / 14 = 0,857 |

Sonuç (harness H12, tahmin):

- **Yazı sırası korunuyor.** Hepsi aynı oranla küçüldüğü için kasa 19,7 px, sahiplik ve kayıt 13,7 px, stok 12,9 px, en küçük satırlar 12 px oluyor.
- **Daha çok pazar görünüyor.** Durum paneli bu telefonda HUD alanının %29'unu (A) veya %25'ini (B) kaplıyor; önceden %39 / %33'tü. Bildirim ve yardım kutuları %36, teklif kartı %27 daha az yer kaplıyor.
- **Düğmeler hâlâ büyük.** Teklif düğmeleri 111 × 53 px; EKIP/06'nın 44 px sınırının ve Material'in 48 dp önerisinin üstünde.
- **Kural basit.** HUD alanı yaklaşık **720 × 293 px** veya daha büyükse her parça tam 12 px'te durur. Bu telefonda alan bu sınırın 184 px genişlik ve 55 px yükseklik üstündedir (A). Bu pay, varsayımlardaki belirsizliği karşılar:
  - **Kamera deliği.** HUD'un `ScreenGui`'si varsayılan `CoreUISafeInsets` ayarıyla çalışır. Roblox belgesine göre bu alan kamera çentiğinden ve üst çubuktan uzak tutulur ([ScreenGui.ScreenInsets](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#ScreenInsets)). Delik alanı birkaç on piksel daraltsa da 12 px değişmez.
  - **Üst çubuğun gerçek yüksekliği.** 58 px'ten farklı olabilir. Yükseklik payı 55 px olduğu için sonuç değişmez.
  - **Android "Görüntü boyutu" ayarı.** Roblox Android yoğunluğunu izliyorsa (A), bu ayar büyütülünce alan küçülür. Kısa kenar 351 dp'nin altına inmedikçe HUD yine 12 px'te kalır.
- **Kavisli kenarlar.** Yatay tutuşta kavis üst ve alt kenardadır. Telefonda en alttaki HUD parçası (durum paneli ve teklif kartının alt kenarı) alttan en az 73 px (≈ 12 mm) yukarıdadır. Üstte ilk HUD satırı üst çubuğun altından başlar. Kavis HUD yazısına denk gelmez (hesap, cihazda görülmedi).
- **Daha büyük yazı isteyen oyuncu.** Roblox'un Text Size ayarı yazıyı büyütür (§6 soru 5). EKIP/06 §5'teki "büyük" ve "çok büyük" kademelerin K0'daki karşılığı budur. 12 px "normal" kademedir.
- **16:9 ve küçük telefonlar** (HUD alanı 720 × 293'ten küçük) değişmedi: 640 × 360'ta 10,1 px, 568 × 320'de 8,9 px. Bu ekranlar hedef dışıdır.

### 7.5 Bu telefonda test

Oyunda konsol açılınca (§6 soru 2) beklenen satır şudur:

```text
[K0 HUD] alan 904x348 telefon · panel 0.86 · en küçük yazı 12.0 px (taban 12)    ← A doğruysa
[K0 HUD] alan 973x379 telefon · panel 0.86 · en küçük yazı 12.0 px (taban 12)    ← B doğruysa
```

Kamera deliği HUD alanından düşülüyorsa genişlik biraz daha küçük çıkar. `panel 0.86` ve `12.0 px` yine aynı kalmalıdır. Farklı bir değer, hesabın bu telefonda tutmadığını gösterir ve test kaydına yazılır.

**Performans notu:** Bu telefon Redmi ailesinin üst orta sınıfındadır (Dimensity 7200-Ultra, 8–16 GB RAM, 120 Hz). Burada ölçülen FPS ve bellek, HD+ Redmi'leri (13C, 14C, A5) temsil etmez. Performans bütçesi `KARARLAR.md` AÇIK-05 olarak açık kalır.

## 8. Kaynaklar

Kontrol tarihi: 27 Eylül 2026.

- Roblox mühendisinin ölçekleme açıklaması (Roblox pikseli ≈ dp, ~160 dpi, TextSize 20 ≈ 1/8 inç): [DevForum #95626/15](https://devforum.roblox.com/t/ui-is-really-really-really-weird-on-mobile/95626/15), alıntılayan konu [3888004](https://devforum.roblox.com/t/specific-details-about-ui-scaling-best-practices/3888004)
- Eski bir Android örneği: 1080 × 1920 Nexus 5'te 640 × 360: [DevForum 28049](https://devforum.roblox.com/t/phone-resolution-smaller-in-roblox/28049)
- `ScreenInsets` ve güvenli alan: [ScreenGui](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#ScreenInsets), [ScreenInsets](https://create.roblox.com/docs/reference/engine/enums/ScreenInsets)
- Fiziksel ekran sınıfı (`GuiService.ViewportDisplaySize`, telefonlar "Small"): [DevForum duyurusu](https://devforum.roblox.com/t/full-release-build-cross-platform-ui-with-the-viewportdisplaysize-api/3880384)
- Yazı boyutu ayarı (`GuiService.PreferredTextSize`): [Accessibility guidelines](https://create.roblox.com/docs/production/publishing/accessibility), [Can I Play That?](https://caniplaythat.com/2025/08/27/roblox-introduces-global-text-size-accessibility-setting/)
- Material 3 yazı ölçeği: [material-components-android Typography](https://github.com/material-components/material-components-android/blob/master/docs/theming/Typography.md)
- Apple yazı boyutları: [Human Interface Guidelines, Typography](https://developer.apple.com/design/human-interface-guidelines/typography)
- Redmi Note 13 Pro+ 5G: [GSMArena özellikler](https://www.gsmarena.com/xiaomi_redmi_note_13_pro+-12572.php), [GSMArena incelemesi (kavis, kamera deliği)](https://www.gsmarena.com/xiaomi_redmi_note_13_pro_plus-review-2669p2.php); kardeş model Note 13 Pro 5G varsayılan en küçük genişlik 406 dp (kullanıcı bildirimi): [xiaomi.eu](https://xiaomi.eu/community/threads/xiaomi-redmi-note-13-pro-5g-garnet-default-smallest-width-value.73114/)
- Redmi ekranları: [GSMArena Redmi 14C / A5](https://www.gsmarena.com/compare.php3?idPhone1=13737&idPhone2=13291), [GSMArena Note 14 4G / 14C](https://www.gsmarena.com/compare.php3?idPhone1=13616&idPhone2=13291), [Wikipedia Redmi 13C](https://en.wikipedia.org/wiki/Redmi_13C)
- Zıplama düğmesi ve joystick alanı (K0.4.4): [PlayerModule TouchJump](https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/scripts/PlayerScripts/StarterPlayerScripts/PlayerModule.module/ControlModule/TouchJump.lua), [DynamicThumbstick](https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/scripts/PlayerScripts/StarterPlayerScripts/PlayerModule.module/ControlModule/DynamicThumbstick.lua)
