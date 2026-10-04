#!/bin/sh
# Herdr supplies a clicked URL, not a Command/plain-click discriminator.
set -eu
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
URL="${HERDR_PLUGIN_CLICKED_URL:-${1:-}}"
case "$URL" in
  http://?*|https://?*) ;;
  *) printf 'Browser Trigger requires an HTTP(S) URL.\n' >&2; exit 1 ;;
esac
BROWSER_TRIGGER_URL="$URL"
export BROWSER_TRIGGER_URL
exec sh "$DIR/open-pane.sh"
