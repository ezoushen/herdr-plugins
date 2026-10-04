# lib.sh — shared helpers for the Local Browser plugin.
# Sourced by pane.sh and open_url.sh. Never execute directly.

# Resolve the terminal-browser engine. Honors an override so we can point at a
# personal checkout if desired.
_what_browser() {
  if [ -n "${TERMINAL_BROWSER_BIN:-}" ] && command -v "$TERMINAL_BROWSER_BIN" >/dev/null 2>&1; then
    printf '%s\n' "$TERMINAL_BROWSER_BIN"
  elif command -v terminal-browser >/dev/null 2>&1; then
    printf '%s\n' "$(command -v terminal-browser)"
  else
    return 1
  fi
}

BROWSER_BIN=""
_ensure_browser() {
  [ -n "$BROWSER_BIN" ] && return 0
  BROWSER_BIN=$(_what_browser) || {
    echo "Local Browser: terminal-browser engine not found on PATH. Install it first." >&2
    return 1
  }
}

# Per-invocation state dir (provided by herdr) or a stable fallback.
LOG_DIR="${HERDR_PLUGIN_STATE_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/howto-browser}"
mkdir -p "$LOG_DIR" 2>/dev/null || true
CLICK_LOG="$LOG_DIR/clicks.log"

_log() {
  # best-effort timestamped logging; never fatal
  ts="$(date '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null || echo '?')"
  {
    printf '%s ' "$ts"
    printf '[%s] ' "${PLUGIN_ID:-local.howto.browser}"
    printf '%s\n' "$*"
  } >>"$LOG_DIR/events.log" 2>/dev/null || true
}

# Pretty-print the raw click context so we can calibrate detection later.
_log_context() {
  ctx="$1"
  if [ -n "$ctx" ] && command -v jq >/dev/null 2>&1; then
    jq -C . <<JSON >>"$LOG_DIR/clicks.log" 2>/dev/null || printf '%s\n' "$ctx" >>"$LOG_DIR/clicks.log"
$ctx
JSON
  else
    printf '%s\n' "$ctx" >>"$LOG_DIR/clicks.log" 2>/dev/null || true
  fi
}
