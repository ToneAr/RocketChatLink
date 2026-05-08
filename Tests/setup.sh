#!/usr/bin/env bash
# setup.sh — Start the local RocketChat Docker stack and wait until it is ready.
# Run from the Tests/ directory (or any directory; it locates itself via $SCRIPT_DIR).
#
# Usage: ./setup.sh [--timeout 300]
#
# Environment variables honoured:
#   RC_TIMEOUT  – seconds to wait for RocketChat to become healthy (default 300)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
TIMEOUT="${RC_TIMEOUT:-300}"

echo "==> Starting RocketChat Docker stack ..."
docker compose -f "${COMPOSE_FILE}" up -d --remove-orphans

echo "==> Waiting for RocketChat to become healthy (timeout: ${TIMEOUT}s) ..."
elapsed=0
interval=5
# /api/info is the correct path since RocketChat 8.x (was /api/v1/info in older versions)
until docker inspect \
        --format='{{.State.Health.Status}}' \
        "$(docker compose -f "${COMPOSE_FILE}" ps -q rocketchat)" \
        2>/dev/null | grep -q "^healthy$"; do
    if [ "${elapsed}" -ge "${TIMEOUT}" ]; then
        echo "ERROR: RocketChat did not become healthy within ${TIMEOUT}s."
        docker compose -f "${COMPOSE_FILE}" logs rocketchat | tail -40
        exit 1
    fi
    sleep "${interval}"
    elapsed=$(( elapsed + interval ))
    echo "... waiting (${elapsed}s)"
done

echo "==> RocketChat is healthy at http://localhost:3100"
echo "    Admin username : rc_admin"
echo "    Admin password : Test1234!"
