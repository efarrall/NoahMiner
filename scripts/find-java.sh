#!/usr/bin/env bash
# Prints a Java 25+ executable path to stdout, or exits 1 with a helpful message.
set -euo pipefail

java_major_version() {
  "$1" -version 2>&1 | awk -F\" '/version/ {print $2}' | cut -d. -f1
}

try_java() {
  local bin="$1"
  [[ -x "$bin" ]] || return 1
  local major
  major="$(java_major_version "$bin" 2>/dev/null || true)"
  [[ -n "$major" && "$major" -ge 25 ]]
}

if [[ -n "${JAVA_CMD:-}" ]] && try_java "$JAVA_CMD"; then
  echo "$JAVA_CMD"
  exit 0
fi

candidates=(
  java
  /usr/lib/jvm/java-25-openjdk-amd64/bin/java
  /usr/lib/jvm/java-25-openjdk/bin/java
  /usr/lib/jvm/temurin-25-jdk-amd64/bin/java
)

for bin in "${candidates[@]}"; do
  if command -v "$bin" >/dev/null 2>&1 && try_java "$(command -v "$bin")"; then
    echo "$(command -v "$bin")"
    exit 0
  fi
done

echo "No Java 25+ found. Minecraft 26.2 needs Java 25 (class file 69), not Java 21." >&2
echo "" >&2
echo "Linux (Ubuntu/Debian):" >&2
echo "  sudo apt update && sudo apt install openjdk-25-jre-headless" >&2
echo "  ./start-server.sh" >&2
echo "" >&2
echo "Windows: install Temurin 25 from https://adoptium.net/ then restart the terminal." >&2
echo "Check: java -version  (must show 25 or higher)" >&2
exit 1
