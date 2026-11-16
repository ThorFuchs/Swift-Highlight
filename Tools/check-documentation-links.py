#!/usr/bin/env python3
"""Check local Markdown link destinations in maintained project docs.

This does not validate external links, fragments, or DocC symbol links.
"""
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

root = Path(__file__).resolve().parent.parent
files = list(root.glob("*.md"))
for directory in ("Documentation", "Docs", "Sources", "Examples", "Scripts"):
    files.extend(p for p in (root / directory).rglob("*.md") if ".build" not in p.parts)
pattern = re.compile(r"\[[^\]]+\]\((<[^>]+>|[^\s)]+)(?:\s+[^)]*)?\)")
errors = []
for path in sorted(files):
    fence = None
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        marker = re.match(r"^\s*(`{3,}|~{3,})", line)
        if marker:
            mark = marker.group(1)
            if fence is None:
                fence = mark
            elif mark[0] == fence[0] and len(mark) >= len(fence):
                fence = None
            continue
        if fence is not None:
            continue
        for match in pattern.finditer(line):
            target = match.group(1).strip("<>")
            parts = urlsplit(target)
            if parts.scheme or parts.netloc or not parts.path:
                continue
            resolved = (path.parent / unquote(parts.path)).resolve()
            if not resolved.exists():
                errors.append(f"{path.relative_to(root)}:{number}: {target}")
if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)
print(f"Checked local links in {len(files)} documentation files")
