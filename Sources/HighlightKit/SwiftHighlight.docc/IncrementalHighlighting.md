# Highlighting an incremental document

Carry parser state between consecutive chunks and understand when to rescan.

A ``Continuation`` preserves parser state such as an open comment between
calls. Use the same ``Highlighter`` and language for consecutive chunks. Each
result is bound to its own chunk: its UTF-16 ranges start at zero for that
chunk, not at the start of the document.

<!-- docc-verify: core -->
```swift
import SwiftHighlight

let highlighter = Highlighter()
let firstLine = "/* An open comment\n"
let secondLine = "still a comment */\n"

let first = highlighter.highlight(firstLine, as: "swift")
let second = highlighter.highlight(
    secondLine, as: "swift", continuation: first.continuation
)
try second.validateSource(secondLine)
precondition(second.tokens.contains { $0.scopes.contains("comment") })
```

This incremental API is tolerant: it returns a plain result when analysis
fails. Use ``Highlighter/highlightStrict(_:as:ignoreIllegals:)`` on the whole
input when explicit diagnostics are more important than continuation.

## Updating an editor

Store each chunk's incoming and outgoing continuation alongside its text and
result. When a chunk changes, highlight it again using the preceding chunk's
outgoing continuation. Continue through subsequent unchanged chunks until the
new outgoing continuation equals the previously stored outgoing continuation;
then their previously computed state remains applicable. Apply the new token
ranges to the corresponding chunk, or translate them to document offsets in
UTF-16 units.

Invalidate the cache when the language, highlighter, or registered grammar
generation changes. A continuation belongs to its original generation and does
not transfer its state to a replacement grammar. Keep retained results and
continuations only as long as needed: they retain source or grammar state.

## Whole-document accuracy

A chunk can't inspect surrounding source for regex anchors or lookaround.
Line-by-line output can therefore differ from a single whole-block pass even
when continuations are used. Include the actual line endings in each chunk, and
choose whole-block highlighting when that distinction matters.
