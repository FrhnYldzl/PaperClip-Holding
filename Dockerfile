# =====================================================================
# Paperclip Holding — Production Dockerfile (non-root user)
# =====================================================================
# Why non-root:
#   Claude Code CLI (used by paperclipai claude_local adapter) refuses
#   to run with --dangerously-skip-permissions as root for security.
#   Railway containers run as root by default, so we explicitly switch
#   to a 'paperclip' user.
# =====================================================================

FROM node:20-slim

# System deps for paperclipai + embedded Postgres fallback (in case Postgres is down)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Global install — runs as root before switching user
RUN npm install -g paperclipai @anthropic-ai/claude-code

# Create non-root user with home dir
RUN useradd -m -d /home/paperclip -s /bin/bash paperclip

# Create data dir owned by paperclip user (for volume mount)
RUN mkdir -p /home/paperclip/.paperclip && chown -R paperclip:paperclip /home/paperclip

# App workspace
WORKDIR /app
COPY --chown=paperclip:paperclip . .

# Switch to non-root user
USER paperclip

# Environment for runtime
ENV HOME=/home/paperclip
ENV PAPERCLIP_DATA_DIR=/home/paperclip/.paperclip
ENV NODE_ENV=production

# Railway provides $PORT (default 8080)
EXPOSE 8080

# Boot via our start script (onboard + config patch + invite + run)
CMD ["sh", "bin/start.sh"]
