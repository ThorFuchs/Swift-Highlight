#!/usr/bin/env bash
set -euo pipefail

name="${1:-world}"
languages=(Swift Python Rust)

for language in "${languages[@]}"; do
  printf 'Hello, %s, from %s!\n' "$name" "$language"
done
