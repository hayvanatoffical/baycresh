# BAYCREST — Doküman yönetimi ve değişiklik kontrolü

**Durum:** Ekip çalışma standardı · 26 Eylül 2026  
**Kapsam:** Tasarım, AI bağlamı, 3D taslaklar, üretim kayıtları

## 1. Belge sınıfları

| Sınıf | Konum | Soru | Değişiklik yetkisi |
|---|---|---|---|
| Karar kaydı | `KARARLAR.md` | Ne seçildi, ne ertelendi, ne açık? | Proje sahibi kararı veya açıkça devredilmiş yetki |
| Kanonik tasarım | `EKIP/00`–`10` | Seçilen sistem nasıl davranır? | İlgili sorumlu taslak hazırlar; karar kaydıyla denetlenir |
| AI çalışma bağlamı | `AI_CONTEXT/` | Bu görevde hangi bağlam ve kalite kapısı kullanılır? | Kanonik belgeden türetilir; kendi başına yeni kural koymaz |
| Tasarım taslağı | `DESIGN_DRAFTS/` | Üretilecek somut şeyin önerisi nedir? | İncelemeden önce `TASLAK`; onay sonrası kanonik kurala bağlanır |
| Üretim kanıtı | `PRODUCTION/` | Varlığın kaynağı, Studio yeri ve kabul kanıtı nedir? | İşlemi yapan kişi ekler; ikinci kişi doğrular |
| Tarihî değerlendirme | Arşiv ve kökteki v3 planı | Bir karar neden tartışıldı? | Referans; güncel kuralları geçersiz kılmaz |

Eski 3.0 belgelerinin sürüm etiketi karar baz çizgisini gösterir. 25 Eylül 2026 düzenlemesi dil, erişim ve üretim işleyişini iyileştirir; kullanıcı kararlarını değiştirmez. Karar değişirse etkilenen kanonik belge, karar kaydı ve değişiklik günlüğü birlikte güncellenir.

## 2. Terimlerin kesin anlamı

- **Karar:** `UK`, `DY` veya `ORTAK` kimliğiyle kayıtlı ürün tercihi.
- **Hedef:** Kabul için ölçülecek değer; sonuç kanıtı değildir.
- **Başlangıç tahmini:** Henüz cihaz/oyuncu testinden geçmemiş sayı. Değiştirilebilir.
- **Platform gereksinimi:** Tarih ve resmî bağlantı ile yeniden kontrol edilmesi gereken dış kural.
- **Uygulandı:** Kod, Studio nesnesi veya asset ID ile gösterilebilir.
- **Doğrulandı:** Test yöntemi, sürüm, cihaz/oturum ve sonuç kaydedildi.

Bir AI çıktısı, Studio ekran görüntüsü veya tek başarılı oynanış oturumu kendi başına `DOĞRULANDI` sayılmaz.

## 3. Değişiklik akışı

1. **Talebi kaydet:** Hangi kararı, sistemi veya varlığı etkiliyor? Kim istiyor? Hangi katmana ait?
2. **Kaynağı aç:** Karar kimliği ve kanonik bölüm bulunur. Çelişki varsa önce karar kaydında çözülür.
3. **Etkiyi yaz:** Ekonomi, veri, güvenlik, görünürlük, arayüz, harita, moderasyon ve test etkileri kontrol edilir.
4. **Taslağı üret:** Yeni iş `DESIGN_DRAFTS/` altında kalır. Belirsiz ölçüler `TBD` ve doğrulama yöntemiyle yazılır.
5. **Gözden geçir:** İlgili alan sorumlusu ve bağımlı alanlardan biri okur. Açık sorular kaybolmaz; `KARARLAR.md` §6 veya taslakta tutulur.
6. **Kabul et ve uygula:** Onaylanan davranış kanonik belgeye, sayısal değişiklikler `03` §14'e, gerçek üretim varlığı `PRODUCTION/` kaydına işlenir.
7. **Doğrula:** Katman kapısı ve test kanıtı eklenir; sonuç [DEGISIKLIK-GUNLUGU.md](DEGISIKLIK-GUNLUGU.md) dosyasına özetlenir.

## 4. İnceleme şablonu

Her anlamlı değişiklik için şu alanlar yeterlidir:

```text
Kimlik / tarih:
İstenen değişiklik ve gerekçe:
Karar kaydı / kanonik bölüm:
Etkilenen belgeler ve oyun nesneleri:
Kapsam / katman:
Açık varsayımlar:
Kabul ölçütü:
Test kanıtı ve sonucu:
Karar veren / gözden geçiren:
```

## 5. Yayın ve doğrulama kapıları

- Kırık bağlantı, bozuk başlık, çelişen ad ve tekrar edilmiş ayar değeri bırakılmaz.
- `TASLAK` bir dosya, `KARARLAR.md` içindeki elenmiş veya ertelenmiş fikri onaylanmış gibi sunamaz.
- Platform kuralı yeniden yazılıyorsa resmî kaynağın adresi ve kontrol tarihi eklenir. Hukuki/ücret/yaş bilgileri yayın ayında yeniden doğrulanır.
- 3D varlıkta kaynak hakkı, ad, pivot/ölçek, çarpışma, doku ve cihaz testi kaydı bulunmadan `DOĞRULANDI` statüsü verilmez. AI/üçüncü taraf varlıkta ayrıca `PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md` içindeki girdi hakkı, çıktı hakkı, atıf, yeniden dağıtım, Roblox uyumu ve köken kapıları doldurulur.
- Studio testinde doğru place ve DataModel kaydedilir. Boş `Place1` ile yapılan bağlantı testi Baycrest oynanış testi değildir.

