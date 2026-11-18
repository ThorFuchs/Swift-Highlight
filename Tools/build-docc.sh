#!/bin/sh
# Build documentation using the installed Swift toolchain; no package plugin required.
# Usage: Tools/build-docc.sh [scratch-directory] [output-directory]
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
scratch=${1:-"$root/.build/docc-work"}
output=${2:-"$root/.build/docc"}
mkdir -p "$scratch" "$output"
scratch=$(CDPATH= cd -- "$scratch" && pwd)
output=$(CDPATH= cd -- "$output" && pwd)
cd "$root"
# On some Apple toolchains SwiftPM also extracts the generated package test
# runner, even though dump-symbol-graph builds without tests. Build that module
# in the same scratch directory first so extraction can import it.
if [ "$(uname -s)" = Darwin ]; then
    swift build --scratch-path "$scratch" --build-tests
fi
swift package --scratch-path "$scratch" dump-symbol-graph --skip-synthesized-members
if command -v docc >/dev/null 2>&1; then
    docc_command=docc
elif command -v xcrun >/dev/null 2>&1; then
    docc_command=$(xcrun --find docc)
else
    printf '%s\n' 'DocC not found in the selected toolchain' >&2
    exit 1
fi
# SwiftPM may place each target's symbol graph in a separate directory.
# Prefer the consolidated output, but search per target when it is absent.
tmp=$(mktemp -d "${TMPDIR:-/tmp}/swift-highlight-docc.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
for module in SwiftHighlight SwiftHighlightHTML SwiftHighlightApple SwiftHighlightCodeCard SwiftHighlightSwiftUI; do
    graph="$scratch/out/symbolgraph/$module.symbols.json"
    if [ ! -f "$graph" ]; then
        graph=$(find "$scratch" -type f -name "$module.symbols.json" -print -quit)
    fi
    if [ -z "$graph" ] || [ ! -f "$graph" ]; then
        printf 'Symbol graph not found for %s under %s\n' "$module" "$scratch" >&2
        exit 1
    fi
    graphdir=$(dirname "$graph")
    case "$module" in
      SwiftHighlight) catalog=Sources/HighlightKit/SwiftHighlight.docc ;;
      SwiftHighlightHTML) catalog=Sources/SwiftHighlightHTML/SwiftHighlightHTML.docc ;;
      SwiftHighlightApple) catalog=Sources/HighlightKit/Rendering/SwiftHighlightApple.docc ;;
      SwiftHighlightCodeCard) catalog=Sources/SwiftHighlightCodeCard/SwiftHighlightCodeCard.docc ;;
      SwiftHighlightSwiftUI) catalog=Sources/SwiftHighlightSwiftUI/SwiftHighlightSwiftUI.docc ;;
    esac
    # Linux cannot emit UIKit/AppKit symbols; report the omission explicitly.
    count=$(python3 -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["symbols"]))' "$graph")
    if [ "$count" -eq 0 ]; then
        if { [ "$module" = SwiftHighlightApple ] || [ "$module" = SwiftHighlightSwiftUI ]; } && [ "$(uname -s)" = Linux ]; then
            printf 'Skipping %s DocC: no Apple SDK symbols on this host.\n' "$module"
            continue
        fi
        printf 'No symbols found for %s\n' "$module" >&2
        exit 1
    fi
    mkdir -p "$tmp/$module"
    cp "$graph" "$tmp/$module/"
    # Apple extensions on the core module may be emitted as secondary graphs.
    for extension in "$graphdir/$module"@*.symbols.json; do
        if [ -f "$extension" ]; then cp "$extension" "$tmp/$module/"; fi
    done
    python3 Tools/check-symbol-documentation.py "$tmp/$module/"*.symbols.json
    "$docc_command" convert "$catalog" --additional-symbol-graph-dir "$tmp/$module" \
        --fallback-display-name "$module" --fallback-bundle-identifier "io.github.thorfuchs.$module" \
        --fallback-bundle-version 1.0.0 --output-path "$output/$module.doccarchive" --warnings-as-errors
    printf 'Documentation archive: %s/%s.doccarchive\n' "$output" "$module"
done
