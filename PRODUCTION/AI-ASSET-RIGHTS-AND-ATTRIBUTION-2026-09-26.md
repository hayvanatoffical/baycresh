# BAYCREST — AI varlık hakları, lisans ve atıf kontrolü

**Kontrol tarihi:** 26 Eylül 2026  
**Durum:** Üretim standardı / yayın öncesi yeniden doğrulanır.  
**Amaç:** AI ile üretilen görsel, mesh, animasyon, ses ve kodun “ücretsiz üretildi = otomatik olarak serbest” varsayımıyla projeye girmesini önlemek.

Bu belge hukuki görüş değildir. Sağlayıcı koşulları ve Roblox kuralları değişebileceği için **her yayın adayı varlıkta o günkü resmî koşul tekrar açılır ve `ASSET_PROVENANCE.md` satırına kanıt eklenir.**

Araç bazlı 26 Eylül çalışma matrisi: [`AI_TOOL_LICENSE_MATRIX_2026-09-26.md`](AI_TOOL_LICENSE_MATRIX_2026-09-26.md). Matris kolay seçim içindir; bu belgedeki altı kapının yerine geçmez.

## 1. Baycrest için zorunlu kabul kapısı

Bir AI çıktısı aşağıdaki altı alan dolmadan `YAYIN ADAYI` olamaz:

1. **Girdi hakkı:** Prompta yüklenen görsel, ses, logo, model veya metni kullanma hakkımız var mı?
2. **Çıktı hakkı:** Kullanılan sağlayıcının o plan/model için ticari kullanıma izin veren güncel koşulu kaydedildi mi?
3. **Atıf:** Sağlayıcı veya kaynak varlık açık atıf istiyor mu? İstiyorsa nerede gösterilecek?
4. **Yeniden dağıtım:** Çıktıyı yalnız oyunda kullanmak ile kaynak dosya/Creator Store ürünü olarak yeniden dağıtmak arasında farklı kural var mı?
5. **Roblox uygunluğu:** İçerik Community Standards, moderasyon ve gerekli Content Maturity beyanları açısından uygun mu?
6. **Köken kanıtı:** Sağlayıcı, model/araç, tarih, prompt sürümü, insan düzenlemesi, asset ID ve kaynak URL kayda girdi mi?

Eksik bir alan `DOĞRULANMADI` demektir. Prototipte referans olarak tutulabilir; yayın varlığı sayılmaz.

## 2. OpenAI ile üretilen Baycrest konsept görselleri

26 Eylül 2026'da kontrol edilen OpenAI Kullanım Şartları, kullanıcı ile OpenAI arasındaki ilişki bakımından girdideki hakların kullanıcıda kaldığını ve izin verilen ölçüde çıktının kullanıcıya ait olduğunu belirtir. Aynı şartlar, girdiyi kullanmak için gerekli hak ve izinlere sahip olma sorumluluğunu kullanıcıya bırakır; AI çıktılarının benzersiz olmayabileceğini de açıklar.

**Baycrest sonucu:** OpenAI ile proje için üretilen özgün konsept görselinde ayrıca “OpenAI'ye telif atfı yazmak” şeklinde genel bir şart bu kontrolde görülmedi. Bu, üçüncü kişilerin fikrî mülkiyet veya kişilik haklarını ortadan kaldırmaz. Referans girdisinin hakkı belirsizse çıktı otomatik olarak güvenli kabul edilmez.

Ek olarak güncel OpenAI hizmet şartlarında görsel/video yetenekleriyle gerçek bir kişinin benzerliğini üretmek için gerekli izin ve hakların bulunması gerektiği belirtilir. Baycrest karakter tasarımında gerçek kişi fotoğrafı kullanılacaksa proje sahibi bunu ayrıca doğrular.

**Resmî kaynaklar:**
- https://openai.com/policies/row-terms-of-use/
- https://openai.com/policies/service-terms/

## 3. Roblox'un kendi AI özellikleriyle üretilen içerik

26 Eylül 2026'da kontrol edilen Roblox Terms of Use, AI Features için kullanıcı ile Roblox arasındaki ilişki bakımından kullanıcının Prompt ve Output üzerindeki mevcut haklarını koruduğunu belirtir; aynı bölüm Roblox'a hizmeti işletme/geliştirme amaçları için geniş bir lisans verir. Koşullar ayrıca AI çıktısındaki provenance/metadata etiketlerinin kaldırılmamasını ister.

Roblox Creator Hub, Roblox AI araçlarıyla yapılan üretimlerin de normal moderasyon ve Community Standards kapsamından geçtiğini; yaratıcı olarak nihai içerikten sorumlu olduğumuzu belirtir.

**Baycrest sonucu:** Studio AI mesh/model çıktısı “Roblox üretti, lisans düşünmeye gerek yok” diye işaretlenmez. Prompt girdisinin hakkı, çıktı asset ID'si, moderasyon durumu ve varsa provenance bilgisi kaydedilir. Yayın adayı olduğunda güncel Roblox koşulu tekrar kontrol edilir.

