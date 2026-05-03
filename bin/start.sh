#!/bin/sh
# =====================================================================
# Paperclip Holding — Container Start Script (self-bootstrapping)
# =====================================================================
# Self-bootstrap: container root olarak başlasa bile bu script kendisini
# paperclip user'a drop eder. Railway'in entrypoint override etmesinden
# bağımsız çalışır.
# =====================================================================

# ---------------------------------------------------------------------
# 0. SELF-BOOTSTRAP — root ise chown yap + paperclip user'a drop ol
# ---------------------------------------------------------------------
if [ "$(id -u)" = "0" ]; then
    echo "[start.sh] Booted as root (uid=0) — performing privilege drop..."
    DATA_DIR_FOR_CHOWN="${PAPERCLIP_DATA_DIR:-/home/paperclip/.paperclip}"
    echo "[start.sh] chown -R paperclip:paperclip $DATA_DIR_FOR_CHOWN"
    chown -R paperclip:paperclip "$DATA_DIR_FOR_CHOWN" 2>&1 | tail -3 || echo "[start.sh] WARN: chown $DATA_DIR_FOR_CHOWN failed"
    echo "[start.sh] chown -R paperclip:paperclip /home/paperclip"
    chown -R paperclip:paperclip /home/paperclip 2>&1 | tail -3 || echo "[start.sh] WARN: chown /home/paperclip failed"

    if command -v gosu >/dev/null 2>&1; then
        echo "[start.sh] exec gosu paperclip sh $0"
        exec gosu paperclip sh "$0" "$@"
    elif command -v su-exec >/dev/null 2>&1; then
        echo "[start.sh] exec su-exec paperclip sh $0"
        exec su-exec paperclip sh "$0" "$@"
    else
        echo "[start.sh] FATAL: neither gosu nor su-exec installed. Cannot drop privilege. Exiting."
        exit 1
    fi
fi

echo "[start.sh] Running as: $(whoami) (uid=$(id -u))"

set -e

# Derived env vars (boş ise default'tan üret)
DATA_DIR="${PAPERCLIP_DATA_DIR:-/home/paperclip/.paperclip}"
CONFIG_PATH="${CONFIG_PATH:-$DATA_DIR/instances/default/config.json}"
EFFECTIVE_PORT="${EFFECTIVE_PORT:-${PORT:-8080}}"
export DATA_DIR CONFIG_PATH EFFECTIVE_PORT
INSTANCE_DIR="$DATA_DIR/instances/default"
CONFIG_PATH="$INSTANCE_DIR/config.json"

# Railway default = 8080. Container env'de PORT zorunlu olarak var olmayabilir.
EFFECTIVE_PORT="${PORT:-8080}"

# Dockerfile installs paperclipai + @anthropic-ai/claude-code globally;
# fallback PATH export covers nixpacks/local builds where they're in node_modules
export PATH="/usr/local/bin:$(pwd)/node_modules/.bin:$PATH"

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
if command -v claude > /dev/null 2>&1; then
    echo "[start.sh] claude CLI:    $(claude --version 2>/dev/null | head -1) at $(command -v claude)"
else
    echo "[start.sh] claude CLI:    NOT FOUND — CEO heartbeat will fail; check @anthropic-ai/claude-code dep installed"
fi
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

// Server settings for cloud deployment
config.server = config.server || {};
config.server.host = '0.0.0.0';
config.server.port = parseInt(process.env.EFFECTIVE_PORT, 10);
config.server.bind = 'lan';
config.server.exposure = 'public';

// Allowed hostnames + auth public URL (zorunlu — public exposure'da)
let firstHost = null;
if (process.env.ALLOWED_HOSTNAME) {
    config.server.allowedHostnames = config.server.allowedHostnames || [];
    const hosts = process.env.ALLOWED_HOSTNAME.split(',').map(s => s.trim()).filter(Boolean);
    for (const h of hosts) {
        if (!config.server.allowedHostnames.includes(h)) {
            config.server.allowedHostnames.push(h);
        }
    }
    firstHost = hosts[0];
}

// Auth config — public exposure için publicBaseUrl ZORUNLU (yoksa server crash)
config.auth = config.auth || {};
if (firstHost) {
    config.auth.baseUrlMode = 'explicit';
    config.auth.publicBaseUrl = 'https://' + firstHost;
}

// Telemetry kapalı — production private data için Paperclip team'ine
// anonim kullanım istatistiği gönderilmez (banka/müşteri verisi zaten asla
// gitmiyordu, ama kapsamı dar tutmak prensibi)
config.telemetry = config.telemetry || {};
config.telemetry.enabled = false;

fs.writeFileSync(path, JSON.stringify(config, null, 2));
console.log('[patch] Config updated:');
console.log('[patch]   server.host:           ', config.server.host);
console.log('[patch]   server.port:           ', config.server.port);
console.log('[patch]   server.bind:           ', config.server.bind);
console.log('[patch]   server.exposure:       ', config.server.exposure);
console.log('[patch]   server.deploymentMode: ', config.server.deploymentMode);
console.log('[patch]   server.allowedHostnames:', JSON.stringify(config.server.allowedHostnames));
console.log('[patch]   auth.baseUrlMode:      ', config.auth.baseUrlMode);
console.log('[patch]   auth.publicBaseUrl:    ', config.auth.publicBaseUrl);
"

echo "[start.sh] Final config.json:"
cat "$CONFIG_PATH" | head -40

# ---------------------------------------------------------------------
# 2b. Ek güvence — allowed-hostname CLI komutu (config patch'in fallback'i)
# ---------------------------------------------------------------------
if [ -n "$ALLOWED_HOSTNAME" ]; then
    echo "[start.sh] Registering allowed hostnames via CLI..."
    for HOST in $(echo "$ALLOWED_HOSTNAME" | tr ',' ' '); do
        HOST=$(echo "$HOST" | tr -d ' ')
        if [ -n "$HOST" ]; then
            echo "[start.sh]   -> $HOST"
            paperclipai allowed-hostname "$HOST" -d "$DATA_DIR" 2>&1 | tail -3 || echo "[start.sh] WARN: allowed-hostname '$HOST' failed (may already be registered)"
        fi
    done
fi

# ---------------------------------------------------------------------
# 3. Bootstrap invite URL — her deploy'da banner ile log'a bas
# ---------------------------------------------------------------------
if [ -n "$ALLOWED_HOSTNAME" ]; then
    FIRST_HOST=$(echo "$ALLOWED_HOSTNAME" | cut -d',' -f1 | tr -d ' ')
    BASE_URL="https://$FIRST_HOST"
    echo ""
    echo "=================================================================="
    echo "=================================================================="
    echo "===            BOOTSTRAP INVITE URL                            ==="
    echo "===  (yeni invite üretiliyor, eski varsa rotate olur)          ==="
    echo "=================================================================="
    paperclipai auth bootstrap-ceo --base-url "$BASE_URL" -d "$DATA_DIR" --force 2>&1 || echo "[start.sh] WARN: bootstrap-ceo failed (admin var olabilir, normal)"
    echo "=================================================================="
    echo "===            URL YUKARIDA — KOPYALAYIP TARAYICIYA            ==="
    echo "=================================================================="
    echo ""
fi

# ---------------------------------------------------------------------
# 4. Paperclip server'ı başlat
# ---------------------------------------------------------------------
echo "=================================================================="
echo "[start.sh] Starting Paperclip server (paperclipai run --bind lan)..."
echo "=================================================================="
exec paperclipai run --bind lan
