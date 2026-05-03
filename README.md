# Paperclip Holding

Bizim "zero-human company" orkestrasyon repomuz — [Paperclip](https://github.com/paperclipai/paperclip) üstüne kurulmuş, GitHub + Railway tabanlı.

## Mimari Özet (v2 — clean slate)

**Tek Holding instance, 4 ilişki türü, Asset Factory dahil her şey içeride:**

```
PAPERCLIP HOLDING
├── EXEC: CEO + COO + CFO
├── DEPT: CMO ─→ Sales & Marketing (proje-agnostik, client-parametreli)
├── DEPT: Asset Factory ─→ Allocator (CIO) + Helmsman per asset
└── PROJECT LIAISONS:
    ├── 🔵 Meridian Observer       (READ-ONLY, trading observe)
    ├── 🟠 Juris S&M Lead          (S&M only — Juris kendi back-office'i)
    └── 🟠 Fevup S&M Lead          (S&M only)
```

**4 ilişki türü** her external project'le bağı net tanımlar — kafa karıştırmaz, kapsam-creep önler:

| Tür | Holding'in işi | Örnek |
|---|---|---|
| 🔵 Observe-only | Veri çek, raporla, alarm | Meridian (trading) |
| 🟣 Internal Asset | Asset Factory üretir, Helmsman operate eder | Newsletter / FBA / Course |
| 🟠 External SaaS — S&M only | Sadece pazarlama+satış+içerik+trafik | Juris, Fevup |
| 🟡 External SaaS — full operator | Her şey | (default değil, ileride istenirse) |

Detaylar:
- [`docs/architecture.md`](docs/architecture.md) — org chart + 4 ilişki türü
- [`docs/asset-factory-doctrine.md`](docs/asset-factory-doctrine.md) — Allocator + Helmsman wisdom (Matrix OS adapte)
- [`docs/project-relationship-types.md`](docs/project-relationship-types.md) — her tip için liaison template'i

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
