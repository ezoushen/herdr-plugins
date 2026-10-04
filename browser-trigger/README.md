# Browser Trigger

A Herdr plugin that opens HTTP(S) URLs in a browser split using the external [terminal-browser](https://github.com/zenbu-labs/terminal-browser) engine.

## Required dependencies

- **Herdr 0.8.2 or newer** — plugin actions, panes and link handlers.
- **`terminal-browser` executable on PATH** — the browser engine, not included in this repository. CLI integration is tested with version **0.8.1**. Install it separately using the upstream instructions.
- **POSIX `sh`** on macOS or Linux.

The install-time `[[build]]` step checks for the engine and fails with an actionable error when it is missing. It does **not** download or execute a remote installer. An explicit `TERMINAL_BROWSER_BIN=/absolute/path/to/terminal-browser` override is supported; an invalid override fails rather than silently falling back. Runtime overrides must also be visible in the Herdr server's environment.

## Install independently

```sh
herdr plugin install ezoushen/herdr-plugins/browser-trigger
# Pin a published revision:
herdr plugin install ezoushen/herdr-plugins/browser-trigger --ref <revision>
```

Plugin ID: `ezoushen.browser-trigger`.

## Use

```sh
herdr plugin action invoke ezoushen.browser-trigger.open-pane
```

Optional binding in `~/.config/herdr/config.toml`:

```toml
[[keys.command]]
key = "prefix+b"
type = "plugin_action"
command = "ezoushen.browser-trigger.open-pane"
description = "open browser split"
```

The HTTP(S) link handler forwards the URL supplied by Herdr into a new browser split. It does not intercept all plain clicks or detect Command independently.

**Gesture limitation:** Herdr's documented plugin link handlers use **Ctrl-click**, including on macOS. System-browser opening through Cmd-click or Shift-Cmd-click depends on the host terminal and Herdr mouse capture. The requested plain-click → embedded browser / Cmd-click → system browser mapping is **not implemented or verified** by this plugin. Installing successfully does not establish that behavior. See [Herdr's link-handler reference](https://herdr.dev/docs/plugins/).

## Develop and remove

```sh
sh browser-trigger/bin/build-engine.sh
herdr plugin link ./browser-trigger
herdr plugin uninstall ezoushen.browser-trigger
```

Runtime browser rendering and mouse input require an interactive smoke test. Unit tests use fake engine and Herdr executables without opening panes.

License: [MIT](../LICENSE). The external engine has its own licensing and installation requirements.
