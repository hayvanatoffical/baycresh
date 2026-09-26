# BAYCREST — Karar Kaydı

**Sürüm:** 3.0 · 24 Eylül 2026
**Okuyucu:** Proje sahibi ve tasarım sorumlusu. Ekip okuyabilir.
**Rol:** Paketin tek karar kaynağı. Bir belge bu dosyayla çelişirse bu dosya geçerlidir ve belge düzeltilir.

---

## 0. Nasıl okunur

Her kararın kaynağı ayrı işaretlenir:

| Kod | Anlamı | Öncelik |
|---|---|---|
| **UK** | Kullanıcı kararı. Proje sahibinin açıkça söylediği. | En yüksek |
| **DY** | Devredilmiş yetkiyle seçilen yön. Kullanıcı cevaplamadığı konularda önerilen yönü kabul etti (UK-01, UK-16). | UK'nin altında |
| **A** | Değerlendirme A (Claude). Kimlikler: MIM, EKO, SUC, ENV, NPC, TEK, OYN, UX, PLT, SUR, BLG, YNI. Dizin: bölüm 7. | Öneri |
| **B** | Değerlendirme B (ChatGPT/Codex). Kimlikler: BC, TY, YF, V-A. Tam metin: `OZEL/ARSIV/B-Degerlendirme-Raporu-ChatGPT-v1.0.md`. | Öneri |

**Sonuç türleri:** Kabul · Geliştirildi (iki kaynak birleştirilip güçlendirildi) · Ertelendi · Elendi · Açık.

İki değerlendirmenin aynı şeyi söylemesi doğruluk kanıtı sayılmadı. Her kabul kendi gerekçesiyle yazıldı. Ekonomi ve oyun ayarlarının sayısal başlangıç değerleri `03-EKONOMI.md` §14'tedir ve prototipte ayarlanır; harita ve performans hedefleri ilgili belgelerde ayrıca ölçülür.

---

## 1. Kullanıcı kararları

| Kimlik | Karar | Uygulandığı yer |
|---|---|---|
| UK-01 | Cevaplanmayan tercihlerde önerilen yön kabul edilir. | Tüm DY kararları |
| UK-02 | Her meslek aynı soyulma riski altında değildir. Müteahhitlikte malzeme hırsızlığı çekirdek döngü olmaz. | 02 §10, 10 §4 |
| UK-03 | Kurgusal ülkenin bir anayasası olur. | 09 §2 |
| UK-04 | Mahkeme olur. Oyuncu katılmasa veya çevrimdışı olsa da dava ilerler ve sonuçlanır. | 09 §8 |
| UK-05 | Doğru delile dayanan karar oyuncuyu hapse gönderebilir. | 09 §5–6 |
| UK-06 | Hapisten birden fazla çıkış yolu olur. Çıkmak tek hamlede kolay değildir. | 09 §10 |
| UK-07 | Hapisten kaçan oyuncu hakkında kaçış raporu oluşur. | 09 §11 |
| UK-08 | Cezalar ve süreler ağır olmaz. | 09 §9, 03 §9 |
| UK-09 | Ekibin gerçek üretim kapasitesi ilk küçük prototipte öğrenilir. | 07 §2 |
| UK-10 | Haritada hapishane, adalet sarayı ve yeterli işletme alanı bulunur. | 05 §2.3–2.4 |
| UK-11 | İşletme seçenekleri dar olmaz; yeni işletme ve özellik fikirleri geliştirilir. | 10 |
| UK-12 | İnceleme raporla ikinci yapay zekâya aktarılır. | Tamamlandı (arşiv) |
| UK-13 | **Silahlar pahalıdır, ucuz değildir.** | 02 §7.1, 03 §8 |
| UK-14 | **Kimse ölmez. Yaralanır ve hastaneye gider.** | 00 §6, 02 §7.4–7.5 |
| UK-15 | **Yüksek hasar yoktur.** | 02 §7.2, 03 §14 |
| UK-16 | Cevaplanmayan sorular Değerlendirme A'nın önerileriyle doldurulur. | Bölüm 2 |
| UK-17 | Paket profesyonel biçimde güncellenir. | Sürüm 3.0 |

