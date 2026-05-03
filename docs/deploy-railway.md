# Railway Deploy Adımları

Paperclip Holding'i Railway'e deploy etmek 5-10 dakikalık iş. Mevcut Meridian + Juris ile aynı altyapıda olur.

## Önkoşullar

- [Railway hesabı](https://railway.app)
- Bu repo'ya push erişimi
- Anthropic Console'dan kredi yüklü API key

## Adım 1 — Railway projesi oluştur

1. Railway → **New Project** → **Deploy from GitHub repo**
2. Repo seç: `FrhnYldzl/PaperClip-Holding`
3. Service otomatik oluşur, ilk deploy başlar (henüz fail edecek — env yok)

## Adım 2 — Postgres add-on ekle

1. Project'te **+ New** → **Database** → **Add PostgreSQL**
2. Postgres servisi oluşur, otomatik olarak `DATABASE_URL` env var'ını Paperclip servisine inject eder
3. (İlk deploy'da Paperclip embedded postgres yerine bunu kullanacak)

## Adım 3 — Env vars set et

Paperclip servisine git → **Variables** sekmesi → şunları ekle:

| Key | Değer | Nasıl elde edilir |
|---|---|---|
| `ANTHROPIC_API_KEY` | `sk-ant-api03-...` | console.anthropic.com → API Keys → Create |
| `AUTH_SECRET` | random hex | `openssl rand -hex 32` veya online generator |
| `BIND` | `lan` | sabit |
| `ALLOWED_HOSTNAME` | `<service>.up.railway.app` | Railway → Settings → Networking → Generate Domain |

> **Not:** `DATABASE_URL` Railway tarafından otomatik atanır, manuel ekleme.

## Adım 4 — Volume (kalıcı data)

Paperclip servisinde:
1. **Volumes** → **+ New Volume**
2. Mount path: `/root/.paperclip`
3. Size: 1GB (yeterli)

> Bu olmadan container restart'ında onboarding sıfırlanır.

## Adım 5 — Public domain + redeploy

1. Settings → Networking → **Generate Domain**
2. Çıkan URL'i `ALLOWED_HOSTNAME`'e koy (Adım 3'te yaptıysan bu adımı atla)
3. **Deployments** → **Redeploy** (env'lerin yüklenmesi için)
4. Build başarılı olunca service yeşile döner

## Adım 6 — Company import

Container ayağa kalkıp ilk onboard tamamlandıktan sonra:

```bash
# Lokal makinende, Railway public URL'iyle:
PAPERCLIP_API_BASE=https://<service>.up.railway.app \
  npx paperclipai company import \
    https://github.com/FrhnYldzl/PaperClip-Holding/tree/main/company \
    --target new --yes
```

Veya Railway servisinin Shell sekmesinden:
```bash
npx paperclipai company import ./company --target new --yes
```

Bu, repo'daki `company/` klasöründen Paperclip Holding'i (4 ajan + 3 proje + onboarding issue'lar) Railway'deki yeni instance'a yükler.

## Adım 7 — UI'a bağlan

1. Browser'da `https://<service>.up.railway.app`
2. İlk girişte bootstrap admin user yaratımı istenebilir → invite URL'i Railway log'unda görürsün veya:
   ```bash
   railway run npx paperclipai auth bootstrap-ceo
   ```
3. Login → Dashboard → CEO + COO + CMO + CFO ajanları + 3 proje görünür

## Bakım & İzleme

| İşlem | Komut |
|---|---|
| Log izle | Railway → Deployments → View logs |
| Restart | Railway → Deployments → Redeploy |
| State backup (markdown) | `paperclipai company export <id> --out ./company` + commit + push |
| State restore (rollback) | Önceki commit'e checkout + import |

## Maliyet Tahmini

- Railway Hobby Plan: $5/ay (build + run dahil)
- Postgres: dahil
- Anthropic API: heartbeat başına ~$0.50-1.50 (CEO PAP-3 için $1.26 idi); günde 10 heartbeat = ~$10/gün worst case
- **Toplam:** $5 fixed + $50-300/ay variable (kullanıma göre)

> Düşük tutmak için: budget cap'leri agentlere sıkı koy (CFO işi).
