# Registering a custom language

Build a fresh grammar for a domain-specific language and use its aliases.

A ``LanguageDescriptor`` supplies a factory for a ``LanguageDefinition``.
The highlighter builds and compiles the grammar lazily. This example recognizes
two annotation words and assigns them the `keyword` scope:

<!-- docc-verify: core -->
```swift
import SwiftHighlight

let annotations = LanguageDescriptor(name: "annotations", aliases: ["notes"]) {
    LanguageDefinition(
        name: "annotations",
        root: Mode(contains: [
            Mode(scope: "keyword", match: #"\b(?:TODO|FIXME)\b"#)
        ])
    )
}
let highlighter = Highlighter(languages: [annotations])
let result = try highlighter.highlightStrict("TODO: review", as: "notes")
precondition(result.tokens.contains { $0.scope == "keyword" })
```

``Highlighter/init(languages:)`` uses the supplied list rather than adding it
to the bundled catalog. To extend the bundled languages, create a default
``Highlighter`` and call ``Highlighter/register(_:)``. Names and aliases are
case-insensitive. Registering an existing canonical name installs a new grammar
generation; already-running work can finish using its original generation.

The factory must construct a fresh, self-contained mode tree on every call. It
must not call a highlighter or recursively request grammar compilation. `Mode`
is mutable during construction; don't mutate a mode tree after handing it to
the highlighter. Regex patterns are evaluated using Foundation and ICU, so
JavaScript regex behavior isn't an unconditional compatibility guarantee.
Invalid grammar or regex construction is reported when the grammar is first
used through the strict API.
