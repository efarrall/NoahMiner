#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [[ ! -f server.jar ]]; then
  echo "server.jar not found. Run: ./scripts/download-server.sh"
  exit 1
fi

if ! grep -q '^eula=true' eula.txt 2>/dev/null; then
  echo "You must accept the Minecraft EULA first."
  echo "Open eula.txt in this folder and change eula=false to eula=true"
  echo "https://aka.ms/MinecraftEULA"
  exit 1
fi

JAVA_BIN="$("$ROOT/scripts/find-java.sh")"
MEM="${NOAHMINER_MEMORY:-2G}"
echo "Using: $("$JAVA_BIN" -version 2>&1 | head -1)"
echo "Starting NoahMiner (Java memory: ${MEM})..."
echo "Stop the server cleanly: type  stop  in this window, then wait for it to exit."
exec "$JAVA_BIN" -Xms"${MEM}" -Xmx"${MEM}" -jar server.jar nogui
