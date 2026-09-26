# BAYCREST — Teknik

**Sürüm:** 3.0 · 24 Eylül 2026
**Durum:** Teknik tasarım baz çizgisi; gösterilen kod şekilleri uygulanmış servis değildir.
**Okuyucu:** Kodcular
**Ön koşul:** `00`, `01`, `02`, `03`, `09`
**Bağlı kararlar:** ORTAK-001, 002, 011, 012, 013, 014, 015, 018, 019, 030, 042

Bu belge Roblox'un temellerini anlatmaz. Yalnızca **bu oyunun** zor kısımlarını anlatır.

---

## 1. Altın kural ve iki özel tuzak

Para, envanter, sahiplik, aranma, dava, infaz ve satın alma sunucuda hesaplanır. İstemci **niyet bildirir**; sunucu doğrulamadan hiçbir niyeti kabul etmez.

> **Doğru kural:** İstemci "şu kasadan şu tutarı çekmek istiyorum" diyebilir. Sunucu, oyuncunun o işletmenin sahibi olduğunu, kasada o tutarın bulunduğunu, oyuncunun kasaya yakın olduğunu ve isteğin makul sıklıkta geldiğini doğrular. Eski belgedeki "istemciden hiçbir miktar gelmez" ifadesi gereksiz bir genellemeydi (ORTAK-013).

Her uzak çağrı için şu yedi kontrol yazılır: **tür, değer aralığı, sahiplik, mesafe, yetki, sıklık, tekrar.**

### 1.1 Birinci tuzak: görünürlük bir oyun kuralıdır

> Sunucu, bir oyuncunun görmemesi gereken veriyi o oyuncunun istemcisine **hiç göndermez.**

Bir oyuncunun cebindeki tabancayı istemciye gönderip görsel olarak gizlemek yeterli değildir; hile yapan istemciye gönderilen her veriyi okur.

```lua
-- YANLIŞ: herkese tam envanteri gönder, istemci gizlesin
envanterRemote:FireAllClients(oyuncu, tamEnvanter)

-- DOĞRU: her istemciye yalnız onun görme hakkı olanı gönder
for _, izleyici in Players:GetPlayers() do
    local gorunur = self:gorunurEnvanteriHesapla(oyuncu, izleyici)
    envanterRemote:FireClient(izleyici, oyuncu, gorunur)
end
```

Sızıntı yalnız uzak çağrılardan olmaz. Ortak nesnelerin özellikleri, `Attributes`, etiketler ve `ReplicatedStorage`'daki tablolar da herkese kopyalanır. Gizli durum yalnız `ServerStorage` ve `ServerScriptService` içinde tutulur.

### 1.2 İkinci tuzak: işletmenin tek yazarı vardır

Oyuncu birden çok sunucuda değildir, ama işletmesinin etkileri farklı yerlerden gelebilir: mahkeme kararı, denetim, çevrimdışı hesap.

> Bir işletme kaydına yalnız **o oyuncunun oturumunu tutan sunucu** yazar. Başka hiçbir sunucu o kaydı değiştirmez.

Diğer sunucuların üreteceği etkiler kayda değil, **olay kutusuna** yazılır (§4.3).

## 2. Görünürlük servisi

`gorunurEnvanteriHesapla(oyuncu, izleyici)` fonksiyonu `02-ENVANTER-VE-SUC.md` §4'teki matrisi uygular. Döndürdükleri:

- Ellerdeki ve sırttaki eşyalar: herkese.
- Çanta nesnesinin kendisi ve tipi: herkese.
- Çanta içeriği: yalnız sahibine, göstermeyi kabul ettiği polise ve delile dayalı arama yapan polise.
- Cep içeriği: yalnız sahibine.
- Açık çanta veya bagaj içeriği: menzildeki ve görüş hattındaki oyunculara, açık kaldığı sürece.

Kurallar:

