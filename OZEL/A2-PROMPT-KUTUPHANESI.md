# A2 — Prompt Kütüphanesi

**Sürüm:** 3.0 · 24 Eylül 2026
**Okuyucu:** Sadece sen. İstersen tek tek arkadaşlarına şablon olarak ver.

Kopyala-yapıştır şablonlar. Köşeli parantezleri doldur.

---

## 1. Oturum açılışı

Her yeni oturumun ilk mesajı. `AI_CONTEXT/README.md` görev rotasındaki ilgili belgeleri yükledikten sonra gönder.

```
Roblox'ta "Baycrest" adında bir şehir hayatı oyunu geliştiriyoruz.
Ekli belgeler bu göreve ilgili tasarım dokümanlarıdır — hepsini oku.
Bir çelişki görürsen KARARLAR.md geçerlidir.

Bilmen gerekenler:
- Oyun bir tycoon omurgası üzerine kurulu: sahiplen, büyüt,
  otomatikleştir, yeni bir şey sahiplen.
- Suç zorunlu değil, seçenek. Her meslek aynı risk altında değil.
- Envanter sistemi imzamız: her eşyanın bedende bir yeri ve bir
  görünürlüğü var.
- Kimse ölmez. Yaralanır ve hastaneye gider. Yüksek hasar yok.
- Ceza likiditeye vurur, meşru varlığa değil.
- Değişken ve servis adları Türkçe, Roblox API İngilizce.
  Türkçe karakter kullanma.
- Tüm sayısal değerler Ayarlar.lua'dan okunur, koda gömülmez.

Şimdi şu konuda yardım et: [KONU]
```

---

## 2. Yeni servis yazdırma

```
Roblox Luau ile [SERVIS ADI] yazıyorum.

BAĞLAM
- Sunucu-istemci ayrımı katı. Tüm hesap sunucuda.
- İstemci niyet bildirebilir; sunucu her niyeti doğrular.
- Servis deseni: .yeni(), :baslat(), iş fonksiyonları.
- Sayılar ReplicatedStorage/Ortak/Ayarlar.lua'dan okunur.
- Bu servis şu servislerle konuşacak: [LISTE]

İSTEDİĞİM
[Numaralı adım listesi — her adım tek bir şey yapsın]

KISITLAR
- Her OnServerEvent parametresi için yedi kontrol yaz:
  tür, değer aralığı, sahiplik, mesafe, yetki, sıklık, tekrar
- Gizli durumu ReplicatedStorage'a, Attribute'a veya ortak
  nesnelere KOYMA. Gizli veri yalnız ServerStorage'da durur.
- DataStore çağrısı varsa pcall içinde
- Para veya eşya hareketi varsa işlem kimliği kullan;
  aynı kimlik iki kez uygulanmasın
- task.wait() ve task.spawn() kullan, eski API kullanma
- NPC yaratılıyorsa Humanoid KULLANMA; animasyon için
  AnimationController kullan
- Bir oyuncunun meşru varlığını (dükkân, araç, ev, meşru para)
  silen kod YAZMA

BİTİRDİKTEN SONRA
Bu kodu hile yapan birinin nasıl kötüye kullanabileceğini
madde madde listele.
```

---

## 3. Envanter ve görünürlük işleri

Bu sistemde AI en çok hata yapıyor, çünkü "gizlemek" kelimesini görsel bir şey sanıyor.

```
Baycrest'te görünürlük bir OYUN KURALI, görsel efekt değil.

MUTLAK KURAL
Sunucu, bir oyuncunun görmemesi gereken veriyi o oyuncunun
istemcisine HİÇ göndermez. İstemciye gönderip gizlemek YASAK —
hile yapan gönderilen her veriyi okur.

Bu yalnız Remote'lar için değil: Attribute, CollectionService
etiketi ve ReplicatedStorage'daki tablolar da herkese kopyalanır.

GÖRÜNÜRLÜK MATRİSİ
- Eller ve sırt: herkes görür
- Cep içeriği: yalnız sahibi (ve delile dayalı aramada polis)
- Çanta nesnesi: herkes görür
- Çanta içeriği: sahibi, göstermeyi kabul ettiği polis,
  ve halka açık yerde açıksa yakındakiler
- Açık bagaj: menzildeki ve görüş hattındakiler

İKİNCİ KURAL
Kılıfı olmayan biri tabancayı cebe koymak isterse sunucu
işlemi reddeder ve istemciye bir ONAY İSTEĞİ gönderir:
"Kılıfın yok, elinde taşınacak. Onaylıyor musun?"
Oyuncu onaylarsa eşya ellere gider. Sessizce ele koyma.
Bu bir hata değil, oyunun temel kuralıdır. "Düzeltme."

ÜÇÜNCÜ KURAL
Yer BİRİM ile ölçülür, slot ile değil. Cep 2 birim,
küçük eşya 1, orta 2, büyük 4. Kimlik, cüzdan ve
anahtarlık yer tutmaz.

Şimdi şunu yaz: [ISTEK]
```

