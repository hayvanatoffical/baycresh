# Roblox Studio ve MCP çalışma akışı

**Durum:** Bağlantı ve üretim kontrol standardı · 25 Eylül 2026 (§0 27 Eylül 2026'da eklendi). Roblox'un [Studio MCP kılavuzu](https://create.roblox.com/docs/studio/mcp) araçların kapsamını ve bağlantı şeklini açıklar.

## 0. Bağlantı

Studio MCP sunucusu Studio'nun kurulu olduğu bilgisayarda yerel bir süreç olarak çalışır ve istemciyle stdio üzerinden konuşur. URL'si yoktur. Bu yüzden claude.ai bulut oturumu ve claude.ai connector'ı ona bağlanamaz. Studio'yu açık internete tünelle açma: MCP istemcisi açık place'i değiştirebilir.

1. Studio'da **Assistant → … → Manage MCP Servers → Enable Studio as MCP server** açılır.
2. Aynı bilgisayarda Claude Code'a sunucu eklenir (kullanıcı kapsamı, her projede görünür):
   - Windows: `claude mcp add --transport stdio --scope user Roblox_Studio -- cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat`
   - macOS: `claude mcp add --transport stdio --scope user Roblox_Studio -- /Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`
3. Depo klasöründe yeni oturum açılır. `claude mcp list` veya oturum içinde `/mcp` ile `Roblox_Studio` satırının `Connected` olduğu görülür. Sonra §1'den devam edilir.

Kaynaklar: [Roblox Studio MCP](https://create.roblox.com/docs/studio/mcp) (Studio ayarı ve Windows/macOS komutu), [Claude Code MCP](https://code.claude.com/docs/en/mcp) (`claude mcp add` sözdizimi).

## 1. Hedefi belirle

1. Bağlı Studio örneklerini listele. Birden fazla örnek varsa ad/place ID ile hedefi seç; ID'yi kalıcı belgeye yazma.
2. Studio modunu ve kullanılabilir DataModel'i oku. Oyun çalışırken `Edit` üzerinde yazmaya çalışma.
3. Hedef place'in adını, mevcut `Workspace` ve `ServerScriptService` ağacını oku. Boş `Place1` ile proje place'ini karıştırma.
4. Görev kapsamını `07` katmanıyla ve ilgili karar kimliğiyle eşleştir. Yazma hedefi belirsizse önce doğru place veya dosyayı netleştir.

## 2. Küçük ve geri alınabilir değişiklik yap

- Tek görev, tek davranış veya tek varlık ailesi. Toplu içerik üretimi ayrı taslak ve inceleme ister.
- Mevcut nesneyi değiştirmeden önce adı, sınıfı, konumu, ilgili script'i ve beklenen sonucu kaydet.
- Yeni varlığı önce gri kutuda doğrula. AI tarafından üretilen mesh ve malzeme `TASLAK` statüsündedir.
- Kalıcı kodun yeri Git/Rojo akışında izlenebilir olmalıdır. Studio içindeki tek kopya üretim kaydı sayılmaz (`04` §15).
- Oyuncu verisi veya gerçek oyuna etkisi olan testlerde test place'i, test hesapları ve geri alma yolu açıkça kaydedilir.

## 3. Doğrula ve kapat

| Değişiklik | Asgari doğrulama |
|---|---|
| Script | Kaynağı yeniden oku; konsol hatası, sunucu doğrulaması ve ilgili davranış testi |
| Sahne/3D varlık | Hiyerarşi, ölçü/pivot, çarpışma, iki ışık koşulu, mobil cihaz kontrolü |
| Çok oyunculu kural | Start Server + 2 Player ve kötü niyetli istek senaryosu |
| Veri veya ekonomi | Tekrar/bağlantı kesme testi; `03` §15 model ve telemetri kontrolü |

Değişikliğin **yerini**, **nedenini**, **test yöntemini**, **sonucu** ve **kalan riski** yaz. Bir test başarısızsa `DOĞRULANDI` yazma. Ekran görüntüsü tek başına veri bütünlüğü veya performans kanıtı değildir.

## 4. Yetki ve kaynak

Studio MCP istemcisi açık place'i okuyup değiştirebilir; bu nedenle yalnız doğru yer ve açık kapsam üzerinde çalışılır. Araç adları sürümle değişebilir; önce mevcut araç listesini kontrol et. Studio MCP kullanımı için ek üçüncü taraf sunucu kurulmaz. Kaynak: [Roblox Studio MCP](https://create.roblox.com/docs/studio/mcp).

