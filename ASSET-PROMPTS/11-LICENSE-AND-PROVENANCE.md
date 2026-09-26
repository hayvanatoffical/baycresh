# 11 — Lisans ve köken (provenance)

**Durum:** TASLAK · K0.4
**Doğrulama tarihi:** 26 Eylül 2026
**Bu dosya `PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md` ile birlikte okunur.** Çelişki varsa daha yeni tarihli olan geçerlidir ve eski olan düzeltilir.

## Temel kural

> **"AI üretti, dolayısıyla telifsizdir" varsayımı KULLANILMAZ.**

Bir varlığın kullanılabilirliği aracın kendi şartlarından gelir, üretim biçiminden değil. Aynı araç, ücretsiz ve ücretli planda **farklı** haklar verebilir — ve bu projede veriyor.

İkinci kural: lisans kesin değilse `UNKNOWN / REVIEW REQUIRED` yazılır ve varlık yayına girmez. Boş bırakmak veya "muhtemelen uygun" yazmak yasaktır.

Üçüncü kural: kaynak olarak **yalnız resmî sayfalar** kullanılır — aracın kendi Terms/License/Help sayfası, resmî GitHub LICENSE, resmî model card. Blog yazısı, forum yorumu ve haber sitesi lisans kaynağı değildir.

## Bu oturumda doğrulananlar

Aşağıdaki iki kayıt 26 Eylül 2026'da resmî sayfalardan doğrulandı.

### Suno (müzik)

| Alan | Bulgu |
|---|---|
| Kaynak | suno.com resmî Terms of Service |
| Ücretsiz / abone olmayan | Çıktı yalnız "lawful, personal and non-commercial purposes" için kullanılabilir |
| Ücretli (Pro / Premier) | Suno çıktı üzerindeki haklarını kullanıcıya devrediyor: "assigns to you all of its right, title and interest in and to any Output owned by Suno", Terms'e ve indirme kısıtlarına bağlı |
| Telif garantisi | **Yok.** "Due to the nature of machine learning, Suno makes no representation or warranty to you that any copyright will vest in any Output." |
| Baycrest kararı | **Ücretsiz plan: TİCARİ YAYINA ALMA.** Ücretli plan: **ADAY**, varlık bazlı kontrol |

Telif garantisinin olmaması önemlidir: çıktı üzerinde münhasır hak iddia edilemeyebilir. Bu, müziği "sahip olunan varlık" değil "kullanım hakkı alınmış varlık" olarak kaydetmeyi gerektirir.

### Meshy (3D)

| Alan | Bulgu |
|---|---|
| Kaynak | meshy.ai resmî Terms of Use ve Help Center |
| Ücretsiz plan | Çıktının fikrî mülkiyeti Meshy'de; kullanıcıya **CC BY 4.0** ile sunuluyor. Ticari kullanım **mümkün**, ancak **Meshy atfı zorunlu** |
| Ücretli plan | Uygulanabilir hukuk çerçevesinde çıktı müşteriye ait; atıf gerekmiyor |
| Baycrest kararı | Ücretsiz: **KULLANILABİLİR, ATIF ZORUNLU.** Ücretli: **TERCİH EDİLİR** |

CC BY 4.0 atfı gerçek bir yükümlülüktür: Roblox deneyiminin açıklamasında veya oyun içi bir kredi ekranında Meshy'ye kredi verilmelidir. Atıf yeri belirlenmeden varlık `ADAY` olamaz (bkz. `10-ASSET-VALIDATION.md` A7).

## Doğrulanmayanlar — kullanılmaz

| Araç | Durum | Neden |
|---|---|---|
| Udio | `UNKNOWN / REVIEW REQUIRED` | Bu oturumda resmî şartları okunmadı |
| Diğer müzik/SFX araçları | `UNKNOWN / REVIEW REQUIRED` | Aynı |
| Text-to-motion animasyon araçları | `UNKNOWN / REVIEW REQUIRED` | Araç seçilmedi |
| İkon/vektör üretim araçları | `UNKNOWN / REVIEW REQUIRED` | Araç seçilmedi |

Bu satırlar boş bırakılmak yerine açıkça `UNKNOWN` yazılmıştır. Bir araç kullanılmadan önce bu tabloya doğrulanmış satır eklenir.