---

## 4. Çatışma, sağlık ve hastane işleri

```
Baycrest'te KİMSE ÖLMEZ. Bu bir kullanıcı kararıdır.

KURALLAR
- Can sıfıra inince oyuncu YARALI duruma geçer.
  Humanoid.Health 1'e sabitlenir, Humanoid.Died TETİKLENMEZ.
  Karakter yeniden doğmaz.
- Yaralı 45 saniye yardım bekler. Sağlık ekibi gelirse
  30 canla kalkar; gelmezse NPC ambulans hastaneye götürür.
- Hastane tedavisi ÜCRETSİZDİR.
- Hasar DÜŞÜKTÜR: tabanca 12, tüfek 18. Kafa çarpanı YOK.
  En az 9 isabet gerekir.
- Kan, gore ve ölüm animasyonu YOK.
- NPC'ler hasar ALMAZ. Tehdit edilince teslim olur veya kaçar.

BAĞLAM KURALI
Oyuncuya ateş yalnız şu üç durumda mümkündür:
1. Görevdeki polis ve aranma >= 2 olan kişi
2. Aktif suç alanı (soygun sırasında hedef mekân ve çevresi)
3. Son 60 saniyede sana hasar vermiş kişi (meşru müdafaa)
Bağlam yoksa tetik kilitlidir ve ekranda sebebi yazar.

KAYIP KURALI
Yaralanan masum oyuncu HİÇBİR ŞEY kaybetmez.
Yalnız taşınan kirli nakdin yarısı ve ruhsatsız silah düşer;
bunları YALNIZ polis toplayabilir. Diğer oyuncular alamaz.

Şimdi şunu yaz: [ISTEK]
```

---

## 5. Adalet sistemi işleri

```
Baycrest'te suçun sonu bir DOSYADIR, kovalamaca değil.
İlgili belge: 09-ADALET-VE-ANAYASA.md

AKIŞ
olay -> delil -> dosya -> karar -> infaz -> kapanış

MUTLAK KURALLAR
- Mahkeme kurallı bir NPC sistemidir. Oyuncu hâkim YOKTUR.
- Dava, sanık çevrimdışıyken de ilerler ve sonuçlanır.
  Ücretsiz NPC temsilci savunur. Kayıtta "katıldı" YAZILMAZ;
  "yokluğunda, temsil yoluyla sonuçlandı" yazar.
- Sahte oyuncu katılımı veya sahte fiziksel olay ÜRETME.
- Mahkûmiyet için iki şart: olay kanıtı VE kimlik bağı
  (en az bir güçlü veya iki orta delil).
- Çanta reddi, şüphe kaydı ve oyuncu ihbarı DELİL DEĞİLDİR.
- Tek infaz tavanı 10 dakikadır. Suçlar üst üste EKLENMEZ.
- Kaçak değilken çevrimdışı geçen süre infazdan düşülür.
- Her verdictId yalnız BİR KEZ uygulanır.
- Ceza meşru varlığa dokunmaz. Yalnız kirli nakit ve
  ruhsatsız silah el konur.

ÇEVRİMDIŞI İŞLEM
Dosyalar ayrı bir adalet kuyruğundadır. Kuyruğu işleyen sunucu
dosya üzerinde kısa süreli kilit alır. Karar, sanığın KAYDINA
değil OLAY KUTUSUNA yazılır. planlananAn ve islendiAn ayrı tutulur;
gecikme ek ceza üretmez.

Şimdi şunu yaz: [ISTEK]
```

---