---

## 2. Değerlendirme A'nın yedi sorusu

| Soru | Sonuç | Kaynak | Karar |
|---|---|---|---|
| S1 — Hedef yaş | 16+ ile başla, içeriği Moderate sınırında tut, tüm yaşlar kararını K6'da veriye göre ver. | DY | ORTAK-036 |
| S2 — Çevrimdışı işletme görünümü | K1'de jenerik NPC dükkânı; K5'te salt okunur vitrin kopyası. | DY | ORTAK-037 |
| S3 — Silah ve oyuncular arası şiddet | Pahalı silah, düşük hasar, ölüm yok, hastane (UK-13–15). Hasar yalnız meşru bağlamda. | UK + DY | ORTAK-023 |
| S4 — Suç ekonomisi | Riskli sektörlerde küçük, sigortalı, korumalı kasa. Büyük hedefler NPC'de. Suç yolu temiz yolun en fazla 1,2–1,5 katı temiz servet üretir. | UK-02 + DY | ORTAK-005, 006 |
| S5 — Devamsızlık | İşletme giderlerini kendi çevrimdışı gelirinden öder, yetmezse dinlenmeye geçer, kimse ayrılmaz. İsteğe bağlı dondurma modu. | DY | ORTAK-003 |
| S6 — Avatar ve kıyafet | Roblox avatarı üzerine oyun içi RP kıyafet katmanı. Maske oyun içi eşyadır. | DY | ORTAK-022 |
| S7 — Kapasite ve ilk yayın | Kapasite K0'da ölçülür (UK-09). Geniş katalog vizyonu korunur (UK-11). İlk yayına giren iş kolları K0 sonrasında seçilir. | UK + DY | ORTAK-025, 029 |

---

## 3. Ortak karar listesi

