# browser-trigger

Community Herdr plugins published as a single repository. Each plugin lives in its own subdirectory and is
independently installable. The repo is tagged with the GitHub topic `herdr-plugin`, so any plugin can be
installed straight from GitHub (and listed in the marketplace once discovery is live).

```bash
herdr plugin install ezoushen/browser-trigger/<subdir>
herdr plugin install ezoushen/browser-trigger/<subdir> --ref <sha> --yes   # pinned
```

### Plugins

| Subdir | Description | Install |
|---|---|---|
| [`how-to-browser`](how-to-browser/) | Open clickable URLs in an in-terminal browser; cmd+click opens your system browser. Requires the `terminal-browser` engine. | `herdr plugin install ezoushen/browser-trigger/how-to-browser` |

### Requirements to be listed
- Repository tagged with GitHub topic `herdr-plugin`.
- Each plugin ships its own `herdr-plugin.toml` (with `id` / `name` / `version` / `min_herdr_version`).
- Root `README.md` documents the install pattern (this file).

Contribute: add a subdir with a `herdr-plugin.toml` and a `README.md`, then open a pull request.
