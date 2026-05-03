# Lokal Windows Setup

Bu klasör Paperclip Holding'i Windows'ta lokal çalıştırmak için scriptleri içerir.

## Dosyalar

- **`start-paperclip.bat`** — Paperclip server'ı doğru bayraklarla başlatan launcher
- **`claude-wrapper.cmd.template`** — `C:\pcbin\claude.cmd` için template (API key + 8.3 path inject)

## Hızlı Setup

1. Windows Developer Mode ON
2. `claude-wrapper.cmd.template` → `C:\pcbin\claude.cmd` (key'leri doldur)
3. PATH'e `C:\pcbin` ekle (başa)
4. `start-paperclip.bat`'ı double-click

Detaylı talimatlar: [`../docs/windows-fix.md`](../docs/windows-fix.md)

## Production?

Lokal Windows **dev/test** için. 7/24 production için **Railway** kullan: [`../docs/deploy-railway.md`](../docs/deploy-railway.md)
