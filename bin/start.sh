#!/bin/sh
# =====================================================================
# Paperclip Holding — Container Start Script
# =====================================================================
# Railway / Render / Fly / her container ortamında doğru çalışsın diye:
#   1. Config yoksa onboard çalıştır (idempotent)
#   2. config.json'u $PORT + 0.0.0.0 host + ALLOWED_HOSTNAME ile patch'le
#   3. Paperclip server'ını başlat
# =====================================================================

set -e

DATA_DIR="${PAPERCLIP_DATA_DIR:-/root/.paperclip}"
INSTANCE_DIR="$DATA_DIR/instances/default"
CONFIG_PATH="$INSTANCE_DIR/config.json"

echo "[start.sh] Data dir: $DATA_DIR"
echo "[start.sh] Config:   $CONFIG_PATH"

# ---------------------------------------------------------------------
# 1. Onboard (idempotent — mevcut config'e dokunmaz)
# ---------------------------------------------------------------------
if [ ! -f "$CONFIG_PATH" ]; then
    echo "[start.sh] No config found, running onboard..."
    paperclipai onboard --yes --bind lan
else
    echo "[start.sh] Config exists, skipping onboard."
fi

# ---------------------------------------------------------------------
# 2. Config patch — Railway / cloud env için
# ---------------------------------------------------------------------
if [ -n "$PORT" ]; then
    echo "[start.sh] Patching config: host=0.0.0.0, port=$PORT, allowedHostname=$ALLOWED_HOSTNAME"
    node -e "
const fs = require('fs');
const path = process.env.CONFIG_PATH;
const config = JSON.parse(fs.readFileSync(path, 'utf8'));

// Cloud deployment için zorunlu ayarlar
config.server.host = '0.0.0.0';
config.server.port = parseInt(process.env.PORT, 10);
config.server.bind = 'lan';
config.server.exposure = 'public';

// Allowed hostnames listesini güncelle
if (process.env.ALLOWED_HOSTNAME) {
    config.server.allowedHostnames = config.server.allowedHostnames || [];
    const hosts = process.env.ALLOWED_HOSTNAME.split(',').map(s => s.trim()).filter(Boolean);
    for (const h of hosts) {
        if (!config.server.allowedHostnames.includes(h)) {
            config.server.allowedHostnames.push(h);
        }
    }
}

fs.writeFileSync(path, JSON.stringify(config, null, 2));
console.log('[patch] Config updated:');
console.log('[patch]   host:', config.server.host);
console.log('[patch]   port:', config.server.port);
console.log('[patch]   bind:', config.server.bind);
console.log('[patch]   exposure:', config.server.exposure);
console.log('[patch]   allowedHostnames:', JSON.stringify(config.server.allowedHostnames));
"
else
    echo "[start.sh] PORT env not set — using config defaults"
fi

# ---------------------------------------------------------------------
# 3. Paperclip server'ı başlat
# ---------------------------------------------------------------------
echo "[start.sh] Starting Paperclip server..."
export CONFIG_PATH
exec paperclipai run --bind lan
