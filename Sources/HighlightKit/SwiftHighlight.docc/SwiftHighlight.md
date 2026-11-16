# ``SwiftHighlight``

Analyze source code and return language scopes as UTF-16 ranges.

## Overview

SwiftHighlight contains the language catalog, grammar compiler and highlighting
engine. It produces tokens without depending on a renderer or an Apple UI
framework. Language definitions and engine semantics derive from HighlightKit
and the pinned highlight.js version; see the repository's third-party notices.

```swift
import SwiftHighlight

let source = "let answer = 42"
let result = try Highlighter().highlightStrict(source, as: "swift")
for token in result.tokens {
    print(token.range, token.scopes)
}
```

Choose ``Highlighter/highlightStrict(_:as:ignoreIllegals:)`` when failures must
be visible. The inherited tolerant call returns plain text on failure. An empty
token array can also be a successful result with no scoped text.

## Topics

### Guides

- <doc:GettingStarted>
- <doc:TokensAndDiagnostics>
- <doc:ConcurrencyAndLimits>

### Highlighting

- ``Highlighter``
- ``HighlightResult``
- ``HighlightToken``
- ``Continuation``
- ``HighlightError``
- ``HighlightFailure``
- ``TokenValidationError``
- ``validateTokens(_:in:)``

### Language definitions

- ``LanguageCatalog``
- ``LanguageDescriptor``
- ``LanguageDefinition``
- ``Mode``
- ``Keywords``
- ``RegexRef``
- ``ScopeRef``
- ``CallbackMatch``
- ``Response``
