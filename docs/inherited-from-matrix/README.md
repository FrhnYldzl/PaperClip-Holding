# Inherited from Matrix OS

This folder contains **wisdom extracted** from the Matrix OS prototype repo (https://github.com/FrhnYldzl/matrix), adapted for use within Paperclip Holding's Asset Factory department.

## Why these docs are here

Matrix OS was an earlier prototype of a digital portfolio AI manager (Allocator + Helmsman pattern). When Paperclip Holding adopted the Asset Factory module, we chose to **adapt** Matrix's hard-won wisdom (catalogs, doctrines, type specs) rather than rebuild from scratch as a sister service. These docs are now reference material for:

1. **Allocator agent** — reads `asset-templates.md` when surveying or evaluating AssetCandidate issues
2. **Helmsman agent** (per-asset, hired on approval) — references type specs to structure its operating-day cycle outputs
3. **Board (you)** — reads these to understand the asset taxonomy, marketplace evidence, mandate frame

## Files

- [`asset-templates.md`](asset-templates.md) — 14 digital asset patterns with marketplace evidence, MRR bands, multiples, missions, strategic themes. Plus Oracle's portfolio-gap rule engine.
- [`types-spec.md`](types-spec.md) — Type specs for Goal, Workflow, Step, Agent, Audit, Approval, Ritual, OracleSuggestion. Maps Matrix concepts to Paperclip primitives.

## Not extracted (was aspirational in Matrix repo)

The Matrix handoff doc described these but they weren't yet implemented in the source:
- ❌ `src/server/allocator/evaluate.ts` — Allocator engine prompt + tool schema
- ❌ `src/server/allocator/bootstrap.ts` — Bootstrap pipeline
- ❌ `src/lib/asset-type-ops.ts` — Per-type canonical org spec (newsletter / saas / ecommerce)

These remain to be designed natively in Paperclip — likely as Allocator skill templates and Helmsman skill packs. Allocator's first heartbeat (PAP-7) attempted a generic survey; with `asset-templates.md` now in repo, next survey will be marketplace-evidence-based.

## Source code mapping (for future reference)

| Matrix Source | Paperclip Adaptation |
|---|---|
| `src/lib/asset-templates.ts` | → `docs/inherited-from-matrix/asset-templates.md` (this folder) |
| `src/lib/types.ts` | → `docs/inherited-from-matrix/types-spec.md` |
| `src/lib/oracle.ts` (portfolio rule engine) | → embedded in `asset-templates.md` ("Oracle Pick Rules" section) |
| `src/lib/idea-analyzer.ts` | (not yet ported — would inform Allocator skill prompts) |
| `src/lib/operator.ts` | (not yet ported — would inform Helmsman skill specs) |
| `src/lib/blueprints.ts` | (not yet ported — would inform Mandate skill packs) |
| `prisma/schema.prisma` (V2.0 models) | → mostly mapped to Paperclip company/agent/project/issue/skill primitives |
