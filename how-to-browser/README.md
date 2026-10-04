# how-to-browser

Local Browser — open clickable URLs in an in-terminal browser; **cmd+click opens your system browser**.

### Install
```bash
herdr plugin install ezoushen/browser-trigger/how-to-browser
# pinned:
herdr plugin install ezoushen/browser-trigger/how-to-browser --ref <sha> --yes
```

### Dependency (declared)
Requires the external **terminal-browser** engine. Installing this plugin via `herdr plugin install`
auto-bootstraps it on macOS/Linux (falling back to `https://terminal-browser.sh/install`). To drive a
specific engine, export `TERMINAL_BROWSER_BIN=/path/to/terminal-browser` before install/link, or install
it yourself first. See `herdr-plugin.toml` (`[[build]]`) and `../../LICENSE`.

### Usage
- Tap/click any `http(s)` URL in a Herdr pane → opens in a right-side split browser.
- `cmd`+left-click → opens in your system browser.
- Optional keybinding (add to `~/.config/herdr/config.toml`):
```toml
[[keys.command]]
key = "prefix+b"
type = "plugin_action"
command = "local.howto.browser.open-pane"
description = "open in-terminal browser pane"
```