- **Açıklanan bilgi geri alınmaz.** Çanta kapandığında istemciye "unut" demek bir güvenlik önlemi değildir. Açıkken gönderilmiş olması bilinçli bir tasarım sonucudur.
- **İzin süreli ve kapsamlıdır.** Polise verilen gösterme izni yalnız o polis, o çanta ve 30 saniye içindir.
- Bu tek fonksiyon imza sisteminin güvenliğini taşır. Yapay zekâya yazdırdıktan sonra elle gözden geçirin.

## 3. Servis yapısı

```
ReplicatedStorage/
├── Ortak/
│   ├── Ayarlar.lua          -- tüm sayısal değerler (03 §14)
│   ├── Tipler.lua
│   ├── Metinler.lua         -- tüm metinler, dil desteği
│   └── Yardimcilar.lua
├── Remotes/
│   ├── Events/
│   └── Functions/
└── Assets/

ServerStorage/
└── GizliVeri/               -- istemciye asla kopyalanmaz

ServerScriptService/
├── Servisler/
│   ├── VeriServisi.lua        -- DataStore, oturum kilidi, uyku, sürüm göçü
│   ├── IslemServisi.lua       -- işlem kimliği, tekrar koruması, kurtarma
│   ├── EkonomiServisi.lua     -- para, telemetri, prestij endeksi
│   ├── EnvanterServisi.lua    -- birimler, gizleme, görünürlük
│   ├── SahiplikServisi.lua    -- işletme kaydı, yuva atama, rehber
│   ├── CalisanServisi.lua     -- NPC çalışan, maaş, karakter, ipucu
│   ├── IsletmeServisi.lua     -- kasa, seviye, üretim günü, soygun
│   ├── TanikServisi.lua       -- tanık kaydı, anlık görüntü, robot resim
│   ├── SupheServisi.lua       -- yumuşak şüphe
│   ├── AranmaServisi.lua      -- sert aranma, şehir alarm seviyesi
│   ├── CatismaServisi.lua     -- hasar, bağlam kuralı, yaralı, hastane
│   ├── AklamaServisi.lua      -- kota, tutarsızlık
│   ├── DenetimServisi.lua     -- dosya, FCU, NPC vakaları
│   ├── AdaletServisi.lua      -- delil, dava, karar, infaz, kaçış
│   ├── NPCServisi.lua         -- yaya, müşteri, devriye havuzu
│   └── ModerasyonServisi.lua  -- metin filtresi, engelleme, raporlama
└── Baslat.server.lua

StarterPlayer/StarterPlayerScripts/
└── Kontrolculer/
    ├── ArayuzKontrolcusu.lua
    ├── EnvanterKontrolcusu.lua   -- yalnız gösterir, karar vermez
    ├── GirdiKontrolcusu.lua
    └── KameraKontrolcusu.lua
```

Her servis aynı iskeleti kullanır: `.yeni()`, `:baslat()`, iş fonksiyonları. Tutarlılık, yapay zekâya iş yaptırırken kaliteyi belirgin şekilde yükseltir.

`AdaletServisi` tek bir servistir; içinde delil, dava, karar, infaz ve kaçış modülleri bulunur. Her kavram için ayrı servis gerekmez.

## 4. Veri ve sahiplik

### 4.1 Oyuncu verisi

```lua
OyuncuVerisi = {
    surum        = 3,
    banka        = 0,
    nakit        = 0,
    kirliNakit   = 0,
    envanter     = {},
    isletmeler   = {},        -- isletmeId listesi
    araclar      = {},
    ev           = nil,
    lisanslar    = {},
    itibar       = { yasal = 0, sokak = 0 },
    meslekKidem  = {},
    adalet       = {
        acikDosyalar = {},
        infaz        = nil,   -- { verdictId, kalanSaniye, baslangic }
        kacak        = nil,   -- { caseId, kalanSaniye, sonGorulme }
        gecmis       = {},    -- sınırlı, kapanmış kayıtlar
    },
    olayKutusu   = {},        -- işlenmemiş dış etkiler
    korumaBitis  = 0,         -- yeni oyuncu koruması
    sonGiris     = os.time(),
}
```

**Veri sürümü zorunludur.** Sürüm 2 verisi sürüm 3'e göçerken: slotlar birimlere çevrilir, taksi payı çalışan kaydına dönüşür, adalet ve olay kutusu alanları boş olarak eklenir.

