#!/bin/sh
# End-to-end CLI smoke: run after building the highlight-card product.
set -eu
binary=${1:-"$(swift build --show-bin-path)/highlight-card"}
tmp=$(mktemp -d "${TMPDIR:-/tmp}/highlight-card-test.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

"$binary" --help > "$tmp/help.txt"
grep -q -- '--language' "$tmp/help.txt"
printf 'let word = "<tag>"\n' | "$binary" --language swift --title '<unsafe>' > "$tmp/card.html"
grep -q '<title>&lt;unsafe&gt;</title>' "$tmp/card.html"
grep -q '&lt;tag&gt;' "$tmp/card.html"
grep -q 'hljs-keyword' "$tmp/card.html"
if printf 'x' | "$binary" --language not-a-language > "$tmp/bad.out" 2> "$tmp/bad.err"; then
    printf '%s\n' 'Unknown language unexpectedly succeeded' >&2; exit 1
fi
if printf 'x' | "$binary" --language plaintext --format html --width 400 > "$tmp/bad.out" 2> "$tmp/bad.err"; then
    printf '%s\n' 'PNG-only option unexpectedly accepted for HTML' >&2; exit 1
fi
if printf 'x' | "$binary" --language plaintext --format png --no-wrap > "$tmp/bad.out" 2> "$tmp/bad.err"; then
    printf '%s\n' 'Clipped PNG unexpectedly succeeded' >&2; exit 1
fi
if [ "$(uname -s)" = Darwin ]; then
    printf 'let answer = 42\n' | "$binary" --language swift --format png --width 320 --output "$tmp/card.png"
    file "$tmp/card.png" | grep -q 'PNG image data'
else
    if printf 'x' | "$binary" --language plaintext --format png > "$tmp/bad.out" 2> "$tmp/bad.err"; then
        printf '%s\n' 'PNG unexpectedly succeeded without macOS' >&2; exit 1
    fi
    grep -q 'requires macOS' "$tmp/bad.err"
fi
printf '%s\n' 'Code-card CLI smoke passed'
