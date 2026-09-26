# 09 — Seslendirme (opsiyonel)

**Durum:** TASLAK · K0.4
**Değerlendirme sonucu: K0 için ÖNERİLMEZ.**

## Karar

K0'a seslendirme **eklenmemelidir**. Gerekçeler aşağıda; karar gerekçesiyle birlikte kayda geçmiştir ki ileride tekrar tartışılırken sıfırdan başlanmasın.

### 1. K0'ın sorusunu ölçmüyor

K0'ın tek hipotezi: *"Oyuncu ilk dakikalarda bir şeye sahip olup, görünür kararlarla büyütmek istiyor mu?"* Seslendirme bu soruyu ölçmez. Konuşma eklemek testin sonucunu değiştirmez, yalnız üretim yükünü artırır.

### 2. Tekrar yükü çok yüksek

Simülasyon 20 dakikada 45–50, 40 dakikada 91–97 müşteri gösteriyor. Her müşterinin bir replik söylemesi, tek oturumda aynı beş-altı cümlenin onlarca kez duyulması demektir. Bu, oyuncuyu **oyundan çıkaran** bir tekrardır; K0'ın erken oyuncu kaybı riskini azaltmaz, artırır.

### 3. Metin zaten var ve çalışıyor

Kaynakta NPC konuşmaları `bubble()` ile baloncuk metni olarak veriliyor: `"Sadece bakıyorum."`, `"Anlaştık!"`, `"Bütçemi aşıyor."`, `"Bekleyemem."`. Bunlar sessiz okunur, tekrar yormaz, çeviri maliyeti sıfıra yakındır ve telefon hoparlörü kapalıyken de çalışır.

### 4. Lisans ve hak yüzeyi genişliyor

Ses klonlama ve sentetik ses, bu projedeki en yüksek hak riskli varlık sınıfıdır: ses benzerliği, izin, plan uygunluğu ve bölgesel şartlar birlikte kontrol edilmelidir. K0'ın ölçmediği bir şey için bu riski açmak orantısızdır.

### 5. Dil kararı verilmedi

Oyun Türkçe arayüzle geliştiriliyor ama Roblox kitlesi çok dilli. Seslendirme eklendiği anda "hangi dil, kaç dil, alt yazı var mı" soruları gelir. Bu, K0 kapsamı dışında bir ürün kararıdır ve `KARARLAR.md`'de kaydı yoktur.

## Ne zaman yeniden değerlendirilir

Seslendirme şu koşulların **hepsi** sağlandığında yeniden gündeme alınır:

1. K0 kapısı geçildi (üç bağımsız oyuncu, 20 dakika, Android dahil).
2. Oyuncu geri bildiriminde "NPC'ler cansız" başlığı somut olarak çıktı.
3. Dil ve alt yazı kararı `KARARLAR.md`'ye yazıldı.
4. Ücretli ve ticari kullanıma uygun bir araç `11-LICENSE-AND-PROVENANCE.md`'de **ADAY** statüsüne geçti.

## Yine de yapılacaksa: kapsam sınırı

Eğer yukarıdaki koşullar oluşur ve seslendirme yapılırsa, kapsam **yalnız kısa NPC tepkileri (barks)** olmalıdır. Tam diyalog, anlatıcı veya seslendirilmiş öğretici K0/K1 kapsamı değildir.

### İzin verilen bark seti

| Kimlik | Tetikleyici | Süre | Varyant |
|---|---|---|---|
| `VOX-GREET` | müşteri sıraya varır | ≤ 0.8 s | 4 |
| `VOX-BROWSE` | "sadece bakıyorum" | ≤ 1.0 s | 3 |
| `VOX-DEAL` | satış tamam | ≤ 0.8 s | 4 |
| `VOX-REJECT` | bütçe aşıldı | ≤ 1.0 s | 3 |
| `VOX-IMPATIENT` | sabır bitiyor | ≤ 0.8 s | 3 |

**Varyant sayısı bir gerekliliktir, süs değil.** Tek varyantlı bark, ikinci duyuşta tekrar hissi verir. Minimum üç varyant ve rastgele olmayan (dönüşümlü) seçim kullanılmalıdır ki aynı klip peş peşe çalmasın.

### Teknik şart

```
Short character voice barks for a market customer NPC in a game.

- Natural conversational delivery, indoor-neutral recording, dry with minimal room
  tone, no music, no reverb, no processing effects.
- Mono, 48 kHz. Peak at or below -3 dBFS. No silence at the start of the file.
- Warm, ordinary, everyday register. Not theatrical, not cartoonish, not whispered,
  not shouted.
- Each line under the duration listed for its bark type.
- Deliver each variant as a SEPARATE file; do not concatenate variants.
- No named character, no accent imitation of a real public figure, no impression
  of any identifiable person.
```

### Hak şartı

Seslendirme üretilirse, **her klip için** `11-LICENSE-AND-PROVENANCE.md` kaydı zorunludur ve şu alanlar boş bırakılamaz:

- Araç ve plan (ücretsiz plan ticari yayına giremez).
- Kullanılan ses modelinin kaynağı ve gerçek bir kişiye benzerlik taşıyıp taşımadığı.
- İnsan oyuncu kullanıldıysa yazılı izin.
- Roblox ses moderasyonundan geçtiğine dair kayıt.

## Alternatif: sözsüz vokal jest

Seslendirmenin yerine, tekrar yükü çok daha düşük bir ara çözüm var: **sözsüz kısa vokal jestler** ("hmm", "ah", kısa onay mırıltısı). Bunlar dil bağımsızdır, çeviri gerektirmez ve tekrarda daha az yorar. Yine de `06-SFX.md`'deki tekrar toleransı kuralına tabidir ve yine `11` kaydı gerekir.

Bu bir öneridir, karar değildir. K0 için hâlâ gerekli görülmemektedir.
