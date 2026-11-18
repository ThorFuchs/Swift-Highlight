#!/usr/bin/env python3
"""Exercise DocC graph discovery without requiring an Apple SDK."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent.parent
MODULES = ("SwiftHighlight", "SwiftHighlightHTML", "SwiftHighlightApple", "SwiftHighlightCodeCard", "SwiftHighlightSwiftUI")

class DocCGraphDiscoveryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="swift-highlight-docc-test-")
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.scratch = self.root / "scratch with spaces"
        self.output = self.root / "output with spaces"
        self.log = self.root / "docc.log"
        for executable, script in {
            "swift": "#!/bin/sh\nexit 0\n",
            "docc": "#!/bin/sh\nprintf '%s\\n' \"$2\" >> \"$DOCC_TEST_LOG\"\n",
        }.items():
            path = self.bin / executable
            path.write_text(script, encoding="utf-8")
            path.chmod(0o755)
        self.env = os.environ.copy()
        self.env["PATH"] = str(self.bin) + os.pathsep + self.env.get("PATH", "")
        self.env["DOCC_TEST_LOG"] = str(self.log)

    def tearDown(self):
        self.temp.cleanup()

    def graph(self, module):
        directory = self.scratch / "per-target" / (module + ".symbolgraphs")
        directory.mkdir(parents=True, exist_ok=True)
        graph = {"symbols": [{"accessLevel": "public", "location": {"uri": "file:///source.swift"},
                             "pathComponents": ["Example"], "docComment": {"lines": [{"text": "Example."}]}}]}
        (directory / (module + ".symbols.json")).write_text(json.dumps(graph), encoding="utf-8")

    def run_script(self):
        return subprocess.run(["sh", str(ROOT / "Tools/build-docc.sh"), str(self.scratch), str(self.output)],
                              cwd=ROOT, env=self.env, text=True, capture_output=True)

    def test_finds_graphs_in_separate_directories(self):
        for module in MODULES:
            self.graph(module)
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(self.log.read_text().splitlines()), len(MODULES))
        for module in MODULES:
            self.assertIn(module + ".doccarchive", result.stdout)

    def test_empty_apple_graph_fails_on_darwin(self):
        for module in MODULES:
            self.graph(module)
        apple = self.scratch / "per-target" / "SwiftHighlightApple.symbolgraphs" / "SwiftHighlightApple.symbols.json"
        apple.write_text(json.dumps({"symbols": []}), encoding="utf-8")
        uname = self.bin / "uname"
        uname.write_text("#!/bin/sh\nprintf 'Darwin\\n'\n", encoding="utf-8")
        uname.chmod(0o755)
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("No symbols found for SwiftHighlightApple", result.stderr)

    def test_missing_graph_reports_error(self):
        self.graph("SwiftHighlight")
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Symbol graph not found for SwiftHighlightHTML", result.stderr)

    def test_extraction_failure_is_not_ignored(self):
        for module in MODULES:
            self.graph(module)
        swift = self.bin / "swift"
        swift.write_text("#!/bin/sh\nif [ \"$1\" = package ]; then exit 17; fi\n", encoding="utf-8")
        result = self.run_script()
        self.assertEqual(result.returncode, 17)
        self.assertFalse(self.log.exists())

    def test_darwin_builds_test_runner_before_extracting_graphs(self):
        for module in MODULES:
            self.graph(module)
        uname = self.bin / "uname"
        uname.write_text("#!/bin/sh\nprintf 'Darwin\\n'\n", encoding="utf-8")
        uname.chmod(0o755)
        swift = self.bin / "swift"
        swift.write_text(
            "#!/bin/sh\n"
            "if [ \"$1\" = build ]; then\n"
            "  [ \"$2\" = --scratch-path ] && [ \"$3\" = \"$DOCC_TEST_SCRATCH\" ] && "
            "[ \"$4\" = --build-tests ] || exit 2\n"
            "  : > \"$DOCC_TEST_MARKER\"\n"
            "elif [ \"$1\" = package ]; then\n"
            "  [ -f \"$DOCC_TEST_MARKER\" ] || exit 3\n"
            "else\n  exit 4\nfi\n", encoding="utf-8")
        swift.chmod(0o755)
        self.env["DOCC_TEST_SCRATCH"] = str(self.scratch)
        self.env["DOCC_TEST_MARKER"] = str(self.root / "test-runner-built")
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(len(self.log.read_text().splitlines()), len(MODULES))

if __name__ == "__main__":
    unittest.main()
