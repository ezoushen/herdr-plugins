# how-to-browser

Local Browser — open clickable URLs in an in-terminal browser; **cmd+click opens your system browser**.

### Install (from the `ezou…/howdr-plugs` monorepo)

```bash
herdr plugin install ezou…/howdr-plugs/how-to-browser
herdr plugin install ezou…/howdr-plugs/how-to-browser --ref <sha> --yes    # pin a revision
```

### Dependency (declared)

Requires the external **terminal-browser** engine. Installing this plugin runs the manifest's `[[build]]` step, which bootstraps terminal-browser on macOS/Linux (falling back to `https://terminal-browser.sh/install`). To drive a specific engine, export `TERMINAL_BROWSER_BIN=/path/to/terminal-browser` before install/link, or install it yourself. See `herdr-plugin.toml` and `../../LICENSE`.

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