| Kimlik | Konu | Kaynaklar | Sonuç | Karar ve gerekçe | Belgeler |
|---|---|---|---|---|---|
| ORTAK-001 | İşletmenin tek yazarı | A: MIM-01 · B: BC-01, BC-13 | Geliştirildi | İşletme kaydına yalnız sahibinin oturumunu tutan sunucu yazar. Çevrimdışı gelir girişte formülle hesaplanır. Başka sunuculardan gelen etkiler olay kutusuna düşer. Çift gelir, para kopyalama ve çelişen stok önlenir. | 01 §2, 04 §4 |
| ORTAK-002 | Cephe kapasitesi ve yuva sınıfları | A: MIM-02 · B: BC-01, TY-04 · UK-10, UK-11 | Geliştirildi | Kapasite işletme sahibi değil, çevrimiçi fiziksel işletme sayısıyla hesaplanır. Yuva sınıfları: çarşı tezgâhı, standart cephe, büyük cephe, pasaj birimi, sanayi yuvası; mobil işletmeler yuvasızdır. Sahiplik ve kazanç hakkı fiziksel gösterimden ayrıdır. | 01 §2.3, 05 §2.4, 04 §5 |
| ORTAK-003 | Zaman birimleri ve devamsızlık | A: EKO-01 · B: BC-09, YF-07 · S5 | Kabul | Görsel gün, üretim günü, gerçek gün ve infaz süresi ayrı birimdir. Maaş ve ruhsat yalnız üretim süresinde işler. Çevrimdışı 8 saatlik pencereden sonra gelir de gider de durur. Çalışan kaybı yalnız sahibi oyundayken yaşanan ihmalden doğar. | 01 §4, 03 §4, 08 §3 |
| ORTAK-004 | Hesap sözleşmesi ve aritmetik | A: EKO-03 · B: BC-02 | Kabul | Ciro, mal maliyeti, ücret, sabit gider ve net kâr ayrı tutulur. Eski "14.000 ₡ = 20 dakikadan az" hesabı hatalıydı ve düzeltildi. | 03 §3, §6 |
| ORTAK-005 | Kasa, tahsilat, şehir hedefleri ve sektöre göre risk | A: EKO-02 · B: BC-03, TY-02 · UK-02 | Geliştirildi | Üç kavram ayrıldı: soyulabilir kasa, korunan tahsilat, NPC şehir hedefleri. Soyulabilir kasa yalnız nakit riskli sektörlerde bulunur. Dört risk türü tanımlandı: operasyonel, ticari, hukuki, suç kaynaklı. | 02 §10, 03 §7, 10 §4 |
| ORTAK-006 | Suç–meslek hedef oranı | A: EKO-03 · S4 | Kabul | Suç ağırlıklı yol uzun vadede temiz yolun en fazla 1,2–1,5 katı temiz servet üretir. Bu tavanı aklama kotası sağlar, soygun büyüklüğü değil. Oran bir test hedefidir. | 03 §7 |
| ORTAK-007 | Aklama kotası | B: BC-04 · A: EKO-03 | Kabul | Kota, doğrulanmış yasal satışa bağlıdır. Aklanan para ciroya eklenmez, yani kapasiteyi kendi kendine büyütemez. Risksiz, riskli ve yasak bölgeler ayrıdır. Kota oyun günüyle ölçülür ve sunucu değiştirince sıfırlanmaz. | 02 §11, 03 §7.4 |
| ORTAK-008 | Tek çalışan modeli | A: EKO-04 | Kabul | Taksi şoförü de dahil tüm NPC çalışanlar aynı maaş, ruh hali ve verim modelini kullanır. Eski %75 şoför payı kaldırıldı. | 01 §5, 03 §5 |
| ORTAK-009 | Fiyat endeksi ve telemetri | A: EKO-05 · B: BC-10 | Kabul | Giriş fiyatları sabittir. Endeksleme yalnız prestij ürünlerinde ve medyana göre yapılır. Sağlık ölçütleri oyun süresi kohortuna göre izlenir. | 03 §12 |
| ORTAK-010 | Robux ile işletme slotu | A: PLT-02 · B: BC-11 | Kabul | Ücretli işletme slotu kaldırıldı. Robux ile ekonomik güç, yargı veya ceza avantajı satılmaz. | 00 §6, 03 §13 |
| ORTAK-011 | Özel sunucu | A: TEK-02 · B: BC-12 | Kabul | Özel sunucu Game Pass değil, aylık aboneliktir. Standart mod kalıcı ekonomiyi paylaşır; serbest RP modunun kazancı genel ekonomiye taşınmaz. Yönetici araçları ekonomiye ve adalete dokunmaz. | 03 §13, 04 §12 |
| ORTAK-012 | İşlem bütünlüğü | B: BC-13 | Kabul | Para ve eşyanın tek esas kaydı vardır. Her işlemin kimliği vardır ve iki kez uygulanamaz; yarım kalan işlem kurtarılır. Ceza, tahliye ve kaçış işlemleri de bu kurala tabidir. | 04 §4.4 |
| ORTAK-013 | İstemci güvenliği | B: BC-14 · A: (04 §1'i korur) | Kabul | İstemci değer içeren niyet bildirebilir; sunucu tür, sahiplik, mesafe, yetki, sıklık ve tekrar açısından doğrular. "İstemciden hiçbir miktar gelmez" genellemesi kaldırıldı. | 04 §1, A2 §2 |
| ORTAK-014 | Metin ve moderasyon | A: TEK-01 · B: BC-15 | Kabul | Tüm oyuncu metinleri Roblox filtresinden geçer; filtre hata verirse metin yayımlanmaz. Tabela hazır şablondan kurulur. Mesajlar yalnız çevrimiçi ve Roblox sohbet altyapısıyla gider. Radyo oyuncu adı kullanmaz. | 04 §11, 06 §7 |
| ORTAK-015 | NPC mimarisi | A: NPC-01 · B: BC-16 | Kabul | Humanoid'siz NPC'ler AnimationController ile canlandırılır. Hareket, önceden çizilmiş yol ağı üzerinde ucuz arama ile yapılır. Tanık kaydı NPC nesnesinden ayrıdır. NPC sayısı ölçülerek yazılır. | 04 §10, 05 §5.4 |
| ORTAK-016 | Gizli NPC karakteri ve Kural 7 | A: NPC-02 | Kabul | Kural 7 yeniden yazıldı. Fırsatçının aldığı para defterde görünür. İşe alımda referans kontrolü ve deneme süresi var. | 00 §6, 01 §5 |
| ORTAK-017 | Polis etkileşimi: soru, durdurma, arama | A: SUC-02 · B: BC-05 | Geliştirildi | Üç kademe var: gönüllü soru, gerekçeli durdurma, delile dayalı arama. Ret suç veya mahkûmiyet değildir. Sorgu için bekleme süreleri var. Oyuncu ihbarı tek başına dayanak değildir. | 02 §5, 09 §5 |
| ORTAK-018 | Suçun sonuç akışı ve adalet | B: BC-06, TY-01 · UK-03–08 | Kabul | Akış: olay → delil → dosya → karar → infaz → kapanış. NPC mahkeme kurallı çalışır. Oyuncu hâkim yoktur. | 09 |
| ORTAK-019 | Bilgi erişim matrisi ve tanık | A: ENV-03 · B: BC-07 | Kabul | Sahip, polis, yakındaki oyuncu, NPC ve kamera için erişim matrisi tanımlandı. Robot resim suç anının anlık görüntüsüdür. | 02 §4, §8, 04 §2 |
| ORTAK-020 | Envanter birim modeli | A: ENV-01 · B: BC-08 | Kabul | Cep 2 birimdir; küçük eşya 1, orta 2, büyük 4 birim. Temel eşyalar yer tutmaz. Riskli görünürlük değişimi önizleme ve onayla yapılır. | 02 §2–3 |
| ORTAK-021 | Telefon ve ayarlar | A: ENV-02 | Kabul | Ayarlar, yardım ve kurallar telefondan bağımsız menüdedir. Telefonun bedeli yalnız uzaktan yönetimdir. | 01 §9, 06 §4.13 |
| ORTAK-022 | Avatar ve RP kıyafet | A: ENV-03 · S6 | Kabul (DY) | Avatar üzerine oyun içi kıyafet katmanı giyilir. UGC yüz aksesuarları suç sırasında gizlenir. Maske oyun içi eşyadır. | 02 §8, 05 §4 |
| ORTAK-023 | Silah, hasar, yaralanma, hastane | UK-13, UK-14, UK-15 · A: SUC-01 · S3 | Kabul | Silahlar pahalıdır ve düşük hasar verir; ölüm yoktur, yaralı durum ve hastane vardır. Oyuncuya ateş yalnız meşru bağlamda mümkündür. Yaralanan masum hiçbir şey kaybetmez. NPC'ler hasar almaz. Güvenli bölgeler ve yeni oyuncu koruması var. | 00 §6, 02 §7, 03 §8, 09 §6 |
| ORTAK-024 | Şehir alarm seviyesi | A: SUC-03 | Kabul | Oyuncu polis az olduğunda NPC müdahale gücü artar. Yakalanma oranı telemetriyle ölçülen bir hedeftir. | 02 §9.3 |
| ORTAK-025 | İş ve meslek kataloğu | UK-11 · B: TY-03, BC-18 · A: OYN-01 | Geliştirildi | 24 işletmelik vizyon kataloğu ve altı iş ailesi var. Her dalın kendi kararı ve riski var. İlk yayın hedefi 6–8 iş kolu, alt sınır 3; kesin liste K0 ölçümünden sonra belirlenir. Katalog yayın sözü değildir. | 10 |
| ORTAK-026 | İlk oturumda sahiplik | B: BC-17 · A: UX-01, MIM-02 | Geliştirildi | İlk oturum çarşı tezgâhı sahipliğiyle biter. Tezgâh–dükkân–mağaza hattı cephe kıtlığını ilerleme ödülüne çevirir. | 01 §1, §3.3 |
| ORTAK-027 | Geri dönüş: çekiciler | A: UX-02, YNI-03 · B: YF-06, BC-25 | Geliştirildi | Dönüş özeti ilk kalıcı veri sürümünde gelir. Kişisel şehir hafızası sonraki aşamadadır. Baskılar yalnız oyuncu oyundayken işler. | 01 §11, 06 §4.8 |
| ORTAK-028 | Erişilebilirlik | A: UX-03 | Kabul | Bilgi renk, simge ve metinle birlikte verilir. Yazı boyutu ayarlanabilir. Süre dolunca güvenli varsayılan seçilir. | 06 §5 |
| ORTAK-029 | Aşamalar ve kapılar | A: SUR-01 · B: BC-19, TY-05 · UK-09 | Geliştirildi | Katman 0–6 ve yayın sonrası. Eski Katman 2 üçe bölündü: sivil çeşitlilik, suç, adalet. Kapılarda beyan yerine davranış ölçülür. Telemetri K1'de başlar. | 07 |
| ORTAK-030 | Tek doğruluk kaynağı | B: BC-20 | Kabul | Kod için Git/Rojo, sahne için yayınlanan place, kararlar için bu dosya. Her sürümde değişiklik günlüğü tutulur. | 04 §15, 07 §10 |
| ORTAK-031 | Platform bilgileri | A: PLT-01 · B: BC-21 | Kabul | Eşik 250, Restricted 18+, Moderate 9–15'e açılabilir, DevEx 13+, topluluk kurmak 100 Robux. Türkiye erişim durumu çelişkili olarak işaretlendi. | A3 |
| ORTAK-032 | İsimler ve kesinlik dili | A: BLG-01 · B: BC-22 | Kabul | Anadol ve Kartal değiştirildi. "Rakipsiz", "bedava", "çözüldü" gibi ifadeler kanıt düzeyine indirildi. | 05 §7, 08 |
| ORTAK-033 | Şehir sözleşmeleri ve tedarik | B: BC-23 · A: YNI-02 | Geliştirildi | K2'de tek örnek: stok teslimi. Geniş sözleşme sistemi K5 ve yayın sonrasına kaldı. | 10 §8 |
| ORTAK-034 | İşletme uzmanlaşması | B: BC-24 | Ertelendi | Yayın sonrası; ilk denemede iki seçenek. | 10 §9 |
| ORTAK-035 | NPC soruşturma vakaları ve defter bulmacası | B: BC-26 · A: YNI-04 | Geliştirildi | FCU için kurallı NPC vakaları ve defter bulmacası. K3'te prototip, K4'te adalete bağlanır. | 02 §12.4 |
| ORTAK-036 | Konumlandırma | A: S1 · A3 | Kabul (DY) | 16+ ile başla; içerik Moderate sınırında kalsın; alkol ve bar yok; tüm yaşlar kararı K6'da. | 00 §8, A3 §2 |
| ORTAK-037 | Çevrimdışı görünüm | A: S2 | Kabul (DY) | K1'de jenerik NPC dükkânı, K5'te vitrin kopyası. | 01 §2.5 |
| ORTAK-038 | Çevrimdışı soygun | A: MIM-01 (seçenek) · B: 4.1 | Elendi | Çevrimdışı işletme soyulamaz. Gerekçe: UK-08'in ruhu, veri basitliği ve oyunda olmayan kişiye zarar verilmemesi. Yayın sonrası yeniden değerlendirilebilir. | 02 §10.4 |
| ORTAK-039 | Oyuncu hâkim | B: 10.2 | Elendi | İlk sürümde yok. Mahkeme kurallı NPC sistemidir. | 09 §4 |
| ORTAK-040 | Gizleme ekipmanını oyuncu dükkânı satar | A: YNI-01 | Ertelendi | Yayın sonrası aday. | 10 §9 |
| ORTAK-041 | Oyuncunun oyuncuyu işe alması | A: YNI-05 | Ertelendi | Deneysel; ikinci hesapla istismar riski yüksek. | 10 §9 |
| ORTAK-042 | Ev iç mekânı | A: BLG-16 | Kabul | Kapıdan girilen örneklenmiş iç mekân. Mimari karar K1 veri modelinde verilir, ev sistemi K5'te gelir. | 01 §8, 04 §6 |
| ORTAK-043 | İbadethaneler | A: BLG-17 | Kabul | Güvenli bölge: silah çekilemez, suç işlenemez, araç giremez. | 00 §6, 05 §2.7 |
| ORTAK-044 | Harita ölçeği | A: BLG-14 · B: TY-04 | Kabul | Ölçek stud ile değil, yolculuk süresiyle tanımlanır. Eski 2.000 stud değeri iptal edildi. | 05 §2.1 |
| ORTAK-045 | Ses kaynağı kuralı | A: BLG-10 · B: §7 | Kabul | Varsayılan kaynak Creator Store. Başka kaynak yalnız ticari lisansı belgelenmişse kullanılır ve lisans kaydı tutulur. | 00 §6, 06 §8.1 |
| ORTAK-046 | OZEL ve EKIP ayrımı | A: BLG-19 | Geliştirildi | Ekibi ilgilendiren kararlar (konumlandırma, grup sahipliği, gelir paylaşımı konuşması) 00 ve 07'ye taşındı. Kararlar bu dosyada. | 00 §8, 07 §6 |
| ORTAK-047 | İnfaz süresi ve çevrimdışı sayım | UK-06–08 · B: TY-01 | Kabul | Tek infaz tavanı 10 dakikadır. Kaçak değilken çevrimdışı süre sayılır. Zorluk bekleme süresinde değil, erken çıkış ve kaçış yollarındadır. | 09 §9 |
| ORTAK-048 | Kurum yerleşimi | UK-10, UK-14 · B: TY-04 | Kabul | Blackstone'da adalet sarayı, hastane, ruhsat ofisi ve karakol; Wrenmoor'da cezaevi. Hepsi ana planda baştan yer alır. | 05 §2.3 |
| ORTAK-049 | Şirket rehberi | B: YF-01 | Kabul | K1'de, dinamik cephenin kullanıcıya görünen yüzü olarak. | 01 §2.4, 06 §4.10 |
| ORTAK-050 | Olay açıklama kartı | B: YF-08 · A: NPC-02 | Kabul | Her ceza, kayıp ve retle birlikte neden, süre ve çözüm yolunu gösteren kart. | 06 §4.2 |
| ORTAK-051 | Kısa ortaklık, tedarikçi teklifleri, kalite kontrolü, mahalle olayları | B: YF-02–05 | Ertelendi | K5 ve yayın sonrası adayları. | 10 §9 |
| ORTAK-052 | Yeni oyuncu koruması ve güvenli bölgeler | A: SUC-01 · B: TY-02 | Kabul | Sahipliğin ilk 2 aktif saatinde işletme soyulamaz. Oyuncu ilk 2 saatinde hasar almaz. Suç işleyen koruma hakkını kaybeder. | 02 §7.7, §10.4 |
| ORTAK-053 | Ret, şüphe ve dayanak | A: SUC-02 · B: BC-05 | Geliştirildi | Gönüllü soruya ret hiçbir şey üretmez. Gerekçeli durdurmada ret küçük ve sönen bir şüphe üretir, aynı memurdan tekrarında üretmez. Hiçbir durumda tek başına dayanak değildir. | 02 §5 |

---

## 4. Değerlendirmeler arasındaki çelişkiler ve çözümü

**a) Çevrimdışı infaz süresi sayılsın mı?** B evet diyor. A'nın kaygısı, bunun UK-06'yı ("çıkmak kolay olmasın") zayıflatmasıydı. Çözüm: süre sayılır, çünkü UK-08 ağır olmayan cezayı emrediyor ve süreler zaten kısa. UK-06'daki zorluk bekleme süresine değil, erken tahliye ve kaçış yollarına yüklendi. (ORTAK-047)

