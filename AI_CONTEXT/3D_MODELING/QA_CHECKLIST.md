# 3D varlık kabul kontrolü

**Kullanım:** Her varlıkta brief'e bağlantı ver, sonucu `geçti / kaldı / ölçülmedi` yaz. `Ölçülmedi`, `geçti` değildir.

## P0 — Oynanışı ve kuralları bozan durumlar

- [ ] Varlık doğru katmana ve doğru Studio place'ine ait.
- [ ] Çarpışma, oyuncu/NPC yolunu ve etkileşim noktasını engellemiyor.
- [ ] Aynı yuva sınıfında ölçü ve bağlama yüzeyleri tutarlı.
- [ ] Gerçek marka, kurum amblemi, telifsiz olduğu kanıtlanmamış içerik, kan/gore ve yasak kapsam yok.
- [ ] İçinde istenmeyen script, Remote veya beklenmeyen nesne yok.

## P1 — Görsel ve teknik kalite

- [ ] Pivot, yön ve Studio'daki gerçek ölçü brief'e uyuyor.
- [ ] Gündüz ve gece/akşam, oyun kamerası ve mobil ekranda okunuyor.
- [ ] Yüzey, normal, UV, doku kenarı ve kapalı geometri hatası yok.
- [ ] Dekoratif parçanın gereksiz çarpışması/sorgusu kapalı; temas eden yüzeylerin çarpışması doğru.
- [ ] Tekrar edilen varlık aynı mesh/doku kimliğini paylaşıyor.
- [ ] Üçgen, doku ve sahne maliyeti kaydedildi; ölçülmemiş hedef sonuç diye sunulmuyor.

## P2 — Teslim ve izlenebilirlik

- [ ] Kaynak model, export ve Studio yolu/asset ID kayıtlı.
- [ ] Kaynak/lisans kanıtı `PRODUCTION/ASSET_PROVENANCE.md` içinde.
- [ ] Brief ve asset register güncel.
- [ ] Test sürümü, cihaz, sahne ve gözden geçiren kayıtlı.
- [ ] Geri alma yolu veya önceki sürüm korunmuş.

**Kabul kaydı:** `Asset ID · tarih · test yeri · P0/P1/P2 sonucu · eksikler · inceleyen · karar`. P0 başarısızsa varlık entegre edilmez. P1/P2 eksikleri açık görev olarak kalır; durum `DOĞRULANDI` olmaz.

