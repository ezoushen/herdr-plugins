# Shared dependency resolution. An explicit override must not silently fall back.
_ensure_browser() {
  BROWSER_BIN="${TERMINAL_BROWSER_BIN:-terminal-browser}"
  if ! command -v "$BROWSER_BIN" >/dev/null 2>&1; then
    printf 'Browser Trigger requires terminal-browser. Install the engine separately or set TERMINAL_BROWSER_BIN to an executable path.\n' >&2
    return 1
  fi
}