### 4.2 İşletme kaydı

```lua
Isletme = {
    isletmeId     = "ISL-4821",
    sahipUserId   = 12345678,
    aile          = "Perakende",
    tip           = "Market",
    seviye        = 3,
    tercihliAdres = "Ironhill_Cephe_07",
    yuvaSinifi    = "StandartCephe",
    kasa          = 840,
    tahsilat      = 12400,        -- korunan, soyulamaz
    stok          = {},
    yukseltmeler  = { kamera = 2, alarm = true },
    calisanlar    = { {npcId=1, karakter="firsatci", ruhHali=0.8, sonMaas=0} },
    tabela        = { sablonId = 12, metin = "Kaya Market", renk = Color3 },
    uretimGunu    = { gecenSaniye = 1200, sayac = 41 },
    gunlukYasalSatis = 0,
    aklananBugun  = 0,
    tutarsizlik   = 0,
    donduruldu    = false,
    uykuda        = false,
}
```

`tabela.metin` filtreden geçmiş metindir; `sablonId` hazır şablonu gösterir (§11).

### 4.3 Olay kutusu

Sahibi oyunda olmayan bir işletmeyi veya oyuncuyu etkileyen her şey, kayda değil oyuncunun olay kutusuna yazılır:

```lua
Olay = {
    olayId    = "EVT-9f3a",      -- benzersiz; iki kez işlenmez
    tur       = "MahkemeKarari", -- Denetim | Tahliye | SigortaOdemesi | ...
    zaman     = os.time(),
    veri      = { caseId = "CASE-221", verdictId = "VER-118" },
}
```

Oyuncu giriş yaptığında `VeriServisi` olay kutusunu sırayla işler ve sonuçları **dönüş özetine** yazar (`06` §4.8). Aynı `olayId` iki kez işlenmez.

Olay kutusuna yazma, tek yazar kuralının istisnası değildir: kutu ayrı bir DataStore anahtarıdır ve yalnız eklenir. İşletme kaydına dokunulmaz.

### 4.4 İşlem bütünlüğü

`IslemServisi`, iki taraflı ve kritik işlemleri yönetir: aklama, oyuncular arası ödeme, sigorta, para cezası, el koyma, satın alma.

Kurallar:

- Her işlemin benzersiz bir `islemId`'si vardır ve tamamlanan kimlikler kaydedilir. Aynı kimlik ikinci kez uygulanmaz.
- Para ve eşyanın **tek esas kaydı** vardır. Kirli nakit yalnız envanterde tutulur; ayrı bir bakiye olarak ikinci kez tutulmaz.
- İki taraflı işlemler iki aşamalıdır: önce rezerve, sonra onay. Yarım kalan işlem, taraflardan biri giriş yaptığında kurtarılır.
- `UpdateAsync` tek bir anahtarı korur; birden çok anahtarı kapsayan işlem otomatik olarak atomik olmaz. Bu yüzden rezerve-onay deseni gerekir.
- Ceza, tahliye ve kaçış işlemleri de bu kurala tabidir (`09` §13).

### 4.5 DataStore kuralları

- Her yazma `pcall` içinde.
- **Oturum kilidi zorunlu.** Aynı hesap iki sunucuda açılırsa veri kaybolur. Kendi kilidinizi yazmak yerine yaygın ve denenmiş bir kütüphane (örneğin ProfileStore) kullanmak bir tercih olarak değerlendirilmelidir.
- Otomatik kayıt: 120 saniyede bir, çıkışta ve `BindToClose` ile.
- Oyuncu başına dakikada 1 yazmayı geçmeyin.
- Veriye sürüm numarası koyun ve göç yolunu yazın.

### 4.6 Ev iç mekânı

Ev, kapıdan girilen **örneklenmiş iç mekândır** (ORTAK-042). Dış cephe herkese ortaktır. Kapıdan girildiğinde sahibinin iç mekân verisinden o oyuncuya özel bir alan yüklenir. Misafirler yalnız davetle girer. Bu tasarım paralel sunucu sorununu evde tamamen ortadan kaldırır.

