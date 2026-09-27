# K0 — Telefonda ekran ve yazı boyutu: "okunuyor mu?"

**Durum:** Araştırma ve hesap · K0.4.5 · 27 Eylül 2026 · **cihazda ölçülmedi**
**Kapsam:** K0 pazar HUD'u, Redmi telefon (proje sahibinin cihazı), yatay ekran

K0.4.4 test planında "durum panelindeki yazılar telefonda okunuyor mu?" diye açık uçlu bir soru vardı. Bu belge soruyu ölçülebilir parçalara ayırıyor. Her parça web kaynağıyla ve hesapla cevaplanıyor. Sonunda cihazda neyin, nasıl kontrol edileceği yazıyor. Buradaki sayılar **hesaptır**. Kesin cevap, telefondaki konsol satırı ve oyuncunun gözüdür (§6).

## 1. Telefonun ekranı kaç piksel?

Proje sahibinin telefonu bir Redmi, ama modeli kayıtlı değil. Güncel Redmi'ler ekran bakımından iki sınıfa ayrılıyor:

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
- **K0.4.5: alt sınırı karşılıyor.** HUD'daki hiçbir yazı iki Redmi sınıfında da 12 px'in altına inmiyor. Bu Android'in kendi en küçük gövde yazısına eşit. **Ama rahat okuma değildir:** Roblox mühendisinin önerdiği 20 px'e yalnız kasa satırı yaklaşıyor (HD+'da 20,4 px). 14 px'lik satırlar 12,4 px'te kalıyor. Hangi boyutta durulacağı sahip kararıdır: `KARARLAR.md` AÇIK-15.

## 5. K0.4.5'te ne değişti?

- **Yazı tabanı 12 px** (`TEXT_MIN`). Başlangıç tahminidir, AÇIK-15 kapanana kadar geçerli.
- **Başlık telefonda gizli.** "BAYCREST / K0 PAZAR" başlığı yalnız markadır; telefonda gizlenir ve satırlar 34 px yukarı kayar. Panelin boyu 334'ten 300 px'e iner, böylece daha az küçülür.
- **Panel yarı ekranı aşabiliyor.** Sağ sütunda yardım ve bildirim yazısı 12 px'in altına düşmediği sürece durum paneli ekranın yarısından geniş olabilir. Ekran ikisine birden yetmezse eski "yarı ekran" kuralına döner.
- **Konsol satırı.** HUD her yerleşimde bir satır yazar: `[K0 HUD] alan 820x302 telefon · panel 0.89 · en küçük yazı 12.4 px (taban 12)`. Harness bu satırın gördüğü ölçüden iyimser olmadığını denetler.
- **Harness H12** artık beş ekranda ölçüyor: PC, iki Redmi sınıfı, 740 × 360 ve 568 × 320. İki Redmi sınıfında ve 740 × 360'ta 12 px altı yazı düşürür. Üç bilinçli bozma denemesi yakalandı: eski K0.4.4 HUD, yalancı konsol satırı ve yarı ekran kuralına dönüş.

**Kapsam dışı kalan:** 16:9 ve daha dar eski telefonlarda (640 × 360 ve altı) taban tutmuyor. 640 × 360'ta hesap 10,1 px, 568 × 320'de 8,9 px. Buralarda yan yana iki sütun sığmıyor. Katlanır panel gibi bir çözüm tasarım işidir; K0'ın hedef cihazı Redmi olduğu için yapılmadı.

## 6. Cihazda nasıl cevaplanır?

Test sırasında şu sorular sorulur ve cevaplar [test kaydına](K0_TEST_RECORD_TEMPLATE.md) yazılır:

1. **Telefon modeli nedir?** Ayarlar → Telefon hakkında.
2. **Konsol satırı ne diyor?** Oyunda Roblox menüsü → Ayarlar → **Developer Console → Open** (veya sohbete `/console` yaz). Log sekmesinde `[K0 HUD] alan …` satırı bulunur ([Developer Console](https://create.roblox.com/docs/studio/developer-console)). Alan ve en küçük yazı değeri kayda geçer. Bu satır §2'deki iki tahminden hangisinin doğru olduğunu gösterir.
3. **Okunuyor mu?** Telefon normal tutuşta (yaklaşık 30–40 cm) tutulur. Şu satırların her biri için "rahat / zorlanarak / okunmuyor" yazılır: Kasa, Pazar kaydı süresi, Talep, stok, Satış/Ciro, Sonuç, Kasiyer, Hedef, yardım metni.
4. **Başparmak altında kalıyor mu?** Sol alttaki joystick kullanılırken hangi satırlar görünmez oluyor?
5. **Roblox yazı boyutu büyütülünce ne oluyor?** Roblox Ayarlar → **Text Size** (Metin boyutu) "Large" yapılır. Taşan veya kesilen yazı var mı? Roblox bu ayarı TextScaled olmayan her yazıya uygular ve kaç kat büyüttüğünü açıklamaz ([Accessibility guidelines](https://create.roblox.com/docs/production/publishing/accessibility), [duyuru](https://devforum.roblox.com/t/introducing-text-scaling-setting-studio-beta/3136967)). Harness'in "kutuya sığıyor" tahmini (H15) yalnız varsayılan boyut içindir. EKIP/06 §5 yazı boyutunun üç kademede test edilmesini ister; K0'da bu ayar o testin yerini tutar.

"Zorlanarak" veya "okunmuyor" cevabı çıkan satır, AÇIK-15'in 14 px veya telefonda sadeleştirilmiş panel seçeneğine kanıt olur.

## 7. Kaynaklar

Kontrol tarihi: 27 Eylül 2026.

- Roblox mühendisinin ölçekleme açıklaması (Roblox pikseli ≈ dp, ~160 dpi, TextSize 20 ≈ 1/8 inç): [DevForum #95626/15](https://devforum.roblox.com/t/ui-is-really-really-really-weird-on-mobile/95626/15), alıntılayan konu [3888004](https://devforum.roblox.com/t/specific-details-about-ui-scaling-best-practices/3888004)
- Eski bir Android örneği: 1080 × 1920 Nexus 5'te 640 × 360: [DevForum 28049](https://devforum.roblox.com/t/phone-resolution-smaller-in-roblox/28049)
- `ScreenInsets` ve güvenli alan: [ScreenGui](https://create.roblox.com/docs/reference/engine/classes/ScreenGui#ScreenInsets), [ScreenInsets](https://create.roblox.com/docs/reference/engine/enums/ScreenInsets)
- Fiziksel ekran sınıfı (`GuiService.ViewportDisplaySize`, telefonlar "Small"): [DevForum duyurusu](https://devforum.roblox.com/t/full-release-build-cross-platform-ui-with-the-viewportdisplaysize-api/3880384)
- Yazı boyutu ayarı (`GuiService.PreferredTextSize`): [Accessibility guidelines](https://create.roblox.com/docs/production/publishing/accessibility), [Can I Play That?](https://caniplaythat.com/2025/08/27/roblox-introduces-global-text-size-accessibility-setting/)
- Material 3 yazı ölçeği: [material-components-android Typography](https://github.com/material-components/material-components-android/blob/master/docs/theming/Typography.md)
- Apple yazı boyutları: [Human Interface Guidelines, Typography](https://developer.apple.com/design/human-interface-guidelines/typography)
- Redmi ekranları: [GSMArena Redmi 14C / A5](https://www.gsmarena.com/compare.php3?idPhone1=13737&idPhone2=13291), [GSMArena Note 14 4G / 14C](https://www.gsmarena.com/compare.php3?idPhone1=13616&idPhone2=13291), [Wikipedia Redmi 13C](https://en.wikipedia.org/wiki/Redmi_13C)
- Zıplama düğmesi ve joystick alanı (K0.4.4): [PlayerModule TouchJump](https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/scripts/PlayerScripts/StarterPlayerScripts/PlayerModule.module/ControlModule/TouchJump.lua), [DynamicThumbstick](https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/scripts/PlayerScripts/StarterPlayerScripts/PlayerModule.module/ControlModule/DynamicThumbstick.lua)
