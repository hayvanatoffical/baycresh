# BAYCREST — Sözlük ve İsimlendirme

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** 3.0 tasarım terimleri için kanonik referans.
**Okuyucu:** Herkes. Referans belgesidir, baştan sona okunmaz.

Ekip Türkçe konuşur, oyun İngilizce yazar. Bu belge ikisini bağlar. Bir şeye isim verirken önce buraya bakın: tutarsız isimlendirme, yapay zekâya iş yaptırırken en çok zaman kaybettiren şeydir.

---

## 1. Yer adları

| Türkçe konuşurken | Oyunda yazılan | Ne |
|---|---|---|
| Ülke | **Verania** | Kurgusal ülke |
| Şehir | **Baycrest** | Oyunun geçtiği şehir |
| Merkez | **Blackstone** | Şehir merkezi, meydan, kurumlar |
| Çarşı | **Blackstone Bazaar** | Tezgâhlar, ilk sahiplik, güvenli bölge |
| Pasaj | **Blackstone Arcade** | Bina içi işletme birimleri |
| Sanayi mahallesi | **Ironhill** | Dar yokuşlu, standart cepheler, kovalamaca |
| Liman | **Oldport** | Suç ekonomisi, depolar, sanayi yuvaları |
| Kurum bölgesi | **Wrenmoor** | Cezaevi |
| Birinci köy | **Alderbrook** | Çiftçilik |
| İkinci köy | **Willowfield** | Sakin oyun |
| Orman | **Northwood** | Kaçış, av |
| Dağ | **Marlowe Ridge** | Arazi sürüşü |
| Vadi | **Deepvale** | Manzara |

## 2. Kurumlar

| Türkçe | Oyunda | Kısaltma |
|---|---|---|
| Şehir polisi | Baycrest Metropolitan Police | **BMP** |
| Kırsal kolluk | Verania Rural Guard | **VRG** |
| Mali suç birimi | Financial Crimes Unit | **FCU** |
| Mahkeme | Baycrest Courthouse | — |
| Cezaevi | Wrenmoor Correctional Facility | — |
| Hastane | Verania General Hospital | — |
| Ruhsat ofisi | Civic Licensing Office | — |
| Acil çağrı | 118 | — |

## 3. Zaman birimleri

Bu ayrım kritiktir. Tek bir "ay" kelimesi üç farklı saati karıştırıyordu.

| Türkçe | İngilizce | Kod adı | Süre |
|---|---|---|---|
| Oyun günü | Game day | `OyunGunu` | 48 gerçek dakika |
| Üretim günü | Production day | `UretimGunu` | İşletmenin 48 dk üretim süresi |
| Gerçek gün | Real day | `GercekGun` | 24 saat |
| İnfaz süresi | Sentence time | `InfazSaniye` | Gerçek saniye |
| Çevrimdışı pencere | Offline window | `CevrimdisiPencere` | 8 saat |

## 4. Sistem terimleri

| Türkçe | İngilizce | Kod adı |
|---|---|---|
| Çanta | Bag | `Canta` |
| Birim | Unit | `Birim` |
| Gizleme | Concealment | `Gizleme` |
| Şişkinlik | Bulge | `Siskinlik` |
| Şüphe (yumuşak) | Suspicion | `Suphe` |
| Aranma (sert) | Wanted level | `Aranma` |
| Şehir alarm seviyesi | City alert level | `SehirAlarm` |
| Tanık | Witness | `Tanik` |
| Robot resim | Sketch | `RobotResim` |
| Kirli nakit | Dirty cash | `KirliNakit` |
| Aklama | Laundering | `Aklama` |
| Aklama kotası | Laundering quota | `AklamaKotasi` |
| Tutarsızlık | Discrepancy | `Tutarsizlik` |
| Denetim | Audit | `Denetim` |
| Yuva | Slot | `Yuva` |
| Cephe | Storefront | `Cephe` |
| Tezgâh | Market stall | `Tezgah` |
| Tercihli adres | Preferred address | `TercihliAdres` |
| Uzaktan hizmet | Remote operation | `UzaktanHizmet` |
| Şirket rehberi | Business directory | `Rehber` |
| Uyku | Dormancy | `Uykuda` |
| Dondurma | Freeze mode | `Donduruldu` |
| Olay kutusu | Event inbox | `OlayKutusu` |
| Tahsilat | Collected earnings | `Tahsilat` |
| Ruh hali | Morale | `RuhHali` |
| Ruhsat | License / permit | `Ruhsat` |
| İtibar | Reputation | `Itibar` |
| Dönüş özeti | Return summary | `DonusOzeti` |