## 5. Yuva atama

### 5.1 Akış

```
Oyuncu sunucuya girdi
  → VeriServisi veriyi ve olay kutusunu yükledi
  → SahiplikServisi her fiziksel işletme için:
      1. tercihliAdres bu sunucuda boş mu?      → oraya
      2. aynı sınıfta boş yuva?                  → en yakınına + bildirim
      3. komşu sınıfta eşdeğer yuva?             → oraya
      4. pasaj birimi boş mu?                    → oraya
      5. hiçbiri yoksa                           → "uzaktan hizmet" durumu
  → Rehber güncellenir
```

"Uzaktan hizmet" durumundaki işletme fiziksel olarak görünmez, ama tam gelir üretir ve yönetilebilir. Oyuncuya durum açıkça bildirilir.

### 5.2 Havuz ve serbest bırakma

- Yuva havuzu sunucu başına tutulur.
- Oyuncu ayrıldığında yuvası 5 dakika ona ayrılır, sonra havuza döner.
- Boş yuvalar jenerik NPC dükkânlarıyla doldurulur (K1). K5'te salt okunur vitrin kopyaları eklenebilir.
- Kapasite: sunucu başına yaklaşık 70 yuva (`01` §2.3). Doluluk telemetriyle izlenir; %85'i sürekli aşarsa kapasite artırılır.

### 5.3 Rehber

`SahiplikServisi` her sunucuda bir rehber tablosu tutar: işletme kimliği, ad, aile, durum (açık, NPC modunda, uzaktan) ve güncel adres. Telefondaki Rehber sekmesi bunu okur. İşletme kimliği sabittir; adres sunucuya göre değişir.

## 6. Envanter tekniği

### 6.1 Veri şekli

```lua
Envanter = {
    cepler  = { {}, {} },          -- her biri 2 birim
    sirt    = nil,                 -- yalnız uzun sınıf
    eller   = nil,
    canta   = { tip = nil, kapasite = 0, esyalar = {} },
    -- türetilmiş, kaydedilmez:
    gizlemeDurumu = {},
    acikGosterim  = nil,           -- { hedef = polisUserId, bitis = os.clock()+30 }
}
```

Temel eşyalar (kimlik, cüzdan, anahtarlık, ruhsat kartları) envanterde tutulmaz; bir bayraktır.

### 6.2 Zorunlu doğrulamalar

| Kontrol | Neden |
|---|---|
| Eşya gerçekten oyuncuda mı | Sahip olmadığı şeyi yerleştiremez |
| Boyut sınıfı ve birim hesabı doğru mu | Tüfek cebe girmez; 2 birimlik eşya 2 birim tutar |
| Sırt yalnız uzun sınıf mı | Tabanca sırta takılmaz |
| Gizleme ekipmanı var mı | Kılıfsız tabanca cebe gizlenemez |
| Çanta ve bagaj kapasitesi | — |
| Nakit birim hesabı | Cüzdan 2.500 ₡, sonra her 5.000 ₡ için 1 birim |
| Oyuncu eşyaya yakın mı | Uzaktan alma engeli |
| İstek sıklığı makul mu | Spam engeli |

### 6.3 Gizleme kuralının doğru uygulaması

Kılıfı olmayan bir oyuncu tabancayı cebe koymak isterse sunucu işlemi **reddeder** ve istemciye bir önizleme gönderir: "Kılıfın yok, elinde taşınacak. Onaylıyor musun?" Oyuncu onaylarsa eşya ellere gider.

Bu, sürüm 2.0'dan bir değişikliktir. Eskiden sunucu eşyayı doğrudan ele koyuyordu; bu, yanlış bir arayüz hareketini bir suç olayına çevirebiliyordu. **Kural aynı, sunum değişti:** gizleyemediğin şeyi elinde taşırsın, ama bunu bilerek yaparsın.

### 6.4 Şişkinlik

Şişkinliğin fark edilmesi sunucuda hesaplanır ve yalnız fark eden NPC'nin şüphe kaydına yazılır. İstemciye o anda hiçbir şey gönderilmez. Kural 7'ye uygunluğu şöyle sağlanır: kayıt, oyuncuya açılan bir dosyada veya polis sorgusundan sonra görünür hâle gelir. Gizli bilgi sonradan okunabilir bir iz bırakır.

