# Tokens and diagnostics

Interpret ranges against the exact source and choose the appropriate error path.

## Token contract

``HighlightToken/range`` is an `NSRange` measured in UTF-16 code units of the
input passed to that highlight call. Tokens are sorted and non-overlapping.
``HighlightToken/scopes`` runs from outermost to innermost; unmarked text is
represented by gaps. A result retains the source. Call
``HighlightResult/validateSource(_:)`` before using its ranges with another
API. Publicly constructed tokens can be checked with ``validateTokens(_:in:)``;
the check rejects out-of-bounds, overlapping and surrogate-splitting ranges.
A token-only API cannot establish that the source is the original input.

## Failure and fallback

The strict path distinguishes unknown names and grammar failures from an empty
successful token stream. With `ignoreIllegals: false`, an illegal match returns
`illegal == true` and no tokens. Nested auto-detection skips candidates that
opt out, reject the input as illegal, or would recurse without progress; a
missing candidate or recursion with no viable candidate is an error. Other
nested compilation or engine failures propagate as ``HighlightFailure``.

The tolerant path catches errors and returns an unhighlighted result. Its empty
tokens do not distinguish an ordinary no-match result from fallback; use the
strict path when that distinction matters.