## 6. Kod incelemesi

AI'nın yazdığı kodu başka bir oturumda inceletmek, tek oturumda düzelttirmekten daha iyi sonuç veriyor.

```
Aşağıdaki Roblox Luau kodunu incele. Baycrest projesine ait.

Şu açılardan kontrol et ve bulduklarını madde madde yaz:

1. İstemciden gelen bir değer doğrulanmadan kullanılıyor mu?
2. Yedi kontrol var mı: tür, aralık, sahiplik, mesafe,
   yetki, sıklık, tekrar?
3. Görmemesi gereken oyuncuya veri gönderilen yer var mı?
   (Remote, Attribute, ReplicatedStorage, etiket)
4. DataStore çağrısı pcall dışında mı?
5. Para veya eşya hareketinde işlem kimliği ve tekrar
   koruması var mı?
6. Her karede çalışan ağır işlem var mı?
7. Humanoid kullanılan NPC var mı? Animasyon için
   AnimationController yerine Tween zinciri var mı?
8. Koda gömülmüş sayı var mı? (Ayarlar.lua'da olmalı)
9. Bir oyuncunun meşru varlığını silen kod var mı?
10. Ölüm veya yeniden doğma mantığı var mı?
    (Bu oyunda ölüm yok, yaralı durumu var)
11. Kafa atışı çarpanı var mı? (Olmamalı)
12. Sahibi çevrimdışı olan bir işletme kaydına yazan kod var mı?
    (Yalnız sahibinin sunucusu yazar)

Düzeltme önerme, sadece bul ve listele.

[KOD]
```

---

## 7. Test senaryosu yazdırma ve koşturma

Studio MCP bağlıyken çalışır.

```
Bu senaryoyu Studio'da çalıştır ve sonucu raporla.

1. Test modunu başlat
2. [Karakteri nereye yürüt]
3. [Neye tıkla, hangi tuşa bas]
4. [Kaç kez tekrarla]
5. Konsol çıktısını oku
6. Ekran görüntüsü al
7. Test modunu durdur

RAPOR FORMATI
- Geçti / Kaldı
- Konsolda kırmızı hata varsa: tam metin ve satır
- Beklenmedik davranış varsa: ne bekleniyordu, ne oldu
- Ekran görüntüsünde göze çarpan sorun
```

---

## 8. Ekonomi modeli ve denge analizi

```
Baycrest'in ekonomi belgesini (03-EKONOMI.md) okudun.

A) MODEL KURMA
03 §15'teki ekonomi modelini bir Python betiği olarak yaz.
Beş arketip için 1, 5, 10, 25, 50 ve 100. saatte temiz serveti
hesapla: temiz işletmeci, karma oyuncu, suç ağırlıklı işletmeci,
işletmesiz suçlu, kamu mesleği.

Sonra §15'teki dört kontrolü çalıştır ve geçip geçmediğini yaz.

B) DEĞİŞİKLİK ANALİZİ
Şu değişikliği yapmak istiyorum: [DEGISIKLIK]

Bana şunları ver:
1. Ayarlar.lua'da hangi satırları etkiliyor
2. Zincirleme etkiler — başka hangi sistemler bozulur
3. Suç/temiz temiz servet oranı 1,2-1,5 bandından çıkıyor mu?
   Hesapla.
4. Enflasyon riski artar mı?

Değişikliği YAPMA, sadece analiz et. Kararı ben vereceğim.
```

---

## 9. Harita ve varlık üretimi

```
Studio MCP bağlı. Şunu üret:

[NESNE TANIMI]

KISITLAR
- Sanat yönü: stilize, gerçekçi değil. Temiz geometri, sıcak renkler.
- Palet: 05-HARITA-SANAT-ANIMASYON.md bölüm 1.3'teki renkler
- Küçük prop için 512x512 veya altıyla başla; nihai boyutu
  cihaz ve oyun kamerası ölçümüyle gerekçelendir
- 4 stud ızgarasına oturmalı
- İsimlendirme: Bolge_Kategori_Ad_Varyant
- Gerçek marka, logo, yazı olmayacak
- Kan, gore, silah propagandası yok

Üretimden sonra parça sayısını, boyutları, pivotu,
çarpışmayı ve henüz ölçülmeyen noktaları ayrı söyle.
```