## 7. Çatışma ve sağlık

`CatismaServisi`, UK-13, UK-14 ve UK-15'i uygular.

**Bağlam kontrolü.** Her atış isteğinde sunucu meşru bağlamı doğrular (`02` §7.3): görevli polis ve aranan kişi, aktif suç alanı, veya son 60 saniyede hasar veren kişi. Bağlam yoksa atış reddedilir ve istemciye sebep gönderilir. Bağlam listesi `Ayarlar.lua`'dan okunur.

**Hasar.** Hasar sunucuda hesaplanır. İstemci yalnız atış niyeti ve nişan yönü bildirir; sunucu isabet, mesafe, mühimmat ve atış hızını doğrular. Kafa çarpanı yoktur.

**Yaralı durumu.** Can sıfıra inince `Humanoid.Health` 1'e sabitlenir ve oyuncu yaralı duruma geçer. Ölüm olayı tetiklenmez, karakter yeniden doğmaz. Bu yaklaşım önemlidir: `Humanoid.Died` tetiklenirse Roblox'un varsayılan yeniden doğması devreye girer ve envanter yönetimi bozulur.

**Düşen eşyalar.** Kirli nakit ve ruhsatsız silah, yalnız polis rolündeki oyuncular tarafından alınabilen bir nesneye dönüşür. Nesne 120 saniye sonra kaybolur ve içindeki para ekonomiden çıkar (`03` §11).

**NPC'ler hasar almaz.** Silah çekildiğinde tepki verirler; can sistemleri yoktur.

## 8. NPC mimarisi

### 8.1 Performans gerçeği

Pahalı olan NPC'nin kendisi değil; `Humanoid`, çalışma anında yol bulma, fizik simülasyonu ve gölgedir.

| Yaklaşım | Beklenen kapasite |
|---|---|
| Humanoid + PathfindingService | ~40 |
| Basit model + yol ağı + Tween | 100–150 (ölçülecek) |

**Bu sayılar ölçülmemiş tahminlerdir.** K1'de gerçek bir orta seviye Android cihazda karşılaştırmalı olarak ölçülecek ve bu belgeye ölçülmüş değer yazılacaktır (AÇIK-05).

### 8.2 Kurallar

- NPC'lerde `Humanoid` **kullanma**. Basit model ve `TweenService`.
- **Animasyon için `AnimationController` ve `Animator` kullan.** Sürüm 2.0'daki "Humanoid olmadan Animator kullanılamaz" ifadesi yanlıştı. Eklemleri tek tek Tween'lemek hem zor hem pahalıdır (ORTAK-015).
- Hareket, önceden çizilmiş bir **yol ağı** üzerinde yapılır. Olaya koşması gereken NPC (devriye, ambulans) bu ağ üzerinde ucuz bir en kısa yol araması yapar. Çalışma anında `PathfindingService` çağrılmaz.
- Oyuncudan uzaktaki NPC'ler devre dışı bırakılır.
- **Havuz kullan.** Yeni NPC yaratılmaz; havuzdan alınır ve geri konur.
- NPC'lerde `CastShadow = false`.

### 8.3 Görünüm çeşitliliği

50–100 farklı NPC görünümü bir tablodur ve **çalışma zamanı maliyeti çok düşüktür**; bellek ve doku maliyeti vardır, bu yüzden "bedava" değildir. Kıyafet seti, saç, renk ve boy kombinasyonlarıyla üretilir. Maliyeti olan asıl şey aynı anda kaç NPC'nin hareket ettiğidir.

**Tanık sistemi için zorunlu:** Kıyafet renkleri net ayırt edilebilir olmalıdır. Tarif "mavi ceketli" diyecekse mavi gerçekten mavi olmalı.

### 8.4 Tanık maliyeti

Görüş hattı kontrolü her karede değil, **yalnız suç anında bir kez** yapılır. Suç anında menzildeki NPC'lere tek tur raycast atılır. Şehrin dolu olmasıyla tanık sisteminin çalışması çatışmaz.

