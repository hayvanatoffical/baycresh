# BAYCREST — AI araçları lisans matrisi

**Kontrol tarihi:** 26 Eylül 2026  
**Durum:** Araç seçimi için çalışma kaydı; şartlar değişebilir, yayın varlığında yeniden kontrol zorunludur.  
**Kural:** Bu tablo “hukuken risksiz” damgası vermez. Her varlığın girdi hakkı ve gerçek oluşturma planı `ASSET_PROVENANCE.md` içinde ayrıca kaydedilir.

## Kısa karar matrisi

| Araç | Baycrest için bugünkü kullanım | Ticari/lisans notu | Atıf / ana risk | Karar |
|---|---|---|---|---|
| **OpenAI görsel üretimi** | Konsept, turnaround, referans | Kullanıcı–OpenAI ilişkisi bakımından çıktı kullanıcıya ait; girdi hakları kullanıcı sorumluluğunda | Genel zorunlu OpenAI atfı bu kontrolde görülmedi; gerçek kişi benzerliği ve üçüncü taraf IP ayrıca kontrol edilir | **KONSEPT İÇİN UYGUN** |
| **Roblox AI Features** | Studio içi üretim / yardımcı yaratım | Prompt/output kullanımından yaratıcı sorumlu; mevcut haklar korunur; Roblox'a koşullardaki lisans verilir | Provenance/metadata etiketleri kaldırılmaz; normal Roblox moderasyonu devam eder | **UYGUN, KAYITLI** |
| **Meshy Free** | 3D deneme / gerektiğinde yayın adayı | Free çıktılar CC BY 4.0; ticari kullanım atıfla mümkün | Meshy atfı zorunlu; yüklenen referansın hakkı ayrıca gerekir | **KULLANILABİLİR, ATIF ZORUNLU** |
| **Meshy Paid** | 3D üretim adayı | Güncel Meshy şartlarında ücretli müşteri çıktısı için özel/ticari haklar daha geniş | Public/Community'e yükleme lisans durumunu değiştirebilir; girdi IP'si kullanıcı sorumluluğu | **TERCİH EDİLEBİLİR** |
| **Tripo Free** | Sadece deney / prototip referansı | Tripo yardım merkezi free çıktılarda Tripo'nun hakları tuttuğunu ve ticari hakkın verilmediğini söylüyor | Genel Output maddesi ile free-tier sahiplik maddesi arasında yorum alanı olduğundan konservatif davranılır | **TİCARİ YAYINA ALMA** |
| **Tripo Paid** | 3D üretim adayı | Resmî yardım merkezi ücretli kullanıcıya ticari kullanım/değiştirme/dağıtım hakları tanımlıyor | Girdi görselinin hakkı yine kullanıcıda olmalı; rakip 3D üretim hizmeti kısıtı var | **ADAY** |
| **ElevenLabs Free** | Ses denemesi | Güncel non-EEA Terms, ücretsiz kullanımı non-commercial ile sınırlar | Ticari oyuna free çıktıyı sokma | **TİCARİ YAYINA ALMA** |
| **ElevenLabs Paid** | Ses/voice üretim adayı | Güncel Terms paid kullanıcıların commercial use yapabileceğini belirtir | Ses benzerliği/izin, plan ve hesap uygunluğu ayrıca incelenir | **ADAY; VARLIK BAZLI KONTROL** |
| **Roblox Creator Store** | Ses, model, materyal, plugin için varsayılan kaynak | Store'dan edinilen asset Roblox Studio ve Experiences içinde kullanım lisansı taşır | Restricted bağımlılığı başka asset içinde yeniden dağıtma/satma sınırlıdır; script denetimi gerekir | **VARSAYILAN DIŞ KAYNAK** |

## Baycrest için pratik seçim

K0/K1 üretiminde lisans yüzeyini küçük tutmak için önce proje içi Roblox Part/Luau, kendi çizim/görsellerimiz ve Creator Store tercih edilir. AI ile gerçek 3D üretim gerekiyorsa **üretildiği andaki plan** kayıt altına alınır; sonradan ücretliye geçmek eski free çıktının hakkını otomatik değiştirmiş sayılmaz.

Meshy Free kullanılacaksa asset kaydına `CC BY 4.0` ve atıf metni eklenir. Tripo Free ve ElevenLabs Free çıktıları ticari Baycrest build'ine alınmaz. Ücretli araçta bile yüklenen referans başkasına aitse sağlayıcının ticari kullanım izni üçüncü taraf hakkını ortadan kaldırmaz.

## Resmî kaynaklar

- OpenAI Terms of Use: https://openai.com/policies/row-terms-of-use/
- OpenAI Service Terms: https://openai.com/policies/service-terms/
- Roblox Terms of Use / AI Features: https://en.help.roblox.com/hc/en-us/articles/115004647846-Roblox-Terms-of-Use
- Roblox Generative AI: https://create.roblox.com/docs/generative-AI
- Roblox Creator Store Terms: https://en.help.roblox.com/hc/en-us/articles/21308223046932-Creator-Store-Terms
- Roblox Creator Store docs: https://create.roblox.com/docs/production/creator-store
- Meshy Terms of Service: https://www.meshy.ai/terms-of-use
- Meshy commercial-use help: https://help.meshy.ai/en/articles/9992001-can-i-use-meshy-assets-commercially-license-copyright-explained
- Tripo Terms: https://www.tripo3d.ai/terms
- Tripo commercial-use help: https://www.tripo3d.ai/help/privacy-policy/how-to-use-tripo-models-commercially
- ElevenLabs Terms: https://elevenlabs.io/terms-of-use

## Atıf kayıt örneği

```text
Asset ID: BC-NPC-003
Araç: Meshy Free
Oluşturma tarihi: 2026-09-26
Lisans: CC BY 4.0
Atıf: "Model created with Meshy – CC BY 4.0 License"
Girdi kaynağı: Baycrest'e ait/orijinal turnaround görseli
İnsan düzenlemesi: retopo + UV + Roblox rig + texture cleanup
Roblox asset ID: TBD
Durum: YAYIN ADAYI / henüz cihaz QA yok
```
