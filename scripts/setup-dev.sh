#!/usr/bin/env bash
set -euo pipefail

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# ---- Step 1: Homebrew ----
if ! command -v brew &>/dev/null; then
  echo ""
  echo "=== Installing Homebrew ==="
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  log "Homebrew installed"
else
  log "Homebrew already installed: $(brew --version | head -1)"
fi

# ---- Step 2: Docker Desktop ----
if ! command -v docker &>/dev/null; then
  echo ""
  echo "=== Installing Docker Desktop ==="
  brew install --cask docker
  open /Applications/Docker.app
  echo "Waiting for Docker Desktop to start..."
  for i in $(seq 1 60); do
    if docker info &>/dev/null 2>&1; then
      log "Docker is running"
      break
    fi
    sleep 5
    echo "  ... waiting ($((i*5))s)"
  done
else
  log "Docker already installed: $(docker --version)"
fi

# ---- Step 3: Start databases ----
echo ""
echo "=== Starting PostgreSQL & Redis ==="
cd "$PROJECT_ROOT"
docker compose up -d
sleep 5
docker compose ps
log "Databases started"

# ---- Step 4: Install server dependencies ----
echo ""
echo "=== Installing server dependencies ==="
cd "$PROJECT_ROOT/server"
npm install
log "Server dependencies installed"

# ---- Step 5: Prisma ----
echo ""
echo "=== Running Prisma ==="
npx prisma generate
npx prisma migrate dev --name init --skip-seed
log "Prisma migration complete"

# ---- Step 6: Seed ----
echo ""
echo "=== Seeding system categories ==="
npm run db:seed
log "Seed complete"

# ---- Step 7: Verify API ----
echo ""
echo "=== Starting API server ==="
npm run dev &
API_PID=$!
sleep 3

if curl -s http://localhost:3000/health | grep -q ok; then
  log "API server running at http://localhost:3000"
else
  warn "API server may need a moment to start, check manually"
fi

kill $API_PID 2>/dev/null || true

# ---- Done ----
echo ""
echo "========================================"
echo -e "${GREEN}Development environment is ready!${NC}"
echo "========================================"
echo ""
echo "Start the API:   cd server && npm run dev"
echo "Start the app:   cd mobile && flutter run"
echo "Database UI:     npx prisma studio"
echo ""