Tanık kaydı NPC nesnesinden ayrı saklanır. NPC havuza dönse de kayıt dosyada kalır (ORTAK-015).

## 9. Adalet servisi

`AdaletServisi` `09-ADALET-VE-ANAYASA.md`'yi uygular.

### 9.1 Veri şekli

```lua
Dosya = {
    caseId       = "CASE-221",
    sucKodu      = "S-03",
    sanikUserId  = 12345678,
    deliller     = { {tur="SistemOlayi", kaynak="EVT-771", guc="olay"},
                     {tur="Tanik", kaynak="WIT-9", guc="guclu", anlikGoruntu=...} },
    durum        = "Bildirim",   -- IlkInceleme | Sorusturma | Bildirim | Karar | Infaz | Kapali
    planlananAn  = os.time() + 600,
    islendiAn     = nil,
    kuralSurumu  = 3,
}

Karar = {
    verdictId  = "VER-118",
    caseId     = "CASE-221",
    sonuc      = "Mahkumiyet",   -- Beraat | Mahkumiyet | DelilYetersiz
    gerekce    = { kullanilanDeliller = {...}, karsilananSart = "guclu-kimlik-bagi" },
    yaptirim   = { paraCezasi = 0, hapisSaniye = 240, elKoyma = {"KirliNakit"} },
    uygulandi  = false,
}
```

### 9.2 Delil–sanık bağı

Her delil kaynağıyla birlikte saklanır. Bir tanık kaydı, görüntüsünü ürettiği oyuncunun kimliğini taşır. Mahkeme, dosyadaki sanığın delil kaynaklarıyla eşleştiğini doğrular.

> Sunucu faili bilir; mahkeme yalnız **toplanmış delili** görür.

Bu sayede masum bir oyuncu başkasının suçundan mahkûm olamaz ve suçlu, delil toplanmadıkça mahkûm olmaz.

### 9.3 Zamanlanmış işlem ve tek yazar

Bir dosyanın planlanan değerlendirme zamanı geldiğinde sanık oyunda olmayabilir.

- Dosyalar ayrı bir **adalet kuyruğunda** tutulur.
- Kuyruğu işleyen sunucu, dosya üzerinde kısa süreli bir kilit alır. İki sunucu aynı dosyaya farklı sonuç yazamaz.
- Karar üretilir ve sanığın **olay kutusuna** yazılır. Sanığın kaydına dokunulmaz.
- `planlananAn` ve `islendiAn` ayrı tutulur. Geciken işlemler geciktiği için ek ceza üretmez.
- Sahte oyuncu katılımı veya sahte fiziksel olay **üretilmez**. Kayıtta durum "yokluğunda, temsil yoluyla sonuçlandı" olarak tutulur.

### 9.4 İnfaz durumu

- Oyuncu giriş yaptığında `adalet.infaz` kontrol edilir. Kalan süre varsa cezaevinde, yoksa serbest başlar ve karar özetini görür.
- Kaçak değilken geçen gerçek zaman süreden düşülür (ORTAK-047).
- Sunucu değiştirme, yaralanma, avatar sıfırlama ve yeniden giriş infazı sıfırlamaz.
- Her `verdictId` yalnız bir kez uygulanır (V-A10).

## 10. Araç sistemi

**Sıfırdan yazmayın.** Araç fiziği Roblox'ta aylar alır.

Creator Store'dan hazır bir şasi alın. Alırken:

- Lisansının ticari kullanıma açık olduğunu doğrulayın ve lisans kaydını tutun.
- **İçindeki script'leri okuyun.** Kötü niyetli script içeren varlıklar yaygındır.
- Sunucu tarafını kendiniz gözden geçirin; hazır sistemlerin çoğu hile korumasızdır.

Sizin yazacağınız katman: sahiplik, plaka, hasar, yakıt, bagaj envanteri, NPC şoför ve bagajın görünürlük kuralları.

## 11. Metin, moderasyon ve sosyal güvenlik

`ModerasyonServisi` (ORTAK-014):

