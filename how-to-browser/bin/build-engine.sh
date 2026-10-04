#!/bin/sh
# Ensure the terminal-browser engine our plugin drives is present.
# Respects TERMINAL_BROWSER_BIN; otherwise installs terminal-browser once.
set -eu
have=false
if [ -n "${TERMINAL_BROWSER_BIN:-}" ] && command -v "$TERMINAL_BROWSER_BIN" >/dev/null 2>&1; then have=true; fi
if [ "$have" = true ]; then echo "[build] using TERMINAL_BROWSER_BIN=$(command -v "$TERMINAL_BROWSER_BIN")"; exit 0; fi
command -v terminal-browser >/dev/null 2>&1 && { exit 0; }
case "$(uname -s)" in
  Darwin|Linux) : ;;
  *) echo "[build] unsupported platform $(uname -s); install terminal-browser manually." >&2; exit 0 ;;
esac
curl -fsSL https://terminal-browser.sh/install | bash
