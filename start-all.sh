#!/bin/bash
# ShopNow 3-Tier - Start All Services
# Usage: ./start-all.sh
# Logs go to /tmp/shopnow-*.log — check them if something fails to start.

set -e

PROJECT_ROOT="$HOME/projects-devsecops/shopnow-3tier"

echo "===================================="
echo "  ShopNow — Starting all 3 tiers"
echo "===================================="

# --- 1. Database ---
echo ""
echo "[1/3] Checking PostgreSQL..."
if sudo service postgresql status > /dev/null 2>&1; then
  echo "  Already running."
else
  sudo service postgresql start
  echo "  Started."
fi

# --- 2. Backend (Node.js) ---
echo ""
echo "[2/3] Starting backend (Node.js) on port 4000..."

# Kill anything stuck on 4000 first
STUCK_PID=$(sudo lsof -ti :4000 2>/dev/null || true)
if [ -n "$STUCK_PID" ]; then
  echo "  Clearing stuck process on port 4000 (PID $STUCK_PID)..."
  sudo kill -9 $STUCK_PID
  sleep 1
fi

cd "$PROJECT_ROOT/backend-node"
nohup npm start > /tmp/shopnow-backend.log 2>&1 &
disown
echo "  Launched (PID $!). Waiting for it to become healthy..."

# Wait up to 15s for backend health check to pass
for i in $(seq 1 15); do
  if curl -s -m 2 http://localhost:4000/health | grep -q "UP"; then
    echo "  Backend is healthy."
    break
  fi
  sleep 1
  if [ "$i" -eq 15 ]; then
    echo "  WARNING: backend did not become healthy in time. Check /tmp/shopnow-backend.log"
  fi
done

# --- 3. Frontend (Java Spring Boot) ---
echo ""
echo "[3/3] Starting frontend (Spring Boot) on port 8081..."

STUCK_PID=$(sudo lsof -ti :8081 2>/dev/null || true)
if [ -n "$STUCK_PID" ]; then
  echo "  Clearing stuck process on port 8081 (PID $STUCK_PID)..."
  sudo kill -9 $STUCK_PID
  sleep 1
fi

cd "$PROJECT_ROOT/frontend-java"
nohup mvn spring-boot:run > /tmp/shopnow-frontend.log 2>&1 &
disown
echo "  Launched (PID $!). This takes ~10-20s to fully start."

echo ""
echo "===================================="
echo "  All services launching."
echo "  Backend log:  tail -f /tmp/shopnow-backend.log"
echo "  Frontend log: tail -f /tmp/shopnow-frontend.log"
echo ""
echo "  Once ready, open: http://localhost:8081"
echo "===================================="
