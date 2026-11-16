# Swift-Highlight

Swift-Highlight is an independent Swift syntax highlighting package based on
[HighlightKit](https://github.com/PhraseHQ/HighlightKit), a Swift port of
highlight.js. It is not endorsed by those projects. The imported history is
retained; see [notices](THIRD_PARTY_NOTICES.md) and
[implementation status](Documentation/IMPLEMENTATION-REPORT.md).

The package is under active development and is not yet release-ready. A Linux Thread Sanitizer run reported unresolved warnings during concurrent grammar compilation; see the implementation report before concurrent production use. It has
three intended products: `SwiftHighlight` for analysis, `SwiftHighlightHTML`
for HTML fragments, and `SwiftHighlightApple` for UIKit/AppKit themes. It has
no external Swift package dependencies. Foundation (including its ICU-backed
regular expressions) and `Synchronization` are system requirements. Swift
6.1 is the manifest minimum; Linux x86_64 tests passed on 6.1.3, 6.2.4 and 6.4.2.

For a local checkout, add `.package(path: "../Swift-Highlight")` to the
consumer's `dependencies` and add the `SwiftHighlight` and
`SwiftHighlightHTML` products to the target. A remote release or published
branch is not yet available from this work.

```swift
import SwiftHighlight
import SwiftHighlightHTML

let source = "let message = \"<hello>\""
let highlighter = Highlighter()
let result = try highlighter.highlightStrict(source, as: "swift")
let fragment = try HTMLHighlightRenderer().render(source, result: result)
```

The fragment is intended for the inside of an existing code block;
`codeBlock(_:tokens:language:)` additionally produces a `<pre><code>` wrapper.
Text is HTML-escaped and class components are restricted to ASCII letters,
digits, `_`, `-`, and dot-separated components (dots become hyphens). Invalid
classes and tokens throw. Carriage returns are encoded as character references; NUL is rejected because HTML parsing cannot preserve it. For example:

```css
.hljs-keyword { color: #8250df; }
.hljs-string { color: #0a3069; }
.hljs-comment { color: #57606a; }
```

Use `highlightStrict` to distinguish unknown languages and grammar errors
from an empty token stream. It also reports errors in explicit or automatically selected nested languages. A missing candidate or recursion with no viable candidate reports `nestedAutoDetection`; candidates rejected by illegal input, opted out, or skipped to prevent non-progressing recursion are excluded from ranking. `highlight(_:as:)` is the inherited tolerant
plain-text fallback. `illegal` signals a rejected input when `ignoreIllegals`
is false. Whole-block parsing is the reference path; incremental line parsing
can differ at regex boundaries. Auto-detection is explicit, not a default for
unlabelled blocks. See [fidelity notes](Docs/FIDELITY.md).

On Apple platforms the intended API is:

```swift
import SwiftHighlight
import SwiftHighlightApple
let highlighter = Highlighter()
let result = try highlighter.highlightStrict(source, as: "swift")
let styled = try result.attributedString(for: source, theme: .githubLight)
```

Applying another theme to the same result does not require re-highlighting.
Token ranges are UTF-16 offsets into the exact analyzed string; scopes are
outermost first and plain gaps are omitted. The result-based renderers check the exact UTF-16 source and validate ordering,
bounds and Unicode scalar boundaries. The low-level token-only HTML API cannot
detect a different source with matching boundaries; callers must supply the
original source. Results retain the source string for exact checking; account for
that lifetime when processing large inputs. HTML rendering is not a
full HTML post-processor or a cmark adapter.

Regexes run synchronously and may consume substantial time or memory on
untrusted input; cancellation is not a hard interruption of an ICU regex call.
Set input limits in the calling application. No fixed resource bound is
currently enforced by this package. Apple SDKs, Linux architectures other than x86_64, and musl are not verified in this environment. WASI Preview 1 has passed a single Swift and HTML runtime smoke test; see [the example](Examples/WASISmoke/README.md).
