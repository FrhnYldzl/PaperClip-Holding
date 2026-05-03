# Asset Factory Doctrine

> Matrix OS'tan miras alınan, Paperclip primitive'lerine adapte edilmiş 9 doctrine.

## 1. Vibe Business
Asset operate'i klikleme yerine **konuşarak** yapılır. Helmsman heartbeat'leri intention emit eder, board doğrudan issue üzerinden karar verir. UI = review/approval surface.

## 2. Conversation Surface Pattern
Allocator AssetCandidate'i değerlendirirken `request_confirmation` veya `ask_user_questions` interaction'ları kullanır. Board cevabı issue thread'inde verir. Tarafların ikisi de async, structured.

## 3. Skill/Knowledge Injection
Catalog'lar statik değil. Asset templates, marketplace evidence, cost bands repo'da `docs/asset-templates.md`'de tutulur — Allocator skill'i okur. Yeni asset türü eklenirse repo'ya commit + Allocator'ın skill cache'i refresh.

## 4. Push Policy
Asset durumu değiştiğinde (state advance, OKR variance, mandate breach) board'a notification (mail / Telegram). Helmsman push intention emit eder, ama her push board approval ile.

## 5. AI-First Operability
Eğer Allocator/Helmsman bir aksiyonu otonom yapamıyorsa (board müdahalesi olmadan), o aksiyon yanlış tasarlanmış demektir. UI sadece **review + approval** içindir.

## 6. Webapp Navigation
Paperclip dashboard'u zaten browser-friendly. Allocator/Helmsman issue'larında deep-link kullan, action tier hierarchy net (Tier A → otomatik, Tier C → approval).

## 7. Asset Model — `connected` vs `greenfield`
- **Connected**: Mevcut bir asset'i operate etmek (kullanıcının halihazırda sahip olduğu newsletter/store). Helmsman var olan platforma connect olur.
- **Greenfield**: Sıfırdan yarat (boş niş + mandate). Helmsman önce platform setup yapar, sonra operate eder.

Allocator değerlendirme yaparken hangisi olduğunu belirtir; bootstrap pipeline'ı buna göre dallanır.

## 8. Allocator Projection — Real P&L + Cashflow
Allocator çıktısı vibe değil, **somut sayılar**:
- 6/12/24 ay revenue projection grid
- Aylık cashflow (revenue − cost − human time − LLM)
- Break-even ay'ı
- Sustainability score (0-100): risk-adjusted geri dönüş
- Proposed OKRs (revenue → leading indicators → driver actions)
- Proposed Mandate (Tier A/B/C limits, monthly budget cap, autonomy level)

Board ratifies a **forecast**, not a vibe.

## 9. Cost Realism — Insan Zamanı Dahil
Cost projection'da:
- LLM token cost
- Platform fees (Beehiiv, Stripe, Lovable, Vercel)
- Ad/marketing budget
- **`humanTimeMonthlyHours`** × hourly rate (insan müdahalesi gerekecek saatler de maliyet)
- Connector subscription costs

Eğer asset insan zamanı maliyetini düşse bile pozitifse → green. Aksi → kırmızı, board reddetmeli.

## Action Tier Taxonomy

| Tier | Yetki | Örnek |
|---|---|---|
| **A** | Auto — log only | Daily metric snapshot, scheduled content publish (önceden onaylı) |
| **B** | Mandate-bounded auto | Ad budget allocation (mandate cap altında), connector reconnect |
| **C** | Always approval | New connector add, model swap (Sonnet → Opus), budget increase |
| **D** | Principal-only | Asset retire, mandate change, hire/fire |

Helmsman emit ettiği her intention bu tier'lardan birine düşer. Tier C/D = board issue açılır, approval bekler.

## Hard Guardrails (kod seviyesinde, asla config-overridable değil)

1. **LLM cap hard cutoff**: Mandate'in monthly token cap'i aşılırsa Helmsman pause olur, intentions queue'lanır
2. **perActionMaxUsd hard refuse**: Tek aksiyon Mandate'in `perActionMaxUsd`'ını aşarsa otomatik tier C → approval
3. **Customer-facing action always Tier C+**: Müşteriye dokunan her şey (email, support reply, refund) approval gerektirir
4. **Hire/fire/legal never possible**: Asset Factory ajanları yeni Paperclip ajanı hire edemez (sadece CEO via paperclip-create-agent skill); legal commitments asla
5. **Audit log append-only**: Paperclip activity log zaten append-only — Asset Factory operations bu log'a düşer

## Trust Ladder

Yeni asset → mandate **conservative** (Tier A çok az, Tier C çoğu)
Asset OKR'larını tutturuyor → mandate **graduated** (Tier B genişler, Tier C daralır)
Asset 6 ay başarılı → **autonomous** (Tier B çok geniş, intervention nadir)
Asset OKR variance > %X → trust auto-degrade

Trust seviyesi Mandate'in bir parçası, board override edebilir.

## Resource Request Agency

Helmsman "I need" diyebilir, ama isteyemezse otonom değil. Örnekler:
- "Beehiiv connector eklenmeli — without it I can't publish"
- "Ad budget +$200 / ay, current burn'le erişim hedefleri tutmaz"
- "Sonnet → Opus model swap — content quality 3 hafta üst üste OKR altında"

Hepsi Tier C (always approval). Issue açılır, board cevap verir.

## Bootstrap'ı Auto-populated, Wizard Değil

Asset onaylandığında:
- **Project** otomatik yaratılır
- **Helmsman ajan** hire edilir (mandate + connector list + budget cap injected)
- **OKR issue'ları** otomatik açılır (Allocator'ın projeksyon driver'larından türetilmiş)
- **Initial Operating Day heartbeat** schedule edilir
- **Connector setup task'ları** Tier C interaction olarak board'a düşer

Board "approve" tıklar, ertesi heartbeat'te asset operate'e başlar. **Setup wizard yok.**

---

## Paperclip → Matrix OS Konsept Eşleme (referans)

| Matrix OS | Paperclip |
|---|---|
| Allocator | Agent (role: allocator) + skill: evaluate-asset-candidate |
| Helmsman | Agent (per-asset) + heartbeat (Operating Day) |
| AssetCandidate | Issue (structured description) |
| Evaluation | Issue interaction (`request_confirmation` ile P&L grid) |
| Mandate | Agent permissions + runtimeConfig + budgetMonthlyCents |
| Intention | Child issue (action / resource_request / status) |
| Bootstrap pipeline | `paperclip-create-agent` + project + initial issues — automated |
| Operating Day cycle | Agent heartbeat (intervalSec) |
| Workspace | Paperclip project |
| Action Tier | Per-skill / per-action governance approval policy |
| Trust ladder | Agent permission tier (custom plugin or convention) |
| Cost realism | Agent budget + custom skill: `track-human-hours` |
| Audit log | Paperclip activity stream (built-in) |

Bu eşleme kısmi — `MetricSnapshot` gibi bazı Matrix konseptleri Paperclip'te plugin gerektirebilir. İlk MVP'de ihtiyaç olduğunda plugin yazılır, şu an gerek yok.
