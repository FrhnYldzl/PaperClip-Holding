# Asset Factory Type Specs

> **Source:** Matrix OS `src/lib/types.ts` (extracted 2026-05-03).
> **Use:** Reference type spec for Goals, Workflows, Skills in Asset Factory primitives. Maps to Paperclip native primitives where possible.

## Goal — KPI Tracking

```typescript
interface Goal {
  id: string;
  workspaceId: string;       // Paperclip: companyId or projectId
  title: string;
  metric: string;            // örn: "MRR", "weekly subscriber growth %", "NRR"
  target: number;            // hedef sayısal değer
  current: number;           // şu anki gerçekleşme
  unit: string;              // "$", "%", "subs", "lead/ay" vb
  invert?: boolean;          // lower-is-better mı? (error rate, burn rate, churn için true)
  trajectory: "ahead" | "on-track" | "at-risk" | "off-track";
  linkedAgentIds: string[];  // bu goal'a bağlı ajan(lar)
  linkedSkillIds: string[];  // bu goal'a bağlı skill(ler)
  linkedThemeIds?: string[]; // strategic theme bağlantısı
  history?: number[];        // son 12 haftalık snapshot (oldest → newest)
  owner?: string;            // sorumlu manager/agent
  cadence?: "weekly" | "monthly" | "quarterly";
}
```

**Paperclip karşılığı:** Paperclip'in native `Goal` modeli — companyID + name + descriptionı tutuyor; metric/target/current alanları custom plugin veya structured comment ile eklenir. Allocator Mandate'lerinde OKR olarak yansıtılır.

## Strategic Theme — Weighted Axis

```typescript
interface StrategicTheme {
  id: string;
  label: string;          // örn: "SEO Liderliği"
  description: string;    // örn: "Commercial keyword'lerde top 3"
  weight: number;         // 0-100 — kaç merkezi
}
```

**Use:** Asset templates'in `themes` listesi → Allocator'ın propose ettiği OKR'ların önceliklendirme akslarına dönüşür. Weight 90+ teması Tier C/D approval gerektiren önemli aksiyon belirleyicisidir.

## Workflow + Step + Trigger

```typescript
interface Workflow {
  id: string;
  workspaceId: string;
  departmentId: string;
  name: string;
  cadence: string;        // "daily" | "weekly" | "biweekly" | ...
  nextRun: string;
  lastStatus: "success" | "running" | "pending-approval" | "failed";
  steps: number;
  trigger?: WorkflowTrigger;
  stepsDetail?: WorkflowStep[];
}

interface WorkflowTrigger {
  kind: "schedule" | "webhook" | "manual";
  cron?: string;
  timezone?: string;
  webhookPath?: string;
}

type WorkflowStepKind =
  | "trigger" | "skill" | "integration" | "approval" | "notify" | "condition";

interface WorkflowStep {
  id: string;
  kind: WorkflowStepKind;
  label: string;
  skillRef?: string;          // skill id/name when kind=="skill"
  modelRef?: string;          // pinned LLM model from llm-catalog
  modelFallback?: string[];   // fallback chain — primary fail/timeout/budget cap
  integration?: string;       // ccxt, github, beehiiv vb
  channel?: "slack" | "notion" | "email" | "webhook";
  target?: string;            // slack channel, notion db, email
  note?: string;
}
```

**Paperclip karşılığı:** Paperclip'in native `Routine` + `heartbeat` primitive'leri — cron/schedule ve heartbeat için. WorkflowStep'in `skill` kindi Paperclip Skill, `approval` kindi governance gate, `notify` kindi mail/webhook side effect.

## Agent Status & Scope

```typescript
type AgentStatus = "live" | "idle" | "paused" | "error";
type Scope = "read" | "write" | "external-send";

interface Agent {
  id: string;
  workspaceId: string;
  departmentId: string;
  name: string;
  displayName: string;
  description: string;
  model: "opus" | "sonnet" | "haiku";  // Anthropic model tier
  status: AgentStatus;
  scopes: Scope[];                      // hangi yetki türleri var
  skillIds: string[];
  callsToday: number;
  successRate: number;
}
```

**Önemli:** `scopes` Paperclip Mandate'in Tier sistemine eşlenir:
- `read` only = Tier A (auto, log only)
- `write` = Tier B/C (mandate-bounded auto / approval)
- `external-send` = Tier C+ (always approval — customer-facing veya finansal aksiyonlar)

## Audit Event — Append-Only Log

```typescript
interface AuditEvent {
  id: string;
  workspaceId: string;
  at: string;
  actor: string;        // agent name or "oracle"|"system"
  action: string;       // "skill.run" | "task.delegate" | "workflow.run" | ...
  target: string;
  result: "ok" | "warn" | "fail";
  durationMs?: number;
  tokens?: number;
  traceId?: string;
}
```

**Paperclip karşılığı:** Paperclip native `activity log` — zaten append-only; Asset Factory operations buraya düşer otomatik.

## Approval Item — Board Queue

```typescript
type ApprovalChannel = "gmail" | "slack" | "sms" | "transfer" | "webhook";

interface ApprovalItem {
  id: string;
  workspaceId: string;
  agent: string;          // agent name
  channel: ApprovalChannel;
  title: string;
  preview: string;
  recipient: string;
  createdAt: string;
  priority: "high" | "medium" | "low";
}
```

**Paperclip karşılığı:** Paperclip'in `request_confirmation` veya `ask_user_questions` issue interaction'ları — board Inbox'ına düşer. `transfer` channel = governance gate'li customer/financial operations.

## Ritual — Human Cadence

```typescript
interface Ritual {
  id: string;
  label: string;
  cadence: "daily" | "weekly" | "biweekly" | "monthly";
  dayOfWeek?: number;     // 1=Mon ... 7=Sun
  timeOfDay?: string;     // "HH:MM" 24h
  durationMinutes: number;
  description: string;
  lastRunAtIso?: string;
  streak: number;
  active: boolean;
}
```

**Önemli ayrım:** Ritual = **insan ritmi** (L10 meeting, Weekly Review, Daily Deep Work). Workflow = ajan ritmi. Ritual calendar'a düşer, hatırlatma gönderir; Paperclip'te board/manager için scheduled issue olarak modellenir.

## Oracle Suggestion — Strategic Recommendation

```typescript
type OracleKind = "gap" | "strategy" | "ops" | "risk";

interface OracleSuggestion {
  id: string;
  workspaceId: string;
  kind: OracleKind;
  title: string;
  rationale: string;
  target: string;        // "Add skill", "Add agent", "New workflow", "Adjust strategy"
  priority: "high" | "medium" | "low";
  createdAt: string;
}
```

**Paperclip karşılığı:** Allocator (CIO ajan) bu pattern'i kullanır — Asset Factory'nin "next move"u önerirken `OracleSuggestion` formatında comment yapar veya issue açar. Board priority'ye göre triaj eder.
