import json
import os
import subprocess
import tempfile
import tomllib
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "browser-trigger"
PLUGIN_ID = "ezoushen.browser-trigger"
INSTALL = "ezoushen/herdr-plugins/browser-trigger"


class RepositoryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        directory = Path(self.temp.name)
        self.engine = directory / "fake engine"
        self.herdr = directory / "fake herdr"
        for executable in (self.engine, self.herdr):
            executable.write_text(
                "#!/usr/bin/env python3\n"
                "import json, sys\n"
                "print(json.dumps(sys.argv[1:]))\n"
            )
            executable.chmod(0o755)
        self.env = {
            **os.environ,
            "TERMINAL_BROWSER_BIN": str(self.engine),
            "HERDR_BIN_PATH": str(self.herdr),
            "HERDR_PLUGIN_ID": PLUGIN_ID,
        }
        for key in ("BROWSER_TRIGGER_URL", "HERDR_PLUGIN_CLICKED_URL"):
            self.env.pop(key, None)

    def run_script(self, name, **extra_env):
        return subprocess.run(
            ["sh", str(PLUGIN / "bin" / name)],
            env={**self.env, **extra_env},
            capture_output=True, text=True,
        )

    def test_monorepo_manifest_fixture(self):
        manifests = list(ROOT.glob("*/herdr-plugin.toml"))
        self.assertEqual(manifests, [PLUGIN / "herdr-plugin.toml"])
        self.assertFalse((ROOT / "herdr-plugin.toml").exists())
        ids = []
        for path in manifests:
            data = tomllib.loads(path.read_text())
            for field in ("id", "name", "version", "min_herdr_version"):
                self.assertTrue(data[field])
            ids.append(data["id"])
            self.assertEqual(data["id"], PLUGIN_ID)
            actions = {a["id"] for a in data["actions"]}
            for handler in data["link_handlers"]:
                self.assertTrue(handler["title"])
                self.assertIn(handler["action"], actions)
            for group in ("build", "actions", "panes"):
                for entry in data[group]:
                    command = entry["command"]
                    self.assertEqual(command[0], "sh")
                    self.assertTrue((path.parent / command[1]).is_file())
        self.assertEqual(len(ids), len(set(ids)))

    def test_docs_canonical_install_path_and_dependency(self):
        for path in (ROOT / "README.md", PLUGIN / "README.md"):
            text = path.read_text()
            self.assertIn(INSTALL, text)
            self.assertIn("terminal-browser", text)
            for wrong in ("howdr-plugs", "ezouteminal", "ezou…", "how-to-browser"):
                self.assertNotIn(wrong, text)
        self.assertIn("not implemented or verified", (PLUGIN / "README.md").read_text())

    def test_all_shell_scripts_parse(self):
        for path in PLUGIN.glob("bin/*.sh"):
            result = subprocess.run(["sh", "-n", str(path)], capture_output=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_dependency_check_uses_explicit_engine(self):
        result = self.run_script("build-engine.sh")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(str(self.engine), result.stdout)

    def test_invalid_engine_override_fails_without_fallback(self):
        result = self.run_script("build-engine.sh", TERMINAL_BROWSER_BIN="/no/such/engine")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("requires terminal-browser", result.stderr)

    def test_open_pane_asks_herdr_for_separate_pane(self):
        result = self.run_script("open-pane.sh")
        self.assertEqual(result.returncode, 0, result.stderr)
        args = json.loads(result.stdout)
        self.assertEqual(args[:5], ["plugin", "pane", "open", "--plugin", PLUGIN_ID])
        self.assertIn("--no-focus", args)
        self.assertNotIn("--env", args)

    def test_url_is_forwarded_as_one_argument_without_shell_expansion(self):
        url = 'https://example.com/?q=";$(echo injected)&x=one two'
        result = self.run_script("open_url.sh", HERDR_PLUGIN_CLICKED_URL=url)
        self.assertEqual(result.returncode, 0, result.stderr)
        args = json.loads(result.stdout)
        self.assertEqual(args[-2:], ["--env", "BROWSER_TRIGGER_URL=" + url])

    def test_non_http_url_is_rejected(self):
        result = self.run_script("open_url.sh", HERDR_PLUGIN_CLICKED_URL="file:///etc/passwd")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_pane_renders_in_existing_pane(self):
        url = "https://example.com/"
        result = self.run_script("pane.sh", BROWSER_TRIGGER_URL=url)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), ["open", url])

    def test_pane_without_url_starts_engine(self):
        result = self.run_script("pane.sh")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), ["open"])


if __name__ == "__main__":
    unittest.main()
