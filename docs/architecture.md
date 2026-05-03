# Paperclip Holding — Mimari

## Vizyon

**"Zero-human company"** felsefesiyle, 3 stratejik proje + ortak departmanlar tek Holding altında orkestre edilir. CEO ajan organizasyonu kurar, manager'lar departmanları yönetir, IC ajanlar gerçek işi yapar — tüm bu süreçte governance gate'leri ve token bütçesi disiplini insan kontrolünde kalır.

## Org Chart

```
              CEO
       (executive direction)
                │
   ┌────────────┼────────────┐
   │            │            │
  COO          CMO          CFO
   │            │            │
 owns         owns         owns
projects'   project-     consolidated
execution   agnostic       P&L &
            S&M           budget
            pipeline      tracking
```

### Manager Sorumlulukları

**COO** — Proje execution sahibi. 3 projenin "owner" şapkasını taşır:
- Meridian Observer (read-only, hire edilecek)
- Juris Operator (deploy + ops, hire edilecek)
- Asset Factory Lead (creative pipeline, hire edilecek)

**CMO** — **Proje-agnostik** Sales & Marketing departmanı. Kritik tasarım kararı: aynı pipeline (lead → araştırma → içerik → kanal → trafik → conversion → analytics) hem **iç projeler** (Juris, Asset Factory çıktıları) hem **dış mal/hizmet**ler için kullanılır. `client` parametresi ile ayrılır; brand voice, channels, audience, KPI client config'inde tutulur.

**CFO** — Konsolide finans. Aylık P&L, ajan başı budget cap, anormal harcama alarmı.

## 3 Strategic Project

### 🟦 Meridian (read-only observer, FOREVER)

**Dış sistem:** Railway-hosted webapp, AI-powered broker entegrasyonu, Gemini self-supervision ile otonom çalışan trading platformu.

**Paperclip ilişkisi:** Sadece okuma. Ne pozisyon açar ne kapar. Görevi:
- Equity portföy konsolidasyonu (günlük)
- BTC portföy konsolidasyonu (günlük, ayrı)
- Denetim raporu (CEO/CFO'ya)
- Mail/Telegram bildirim

**Kalıcı kural:** Meridian'a Paperclip'ten asla yazma yetkisi verilmez. Trading kritikliği sebebiyle çift kontrol mantığını bozmaz.

### 🟪 Juris (back-office operator)

**Dış sistem:** Railway'de kod hazır, canlı değil bir Legal SaaS (hukuk dikeyi).

**Paperclip ilişkisi:** Operator. Ajanlar back-office'te:
- Deploy + uptime + healthcheck
- Sales pipeline (CMO departmanı tarafından)
- Marketing içerik + SEO + trafik (CMO)
- Customer support (CMO/COO)
- Sözleşme inceleme — **cowork-style** (ajan hazırlar, insan onaylar)

**Sınır:** Juris'in son kullanıcıları (avukatlar, hukuk firmaları) hâlâ insan. Ajanlar onların yerine geçmez.

### 🟧 Asset Factory (internal digital asset pipeline)

**İçeride bir department** — daha önce ayrı proje "The Matrix" idi, iptal edip Paperclip'e gömdük.

**Pipeline:**
```
Concept Scout → Producer → QA → Distributor → Monetizer
```

**CMO'nun ilk internal "client"ı.** Asset Factory üretir, S&M departmanı dağıtır → kapalı döngü.

## Cross-Cutting Departments

CMO altındaki S&M departmanı IC ajanlar (Researcher, Content Producer, Channel Distributor, Lead Manager, Analytics) **lazım oldukça** hire edilir, idle department oluşmaz.

## Governance & Bütçe

- `requireBoardApprovalForNewAgents=true` (her hire onaydan geçer)
- Manager başı aylık token cap (önerilen $5-10)
- Departman başı IC token sharing
- Meridian: read-only enforced kuralı (kod + ajan talimatlarında ayrı ayrı yazılı)
- Juris contract review: cowork governance gate

## Mimari Kararlar Loga

| Karar | Tarih | Sebep |
|---|---|---|
| Tek Holding instance, 3 proje | 2026-05-03 | Kullanıcı netleştirdi: tek arayüz/disiplin |
| Meridian forever read-only | 2026-05-03 | Trading çift-kontrol mantığını koru |
| The Matrix → Asset Factory department | 2026-05-03 | İçerde tutmak konsolidasyon sağlar |
| S&M proje-agnostik | 2026-05-03 | "Mal/hizmet" pazarlanabilen herhangi bir client için |
| GitHub + Railway deploy | 2026-05-03 | Lokal Windows ağrısından çıkış, 7/24 always-on |
