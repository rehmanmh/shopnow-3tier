#!/usr/bin/env bash

echo "=========================================================="
echo " Starting Traffic Generator (Unknown 502 / Crash Scenario)"
echo " Press [CTRL+C] to stop execution                        "
echo "=========================================================="

while true; do
  # Regular traffic
  RAND_ID=$(( ( RANDOM % 4 ) + 1 ))
  curl -s -o /dev/null -w "GET /api/products/$RAND_ID -> Status: %{http_code}\n" \
    "http://localhost:4000/api/products/$RAND_ID" &

  # Unknown failing checkout route (Product 7)
  if [ $(( RANDOM % 4 )) -eq 0 ]; then
    curl -s -o /dev/null -w "--> GET /api/products/checkout/7 -> Status: %{http_code} [UNKNOWN ISSUE]\n" \
      "http://localhost:4000/api/products/checkout/7" &
  fi

  sleep 0.3
done
