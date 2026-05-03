# Windows Lokal Çalıştırma — 4-Adım Fix

Paperclip Linux-first. Windows'ta — özellikle user profile'da **boşluk** varsa (`C:\Users\Adı Soyadı\` gibi) — 4 fix gerekir. Test edildi, çalıştı.

## Önkoşullar

- Node.js 20+
- npm
- `claude` CLI: `npm install -g @anthropic-ai/claude-code`
- Anthropic Console'da kredi yüklü API key

## Fix 1 — Windows Developer Mode ON

**Niye:** Paperclip ajan workspace'ine skill'leri symlink'liyor. Non-admin user için Windows symlink yaratımı varsayılan kapalı → EPERM hatası.

**Adım:**
1. **Win + I** → **Settings**
2. Üstten ara: `developer settings`
3. **Developer Mode** toggle'ını **ON** yap
4. Restart gerekmez

## Fix 2 — `C:\pcbin\claude.cmd` wrapper

**Niye-1:** Paperclip subprocess'e `ANTHROPIC_API_KEY` env var'ını geçirmiyor — wrapper içinde inject ediliyor.

**Niye-2:** Real `claude.cmd` boşluklu yolda (`C:\Users\FERHAN YILDIZLI\AppData\Roaming\npm\`) → cmd.exe quote bug. Wrapper FERHAN~1 8.3 short-name ile boşluksuz çağırıyor.

**Adım:**
1. `C:\pcbin\` klasörü oluştur
2. `setup-local-windows/claude-wrapper.cmd.template`'ı `C:\pcbin\claude.cmd` olarak kopyala
3. İçinde `YOUR-API-KEY-HERE`'i gerçek key ile değiştir
4. `YOUR-8.3-USERNAME`'i kendi user profilinin kısa adıyla değiştir:
   ```cmd
   dir /X C:\Users
   ```
   (Listede `FERHAN~1` gibi 8.3 short-name görünür.)
5. PATH'in başına ekle:
   ```cmd
   setx PATH "C:\pcbin;%PATH%"
   ```

## Fix 3 — Paperclip'i `-d FERHAN~1` ile başlat

**Niye:** Paperclip subprocess'e prompt-cache + workspace path'lerini argümanla veriyor. Boşluklu path → cmd.exe quote'ları bozar → "Append system prompt file not found" hatası.

**Adım:** `setup-local-windows/start-paperclip.bat` zaten doğru yapıyor. Sadece içindeki `FERHAN~1`'i kendi 8.3 username ile değiştirmeniz yeterli (Fix 2'deki gibi).

Çalıştırma:
```cmd
C:\PaperClip\holding-repo\setup-local-windows\start-paperclip.bat
```

## Fix 4 — Anthropic Console'da kredi

**Niye:** Pro/Max abonelik subprocess auth'unda çalışmıyor (`Not logged in` hatası). API key + kredi modeli çalışıyor.

**Adım:**
1. console.anthropic.com → **Settings → Billing**
2. Min $5 kredi yükle (auto-reload kapalı tutun, kontrolde olsun)
3. **Settings → API Keys** → **Create Key** → kopyala
4. Bu key'i Fix 2'deki wrapper'da kullan

## Doğrulama

Wrapper çalışıyor mu?
```cmd
C:\pcbin\claude.cmd --print "say one word: ALIVE"
```
Beklenen çıktı: `ALIVE`

## Yaşanmış Bug Listesi (referans)

| # | Bug | Fix |
|---|---|---|
| 1 | Cascade FK delete (eski şirket silinmiyor) | Workaround: archive |
| 2 | subprocess path quote (`claude.CMD` not recognized) | Fix 2 (wrapper) |
| 3 | Symlink EPERM | Fix 1 (Developer Mode) |
| 4 | INT overflow on Windows exit codes | Primary fix sonrası kayboluyor |
| 5 | subprocess append-system-prompt path quote | Fix 3 (`-d FERHAN~1`) |
| 6 | env var passing | Fix 2 (wrapper içinde set) |
| 7 | CLI flag no-op (issue update --description vs.) | Workaround: REST API |

> **Tavsiye:** Windows'ta dert yaşatmaması için **Railway** deployment'ını öner. Bu fix'ler dev/test için backup planı.
