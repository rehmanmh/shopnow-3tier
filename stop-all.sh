#!/bin/bash
# ShopNow 3-Tier - Stop All Services
# Usage: ./stop-all.sh

echo "Stopping backend (port 4000)..."
sudo lsof -ti :4000 | xargs -r sudo kill -9

echo "Stopping frontend (port 8081)..."
sudo lsof -ti :8081 | xargs -r sudo kill -9

echo "Done. (PostgreSQL left running as a system service — stop it separately with: sudo service postgresql stop)"
