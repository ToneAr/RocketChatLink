#!/usr/bin/env bash
# teardown.sh — Stop and remove the local RocketChat Docker stack.
# Removes volumes so the next test run starts from a clean state.
#
# Usage: ./teardown.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"

echo "==> Stopping RocketChat Docker stack …"
docker compose -f "${COMPOSE_FILE}" down --volumes --remove-orphans
echo "==> Done."
