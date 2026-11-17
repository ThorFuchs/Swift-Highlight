# Getting started

Create a highlighter, select a registered language, and consume its tokens.

## Add the package

Add the public repository URL `https://github.com/ThorFuchs/Swift-Highlight.git`
as a Swift package dependency and add the `SwiftHighlight` product to your
application target. The package requires Swift tools 6.1 and Swift 6 language
mode. Its Apple deployment targets are macOS 15, iOS 18, tvOS 18, watchOS 11,
and visionOS 2 or later. The core and HTML products also support Linux; see the
repository's platform verification report for tested toolchains.

Choose `SwiftHighlightHTML` for escaped HTML or `SwiftHighlightApple` for
attributed text on Apple platforms. These are separate products; add the
renderer your application uses to its target dependencies.

## Explicit language

<!-- docc-verify: core -->
```swift
import SwiftHighlight

let highlighter = Highlighter()
let source = "let value = 42"
let result = try highlighter.highlightStrict(source, as: "swift")
if result.illegal {
    // No tokens are available for this rejected input.
}
```

Language names and aliases are case-insensitive. For example `js` resolves to
`javascript`, `html` to `xml`, and `yml` to `yaml`. Use
``Highlighter/hasLanguage(named:)`` and ``Highlighter/languageNames`` to query
registrations. Explicit `plaintext` is a language; an unknown name is an error
on the strict path.

## Detection and continuation

The `highlightAuto(_:subset:)` method ranks candidate grammars by
relevance; passing a subset bounds the candidates. The async overload schedules
candidates through a processor-bounded window and cancellation can yield the
best completed result. Automatic detection is not the default for explicit
language highlighting.

The tolerant explicit API accepts a ``Continuation`` from the preceding result
for line-oriented editors. Whole-block highlighting is the reference path:
regex lookaround and anchors at line boundaries can produce different results
when lines are parsed in isolation.
