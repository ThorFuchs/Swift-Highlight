# Swift-Highlight

[![CI](https://github.com/ThorFuchs/Swift-Highlight/actions/workflows/ci.yml/badge.svg)](https://github.com/ThorFuchs/Swift-Highlight/actions/workflows/ci.yml)

Swift-Highlight highlights source code in Swift. It separates language analysis
from rendering, so the same tokens can produce an escaped HTML fragment or an
Apple `NSAttributedString`. The engine runs in-process without a JavaScript
engine, web view, external process, or network service.

```swift
import SwiftHighlight
import SwiftHighlightHTML

let source = "let greeting = \"<hello>\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let html = try HTMLHighlightRenderer().render(source, result: result)
```

Swift-Highlight is an independent project based on
[HighlightKit](https://github.com/PhraseHQ/HighlightKit), a Swift port of
[highlight.js](https://highlightjs.org/). It is not an official product of
either project. The retained HighlightKit history and bundled language and
test material come with their original licenses; see
[third-party notices](THIRD_PARTY_NOTICES.md).

## Why Swift-Highlight

- **Tokens first.** The core returns scopes and UTF-16 ranges without tying
  analysis to a UI or HTML representation.
- **Explicit rendering.** HTML escapes source text; Apple themes apply to
  existing results without another highlighting pass.
- **Pinned reference.** The bundled catalog has 65 registered languages and
  the test suite compares 375 fixture pairs with expectations generated from
  highlight.js 11.11.1. This is evidence for those inputs, not universal parity.
- **No external Swift package dependencies.** The core does require
  Foundation's regular expressions and the Swift `Synchronization` module.

## Requirements and installation

The manifest requires Swift tools 6.1 and Swift 6 language mode. The table
summarizes observed checks, not an unsupported-platform guarantee:

| Platform | Evidence |
| --- | --- |
| Linux x86_64 | Core and HTML tests with Swift 6.1.3, 6.2.4 and 6.4.2; standard release build with 6.4.2 |
| macOS | User-reported local Apple build; exact destination and tests not independently recorded |
| iOS | Apple renderer implemented; SDK build not independently verified here |
| WebAssembly (WASI Preview 1) | Core and HTML builds reported on macOS; one Swift/HTML consumer smoke executed on Node.js 24 from Linux |
| Linux arm64, static Linux (musl), other Apple platforms | Not verified |

The proposed first release is `0.1.0`; **it has not been published**. Until a
release is available, use a local checkout or the existing development branch:

```swift
dependencies: [
    .package(url: "https://github.com/ThorFuchs/Swift-Highlight.git",
             branch: "feature/bootstrap-swift-highlight")
],
targets: [
    .target(name: "YourTarget", dependencies: [
        .product(name: "SwiftHighlight", package: "Swift-Highlight"),
        .product(name: "SwiftHighlightHTML", package: "Swift-Highlight"),
        // Add SwiftHighlightApple on supported Apple platforms if needed.
    ])
]
```

Branch dependencies are not stable releases. Once `0.1.0` is actually
published, replace `branch:` with `from: "0.1.0"`. The repository is currently
private, so consumers need access. See [release preparation](RELEASING.md).

## Analyze source

```swift
import SwiftHighlight

let highlighter = Highlighter()
let result = try highlighter.highlightStrict("let value = 42", as: "swift")
for token in result.tokens {
    print(token.range, token.scopes)
}
```

Names and aliases are case-insensitive. The catalog includes `javascript`/`js`,
`xml`/`html`, and `yaml`/`yml`; `languageNames` lists canonical registrations
and `hasLanguage(named:)` checks an alias. `plaintext` is an explicit registered
language. `highlightStrict` throws for an unknown language, an invalid grammar,
or an engine failure. An illegal match is reported by `result.illegal` when
`ignoreIllegals` is `false` and produces no tokens. Empty tokens by themselves
are a valid result. The inherited `highlight(_:as:)` is tolerant and may return
plain text on errors; choose the strict API when diagnostics matter.

Tokens describe ranges in **UTF-16 code units** of the exact source that produced
them. Scope arrays go from outermost to innermost. Plain text is represented by
gaps, not extra tokens. A result retains the input for source validation, so
keep its lifetime in mind for large inputs. See [token and error contracts](Documentation/API-CONTRACTS.md).

## Render HTML

```swift
import SwiftHighlight
import SwiftHighlightHTML

let source = "let x = \"</code><script>\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let renderer = HTMLHighlightRenderer()
let fragment = try renderer.render(source, result: result)
// Or validate the result before using the token-only wrapper API:
try result.validateSource(source)
let block = try renderer.codeBlock(source, tokens: result.tokens, language: "swift")
```

The fragment belongs inside an existing code element. Source text is escaped,
including quotes; CR is represented by a character reference. NUL is rejected
because HTML parsing cannot preserve it. Scope and language class components
accept ASCII letters, digits, hyphens and underscores, with dots mapped to
hyphens; invalid values and invalid token ranges throw. The result-based API
checks source identity. The token-only API validates ranges but cannot know
which source generated them. No CSS is bundled; a minimal starting point is:

```css
.hljs-keyword { color: #8250df; }
.hljs-string  { color: #0a3069; }
.hljs-comment { color: #57606a; }
```

This renders code fragments, not general HTML documents, and is not a
cmark-gfm adapter or a promise of another highlighter's HTML layout.

## Render attributed text on Apple platforms

```swift
import SwiftHighlight
import SwiftHighlightApple

let source = "let answer = 42"
let result = try Highlighter().highlightStrict(source, as: "swift")
let styled = try result.attributedString(for: source, theme: .githubLight)
// Reuse result with .githubDark, .xcodeLight, or another theme.
```

Themes resolve scope styles and fonts independently of tokenization. Adaptive
`.github` and `.xcode` themes and light/dark variants are retained from
HighlightKit. Apple SDKs are required to build and verify this layer.

## Detection, security and limits

Whole-block highlighting is the reference path. Incremental continuation
retains parser state, but regex context crossing a line boundary can make it
differ from a whole-block pass. Automatic detection is explicit and can be
restricted to a subset; its async form uses a processor-bounded task window.
Cancellation is cooperative and cannot forcibly interrupt a synchronous ICU
regex call. Apply your own input and execution limits for untrusted sources;
the package does not enforce a hard time or input-size limit. Linux Thread
Sanitizer reported unresolved registry warnings; see [verification](Documentation/IMPLEMENTATION-REPORT.md).

The compatibility target is the pinned highlight.js port, subject to the
[documented Unicode and incremental differences](Docs/FIDELITY.md). We do not
claim full parity with highlight.js, GitHub.com, Rouge, Prism, or a site pipeline.

## Testing and documentation

```sh
swift build
swift test
swift build -c release
```

The [implementation report](Documentation/IMPLEMENTATION-REPORT.md) separates
completed checks from open platform and sanitizer work. The
[WASI example](Examples/WASISmoke/README.md) exercises one actual Swift/HTML
case. See [contributing](CONTRIBUTING.md) for fixture and reference checks and
[DocC guides](Sources/HighlightKit/SwiftHighlight.docc/SwiftHighlight.md) for
API contracts.

## Versioning and support

Before 1.0, minor versions may contain breaking API changes; patch versions are
intended for compatible fixes. There is no published stability guarantee until
a release exists. Use [GitHub Issues](https://github.com/ThorFuchs/Swift-Highlight/issues)
for questions and bugs; report security issues as described in [SECURITY.md](SECURITY.md).

New contributions are offered under [Apache-2.0](LICENSE). Imported MIT- and
BSD-licensed material retains its original terms; preserve the notices for
both source and binary distributions. See [NOTICE](NOTICE) and
[third-party notices](THIRD_PARTY_NOTICES.md).