**Resmî kaynaklar:**
- https://en.help.roblox.com/hc/en-us/articles/115004647846-Roblox-Terms-of-Use
- https://create.roblox.com/docs/ai/accelerated-workflows
- https://create.roblox.com/docs/generative-AI

## 4. Creator Store varlıkları

Creator Store Terms, Store'dan alınan bir varlık için Roblox Studio ve Roblox deneyimlerinde kullanım lisansı verildiğini belirtir. Bu lisans “varlığı dilediğin yerde yeniden satabilirsin” anlamına gelmez. Creator Hub ayrıca başka birinin Restricted varlığını içeren kompozit modeli Creator Store'da yeniden dağıtma/satma konusunda sınırlamalar bulunduğunu açıklar.

**Baycrest kuralı:** Her Creator Store varlığında en az şunlar saklanır:

- yaratıcı adı ve asset ID,
- Creator Store bağlantısı,
- alındığı tarih,
- o gün görülen lisans/erişim durumu,
- Restricted / paylaşım durumu,
- model içindeki Script/LocalScript/ModuleScript denetimi,
- oyunda kullanıldığı Explorer yolu.

Kaynak bağlantısı kaybolursa veya hak durumu anlaşılamazsa varlık yayından çıkarılır ya da proje içi varlıkla değiştirilir.

**Resmî kaynaklar:**
- https://en.help.roblox.com/hc/en-us/articles/21308223046932-Creator-Store-Terms
- https://create.roblox.com/docs/production/creator-store

## 5. Oyuncunun oyun içinde AI ile etkileşmesi başka bir durumdur

Baycrest bugün AI'yi **üretim aracı** olarak kullanıyor; K0 prototipinde oyuncuya açık üretken AI özelliği yoktur. İleride oyuncu metin, ses, görüntü, 3D veya avatar hareketi ile bir üretken modeli tetiklerse Roblox bunun için ayrı şeffaflık ve Content Maturity yükümlülükleri tanımlıyor. Böyle bir özellik eklenirse bu belge yeterli sayılmaz; yayın akışı yeniden incelenir.

26 Eylül 2026 Creator Hub dokümanında oyuncunun üretken AI modeliyle etkileştiği deneyimlerde AI olduğuna dair görünür açıklama ve ilgili Content Maturity sorularının doğru yanıtlanması isteniyor. Genişletilmiş AI etkileşimleri daha ağır yaş/kategori sonuçları doğurabilir.

**Resmî kaynak:** https://create.roblox.com/docs/generative-AI

## 6. Üçüncü taraf AI sağlayıcısı kontrol şablonu

Yeni bir araç eklenirken aşağıdaki tablo doldurulur; pazarlama sayfası tek başına kanıt değildir.

| Alan | Kaydedilecek bilgi |
|---|---|
| Sağlayıcı / araç | Örn. modelleme, doku, ses, kod |
| Plan | Free / öğrenci / ücretli / API |
| Model / sürüm | Mümkünse tam sürüm |
| Koşul URL'si | Resmî Terms / License |
| Kontrol tarihi | YYYY-MM-DD |
| Ticari kullanım | Evet / Hayır / Belirsiz |
| Atıf | Yok / Zorunlu / Koşullu |
| Girdi hakkı şartı | Özet |
| Çıktı sahipliği/lisansı | Özet |
| Yeniden dağıtım | Oyun içinde / kaynak dosya / marketplace farkı |
| Eğitim/veri tercihi | Varsa opt-in/opt-out durumu |
| Provenance/metadata | Korunması gereken işaret var mı? |
| İnsan QA | Kim inceledi ve ne değiştirildi? |
| Baycrest kararı | REFERANS / ADAY / YAYIN ADAYI / RED |

## 7. K0 için mevcut karar

- `K0-CONCEPT-001` OpenAI ile oluşturulmuş **konsept referanstır**; kaynak/üretim kaydı tutulur, oyun içine doğrudan doku olarak yüklenmiş sayılmaz.
- Roblox Studio AI ile üretilen eski turunçgil ve ekmek mesh denemeleri canlı ArtV3 sahnesinden çıkarılmıştır; geçmiş üretim kaydı olarak kalır.
- K0'ın aktif tezgâh geometrisinin proje içi Roblox Part/Luau üretimi olması lisans yüzeyini küçültür; ancak dış ses, font, görsel veya mesh eklendiği anda aynı köken kapısı uygulanır.
- NPC konseptlerinin daha sonra 3D modele çevrilmesi durumunda kaynak referans görselinin kullanım hakkı, AI sağlayıcısı ve modelleme/export zinciri tek varlık kaydında birbirine bağlanır.

## 8. Yayın öncesi son kontrol

`K6` öncesinde yalnız “dosya var mı?” kontrolü yapılmaz. Kullanılan her varlığın gerçek place'te hâlâ var olup olmadığı, asset ID'nin sahibi, güncel hak durumu, moderasyon sonucu ve atıf gereksinimi yeniden karşılaştırılır. Bu kontrol sonucu `ASSET_PROVENANCE.md` içindeki her canlı satır `DOĞRULANDI` veya `KALDIRILDI` olarak kapanır.