**Standart yuva için özel not — bu en kritik varlık:**

```
[Bazaar tezgâhı / Ironhill standart cephesi] için şablon üret.

Bu bir ŞABLON — çok sayıda kopyası olacak ve hepsi aynı
ölçüde olmalı. Önce gri kutuda ölç, testten sonra sabitle ve bana yaz:
- Kapı veya tezgâh genişliği ve yüksekliği
- Vitrin veya sergi alanı
- Tabela alanı (boş bırak, oyuncunun şablonu oraya gelecek)
- Toplam genişlik

Dış görünüm işletme tipine göre değişecek ama GEOMETRİ
hiç değişmeyecek. Buna göre tasarla.
```

---

## 10. Animasyon

```
Baycrest için R15 animasyonu istiyorum.

Animasyon: [AD]
Süre: [SANIYE]
Döngü: [evet/hayır]

Tarif: [Hareketin adım adım tarifi]

Bu animasyon [nerede] kullanılacak ve oyuncu bunu
[kaç kez] görecek.

KISITLAR
- Kan, acı çekme veya ölüm anlatımı yok.
  Yaralı animasyonları sakin ve kansızdır.
- Silah animasyonları abartısızdır.
- Bu bir imza animasyonuysa jenerik hissettirmemeli.
```

---

## 11. Hata avı

```
Şu hatayı alıyorum:

[HATA METNI]

Bağlam:
- Hangi dosya: [DOSYA]
- Ne yaparken: [DURUM]
- Studio mu, test modu mu, canlı sunucu mu: [HANGISI]
- Tek oyuncu mu, iki oyuncu mu: [HANGISI]

Önce SEBEBİ açıkla, sonra düzeltmeyi ver.
Düzeltmenin başka neyi bozabileceğini de söyle.
```

---

## 12. Belge güncelleme ve tutarlılık taraması

Tasarım değiştiğinde belgeleri güncel tutmak için.

```
Şu karar alındı: [KARAR]
Gerekçe: [GEREKCE]

Ekli belgeleri oku ve bana şunu ver:
1. Bu kararın çeliştiği bölümler — hangi belge, hangi başlık
2. Güncellenmesi gereken sayılar
3. KARARLAR.md'ye eklenecek satır (kimlik, kaynak, sonuç,
   gerekçe, etkilenen belgeler)

Belgeleri yeniden yazma, sadece listele.
```

**Tam tarama (tüm paketi yükle, tek istisna):**

```
Baycrest belge paketinin tamamını yükledim. Tutarlılık taraması yap.

Şunları ara:
1. Aynı sayının iki belgede farklı yazılması
2. Bir belgenin KARARLAR.md ile çelişmesi
3. Var olmayan bir belgeye veya bölüme referans
4. Aynı kavramın farklı adlarla anılması
5. Bir katmanda gelen özelliğin başka bir belgede
   farklı katmanda gösterilmesi
6. Ölçülmemiş bir şeyin kesin gibi yazılması
   ("rakipsiz", "bedava", "çözüldü", "3 saatte biter")

Her bulgu için: belge, bölüm, ne yazıyor, ne olmalı.
Düzeltme yapma, listele.
```

---

## 13. Kaçınılacak prompt kalıpları

| Kötü | Neden | Yerine |
|---|---|---|
| "Market soygunu sistemi yaz" | Bağlam yok, AI kendi kurallarını uydurur | Bölüm 2 şablonu |
| "Bunu düzelt" | Neyin yanlış olduğunu AI tahmin eder | Bölüm 11 şablonu |
| "Daha iyi yap" | Ölçüt yok, sonsuz döngü | Somut ölçüt ver |
| "Tüm belgeleri yükle" | Çoğu işte dikkati dağıtır | İlgili 2–3 belge; tarama hariç |
| "Sence nasıl olmalı?" | Tasarım kararını AI'ya devretmek | Seçenekleri iste, kararı sen ver |
| "Ölüm sistemini yaz" | Bu oyunda ölüm yok | "Yaralı durumu ve hastane akışı" |
| "Envanter slotlarını yaz" | Slot değil birim | "Birim tabanlı envanter" |
| "Bu gerçekçi olsun" | Gerçekçilik hedef değil | "Stilize ve inandırıcı" |
