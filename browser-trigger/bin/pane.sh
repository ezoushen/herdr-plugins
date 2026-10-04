#!/bin/sh
# Herdr has already created the browser pane; render here without another split.
set -eu
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$DIR/lib.sh"
_ensure_browser
if [ -n "${BROWSER_TRIGGER_URL:-}" ]; then
  exec "$BROWSER_BIN" open "$BROWSER_TRIGGER_URL"
fi
exec "$BROWSER_BIN" open
