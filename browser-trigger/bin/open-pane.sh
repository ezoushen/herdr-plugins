#!/bin/sh
# Actions are background commands; ask Herdr to create a pane for the renderer.
set -eu
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$DIR/lib.sh"
_ensure_browser
HERDR="${HERDR_BIN_PATH:-herdr}"
set -- plugin pane open --plugin "${HERDR_PLUGIN_ID:-ezoushen.browser-trigger}" \
  --entrypoint browser --placement split --direction right --no-focus
if [ -n "${BROWSER_TRIGGER_URL:-}" ]; then
  set -- "$@" --env "BROWSER_TRIGGER_URL=$BROWSER_TRIGGER_URL"
fi
exec "$HERDR" "$@"
