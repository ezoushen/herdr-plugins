#!/bin/sh
# Handler invoked by herdr when a user clicks a URL in a pane.
#   - Plain tap/click on a URL  -> open inside an in-terminal browser (herdr).
#   - Cmd+left-click            -> open in the system browser.
# On macOS the terminal mouse stream does not cleanly separate these gestures,
# so we inspect the context Herdr provides, log it, and fall back to tunable
# defaults from the settings file until we can calibrate to this machine.
set -eu
DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

_ensure_browser || exit 1

CLI_URL="${1:-}"
CLICKED_URL="${HERDR_PLUGIN_CLICKED_URL:-$CLI_URL}"
CONTEXT_JSON="${HERDR_PLUGIN_CONTEXT_JSON:-}"
ACTION_ID="${HERDR_PLUGIN_ACTION_ID:-}"

[ -n "$CONTEXT_JSON" ] && _log_context "$CONTEXT_JSON"
_log "action=$ACTION_ID url=${CLICKED_URL:-<none>} click_modifier=$(printf '%s' "$CONTEXT_JSON" | jq -r '.click_modifier // .button // .keyMods // ""' 2>/dev/null || echo '?')"

# --- Where should each gesture go? Tunable via ~/.config/howto-browser/settings.json ---
SETTINGS_DIR="${HERDR_PLUGIN_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/howto-browser}"
settings_value() { # key
  [ -f "$SETTINGS_DIR/settings.json" ] || return 0
  jq -r --arg k "$1" '.[$k] // empty' "$SETTINGS_DIR/settings.json" 2>/dev/null
}
DEFAULT_ON_CLICK="$(settings_value on_click)"          # herdr|system
DEFAULT_MOD_CLICK="$(settings_value mod_click)"        # herdr|system
ON_CLICK="${DEFAULT_ON_CLICK:-herdr}"
MOD_CLICK="${DEFAULT_MOD_CLICK:-system}"

force_system="${HERDR_BROWSER_FORCE_SYSTEM:-}"

decide_system() {
  ctx="$1"
  # Heuristics from whatever fields herdr exposes about the click.
  mod="$(printf '%s' "$ctx" | jq -r '(.click_modifier // .button // .keyMods // .mods // "")' 2>/dev/null || echo '')"
  case "$(printf '%s' "$mod" | tr '[:upper:]' '[:lower:]')" in
    *cmd*|*ctrl*|*super*|*meta*|*command*) return 0 ;;   # looks like a cmd/ctrl -> system
    *) return 1 ;;
  esac
}

if [ -z "$CLICKED_URL" ]; then
  _log "no URL to open; ignoring"
  exit 0
fi

is_mod="$(decide_system "$CONTEXT_JSON")"

if [ -n "$force_system" ]; then
  is_mod="yes"
fi

case "$is_mod" in
  yes)
    case "$MOD_CLICK" in
      system) open "$CLICKED_URL" >/dev/null 2>&1 || xdg-open "$CLICKED_URL" >/dev/null 2>&1 ;;
      herdr)  exec "$BROWSER_BIN" open --split right --size 0.7 "$CLICKED_URL" 2>/dev/null || exec "$BROWSER_BIN" open --split right "$CLICKED_URL" ;;
    esac
    ;;
  no)
    case "$ON_CLICK" in
      system) open "$CLICKED_URL" >/dev/null 2>&1 || xdg-open "$CLICKED_URL" >/dev/null 2>&1 ;;
      herdr)  exec "$BROWSER_BIN" open --split right --size 0.7 "$CLICKED_URL" 2>/dev/null || exec "$BROWSER_BIN" open --split right "$CLICKED_URL" ;;
    esac
    ;;
esac
