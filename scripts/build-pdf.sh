#!/usr/bin/env bash
# Genera los PDFs del CV a partir de las páginas web.
#   index.html  -> assets/pdf/CvIJEO-en.pdf
#   cv-es.html  -> assets/pdf/CvIJEO-es.pdf
# Uso: bash scripts/build-pdf.sh   (desde cualquier carpeta)
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="${CHROME:-}"
if [ -z "$CHROME" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           google-chrome google-chrome-stable chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then CHROME="$c"; break; fi
  done
fi
[ -n "$CHROME" ] || { echo "No encontré Chrome/Chromium" >&2; exit 1; }

PORT="${PORT:-8765}"
python3 -m http.server "$PORT" >/dev/null 2>&1 &
SERVER=$!
trap 'kill $SERVER 2>/dev/null' EXIT
for _ in $(seq 1 20); do curl -s "http://localhost:$PORT/" >/dev/null && break; python3 -c 'import time; time.sleep(0.25)'; done

PROFILE="$(mktemp -d)"
render() {
  "$CHROME" --headless=new --disable-gpu --no-sandbox \
    --user-data-dir="$PROFILE" \
    --no-pdf-header-footer --print-to-pdf-no-header \
    --virtual-time-budget=5000 --run-all-compositor-stages-before-draw \
    --print-to-pdf="$2" "http://localhost:$PORT/$1" 2>/dev/null
  echo "✓ $2"
}
render ""            assets/pdf/CvIJEO-en.pdf
render "cv-es.html"  assets/pdf/CvIJEO-es.pdf
rm -rf "$PROFILE"
