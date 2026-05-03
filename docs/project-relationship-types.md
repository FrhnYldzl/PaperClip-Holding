# Project Relationship Types — Templates

Holding'in her external project'le 4 ilişki türünden biriyle bağlandığı `architecture.md`'de tanımlandı. Bu dokümanda her tür için:
- Karakteristik özellikler
- Liaison ajan profili (skill/permission/budget önerisi)
- Initial setup checklist
- Yasaklar (deny-by-default)

## 🔵 Tip 1: Observe-only

**Örnek:** Meridian (trading platform)

### Karakteristik
- External system kendi başına otonom
- Holding sadece veri ÇEKER
- Hiçbir write/mutation yok — `forever`

### Liaison Ajan Profili
| Field | Değer |
|---|---|
| Name | `<Project> Observer` (örn: `Meridian Observer`) |
| Role | `observer` veya `general` |
| Reports to | COO |
| Skills | `fetch-metrics`, `consolidate-report`, `notify-board` |
| Permissions | API base read-only credentials, mail/Telegram send |
| Budget cap | $2-3/ay (sadece okuma, az LLM kullanımı) |
| Heartbeat | Daily (24h) — günlük rapor için yeterli |

### Initial Setup
1. External API'nin read-only credential'ı Paperclip secret olarak ekle
2. İlk issue: "Connect to <Project> API, verify can fetch <metric set>"
3. İkinci issue: "Define daily report template — board ne görmek ister?"
4. Üçüncü issue: "Schedule daily heartbeat at 09:00 local"

### Yasaklar (deny-by-default)
- ❌ Asla POST/PUT/DELETE endpoint çağrılmaz
- ❌ Asla credentials write-scope istemez
- ❌ External system'e config/policy değişikliği önermez
- ❌ Eğer kullanıcı "şunu kapat / pozisyon ayarla" istese → **refuse + escalate to board**

---

## 🟣 Tip 2: Internal Asset

**Örnek:** Asset Factory output'ları — Newsletter, FBA store, Course, Affiliate site

### Karakteristik
- Holding %100 sahibi
- Allocator değerlendirir, Helmsman operate eder
- S&M departmanı asset'in distribution'ını yapar
- CFO P&L konsolide eder

### Tek bir tip "liaison" yok — Helmsman zaten asset'in operator'ü

### Initial Setup (asset onaylandıktan sonra otomatik)
1. Allocator → Evaluation comment (P&L + OKR + Mandate)
2. Board approve interaction
3. Auto: project yaratılır
4. Auto: Helmsman hire edilir (mandate + connector list + budget injected)
5. Auto: OKR child issue'lar açılır
6. Auto: ilk Operating Day heartbeat schedule edilir

Detay: `docs/asset-factory-doctrine.md`

---

## 🟠 Tip 3: External SaaS — S&M only

**Örnek:** Juris (legal SaaS), Fevup (e-commerce SaaS), gelecek SaaS'ler

### Karakteristik
- External SaaS'in sahibi/geliştiricisi başkası (sen veya başka ekip) — Holding sadece **agency** rolünde
- Holding sadece pazarlama, satış, içerik, trafik, lead, müşteri-talep analizi alanlarında çalışır
- SaaS'in ürün geliştirme, deploy, support, contract işleri Holding'in DEĞİL

### Liaison Ajan Profili
| Field | Değer |
|---|---|
| Name | `<Project> S&M Lead` (örn: `Juris S&M Lead`) |
| Role | `general` |
| Reports to | CMO (proje-agnostik S&M departmanı) |
| Skills | `client-brief-author`, `content-strategist`, `lead-pipeline-manager`, `analytics-reporter` |
| Permissions | Read-only product info, write SaaS pages content (opsiyonel), CRM access |
| Budget cap | $5-10/ay (içerik üretimi LLM yoğun) |
| Heartbeat | Weekly (her Pazartesi) — tactical loop |

### Initial Setup
1. Liaison ajan kendi `client-brief.md` doc'unu yazar:
   - Brand voice
   - Target audience
   - Channels (LinkedIn / Twitter / SEO / paid?)
   - KPIs (lead/ay, MQL conversion, cost per acquisition)
   - Brand DON'Ts (ne ASLA söylenmez)
2. Brief CMO ve board onayından geçer
3. Onaylanınca CMO departmanından IC ajanlar (Researcher, Content Producer, vb.) lazım oldukça hire edilir, brief'e göre çalışır
4. Lead'ler liaison ajanına gelir — analytics ve raporlama yine onun sorumluluğunda

### Yasaklar (deny-by-default)
- ❌ External SaaS'in kod tabanına dokunma yok (PR açma, repo clone yok)
- ❌ Deploy/healthcheck/rollback işlemi yok (SaaS sahibinin işi)
- ❌ Customer support reply Tier C+ (müşteriye dokunan her şey board approval)
- ❌ Contract/legal review yok (cowork-uyumlu olarak ayrı bir ajan eklenebilir, ama default değil)
- ❌ Pricing değişikliği önerme yetkisi yok (SaaS sahibi karar verir)

---

## 🟡 Tip 4: External SaaS — Full Operator

**Örnek:** Şu anda yok. İleride sen bir SaaS'i Holding'e tamamen devretmek istersen.

### Karakteristik
- Holding her şeyi operate eder: deploy + sales + support + content + product + contract
- Yüksek bilişsel yük + yüksek risk
- Holding'in birden çok departmanı + per-area liaison ajanları

### Önerim
Bu türü **default'a alma**. Bir SaaS önce Tip 3 (S&M only) ile başlatılsın; başarılı olursa ve Holding kapasitesi hazırsa Tip 4'e graduate edilsin.

---

## Yeni Project Eklerken Standart Akış

1. **Board** yeni external project için issue açar:
   - Title: "Establish liaison: <ProjectName>"
   - Description: Project tipini belirt (Tip 1 / 3 — varsayılan), karakteristik kısa
2. **CEO** issue'yu COO'ya dispatch eder
3. **COO** liaison ajan tasarımı önerir (paperclip-create-agent skill ile), board approval ister
4. **Board** approve → liaison ajan hire edilir
5. Liaison ajan kendi initial setup checklist'ini yapar (yukarıdaki templates'a göre)
6. CMO departmanı liaison'a hizmet vermeye başlar (Tip 3 ise)

Bu süreç hep aynı — yeni SaaS / yeni asset eklerken kafa yorulmaz.
