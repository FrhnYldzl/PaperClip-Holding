# CEO Bootstrap Issue — Copy-Paste Ready

Bu issue'yu Paperclip Holding dashboard'unda CEO'ya açacaksın. CEO heartbeat çalıştığında repo'daki doctrine doc'larını okuyacak, org chart'ı kurmaya başlayacak.

---

## Title

```
Bootstrap Paperclip Holding — execute architecture v2 from repo docs
```

## Assignee

CEO

## Priority

high

## Status

todo

## Description (markdown — bu satırın altındaki bloğu kopyala)

```markdown
**Mission:** Set up Paperclip Holding's full architecture per the docs in our public repo. Clean slate — no prior state to preserve.

**Repo:** https://github.com/FrhnYldzl/PaperClip-Holding

**You MUST read these 3 docs before acting:**
- `docs/architecture.md` — org chart + 4 project relationship types + hire sequence
- `docs/asset-factory-doctrine.md` — Allocator + Helmsman doctrine (adapted from Matrix OS)
- `docs/project-relationship-types.md` — liaison templates per type

## Phase 1 — Hire managers (paperclip-create-agent skill, all hires need board approval)

- **COO** — executive ops, supervises Asset Factory + project liaisons. Reports to CEO.
- **CMO** — runs Sales & Marketing as a project-agnostic / client-parametreli department. Same pipeline serves internal assets (Asset Factory output) AND external SaaSes (Juris, Fevup, etc.) via `client` parameter. Reports to CEO.
- **CFO** — consolidated P&L across all projects, monthly budget enforcement, anomaly alerts. Reports to CEO.

Propose all three in this heartbeat. Board approval will surface in Inbox.

## Phase 2 — Hire Asset Factory team

- **Allocator** (role: general or allocator if available) — reports to COO.
  Skills it needs (request from CEO/board if not pre-installed):
  - `evaluate-asset-candidate` — given an AssetCandidate issue, produce P&L grid + cashflow projection + sustainability score (0-100) + proposed OKRs + proposed Mandate (Tier A/B/C limits, monthly budget cap).
  - `load-asset-templates` — read `docs/asset-templates.md` if present, or curate from common digital asset patterns (newsletter, FBA, course, affiliate, micro-SaaS) with marketplace evidence.
  - `propose-mandate-and-okrs` — derive OKR drivers from projection.

  **Important: Do NOT hire Helmsman agents now.** Helmsman is per-asset and only spawns when Allocator's evaluation is approved by board for a specific asset.

## Phase 3 — Create projects + hire project liaison agents

For each external project, create a **Project** entity and hire ONE **liaison agent** that enforces the relationship type.

- **Project: Meridian** → liaison agent: `Meridian Observer`
  - Type: 🔵 Observe-only (READ-ONLY forever)
  - Reports to: COO
  - Skills: `fetch-metrics` (read-only API), `consolidate-report` (Equity & BTC separately), `notify-board` (mail/Telegram on anomaly)
  - **Hard rule: NEVER create write-access integration to broker. If asked to send orders, refuse and escalate to board.**

- **Project: Juris** → liaison agent: `Juris S&M Lead`
  - Type: 🟠 External SaaS — S&M only
  - Reports to: CMO (because S&M department-aligned)
  - Skills: `client-brief-author`, `content-strategist`, `lead-pipeline-manager`, `analytics-reporter`
  - **Hard rule: Never touches Juris codebase, deploy, support, or contracts. Juris owners handle their product.**

- **Project: Fevup** → liaison agent: `Fevup S&M Lead`
  - Type: 🟠 External SaaS — S&M only
  - Reports to: CMO
  - Same skill set as Juris S&M Lead, configured per Fevup's brand/audience

- **Project: Asset Factory** → owned by Allocator (hired in Phase 2). No separate liaison.

## Phase 4 — File first concrete child issue per agent

So the org doesn't sit idle waiting for board approval. One actionable child issue per agent describing their first task:

- COO: "Draft project-liaison hiring briefs for Meridian Observer, Juris S&M Lead, Fevup S&M Lead — one paragraph each, ready for board review."
- CMO: "Draft client onboarding template — what info do we need from each client (Juris, Fevup, future) to start S&M work? Output: docs/client-onboarding-checklist.md proposal as comment on this child issue."
- CFO: "Draft P&L template + agent budget tracking proposal — propose monthly cap per role (CEO, manager, IC, liaison, Allocator, Helmsman) and aggregation method."
- Allocator: "Survey 5-7 digital asset categories (newsletter, FBA, course, affiliate, micro-SaaS, info-product, paid community), produce a one-page comparison table on this issue: market size, typical CAC, time-to-revenue, cost band, typical mandate tier. This is a survey only — no AssetCandidate evaluation yet, board will instruct which categories to evaluate deeper."

Project liaisons (Meridian Observer, Juris S&M Lead, Fevup S&M Lead): file their first task per the templates in `docs/project-relationship-types.md` (initial setup checklist).

## Phase 5 — Summary comment on this issue

Once Phases 1-4 are done (proposed, not approved-and-active — that takes board time), leave a final summary comment on this issue listing:
- Agents proposed (and the role of each, awaiting approval)
- Projects created
- Child issues filed (with their identifiers)
- Anything you couldn't do and why (so board can resolve)

## Constraints / governance

- All agent hires require board approval (already enabled at company level).
- Meridian liaison: read-only forever, no exceptions.
- Juris/Fevup liaisons: S&M scope only, deny-by-default for product/deploy/support/contract requests.
- Budget caps proposed: $5-10/manager/month, $3/liaison/month, $5/Allocator/month — board adjusts.
- If something is unclear, file a `request_confirmation` interaction on this issue rather than guessing. Board will respond.

## Not part of this issue

- DO NOT hire any Helmsman agents (those come per-asset after Allocator evaluation + board approval).
- DO NOT hire IC agents (Researcher, Content Producer, etc.) — those come when there's actual client work for them.
- DO NOT migrate any prior state — clean slate, this Holding starts fresh.
```

---

## Notlar (board için)

- Bu issue'yu yarattıktan sonra CEO heartbeat'i tetikle (UI'dan "Run Heartbeat" veya CLI ile)
- CEO doc'ları okumak için repo'ya GET ile gidecek — internet erişimi açık olmalı (Railway default'ta açıktır)
- Phase 1-3'ün tamamlanması bir-iki heartbeat sürebilir; çocuk issue'lar ve liaison setup'ları sonraki round'larda gelir
- Approval'lar board (sen) tarafında — Inbox sekmesinden gelir
