#!/usr/bin/env bash
set -euo pipefail

echo "=== Environment Check ==="
echo ""

check() {
  if command -v "$1" &>/dev/null; then
    echo "[✓] $1: $($1 --version 2>&1 | head -1)"
  else
    echo "[✗] $1: NOT FOUND"
  fi
}

check node
check npm
check docker
check flutter

echo ""

if docker info &>/dev/null 2>&1; then
  echo "[✓] Docker daemon is running"
else
  echo "[✗] Docker daemon is NOT running"
fi

echo ""
echo "=== Connectivity ==="
if curl -s --max-time 5 https://registry.npmjs.org/ &>/dev/null; then
  echo "[✓] npm registry reachable"
else
  echo "[✗] npm registry unreachable (network restricted?)"
fi

echo ""
echo "=== Project files ==="
for f in docker-compose.yml server/package.json server/prisma/schema.prisma mobile/pubspec.yaml; do
  if [[ -f "$f" ]]; then
    echo "[✓] $f"
  else
    echo "[✗] $f MISSING"
  fi
done
