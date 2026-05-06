#!/usr/bin/env bash

set -euo pipefail

DEVICE_ID="${1:-8PXCGQZPEQJNP7U8}"
KEEP_LATEST="${2:-10}"

if ! [[ "$KEEP_LATEST" =~ ^[0-9]+$ ]]; then
  echo "KEEP_LATEST must be a non-negative integer"
  exit 1
fi

echo "Device: $DEVICE_ID"
echo "Keep latest: $KEEP_LATEST"
APP_CACHE_DIR="cache/transcoded_audio"
raw_list="$(adb -s "$DEVICE_ID" shell run-as com.voice2text.app ls -1t "$APP_CACHE_DIR" 2>/dev/null | tr -d '\r' || true)"
wav_list="$(printf '%s\n' "$raw_list" | grep '\.wav$' || true)"

if [[ -z "$wav_list" ]]; then
  echo "No wav files found."
  exit 0
fi

echo "Found wav files:"
printf '%s\n' "$wav_list"

wav_array=()
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  wav_array+=("$line")
done <<< "$wav_list"
total="${#wav_array[@]}"

if (( total <= KEEP_LATEST )); then
  echo "Nothing to delete."
else
  for ((i = KEEP_LATEST; i < total; i++)); do
    f="${wav_array[i]}"
    [[ -z "$f" ]] && continue
    adb -s "$DEVICE_ID" shell run-as com.voice2text.app rm -f "$APP_CACHE_DIR/$f" >/dev/null
    echo "deleted: $f"
  done
fi

echo "remaining:"
adb -s "$DEVICE_ID" shell run-as com.voice2text.app ls -1t "$APP_CACHE_DIR" 2>/dev/null | tr -d '\r' | grep '\.wav$' || true
