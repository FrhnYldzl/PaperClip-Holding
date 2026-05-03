# DEPRECATED — Lokal Paperclip Holding Export (eski state)

Bu klasörde bulunan markdown package, **lokal Windows kurulumunda** (May 3, 2026) lokalce yaratılan ilk PaperClip Holding deneyiminin export'udur. **Artık kullanılmıyor.**

## Niye?

Mimari **clean slate** ile yeniden tasarlandı (2026-05-03 sonrası):
- Önceki: 4 ajan + 3 proje (CEO/COO/CMO/CFO + Meridian/Juris/Asset Factory)
- Yeni: Aynı ajan iskelesi + **4 ilişki türü** + Asset Factory genişletilmiş Allocator+Helmsman doctrine + Fevup gibi ek SaaS'ler için standart liaison patterni

Ayrıntılar: [`../docs/architecture.md`](../docs/architecture.md)

## Bu Klasörü Tutuyoruz Çünkü...

1. **Tarih:** İlk lokal deneyim referansı, ne yaptığımızı görmek için faydalı
2. **Yedek:** İhtiyaç olursa eski export'u Paperclip'e import edebiliriz
3. **`paperclipai company import` testleri:** Bu klasörü bir test fikstürü olarak kullanabiliriz

## Yeni State Nerede?

**Railway'de yaşıyor**, lokal export yok (clean slate kararı). Mevcut state'i export etmek istersen:

```bash
# Önce CLI auth Railway'e
paperclipai context set --profile railway \
  --api-base https://paperclip-holding-production.up.railway.app \
  --api-key-env-var-name PAPERCLIP_API_KEY \
  --use

# Sonra export
PAPERCLIP_API_KEY=<key> paperclipai company export <company-id> --out ./company-railway
```

Ama bu adım acele değil — Railway versiyonu zaten "single source of truth".
