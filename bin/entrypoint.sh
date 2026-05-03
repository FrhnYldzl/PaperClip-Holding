#!/bin/sh
# =====================================================================
# Paperclip Holding — Container Entrypoint
# =====================================================================
# Niye gerek: Railway persistent volume default'ta root:root sahipliğiyle
# mount edilir. Paperclip non-root user (paperclip) ile çalışıyor →
# volume'e yazamaz → start.sh mkdir patlıyor → container crash.
#
# Çözüm: Bu entrypoint root olarak başlar, volume mount path'ini chown
# yapar, sonra `gosu` ile paperclip user'a düşer ve start.sh'ı exec eder.
# =====================================================================
set -e

DATA_DIR="${PAPERCLIP_DATA_DIR:-/home/paperclip/.paperclip}"

echo "[entrypoint.sh] Running as: $(whoami) (uid=$(id -u))"
echo "[entrypoint.sh] Data dir: $DATA_DIR"

# Volume mount edilmiş olabilir, mount root-owned olabilir.
# chown ile paperclip'e devret. Idempotent — paperclip zaten owner ise no-op.
if [ -d "$DATA_DIR" ]; then
    echo "[entrypoint.sh] Fixing ownership of $DATA_DIR (recursive)..."
    chown -R paperclip:paperclip "$DATA_DIR" 2>&1 || echo "[entrypoint.sh] WARN: chown failed (may be already correct)"
fi

# Home dizinini de garanti et (cache, config dosyaları için)
chown -R paperclip:paperclip /home/paperclip 2>&1 || true

# Privilege drop: paperclip user olarak start.sh'ı exec et
echo "[entrypoint.sh] Dropping to paperclip user, exec start.sh..."
exec gosu paperclip sh /app/bin/start.sh
