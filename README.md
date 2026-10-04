# herdr-plugins

Personal Herdr plugins by [ezoushen](https://github.com/ezoushen), maintained in one monorepo. Each plugin has its own manifest and can be installed separately.

| Plugin | Dependency | Install |
| --- | --- | --- |
| [Browser Trigger](browser-trigger/) | `terminal-browser` executable | `herdr plugin install ezoushen/herdr-plugins/browser-trigger` |

## Install

```sh
herdr plugin install ezoushen/herdr-plugins/browser-trigger
# Optionally pin a published commit or tag:
herdr plugin install ezoushen/herdr-plugins/browser-trigger --ref <revision>
```

Installing one subdirectory registers only that plugin, not every plugin in this repository. Herdr may clone the whole repository to resolve the selected subdirectory.

## Develop

```sh
git clone https://github.com/ezoushen/herdr-plugins.git
cd herdr-plugins
sh browser-trigger/bin/build-engine.sh
herdr plugin link ./browser-trigger
```

If a GitHub-installed copy with the same ID already exists, uninstall it before linking the local copy. Linking does not run build checks automatically.

Each future plugin belongs in its own directory with `herdr-plugin.toml` and `README.md`. The public repository uses the GitHub topic `herdr-plugin` for marketplace discovery.

## Checks

```sh
python3 -m unittest discover -s tests -v
```

These checks validate repository structure and mocked CLI calls; they do not prove live browser rendering or mouse gestures.
