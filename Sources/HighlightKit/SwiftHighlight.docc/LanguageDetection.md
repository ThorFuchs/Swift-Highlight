# Choosing and detecting languages

Prefer a known language, or restrict automatic detection to plausible choices.

When a file extension, user selection, or code-fence label identifies a
language, use explicit highlighting. Names and aliases are case-insensitive;
``Highlighter/hasLanguage(named:)`` checks both, and
``Highlighter/languageNames`` lists canonical names. `plaintext` is a registered
language; it isn't a synonym for an unknown name.

Automatic detection ranks grammars by relevance. Restricting the candidates can
reduce work and avoid irrelevant guesses:

<!-- docc-verify: core -->
```swift
import SwiftHighlight

let highlighter = Highlighter()
let source = "SELECT id FROM users WHERE active = 1"
let result = highlighter.highlightAuto(source, subset: ["sql", "json"])
if let language = result.language {
    print("Best candidate: \(language), relevance: \(result.relevance)")
}
```

Detection is best effort, not a guarantee that the selected language is
correct. Invalid or unsuitable candidates are skipped. An empty token array
can also be a valid result. For explicit errors, use
``Highlighter/highlightStrict(_:as:ignoreIllegals:)`` with a known language.

The async overload evaluates candidates in a bounded window. Without
cancellation it follows the synchronous ranking; after cancellation it may
return the best candidate that completed rather than considering them all.
Cancellation is cooperative and can't forcibly interrupt an ICU regex already
executing. Apply application-level resource controls for untrusted inputs.