## 5. Adalet terimleri

| Türkçe | İngilizce | Kod adı |
|---|---|---|
| Anayasa | Constitution | `Anayasa` |
| Suç kodu | Offence code | `SucKodu` |
| Delil | Evidence | `Delil` |
| Delil gücü | Evidence weight | `DelilGucu` |
| Dosya | Case file | `Dosya` / `caseId` |
| Duruşma | Hearing | `Durusma` |
| Karar | Verdict | `Karar` / `verdictId` |
| Beraat | Acquittal | `Beraat` |
| Mahkûmiyet | Conviction | `Mahkumiyet` |
| İkrar | Guilty plea | `Ikrar` |
| İnfaz | Sentence execution | `Infaz` |
| Gözaltı | Detention | `Gozalti` |
| Koşullu tahliye | Parole | `KosulluTahliye` |
| İtiraz | Appeal | `Itiraz` |
| Kaçış | Escape | `Kacis` |
| Kaçak | Fugitive | `Kacak` |
| Kaçış raporu | Escape report | `KacisRaporu` |
| NPC temsilci | Public defender | `Temsilci` |
| Yetki puanı | Authority score | `YetkiPuani` |

## 6. Sağlık ve çatışma terimleri

| Türkçe | İngilizce | Kod adı |
|---|---|---|
| Yaralı durumu | Downed state | `Yarali` |
| İlk yardım | First aid | `IlkYardim` |
| Hastane | Hospital | `Hastane` |
| Sağlık ekibi | Medic | `SaglikEkibi` |
| Meşru bağlam | Valid context | `MesruBaglam` |
| Meşru müdafaa | Self-defence | `MesruMudafaa` |
| Güvenli bölge | Safe zone | `GuvenliBolge` |
| Yeni oyuncu koruması | New player protection | `YeniOyuncuKorumasi` |
| Elektroşok | Taser | `Elektrosok` |

**Kural:** Değişken ve fonksiyon adları Türkçe, sınıf ve servis adları da Türkçedir (`AdaletServisi`, `EnvanterServisi`). Roblox API adları İngilizce kalır. Hiçbir yerde Türkçe karakter kullanılmaz (ı, ş, ğ, ü, ö, ç).

## 7. Para

**Crown (₡)**. Kod içinde `Crown`, arayüzde `₡`.

Kirli nakit ayrı bir para birimi değildir; izlenen bir Crown türüdür ve `KirliNakit` olarak tutulur.

Türkçe konuşurken "kron" denebilir. Belgelerde "₡" veya "Crown".

## 8. Varlık isimlendirme

```
Bolge_Kategori_Ad_Varyant
```

| Kategori | Ne için |
|---|---|
| `Bina` | Yapılar |
| `Yuva` | İşletme yuvaları (tezgâh, cephe, pasaj, sanayi) |
| `Prop` | Sokak eşyası, dekor |
| `Arac` | Araçlar |
| `Ic` | İç mekân parçaları |
| `Anim` | Animasyonlar |
| `UI` | Arayüz öğeleri |
| `Kiyafet` | RP kıyafet setleri |

Varlık her yerde kullanılıyorsa bölge yerine `Ortak` yazılır.

**Örnekler:**

```
Blackstone_Bina_Apartman_03
Bazaar_Yuva_Tezgah_07
Ironhill_Yuva_StandartCephe_07
Wrenmoor_Bina_Hucre_01
Oldport_Prop_Konteyner_02
Ortak_Arac_DorukSedan_01
Ortak_Anim_CantaGoster_01
Ortak_Anim_YaraliCokme_01
Ortak_Kiyafet_Saglik_01
Ortak_UI_EnvanterSiluet
```

## 9. Sokak adları

