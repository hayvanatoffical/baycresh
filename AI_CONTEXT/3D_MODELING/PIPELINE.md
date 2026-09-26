# 3D varlık üretim hattı

**Yetki:** [EKIP/05](../../EKIP/05-HARITA-SANAT-ANIMASYON.md) ve [KARARLAR.md](../../KARARLAR.md) kararlarını uygular. Teknik ayrıntı [TECHNICAL_STANDARD.md](TECHNICAL_STANDARD.md), kalite kapısı [QA_CHECKLIST.md](QA_CHECKLIST.md) içindedir. Bu dosya yeni görsel yön belirlemez.

## Varlık yaşam döngüsü

| Aşama | Çıktı | Geçiş koşulu |
|---|---|---|
| 0. İstek | Asset kimliği, katman, oynanış amacı | `DESIGN_DRAFTS/3D/ASSET_REGISTER.md` satırı |
| 1. Brief | Boyut/arayüz, referans, yasaklar, kabul ölçütü | Belirsiz ölçüler `TBD` ve nasıl ölçüleceği yazılmış |
| 2. Gri kutu | Studio'da temel hacim ve oyuncu/NPC akışı | Oynanış, geçiş, görüş ve etkileşim alanları çalışıyor |
| 3. Sanat adayı | Modüler model, malzeme, renk | Siluet ve `05` paletiyle uyumlu; oyun kuralı değişmiyor |
| 4. Teknik aday | Export/import, pivot, çarpışma, dosya/asset kimlikleri | [TECHNICAL_STANDARD.md](TECHNICAL_STANDARD.md) kontrolleri geçti |
| 5. İnceleme | Görsel ve cihaz testi, kaynak hakkı | İkinci kişi QA listesine göre onayladı |
| 6. Entegrasyon | Doğru place'e konmuş, kayıtlı varlık | `PRODUCTION/ASSET_PROVENANCE.md` ve register güncellendi |

`TASLAK → GRİ KUTU → ADAY → ONAYLI → STUDIO'DA → DOĞRULANDI` statüleri sırayla kullanılır. Render veya prompt çıktısı doğrudan `ONAYLI` değildir.

## Brief için zorunlu bilgi

Kimlik, kullanılacağı katman, sahip/inceleyen, kaynak karar, tek cümlelik işlev, oyuncunun temas ettiği yüzeyler, standart modül arayüzü, ölçek, okunabilirlik mesafesi, deformasyon/animasyon ihtiyacı, çarpışma, doku/malzeme, kaynak hakkı ve test koşulları. [ASSET_BRIEF_TEMPLATE.md](ASSET_BRIEF_TEMPLATE.md) kopyalanır.

## Baycrest'e özgü kurallar

- Dört stud ızgara, parçaların montajını belirler; **tezgâh ve cephelerin kesin boyutları** gri kutu ile doğrulanır. Ölçülmemiş boyutu tasarıma zorla sabitleme.
- Aynı yuva sınıfında kapı, vitrin ve tabela arayüzü özdeş kalır. Dış görünüm değişebilir; oyuncu kapasitesi değişmez.
- Oyuncu tarafından görülecek tabela alanına serbest metin veya gerçek marka gömülmez; UI/şablon sistemi bağlanır.
- Tanık sisteminde plaka ve kıyafet ayırt edilebilirliği oynanış ölçütüdür. Yalnız yakın plan render ile değerlendirme yapılmaz.
- Yaralanma ve polis/kurum varlıkları kan, gore, gerçek amblem veya gerçekçi yüksek şiddet çağrışımı taşımaz.
- K0 dekoru, satış döngüsünü ve 20 dakikalık testi geciktirecek düzeye genişletilmez.

## AI üretimi için kural

AI mesh/malzeme üretebilir; tasarım brief'i ve kabul ölçütü insana aittir. Prompt'ta amaç, ölçek bağlamı, stil paleti, yasaklar ve teslim biçimi açık yazılır. Çıktı Studio'ya eklenmeden önce topoloji, çarpışma, içerik, marka ve kaynak hakları incelenir. AI üretim prompt'u ile son kullanılan varlık ayrı kaydedilir. Sağlayıcı/model/plan, girdi hakkı, ticari kullanım, atıf, yeniden dağıtım ve provenance kontrolü [AI varlık hakları standardına](../../PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md) göre yapılır; “ücretsiz plan” tek başına kullanım hakkı kanıtı değildir.

## Teslim paketi

`brief.md` + kaynak model dosyası + export + Studio varlık/nesne yolu + önden/yan/oyun kamerasından görüntü + QA sonucu + kaynak/lisans kaydı. Henüz üretilmemiş dosya veya asset ID için yer tutucu kullan; sahte kanıt yazma.

