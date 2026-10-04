#!/bin/sh
# Pane entrypoint: render terminal-browser in herdr's own (already-split) pane.
# Usage: pane.sh [url]  -> renders into the current pane (no extra split).
set -eu
DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

_ensure_browser || exit 1
URL="${1:-}"

if [ -n "$URL" ]; then
  exec "$BROWSER_BIN" open --no-overlays --size 0.7 "$URL" 2>/dev/null \
    || exec "$BROWSER_BIN" open "$URL"
else
  exec "$BROWSER_BIN" open --no-overlays 2>/dev/null \
    || exec "$BROWSER_BIN" open
fi
