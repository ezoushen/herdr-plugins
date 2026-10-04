# howdr-plugs

Community Herdr plugins published as a single **monorepo** owned by `ezou…`. Each plugin lives in its own subdirectory and is independently installable; the repository is tagged with the GitHub topic `herdr-plugin`, so any plugin installs straight from GitHub.

## Install any plugin (by subdir)

```bash
herdr plugin install ezou…/howdr-plugs/how-to-browser

# Pin a specific revision:
herdr plugin install ezou…/howdr-plugs/how-to-browser --ref <sha> --yes
```

## Plugins

| Subdir | Description | Install |
|---|---|---|
| [`how-to-browser`](how-to-browser/) | Open clickable URLs in an in-terminal browser; cmd+click opens your system browser. Requires the `terminal-browser` engine. | `herdr plugin install ezou…/howdr-plugs/how-to-browser` |

## Requirements to be listed on the marketplace
- Repository tagged with GitHub topic `herdr-plugin`.
- Each plugin ships its own `herdr-plugin.toml` (with `id`, `name`, `version`, `min_herdr_version`).
- Root `README.md` documents the install pattern (this file).

Contribute: add a subdir with a `herdr-plugin.toml` and a `README.md`, then open a pull request.
