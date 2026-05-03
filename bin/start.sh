#!/bin/sh
# =====================================================================
# Paperclip Holding — Container Start Script
# =====================================================================
# Railway / Render / Fly / her container ortamında doğru çalışsın diye:
#   1. Config yoksa onboard çalıştır (idempotent)
#   2. config.json'u $PORT (default 8080) + 0.0.0.0 host + ALLOWED_HOSTNAME ile patch'le
#   3. Paperclip server'ını başlat
# =====================================================================

set -e

DATA_DIR="${PAPERCLIP_DATA_DIR:-/root/.paperclip}"
INSTANCE_DIR="$DATA_DIR/instances/default"
CONFIG_PATH="$INSTANCE_DIR/config.json"

# Railway default = 8080. Container env'de PORT zorunlu olarak var olmayabilir.
EFFECTIVE_PORT="${PORT:-8080}"

echo "=================================================================="
echo "[start.sh] Paperclip Holding — boot script"
echo "[start.sh] Data dir:       $DATA_DIR"
echo "[start.sh] Config path:    $CONFIG_PATH"
echo "[start.sh] PORT env:       ${PORT:-(not set, using fallback)}"
echo "[start.sh] Effective port: $EFFECTIVE_PORT"
echo "[start.sh] ALLOWED_HOSTNAME: ${ALLOWED_HOSTNAME:-(not set)}"
echo "[start.sh] DATABASE_URL set: $([ -n "$DATABASE_URL" ] && echo yes || echo no)"
echo "[start.sh] ANTHROPIC_API_KEY set: $([ -n "$ANTHROPIC_API_KEY" ] && echo yes || echo no)"
echo "[start.sh] AUTH_SECRET set: $([ -n "$AUTH_SECRET" ] && echo yes || echo no)"
echo "=================================================================="

# ---------------------------------------------------------------------
# 1. Onboard (idempotent — mevcut config'e dokunmaz)
# ---------------------------------------------------------------------
mkdir -p "$INSTANCE_DIR"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "[start.sh] No config found at $CONFIG_PATH — running onboard..."
    paperclipai onboard --yes --bind lan
    echo "[start.sh] Onboard done."
else
    echo "[start.sh] Config exists, skipping onboard."
fi

# ---------------------------------------------------------------------
# 2. Config patch — Railway / cloud env için (zorla 0.0.0.0:$PORT)
# ---------------------------------------------------------------------
echo "[start.sh] Patching config: host=0.0.0.0, port=$EFFECTIVE_PORT, exposure=public"
node -e "
const fs = require('fs');
const path = process.env.CONFIG_PATH;
const config = JSON.parse(fs.readFileSync(path, 'utf8'));

// Cloud deployment için zorunlu ayarlar
config.server.host = '0.0.0.0';
config.server.port = parseInt(process.env.EFFECTIVE_PORT, 10);
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

// Auth config — required when deploymentMode=authenticated and exposure=public
config.auth = config.auth || {};
config.auth.baseUrlMode = 'explicit';

// Derive publicBaseUrl from environment
let publicBaseUrl = 'http://localhost:8080';
if (process.env.ALLOWED_HOSTNAME) {
    const firstHost = process.env.ALLOWED_HOSTNAME.split(',')[0].trim();
    if (firstHost) publicBaseUrl = firstHost;
} else if (process.env.RAILWAY_PUBLIC_DOMAIN) {
    publicBaseUrl = process.env.RAILWAY_PUBLIC_DOMAIN;
}
// Prepend https:// if no scheme is present
if (!/^https?:\/\//i.test(publicBaseUrl)) {
    publicBaseUrl = 'https://' + publicBaseUrl;
}
config.auth.publicBaseUrl = publicBaseUrl;

fs.writeFileSync(path, JSON.stringify(config, null, 2));
console.log('[patch] Config updated:');
console.log('[patch]   host:', config.server.host);
console.log('[patch]   port:', config.server.port);
console.log('[patch]   bind:', config.server.bind);
console.log('[patch]   exposure:', config.server.exposure);
console.log('[patch]   deploymentMode:', config.server.deploymentMode);
console.log('[patch]   allowedHostnames:', JSON.stringify(config.server.allowedHostnames));
console.log('[patch]   auth.baseUrlMode:', config.auth.baseUrlMode);
console.log('[patch]   auth.publicBaseUrl:', config.auth.publicBaseUrl);
"

echo "[start.sh] Final config.json:"
cat "$CONFIG_PATH" | head -40

# ---------------------------------------------------------------------
# 3. Paperclip server'ı başlat
# ---------------------------------------------------------------------
echo "=================================================================="
echo "[start.sh] Starting Paperclip server (paperclipai run --bind lan)..."
echo "=================================================================="
exec paperclipai run --bind lan
