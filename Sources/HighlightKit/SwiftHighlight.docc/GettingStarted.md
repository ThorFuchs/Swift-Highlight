# Getting started

Create a highlighter, select a registered language, and consume its tokens.

## Explicit language

```swift
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
