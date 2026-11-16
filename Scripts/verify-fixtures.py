#!/usr/bin/env python3
"""Verify checked-in token expectations against the pinned highlight.js build.

Never rewrites checked-in expectations. Optionally generates files outside
the checkout for review. Run after `npm ci && npm run build`
in the pinned highlight.js checkout; set HIGHLIGHTJS_DIR to that checkout.
"""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--output-dir", type=Path, help="write generated JSON into a new directory outside the repository")
args = parser.parse_args()
root = Path(__file__).resolve().parent.parent
output_dir = args.output_dir.resolve() if args.output_dir else None
if output_dir and (output_dir == root or root in output_dir.parents or output_dir.exists()):
    sys.exit("output directory must be a new path outside the repository")
fixtures = root / "Tests/HighlightKitTests/Fixtures"
reference = Path(os.environ["HIGHLIGHTJS_DIR"]).resolve()
revision = subprocess.check_output(["git", "-C", str(reference), "rev-parse", "HEAD"], text=True).strip()
if revision != "08cb242e7d4aee787114eb04cc7ab18314d82f92":
    sys.exit(f"wrong highlight.js revision: {revision}")
code_files = sorted(fixtures.glob("*/*.code.txt"))
expected_files = list(fixtures.glob("*/*.tokens.json"))
if len(code_files) != 375 or len(expected_files) != 375 or len({p.parent for p in code_files}) != 65:
    sys.exit("unexpected fixture inventory")
inputs = []
for path in code_files:
    with path.open(encoding="utf-8", newline="") as file:
        code = file.read()
    inputs.append(json.dumps({"lang": path.parent.name, "code": code}, ensure_ascii=True))
result = subprocess.run(["node", str(root / "Scripts/tokenize-batch.mjs")], input="\n".join(inputs) + "\n", text=True, capture_output=True, check=True)
lines = result.stdout.splitlines()
if len(lines) != len(code_files):
    sys.exit(f"reference returned {len(lines)} results for {len(code_files)} inputs: {result.stderr}")
failures = []
generated = []
clipped = 0
for path, line in zip(code_files, lines):
    expected_path = path.with_name(path.name.removesuffix(".code.txt") + ".tokens.json")
    expected = json.loads(expected_path.read_text(encoding="utf-8"))
    actual = json.loads(line)
    if "error" in actual:
        sys.exit(f"reference failed for {path}: {actual['error']}")
    clipped += actual.get("referenceEOFUnitsClipped", 0)
    generated.append((path, {"language": path.parent.name, "relevance": actual["relevance"], "tokens": actual["tokens"]}))
    if "error" in actual or expected["language"] != path.parent.name or actual.get("tokens") != expected["tokens"] or abs(actual.get("relevance", -1) - expected["relevance"]) > 0.001:
        failures.append(f"{path.relative_to(fixtures)}: {actual.get('error', 'token/relevance mismatch')}")
if failures:
    print("\n".join(failures), file=sys.stderr)
    sys.exit(f"{len(failures)} fixture(s) failed; expectations unchanged")
if output_dir:
    output_dir.mkdir(parents=True, exist_ok=False)
    for path, data in generated:
        destination = output_dir / path.parent.name / (path.name.removesuffix(".code.txt") + ".tokens.json")
        destination.parent.mkdir(exist_ok=True)
        destination.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Generated {len(generated)} reference files at {output_dir}")
print(f"Verified {len(code_files)} pairs across 65 languages; clipped EOF units: {clipped}")