## Önceki matristen taşınanlar

`PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md` içindeki şu kararlar bu oturumda **değiştirilmedi** ve yeniden doğrulanmadı; yayın öncesi tekrar kontrol edilmelidir:

- OpenAI görsel üretimi — konsept için uygun
- Roblox AI Features — uygun, provenance metadata korunur
- Tripo free — ticari yayına alınmaz; Tripo paid — aday
- ElevenLabs free — ticari yayına alınmaz; paid — aday
- Roblox Creator Store — varsayılan dış kaynak

## Kontrol edilecek alanlar

Yeni bir araç değerlendirilirken şu alanların **hepsi** doldurulur. Eksik alan varsa sonuç `UNKNOWN`'dır.

- [ ] Ticari kullanım (commercial use) veriliyor mu?
- [ ] Ücretsiz plan ile ücretli plan arasında fark var mı?
- [ ] Atıf (attribution) zorunlu mu? Zorunluysa metni ne?
- [ ] Yeniden dağıtım (redistribution) — çıktı başka bir üründe dağıtılabilir mi?
- [ ] Girdi hakları — yüklenen referansın hakkı kimde?
- [ ] Çıktı sahipliği — kullanıcıda mı, araçta mı, lisansla mı veriliyor?
- [ ] Eğitim/girdi kullanımı — yüklenen içerik modeli eğitmekte kullanılıyor mu?
- [ ] Roblox'ta kullanıma engel bir madde var mı?
- [ ] Provenance metadata gömülüyor mu? Kaldırılması yasak mı?
- [ ] Ses/müzik için özel koşul var mı (benzerlik, indirme kotası, iptal sonrası hak)?
- [ ] Şartların kontrol edildiği tarih ve URL kaydedildi mi?

## Provenance kayıt şablonu

Her varlık için, **üretimden önce** açılır:

```
Asset ID:            (ör. PROP-ORANGE-UNIT)
Asset type:          (3D model / animation / SFX / music / icon / texture / voice)
Tool:                (araç adı)
Tool plan:           (free / paid — hangi plan, hangi tarihte)
Generation date:     (YYYY-MM-DD)
Prompt file:         (ASSET-PROMPTS/ altındaki dosya ve bölüm)
Source/reference:    (kullanılan girdi görsel/ses; hakkı kimde)
License:             (tam lisans adı; UNKNOWN yazılabilir ama boş bırakılamaz)
Commercial use:      (evet / hayır / koşullu — koşul nedir)
Attribution:         (gerekli mi; gerekiyorsa metin ve nereye konacağı)
Human edits:         (üretim sonrası insan müdahalesi; ne yapıldı)
Final reviewer:      (kim onayladı)
Roblox upload ID:    (yüklendiyse asset ID; yüklenmediyse "yüklenmedi")
Notes:               (moderasyon, benzerlik, risk notları)
```

### Doldurma kuralları

- `Tool plan` **zorunludur.** Bu projedeki en kritik ayrım ücretsiz/ücretli farkıdır; "Meshy" yazmak yetmez, "Meshy free" veya "Meshy paid" yazılır.
- `License` alanı `UNKNOWN` ise varlık `PRODUCTION/ASSET_PROVENANCE.md`'ye `ADAY` olarak yazılamaz; `DENEME` olarak yazılır ve yayına girmez.
- `Human edits` boş bırakılmaz. İnsan müdahalesi yoksa "yok" yazılır — bu bilgi ileride hak tartışmasında önemlidir.
- `Roblox upload ID` yüklenmemişse "yüklenmedi" yazılır. Boş bırakmak, yüklenmiş ama kaydedilmemiş izlenimi verir.

## Bu oturumun doğrulama sınırı

- Suno ve Meshy şartları 26 Eylül 2026'da okundu. **Bu şartlar hızla değişir.** Yayın öncesi yeniden okunmalıdır.
- Diğer bütün araçlar için bu oturumda doğrulama **yapılmadı**.
- Hiçbir varlık üretilmedi, dolayısıyla doldurulmuş provenance kaydı da yok. Şablon hazırdır; ilk varlıkla birlikte doldurulacaktır.
- Bu dosya hukuki görüş değildir. Yayın öncesi, özellikle ses ve müzik tarafında, şartların bir insan tarafından okunması gerekir.