- **Tüm oyuncu metinleri** Roblox'un metin filtresinden geçer: tabela metni, işletme adı, mesaj. **Filtre hata verirse metin yayımlanmaz.**
- **Tabela** hazır şablon ve sınırlı bir kelime havuzundan kurulur; serbest metin yoktur. Yeni kelimeler ekip onayıyla havuza eklenir.
- **Mesajlaşma** Roblox'un sohbet altyapısı üzerinden ve yalnız çevrimiçi oyuncular arasında yapılır. Çevrimdışı mesaj kutusu yoktur.
- **Engelleme** bütün yüzeylerde geçerlidir: telefon, mahkeme salonu, cezaevi ortak alanı, yakınlık sohbeti.
- **Raporlama** her sosyal yüzeyde bulunur ve telefondan bağımsız menüdedir.
- **Haber radyosu** oyuncu adı, işletme adı veya serbest metin kullanmaz. Yalnız olay türü ve mahalle: "Ironhill'de bir markette soygun bildirildi."
- Moderasyon kayıtlarına erişim ekiple sınırlıdır ve saklama süresi tanımlıdır.

## 12. Özel sunucular

- Özel sunucu, Roblox'un yerleşik **aylık abonelik** özelliğidir; Game Pass değildir (ORTAK-011).
- **Standart mod:** Kalıcı ekonomiyi paylaşır. Soygun ödülü %50 çarpanla uygulanır.
- **Serbest RP modu:** Ayrı bir kayıt alanı kullanır. Kazanç ve adalet sonuçları kalıcı ekonomiye taşınmaz. Mod ekranda sürekli görünür.
- Yönetici araçları yalnız sunucu yönetimini kapsar: atma, saat, hava, etkinlik. **Para, eşya, aranma, dava, karar ve infaza dokunamaz.**
- Sunucu sahibinin oyuncu verisini değiştirebildiği hiçbir uzak çağrı bulunmaz.

## 13. Performans bütçesi

Oyuncuların büyük kısmı telefondan oynuyor.

Bu tablo bir **ilk hedefler listesi**dir; platform garantisi veya ölçülmüş sonuç değildir. K1'de hedef cihaz, sahne ve test koşulları kaydedilerek profil çıkarılır. Limit aşılırsa önce darboğaz bulunur, sonra varlık ve sistem bütçeleri güncellenir.

| Ölçüt | Hedef |
|---|---|
| Hedef cihaz | Orta seviye Android |
| FPS | 30+ |
| Sunucu adım süresi | < 10 ms |
| Aynı anda hareket eden NPC | Başlangıç tahmini ≤ 120; ölçümle belirlenecek |
| Ekrandaki parça sayısı | İlk inceleme eşiği ≤ 8.000; tek başına FPS ölçütü değil |
| Küçük prop dokusu | 512×512 veya altıyla başla; görünürlük ve bellek ölçümüne göre ayarla |

**Başlangıç teknik yönü:** Büyük harita için `StreamingEnabled` açılması değerlendirilir; yükleme, görünürlük ve oynanış akışları birlikte test edilir. Uzak nesneler için uygun ayrıntı düzeyi, ışık kaynağı sınırı ve mesh çarpışma doğruluğu profille seçilir.

**Ölçüm K1'de yapılır**, yayın öncesinde değil. Gerçek cihazda bellek, ağ trafiği, animasyon ve görüş kontrolleri birlikte ölçülür.

## 14. Test

Studio'nun gömülü MCP sunucusu oyunu başlatma, karakter hareketi, giriş simülasyonu, ekran görüntüsü ve konsol okuma araçları sağlar. Otomatik regresyon senaryoları kurulabilir. Ekip için bağlantı ve doğrulama akışı: `AI_CONTEXT/ROBLOX_WORKFLOW.md`.

### 14.1 Veri testi protokolü

1. Oyundan çık, gir. Veri duruyor mu?
2. İki sekmede aynı hesapla gir. Ne oluyor?
3. Oyun ortasında Studio'yu zorla kapat. Son 2 dakika kayboldu mu?
4. İşletme satın al, hemen çık, gir. Duruyor mu?
5. Aklama işlemi sırasında bağlantıyı kes. Para kayboldu mu, çoğaldı mı?
6. Bunu 50 kez tekrarla.

