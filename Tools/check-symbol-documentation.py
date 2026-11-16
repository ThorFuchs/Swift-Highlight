#!/usr/bin/env python3
"""Fail when a source-declared public symbol in a graph lacks a doc comment."""
import json
from pathlib import Path
import sys

if len(sys.argv) < 2:
    raise SystemExit("usage: check-symbol-documentation.py GRAPH [GRAPH ...]")
missing = []
count = 0
for name in sys.argv[1:]:
    graph = json.loads(Path(name).read_text(encoding="utf-8"))
    symbols = graph["symbols"]
    if isinstance(symbols, dict):
        symbols = symbols.values()
    for symbol in symbols:
        if symbol.get("accessLevel") != "public" or not symbol.get("location"):
            continue
        count += 1
        if not symbol.get("docComment", {}).get("lines"):
            missing.append(".".join(symbol["pathComponents"]))
if not count:
    raise SystemExit("No source-declared public symbols found")
for symbol in sorted(missing):
    print(f"Undocumented public symbol: {symbol}")
print(f"Documented public source symbols: {count - len(missing)}/{count}")
raise SystemExit(bool(missing))
