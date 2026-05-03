# =====================================================================
# Paperclip Holding — Production Dockerfile
# =====================================================================
# Architecture:
#   1. Container starts as root (entrypoint runs)
#   2. entrypoint.sh chowns volume mount + drops to paperclip user
#   3. start.sh runs as paperclip → onboard + config patch + run server
#
# Why non-root paperclip user:
#   Claude Code CLI refuses --dangerously-skip-permissions as root for
#   security. Paperclip's claude_local adapter passes this flag, so we
#   must run as a non-root user.
#
# Why entrypoint w/ chown:
#   Railway volumes mount as root:root by default. paperclip user can't
#   write there without ownership fix. entrypoint.sh handles this once
#   per boot, idempotent.
# =====================================================================

FROM node:20-slim

# System deps:
#   - ca-certificates, curl: HTTPS, debugging
#   - gosu: privilege drop in entrypoint (https://github.com/tianon/gosu)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gosu \
  && rm -rf /var/lib/apt/lists/*

# Global tooling — Paperclip + Claude Code CLI
RUN npm install -g paperclipai @anthropic-ai/claude-code

# Non-root user (Claude CLI requirement)
RUN useradd -m -d /home/paperclip -s /bin/bash paperclip

# Pre-create paperclip data dir (will be overlaid by volume mount at runtime)
RUN mkdir -p /home/paperclip/.paperclip \
  && chown -R paperclip:paperclip /home/paperclip

# App code
WORKDIR /app
COPY . .
RUN chmod +x bin/entrypoint.sh bin/start.sh 2>/dev/null || true

# Runtime env
ENV HOME=/home/paperclip
ENV PAPERCLIP_DATA_DIR=/home/paperclip/.paperclip
ENV NODE_ENV=production

# Railway provides $PORT (defaults to 8080 in start.sh)
EXPOSE 8080

# Container starts as root → entrypoint chowns volume → drops to paperclip
ENTRYPOINT ["sh", "/app/bin/entrypoint.sh"]
