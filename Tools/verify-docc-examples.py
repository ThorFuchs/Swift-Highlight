#!/usr/bin/env python3
"""Compile and run marked DocC examples as independent SwiftPM consumers.

An HTML comment immediately before a Swift fence selects dependencies:
    <!-- docc-verify: core -->  (or html / apple)
Apple examples are skipped on non-Apple hosts and should also run on macOS CI.
Swift fences in inline core API comments are checked as well.
"""
from __future__ import annotations

import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
PATTERN = re.compile(
    r"<!-- docc-verify: (core|html|apple) -->\s*\n```swift\s*\n(.*?)\n```",
    re.DOTALL,
)
PRODUCTS = {
    "core": ["SwiftHighlight"],
    "html": ["SwiftHighlight", "SwiftHighlightHTML"],
    "apple": ["SwiftHighlight", "SwiftHighlightApple"],
}


def main() -> None:
    examples = []
    skipped = []
    for catalog in sorted((ROOT / "Sources").rglob("*.docc")):
        for path in sorted(catalog.rglob("*.md")):
            content = path.read_text(encoding="utf-8")
            matches = list(PATTERN.finditer(content))
            if content.count("<!-- docc-verify:") != len(matches):
                raise SystemExit(f"Malformed DocC example marker or Swift fence: {path}")
            if content.count("```swift") != len(matches):
                raise SystemExit(f"Unverified Swift code block in {path}")
            for match in matches:
                platform, source = match.groups()
                if platform == "apple" and sys.platform != "darwin":
                    skipped.append(path.relative_to(ROOT))
                    continue
                examples.append((path.relative_to(ROOT), platform, source))
    # Inline API examples are core-only and omit the enclosing module import,
    # as is customary in a symbol's documentation page.
    inline_pattern = re.compile(
        r"(?m)^\s*/// ```swift\s*\n((?:\s*///[^\n]*\n)*?)\s*/// ```\s*$"
    )
    for path in sorted((ROOT / "Sources" / "HighlightKit").rglob("*.swift")):
        if "Rendering" in path.relative_to(ROOT).parts:
            continue
        content = path.read_text(encoding="utf-8")
        matches = list(inline_pattern.finditer(content))
        if content.count("/// ```swift") != len(matches):
            raise SystemExit(f"Malformed inline Swift code block in {path}")
        for match in matches:
            lines = [re.sub(r"^\s*/// ?", "", line) for line in match.group(1).splitlines()]
            examples.append((path.relative_to(ROOT), "core", "import SwiftHighlight\n" + "\n".join(lines)))
    if not examples:
        raise SystemExit("No runnable DocC examples found")

    with tempfile.TemporaryDirectory(prefix="swift-highlight-docc-examples-") as temp:
        package = Path(temp)
        targets = []
        for index, (path, platform, source) in enumerate(examples, 1):
            name = f"Example{index}"
            directory = package / "Sources" / name
            directory.mkdir(parents=True)
            (directory / "main.swift").write_text(source + "\n", encoding="utf-8")
            dependencies = ", ".join(
                f'.product(name: "{product}", package: {json.dumps(ROOT.name)})'
                for product in PRODUCTS[platform]
            )
            targets.append(f'.executableTarget(name: "{name}", dependencies: [{dependencies}])')
            print(f"Example {index}: {path}", flush=True)
        manifest = f'''// swift-tools-version: 6.1
import PackageDescription
let package = Package(
    name: "DocCExamples",
    platforms: [.macOS(.v15)],
    dependencies: [.package(path: {json.dumps(str(ROOT))})],
    targets: [{", ".join(targets)}]
)
'''
        (package / "Package.swift").write_text(manifest, encoding="utf-8")
        subprocess.run(["swift", "build", "--package-path", str(package)], check=True)
        for index in range(1, len(examples) + 1):
            subprocess.run(
                ["swift", "run", "--skip-build", "--package-path", str(package), f"Example{index}"],
                check=True,
            )
    print(f"Verified {len(examples)} DocC examples; skipped {len(skipped)} Apple-only examples")


if __name__ == "__main__":
    main()
