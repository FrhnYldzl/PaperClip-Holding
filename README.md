# Paperclip Holding

Bizim "zero-human company" orkestrasyon repomuz — [Paperclip](https://github.com/paperclipai/paperclip) üstüne kurulmuş, GitHub + Railway tabanlı.

## Mimari Özet

**Tek Holding instance, 3 strategic project + 4 manager:**

```
PAPERCLIP HOLDING
├── CEO
├── COO  ─→ owns 3 projects' execution
├── CMO  ─→ proje-agnostik Sales & Marketing (client-parametreli)
├── CFO  ─→ konsolide P&L + budget enforcement
│
├── Project: MERIDIAN        (read-only observer, FOREVER — trade için kalıcı kural)
├── Project: JURIS           (back-office operate + cowork contract review)
└── Project: ASSET FACTORY   (Matrix göçü — internal digital asset pipeline)
```

Detaylar: [`docs/architecture.md`](docs/architecture.md)

## Bu Repo Ne İçerir?

| Klasör/Dosya | İçerik |
|---|---|
| `company/` | Paperclip Holding'in markdown export'u — `paperclipai company import` ile herhangi bir Paperclip instance'ına yüklenebilir |
| `package.json` + `railway.toml` | Railway nixpacks deploy config'i |
| `.env.example` | Production env var template (gerçek key'ler YOK) |
| `setup-local-windows/` | Windows lokal restart script + claude wrapper template |
| `docs/` | Architecture, Railway deploy, Windows fix dokümantasyonu |

## 3 Yoldan Çalıştırılır

### 🚀 Railway (önerilen — 7/24 always-on)
**[`docs/deploy-railway.md`](docs/deploy-railway.md)**

### 🪟 Lokal Windows (test/dev)
**[`docs/windows-fix.md`](docs/windows-fix.md)**

### 🐧 Lokal Linux/macOS
```bash
npm install
npm start
```
(Hiçbir Windows fix gerekmez — Paperclip Linux-first, sorunsuz çalışır.)

## Sırlar / Güvenlik

- Asla repo'ya `.env` veya gerçek API key push etme — `.gitignore` koruyor
- `setup-local-windows/claude-wrapper.cmd.template` içinde key placeholder var, gerçek key sadece **lokal** disk'te (`C:\pcbin\claude.cmd`)
- Railway'de key'ler Railway env vars'da tutulur

## Hızlı Komutlar

```bash
# Mevcut state'i tekrar export et (CEO yeni iş yapınca)
paperclipai company export <company-id> --out ./company

# Başka bir Paperclip instance'a import et (ör. Railway'e)
paperclipai company import https://github.com/FrhnYldzl/PaperClip-Holding/tree/main/company

# Lokal restart (Windows)
./setup-local-windows/start-paperclip.bat
```