**b) İlk yayında kaç iş kolu?** A 3 önerdi, B 6–8 önerdi, UK-11 genişlik istiyor. Çözüm: hedef 6–8, alt sınır 3. Kesin sayıyı K0'da ölçülen hız belirler. (ORTAK-025)

**c) Çevrimdışı soygun.** A olay kutusuyla mümkün kılmayı bir seçenek olarak önerdi, B korunan işletme önerdi. Çözüm: korunan işletme. Gerekçesi basitlik ve oyunda olmayan kişiye zarar verilmemesi. (ORTAK-038)

**d) Aşama adları.** B P0–P6 önerdi, eski belgeler "Katman" kullanıyordu. Çözüm: ekibin bildiği "Katman" adı korundu, B'nin yedi aşamalı yapısı K0–K6 olarak benimsendi. (ORTAK-029)

**e) DevEx yaşı.** A doğrulayamamıştı, B 13 dedi. Resmî dokümantasyonla 13 yaş ve 30.000 kazanılmış Robux şartı doğrulandı. A3'teki "18 yaş" bilgisi yanlıştı. (ORTAK-031)

**f) Türkiye erişimi.** B, açılışı haberle destekli saydı. A'nın bulduğu bazı kaynaklar ise resmî engelin sürdüğünü bildiriyordu. Çözüm: "çelişkili" olarak işaretlendi; yayın öncesinde yeniden kontrol edilecek. (ORTAK-031)