Kural: **sıfat + nesne** veya **meslek + sokak tipi.** İngilizce, okunabilir, kısa.

Kullanılabilir sokak tipleri: Street, Lane, Road, Row, Way, Alley, Quay.

Örnek havuz: Harbour Lane, Old Mill Street, Tanner's Row, Anchor Way, Quarry Road, Salt Street, Cooper's Alley, Kiln Road, Net Quay, Forge Lane.

Tanık tarifleri bu adları kullanır, o yüzden telaffuzu kolay olmalıdır.

## 10. Araç markaları

Bunlar kurgusal marka adlarıdır ve Türkçe kalır; Türkçe karakter içermez.

| Marka | Tip |
|---|---|
| **Doruk** | Sedan, hatchback |
| **Ova Motors** | Kamyonet, minibüs |
| **Siper** | Polis, ambulans, itfaiye, resmî |
| **Egemen** | Spor, lüks |

> **Sürüm 3.0 değişikliği:** "Anadol" ve "Kartal" kaldırıldı. İkisi de gerçek Türk otomotiv adlarıyla çakışıyordu ve §12'deki kendi kuralımızı ihlal ediyordu (ORTAK-032).

Plaka formatı: `BC 42 VRN`

## 11. Eşya sınıfları

| Sınıf | Kod adı | Birim | Nereye girer |
|---|---|---|---|
| Temel | `Temel` | 0 | Her zaman yanında (kimlik, cüzdan, anahtarlık, ruhsat) |
| Küçük | `Kucuk` | 1 | Cep, çanta, bagaj |
| Orta | `Orta` | 2 | Cep (birini doldurur), çanta, bagaj |
| Büyük | `Buyuk` | 4 | Yalnız çanta veya bagaj |
| Uzun | `Uzun` | — | Yalnız sırt veya bagaj |

Nakit: cüzdan 2.500 ₡'ye kadar yer tutmaz; sonra her başlayan 5.000 ₡ için 1 birim.

## 12. Yasak isimler

Aşağıdakiler hiçbir yerde kullanılmaz: ne varlık adında, ne metinde, ne tabelada.

- Gerçek şehir, ülke ve il adları
- Tanınmış gerçek marka, mağaza zinciri ve ürün adları
- Gerçek polis teşkilatı, kurum ve bakanlık adları
- Gerçek kişi adları, siyasetçiler, ünlüler
- Gerçek araç markaları ve model adları

**Yeni ad koyma süreci:** Önerilen adı bir arama motorunda ve bir marka veritabanında ara. Tanınmış bir marka, kurum veya ürünle çakışıyorsa kullanma. Sonucu `KARARLAR.md` AÇIK-02'ye yaz.

## 13. Karar kimlikleri

Paketteki bütün kararlar `KARARLAR.md`'de izlenir.

| Önek | Anlamı |
|---|---|
| `UK-` | Kullanıcı kararı |
| `ORTAK-` | Ortak karar listesi maddesi |
| `AÇIK-` | Açık konu |
| `V-A` | Anayasa maddesi |
| `S-` | Suç kodu |
| `IS-` | İşletme kataloğu kodu |
| `MS-` | Meslek kataloğu kodu |
| `BC-`, `TY-`, `YF-` | Değerlendirme B'nin kimlikleri (arşiv) |
| `MIM-`, `EKO-`, `SUC-`, `ENV-`, `NPC-`, `TEK-`, `OYN-`, `UX-`, `PLT-`, `SUR-`, `BLG-`, `YNI-` | Değerlendirme A'nın kimlikleri |

## 14. Belge adlandırma

```
NN-KONU-BASLIK.md
```

Ekip belgeleri `EKIP/`, özel belgeler `OZEL/`, arşiv `OZEL/ARSIV/` klasöründedir. Karar kaydı kök dizindedir. Her kanonik belgenin başlığını sürüm ve tarih izler. `AI_CONTEXT/` kanonik belgelerden türetilmiş çalışma bağlamıdır; `DESIGN_DRAFTS/` onay bekleyen üretim taslaklarını içerir. Sürüm ve değişiklik kuralları `DOKUMAN-YONETIMI.md` içindedir.
