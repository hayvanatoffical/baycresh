# BAYCREST — Kısa proje bağlamı

**Durum:** 3.0 tasarım baz çizgisinden türetilmiş özet; üretim kanıtı değildir. Ayrıntıda [EKIP/00](../EKIP/00-BASLA-BURADAN.md), [yol haritası](../EKIP/07-YOL-HARITASI.md) ve [karar kaydı](../KARARLAR.md) geçerlidir.

## Oyun ve amaç

Baycrest, kurgusal Verania'nın liman şehrinde geçen çok oyunculu bir şehir hayatı oyunudur. Oyuncu iş kurar, büyütür, çalışan ve araç edinir; risk, envanterin görünürlüğü ve şehrin kuralları yaşam tarzı tercihlerini değiştirir. Tasarım yasası: **Her yol bir imparatorluğa çıkar.** Temiz oyun tam bir yoldur; suç zorunlu değildir.

## Değişmez tasarım sınırları

- Kumar ve Robux ile güç satışı yok.
- Gerçek marka, kurum amblemi, siyasi sembol ve lisansı kanıtlanmamış ses yok.
- Din yalnız çevre ve güvenli alan tasarımıdır; görev/ödül yok.
- Ölüm, yüksek hasar, kan ve gore yok; yaralanma ve hastane var.
- Ceza, kayıp ve ret neden/çözüm yoluyla açıklanır. Meşru varlık normal cezayla silinmez.
- Gizli veri istemciye gönderilmez; para, sahiplik, envanter ve adalet kararları sunucu tarafında doğrulanır.

Tam ve bağlayıcı metin `EKIP/00` §6 ile `KARARLAR.md` içindedir.

## Şu anki üretim sınırı

**Katman 0:** Blackstone Bazaar'ın tek sokaklık gri kutusu; tek tezgâh, tek oyuncu, NPC müşteriye satış, kazanç, tezgâh büyütme, bir çalışan ve bir maaş günü. Polis, silah, suç, mahkeme ve geniş şehir burada üretilmez. Test: üç kişinin ayrı 20 dakikalık oturumu, gönüllü devam ve ertesi gün dönüş (`07` §2).

**Gerçek durum:** `GAME/` altında çalışan K0 Luau kaynakları, sahne ve sanat kurucuları vardır; Roblox place ID `83986068176961` içinde sahiplikten maaşa oynanabilir kesit kuruldu. İki AI mesh prototipte adaydır; onaylı sanat veya K0 oyuncu kabul testi anlamına gelmez. Studio oturumu her görevde yeniden doğrulanır. Kanıt: [K0 sanat/oynanış kontrolü](../PRODUCTION/K0_ART_PLAYCHECK_2026-09-25.md).

## Varlık üretimine etkisi

- Sanat yönü: sıcak renkli, stilize, inandırıcı Akdeniz liman şehri (`05` §1).
- Modüler parçalar 4 stud ızgarasına uyar; aynı yuva sınıfının arayüzleri özdeş olur (`05` §3, `01` §2.3).
- Tabela alanı hazır şablon sistemi için boş kalır; serbest oyuncu metni varlığa gömülmez.
- İlk 3D önceliği oynanışa hizmet eden tezgâh ve gri kutudur; dekoratif bina ayrıntısı K0 kapısını geciktirmez.
- Sayısal performans değerleri başlangıç hedefidir; gerçek cihaz testi olmadan kesin sınır diye kullanılmaz.
