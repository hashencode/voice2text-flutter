#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WITH_BUILD=false
if [[ "${1:-}" == "--with-build" ]]; then
  WITH_BUILD=true
fi

echo "[1/4] Audio contract check"
./tool/check_audio_contract.sh

echo "[2/4] Flutter analyze"
flutter analyze

echo "[3/4] Flutter test"
flutter test

if [[ "$WITH_BUILD" == "true" ]]; then
  echo "[4/4] Flutter build apk --debug"
  flutter build apk --debug
else
  echo "[4/4] Skipped build (pass --with-build to enable)"
fi

echo "dev_check finished."
