#!/bin/sh
# Check the external dependency without downloading or executing an installer.
set -eu
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$DIR/lib.sh"
_ensure_browser
printf 'Browser Trigger dependency found: %s\n' "$BROWSER_BIN"
