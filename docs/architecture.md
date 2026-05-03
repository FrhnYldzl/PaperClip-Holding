# Paperclip Holding — Mimari (v2, clean slate)

## Vizyon

Tek Holding altında tüm orkestrasyon. **Asset Factory dahil** her şey Paperclip primitive'leri (company/department/agent/routine/skill) üzerine kurulur. Federation/sister-service yok — tek motor, tek arayüz, tek dashboard.

Çekirdek prensip: **Holding = "agency"**. Kendi internal asset'lerini (Asset Factory üretir) ve dış SaaS'lerin (Juris, Fevup, vb.) **sadece belirli alanlarını** (S&M öncelikle) servis eder. Dış SaaS'lerin ürün geliştirme/operasyonlarına dokunmaz.

## Org Chart

```
                  PAPERCLIP HOLDING
                        │
   ┌────────────────────┼─────────────────────────────────┐
   │                    │                                  │
EXECUTIVE          DEPARTMENTS                  PROJECT LIAISONS
                                              (her external project için 1 ajan)
CEO                CMO ─→ Sales & Marketing
  governance       │      proje-agnostik            ┌─ Meridian Observer
  board liaison    │      client-parametreli        │   → READ-ONLY observe
                   ├── Researcher                   │
COO                ├── Content Producer             ├─ Juris S&M Lead
  exec ops         ├── Channel Distributor          │   → SADECE S&M
  Asset Factory    ├── Lead Manager                 │
  + project        └── Analytics                    ├─ Fevup S&M Lead
  liaisons                                          │   → SADECE S&M
  supervisor                                        │
                   Asset Factory department         └─ <yeni SaaS> Lead
CFO                ├── Allocator (CIO)
  konsolide P&L    │   → AssetCandidate evaluate
  budget cap       │
  enforcement      └── Helmsman:<AssetName>
                       (her onaylanan asset için
                        hire — gereksiz idle yok)
```

## 4 İlişki Türü (kritik — proje tasarlanırken hangi tür olduğu net olmalı)

| # | Tür | Örnek | Holding'in işi | Asla yapmayacağı |
|---|---|---|---|---|
| 1 | **🔵 Observe-only** | Meridian (trading) | Read-only veri çek, Equity & BTC ayrı konsolide, denetim raporu, mail/Telegram alarm | Pozisyon açma/kapama, broker'a komut, herhangi bir write — **forever** |
| 2 | **🟣 Internal Asset** | Newsletter, FBA, Course, Affiliate (Asset Factory output) | Allocator değerlendirir → Helmsman operate eder → S&M departmanı dağıtır → CFO P&L konsolide eder | (yok — full ownership) |
| 3 | **🟠 External SaaS — S&M only** | Juris (legal SaaS), Fevup (e-commerce/dropshipping), gelecek SaaS'ler | Sadece pazarlama, satış, içerik üretimi, trafik, lead pipeline, müşteri-talep analizi | Ürün geliştirme, deploy, support, contract review, kod tabanı yönetimi — **bunları SaaS sahibi kendi çözer** |
| 4 | **🟡 External SaaS — full operator** | (şimdilik yok, ileride istenirse) | Her şey: deploy + sales + support + content + product ops + contract | (none) |

> **Default ilişki türü = Observe-only veya S&M only.** Full operator yapısı yüksek bilişsel yük + yüksek risk → ancak iş değeri çok yüksek + ekip kapasitesi var ise seçilir.

## Ajan Hire Sırası

1. **Manager katmanı** (Faz 1): COO, CMO, CFO — board approval, paralel
2. **Asset Factory** (Faz 2): Allocator — board approval
3. **Project Liaison** (Faz 3): Her external project için 1 ajan — board approval, paralel
   - Meridian Observer
   - Juris S&M Lead
   - Fevup S&M Lead
4. **IC ajanlar** (Faz 4): Sadece gerçek iş geldiğinde — Researcher/Content Producer/Lead Manager/Analytics, lazım oldukça hire
5. **Helmsman per asset** (Faz 5+): Allocator'ın evaluate ettiği bir asset board tarafından onaylanınca, o asset için 1 Helmsman hire

## Governance & Budget

- `requireBoardApprovalForNewAgents=true` — her hire onaydan geçer
- Manager başı aylık bütçe (öneri): $5-10
- Departman IC'leri shared budget
- Helmsman her asset için Mandate-bounded (Allocator önerir, board onaylar)
- **Meridian read-only enforced** — kod + ajan talimatları + Holding governance, üç katmanda yazılı
- **External SaaS S&M only** — liaison ajan'ı kendi SaaS'in product operations'ına dokunamaz; deny-by-default

## Ne Değişti (önceki versiyondan)

- ❌ ~~"Juris back-office full operator"~~ → ✅ **Juris S&M only liaison**
- ❌ ~~"Asset Factory ayrı sister service?"~~ → ✅ **Asset Factory Holding altında department**
- ❌ ~~Matrix OS kodu rebuild~~ → ✅ **Matrix OS wisdom (doctrines + asset templates) Paperclip skill/memory'sine adapte**
- ✅ **Yeni:** Project Liaison ajan paterni — her external project için tek temsilci ajan, ilişki türünü enforce eder
- ✅ **Yeni:** Fevup ve gelecek SaaS'ler standart "S&M only liaison" kalıbıyla katılır

## Mimari Karar Logu

| Karar | Tarih | Sebep |
|---|---|---|
| Tek Holding (Asset Factory dahil) | 2026-05-03 | Kullanıcının tek-arayüz/tek-disiplin motivasyonuna sadık kalmak |
| Asset Factory native, sister service değil | 2026-05-03 | Matrix OS wisdom transfer, kod rebuild değil; tek motor |
| External SaaS default = S&M only | 2026-05-03 | Full operator yükü ürün ekibinin sorumluluğuna girer; agency paterni daha sağlıklı |
| Project Liaison ajan paterni | 2026-05-03 | Her external project için tek noktada ilişki türü enforce edilir |
| Helmsman lazım oldukça (idle yok) | 2026-05-03 | Maliyet disiplini + complexity azaltma |
