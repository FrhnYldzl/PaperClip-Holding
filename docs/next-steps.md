# Next Steps — sıralı akış

Şu an Railway'de Paperclip up + board user oluşturuldu. Bundan sonraki akış:

## 1. API Key (siz, 30 sn)

Paperclip dashboard → **Settings → API Keys** → **Create New Key** → kopyala → güvenli bir yere yapıştır.

> Eğer API Keys bulamazsan Profile/Settings menüsünde "Tokens", "Personal Access Tokens" veya "Developer" bölümleri olabilir.

## 2. CEO Bootstrap (Claude — yapacağı)

API key elime geçince:

```bash
paperclipai context set \
  --profile railway \
  --api-base https://paperclip-holding-production.up.railway.app \
  --api-key <KEY> \
  --use

paperclipai issue create \
  --title "Bootstrap Paperclip Holding — execute architecture v2 from repo docs" \
  --description "$(cat docs/ceo-bootstrap-issue.md | section description)" \
  --assignee-agent-id <CEO_ID> \
  --priority high \
  --status todo
```

Sonra heartbeat tetikle:
```bash
paperclipai heartbeat run -a <CEO_ID>
```

CEO `docs/ceo-bootstrap-issue.md` brief'ini okur → Phase 1-4'ü işler → manager + Allocator + project liaison teklifleri Inbox'a düşer.

## 3. Board Approvals (siz, ~2 dk)

Inbox'tan onaylar:
- COO ✅
- CMO ✅
- CFO ✅
- Allocator ✅
- Meridian Observer ✅ (read-only confirmed)
- Juris S&M Lead ✅ (S&M only confirmed)
- Fevup S&M Lead ✅ (S&M only confirmed)

Approval'lardan sonra her ajan otomatik instantiate olur (claude_local adapter, ANTHROPIC_API_KEY kullanarak Anthropic API'sine konuşur).

## 4. Manager + Liaison ilk heartbeat'leri

Otomatik schedule edilir veya manual tetiklenir. Her birinin kendi onboarding child issue'su var (CEO açtı), kendi alanlarında ilk concrete iş yaparlar.

## 5. Allocator survey (board ile etkileşim)

Allocator'ın ilk task'ı 5-7 asset kategorisinin survey'i. Survey gelir → board (sen) "şu 2 kategori için derin evaluation yap" der → Allocator AssetCandidate'lar sunar → board hangi asset'i pursue edeceğine karar verir → Helmsman hire edilir → Operating Day cycle başlar.

## 6. Yeni SaaS eklemek istediğinde

Standart akış:
1. Board issue: "Establish liaison: <SaaSName>"
2. Tip belirt: Tip 3 (S&M only, default) veya Tip 4 (full, advanced)
3. CEO → COO → liaison ajan teklifi
4. Approve → liaison hire
5. Liaison `docs/project-relationship-types.md` template'ine göre kendi initial setup'ını yapar
6. CMO departmanı liaison'a hizmet vermeye başlar (Tip 3 ise)

Bu akış değişmez — kafa yorulmaz, kapsam-creep önlenir.

## Ölçüm — Holding sağlıklı mı?

Haftalık board check (CFO raporu):
- ✅ Aktif agent sayısı, hangileri running/paused/error
- ✅ Token harcaması (toplam + per role)
- ✅ Pending approval sayısı (board response time)
- ✅ Tamamlanan task sayısı (haftalık)
- ✅ Error rate per agent (heartbeat fail %)
- ✅ Asset operating count (Helmsman'ları olan kaç asset)
- ✅ External liaison KPI'lar (Juris/Fevup için lead/CAC trends)

CFO bu raporu otomatik üretir, board Inbox'ına haftalık düşer.
