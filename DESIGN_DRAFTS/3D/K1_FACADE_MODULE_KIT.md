# 3D-K1-001 — Modüler cephe başlangıç kiti

**Durum:** TASLAK · **Katman:** K1 hazırlığı · **Öncelik:** P1  
**Kaynak:** `EKIP/05` §2.4, §3.1–3.3, §8; `EKIP/01` §2.3.

## Teslim sınırı

Beş tekrar kullanılabilir parça: düz duvar, köşe, pencere, kapı ve balkonlu duvar. Bu kit ile üç farklı bina silueti oluşturulur. K0 satış döngüsü bitmeden ayrıntılı cephe sanatına yatırım yapılmaz.

## Arayüz sözleşmesi

- Her parça 4 stud ızgarasında başlar/biter; gerçek ölçü ve kapı açıklığı, gri kutu karakter/araç geçişiyle kaydedilir.
- Standart cephe, büyük cephe ve pasaj birimi **ayrı yuva sınıflarıdır**. Bir sınıfın kendi kapı, vitrin, tabela ve iç mekân bağlantı noktaları eşit kalır; sınıflar arasında otomatik eşdeğerlik varsayılmaz.
- Tabela bağlantısı boş tutulur. Hazır işletme şablonu sonradan yerleşir.
- Pencere, köşe ve balkon varyasyonu oyuncu kapasitesini veya haksız görüş avantajını değiştirmez.
- Pivot ve montaj noktası aynı kurala uyar; birleşimlerde görünür boşluk/çakışma olmaz.

## İlk inceleme

1. Üç bina, aynı beş parçadan kurulabilir mi?
2. Oyuncu kapıdan geçer, kaldırıma takılmaz ve tabela oyun kamerasında okunur mu?
3. Aynı mesh/doku kimlikleri tekrar kullanılıyor mu?
4. Gündüz ve akşam siluet farklılığı `EKIP/05` sanat yönünü koruyor mu?
5. Android cihaz ve profiler ölçümü olmadan parça bütçesi `geçti` diye işaretlenmedi mi?

**Açık karar:** Standart yuva kesin en/boy/yükseklik ve tabela ölçüsü K1 gri kutu testinde belirlenir; `KARARLAR.md` AÇIK-06 harita ölçeğiyle birlikte değerlendirilir.