### 14.2 Adalet testi protokolü

1. Dosya açıkken çık, süre geçsin, gir. Karar doğru uygulanmış mı?
2. İki sunucuda aynı anda aynı dosya işlenmeye çalışılırsa ne olur?
3. İnfaz sırasında çık, gir. Süre doğru mu?
4. Kaçış sırasında bağlantıyı kes. Kaçış başarılı sayıldı mı? (Sayılmamalı.)
5. Aynı kararı iki kez uygulamayı dene.

### 14.3 İnsan eliyle yapılması zorunlu olanlar

- **Start Server + 2 Player.** Çok oyunculu mantık için zorunlu insan denetimli kabul testidir; otomatik test bunun yerini tek başına almaz.
- **Kötü niyetli test.** Her sistemi bozmaya çalışın: uzaktan tıklayın, spam yapın, ortada çıkın, iki hesapla girin, birbirinizi yaralamayı deneyin.
- **"Bu eğlenceli mi" kararı.** Yapay zekâ bunu cevaplayamaz.

## 15. Sürüm kontrolü ve tek doğruluk kaynağı

| Alan | Tek kaynak |
|---|---|
| Kod | Git deposu ve Rojo ile senkronize kaynak (kurulduğunda; mevcut belge paketi henüz kod deposu değildir) |
| Sahne ve varlıklar | Yayınlanan place; haftalık `.rbxl` yedeği |
| Ekonomi ve oyun ayarları | Tasarım baz çizgisi `03-EKONOMI.md` §14; uygulandığında `Ayarlar.lua` ile birlikte güncellenir |
| Metinler | `Metinler.lua` |
| Kararlar | `KARARLAR.md` |

- Team Create kullanılır, ama aynı script'i iki kişi aynı anda düzenlemez.
- MCP ile yapılan değişiklikler de Git'e işlenir. Yalnız Studio içinde kalan bir değişiklik "yapılmış" sayılmaz.
- Her önemli değişiklik kısa bir not ve karar kimliğiyle gruba yazılır.

## 16. Yapay zekânın bu projede sık yaptığı hatalar

Genel listeler değil, **bu oyuna özgü** olanlar:

| Hata | Nasıl fark edersin |
|---|---|
| Tam envanteri tüm istemcilere yayar | `FireAllClients` içinde envanter görürsen dur |
| Gizli veriyi Attribute veya ReplicatedStorage'a koyar | Gizli durum ortak nesnedeyse dur |
| Gizleme kuralını "hata" sanıp düzeltir | Kılıfsız tabanca sessizce cebe giriyorsa yanlış |
| İşletmeyi tüm sunuculara küresel kilitler | Tek bir global tablo görürsen dur |
| Çevrimdışı işletmeyi sunucuda simüle eder | Sahibi yokken kayda yazan kod varsa dur |
| Kasa tutarını istemciden alır ve doğrulamaz | `OnServerEvent` parametresi doğrulanmadan kullanılıyorsa yanlış |
| Bu proje için seçilen NPC mimarisine gerekçesiz `Humanoid` ekler | Mimari ve cihaz bütçesi yeniden incelenmeden kabul edilmez |
| NPC animasyonu için Tween zinciri yazar | AnimationController kullanılmalı |
| Denetimi anında tetikler | Bir oyun günü gecikme olmalı |
| Cezayı meşru varlığa uygular | Dükkân, araç veya ev siliniyorsa yanlış |
| Ölüm ve yeniden doğma yazar | Bu oyunda ölüm yok; yaralı durumu var |
| Kafa atışı çarpanı ekler | UK-15'e aykırı |
| Aynı kararı tekrar uygular | `verdictId` kontrolü yoksa yanlış |
| DataStore'u pcall'suz çağırır | Veri kaybı |

Kod yazdırdıktan sonra her seferinde şunu sorun: *"Bu kodu hile yapan biri nasıl kötüye kullanır?"*
