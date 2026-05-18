#!/usr/bin/env bash
# Downloads the official Minecraft server jar for the version in minecraft-version.txt
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSION="$(tr -d '[:space:]' < minecraft-version.txt)"
if [[ -z "$VERSION" ]]; then
  echo "minecraft-version.txt is empty." >&2
  exit 1
fi

echo "Downloading Minecraft server ${VERSION}..."

MANIFEST_URL="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
VERSION_URL="$(curl -fsSL "$MANIFEST_URL" | python3 -c "
import json, sys
target = sys.argv[1]
data = json.load(sys.stdin)
for v in data['versions']:
    if v['id'] == target:
        print(v['url'])
        break
else:
    raise SystemExit(f'Version not found in manifest: {target}')
" "$VERSION")"

SERVER_URL="$(curl -fsSL "$VERSION_URL" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data['downloads']['server']['url'])
")"

curl -fL --progress-bar -o server.jar "$SERVER_URL"
echo "Saved server.jar ($(du -h server.jar | cut -f1))"