**g) Çanta reddi ve şüphe.** A azalan bir şüphe önerdi, B reddin dayanak olmamasını istedi. Çözüm iki kaynağı birleştiriyor (ORTAK-053).

**h) Ceza kavramının kapsamı.** B'nin "mülkiyetin devamlılığı" istisnaları (suç gelirine el koyma, hileli kaydın geri alınması) A'nın "yakalanınca kirli nakde el konması" önerisiyle birleşti. Meşru varlık hiçbir cezayla silinmez. (09 §2, V-A01)

---

## 5. Elenen ve ertelenen fikirler

**Elenenler:**
- Çevrimdışı soygun (ORTAK-038)
- Oyuncu hâkim (ORTAK-039)
- Robux ile işletme slotu (ORTAK-010)
- Pompalı tüfek (UK-15 ile uyumsuz yüksek hasar)
- Taksi şoförüne %75 pay (ORTAK-008)
- Servete endeksli giriş fiyatları (ORTAK-009)
- Oyuncunun serbest metin yazdığı tabela (ORTAK-014)

**Ertelenenler:**
- İşletme uzmanlaşması (ORTAK-034)
- Gizleme ekipmanını oyuncu dükkânlarının satması (ORTAK-040)
- Oyuncu istihdamı (ORTAK-041)
- YF-02–05 (ORTAK-051)
- Kefalet
- Avukat mesleği
- Çanta kapkaçı
- Sahte defter
- Tanık satın alma
- Kişisel şehir hafızası (ORTAK-027'nin ikinci yarısı)

---

## 6. Açık konular

Bunlar onay engeli değildir. İlgili aşamada ölçülür veya kaynakla doğrulanır. Kullanıcı kararı gerekenler işaretlidir.

| Kimlik | Konu | Ne zaman | Kim |
|---|---|---|---|
| AÇIK-01 | **Oyun ve bölge adı çakışması.** "Baycrest", Toronto'daki bilinen bir sağlık kurumunun adıyla; "Blackstone" büyük bir yatırım şirketinin adıyla örtüşüyor. Oyun adı olduğu için değişiklik kullanıcı kararıdır. Marka araması önerilir. | K1 öncesi | **Kullanıcı** |
| AÇIK-02 | Yeni adlar için marka araması: Ova Motors, Siper, Wrenmoor, Verania General Hospital, Baycrest Courthouse. | K3 öncesi | Yönetim |
| AÇIK-03 | Ekonomi başlangıç değerleri. Simülasyon tablosuyla doğrulanacak (03 §15). | K0–K3 | Tasarım |
| AÇIK-04 | Ceza süreleri, toplam tavan ve kaçış zorluğu. | K4 testi | Tasarım |
| AÇIK-05 | NPC, araç ve iç mekân performans bütçesi. Gerçek telefonda ölçülecek. | K1 | Kod |
| AÇIK-06 | Harita ölçeği. Gri kutuda süre hedeflerine göre belirlenecek. | K1–K2 | Harita |
| AÇIK-07 | İlk yayına girecek iş kolları. | K0 sonrası | Yönetim + Tasarım |
| AÇIK-08 | Türkiye erişim durumu ve 7578 sayılı Kanun'un yönetmeliği. | Çeyreklik | Yönetim |
| AÇIK-09 | Tüm yaşlara açılma kararı. | K6 | **Kullanıcı** |
| AÇIK-10 | Gelir modelinin gerçek talebi. | K5–K6 | Yönetim |
| AÇIK-11 | Ev ve işletme iç mekânlarına başkalarının erişim sınırları. | K5 | Tasarım |
| AÇIK-12 | Dava bildirim penceresinin uzunluğu. | K4 | Tasarım |
| AÇIK-13 | **K0 talep panosunun ekonomik ağırlığı.** K0.4.1 ölçümünde panoyu izleyen stok politikası izlemeyene göre 20 dakikada anlamlı fark yaratmıyor (gerçek kaynakla 12 tohumda ortalama −2,2 ₡). Seçenekler (değiştirme / talep döngüsünü uzat / talep bonusunu artır / ikisi) ölçüldü, hiçbiri uygulanmadı: `PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md` §4. Prototip config değeridir; 03 §14 baz çizgisini etkilemez. | K0 oyuncu testi öncesi | **Kullanıcı** + Tasarım |

---

## 7. Kimlik dizini — Değerlendirme A

| Kimlik | Kısa tanım |
|---|---|
| MIM-01 | Çevrimdışı işletmenin tek yazarı yok; çift yazma ve cephe tıkanması |
| MIM-02 | Cephe sayısı başarı hedefiyle çelişiyor; tezgâh–dükkân–mağaza hattı |
| EKO-01 | "Ay" tanımsız; 30 oyun günü = 24 gerçek saat; sınav dönemi sorunu |
| EKO-02 | Kasa, çevrimdışı birikim ve soygun tablosu uyumsuz |
| EKO-03 | Ekonomi modellenmemiş; 14.000 ₡ hesabı hatalı; suç 6–9 kat |
| EKO-04 | Taksi NPC'si %75 ile otomasyon yasasını deliyor |
| EKO-05 | Servete endeksli fiyat yeni oyuncuyu cezalandırıyor |
| SUC-01 | Çatışma, yaralanma, ölüm kuralları yok |
| SUC-02 | Polis ve FCU yetkileri tacize açık |
| SUC-03 | Suç dengesi polis varlığına bağlı |
| ENV-01 | Slot aritmetiği belirsiz |
| ENV-02 | Telefon ayarları envantere bağlıyor |
| ENV-03 | Avatar tanımsız; robot resim canlı olmamalı |
| NPC-01 | NPC mimarisi çelişkili; AnimationController |
| NPC-02 | Gizli karakter Kural 7 ve Kural 1 ile gerilimde |
| TEK-01 | Oyuncu metni için kural yok |
| TEK-02 | Özel sunucu yanlış modellenmiş |
| OYN-01 | İşletme türleri listesi yok |
| UX-01 | İlk 10 dakika tanımsız |
| UX-02 | Geri dönüş kayıp korkusuna dayalı |
| UX-03 | Erişilebilirlik |
| PLT-01 | A3 platform bilgileri eskimiş |
| PLT-02 | +1 slot güç satışı algısı |
| SUR-01 | Kapı testleri öz bildirime dayalı |
| BLG-01 | Anadol ve Kartal gerçek adlar |
| BLG-02–19 | Belge içi tutarlılık düzeltmeleri (değişiklik günlüğünde tek tek) |
| YNI-01–05 | Oyuncu dükkânı ekipman satışı, tedarik zinciri, dönüş özeti, defter bulmacası, oyuncu istihdamı |
