#!/usr/bin/env python3
"""Verify symbol-documentation checks for extension graphs."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent.parent
CHECKER = ROOT / "Tools/check-symbol-documentation.py"

def symbol(name, kind, documented):
    result = {"accessLevel": "public", "location": {"uri": "file:///source.swift"},
              "kind": {"identifier": kind}, "pathComponents": name.split(".")}
    if documented:
        result["docComment"] = {"lines": [{"text": "Documented."}]}
    return result

class SymbolDocumentationTests(unittest.TestCase):
    def check(self, symbols):
        with tempfile.TemporaryDirectory(prefix="swift-symbol-test-") as temp:
            path = Path(temp) / "graph.json"
            path.write_text(json.dumps({"symbols": symbols}), encoding="utf-8")
            return subprocess.run([sys.executable, str(CHECKER), str(path)], text=True, capture_output=True)

    def test_extension_container_is_skipped_but_documented_member_is_counted(self):
        result = self.check([symbol("External", "swift.extension", False),
                             symbol("External.render()", "swift.method", True)])
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("1/1", result.stdout)

    def test_undocumented_extension_member_still_fails(self):
        result = self.check([symbol("External", "swift.extension", False),
                             symbol("External.render()", "swift.method", False)])
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("External.render()", result.stdout)

    def test_extension_containers_alone_do_not_pass(self):
        result = self.check([symbol("External", "swift.extension", False)])
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("No source-declared public symbols found", result.stderr)

    def test_undocumented_non_extension_still_fails(self):
        result = self.check([symbol("Widget", "swift.struct", False)])
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Widget", result.stdout)

if __name__ == "__main__":
    unittest.main()
