# API contracts

## Language lookup and diagnostics

`Highlighter` registers the bundled language catalog by default. Canonical
names and aliases are case-insensitive. `languageNames` returns canonical names;
`hasLanguage(named:)` checks either form. `plaintext` is a registered grammar,
whereas an unknown name causes `highlightStrict` to throw `HighlightError`.
Grammar compilation errors carry a language and, where relevant, the invalid
regex. Engine and nested-language failures use `HighlightFailure`.

`highlightStrict(_:as:ignoreIllegals:)` is synchronous and reports failures.
With `ignoreIllegals: false`, an illegal match returns a result with `illegal`
set and no tokens; the default is to ignore illegal matches. A normal input
without scoped content may also have no tokens. The inherited tolerant
`highlight(_:as:)` catches errors and returns plain text; callers cannot infer
whether an empty token array represents fallback or a successful no-match scan.

Nested automatic detection skips languages that opt out, reject the input as
illegal, or would recurse without progress. Missing explicitly listed candidates
and recursive detection with no viable candidate cause a diagnostic on the
strict path. Automatic detection is optional. The async overload schedules a
processor-bounded window, and cancellation returns the best candidates that
completed; it is not a promise of complete detection after cancellation.

## Source, UTF-16, and rendering

A token's `NSRange` indexes UTF-16 code units in exactly the input analyzed by
its result. Tokens are sorted and non-overlapping, their scope stack is ordered
outermost first, and plain-text gaps are not tokens. Results retain their source;
`validateSource(_:)` compares the exact UTF-16 sequence before validating
ranges. This distinguishes canonically equivalent but differently encoded
strings. Validation checks boundaries, overflow, ordering and surrogate pairs.
The public token-only validation API cannot prove source association.

The HTML renderer escapes text and validates scope/language class names. It
returns a fragment or an explicitly requested `<pre><code>` wrapper; it does
not parse an existing HTML document. CR is encoded as `&#13;`; NUL is rejected
because an HTML parser cannot round-trip it. No partial output is returned on a
validation error. The Apple renderer validates result identity and ranges
before applying a theme; its convenience API falls back to plain text.

## Incremental parsing and resource use

A continuation belongs to the compiled grammar generation that created it. It
retains the state and graph needed for a following chunk. When a continuation
belongs to another generation, the engine starts from the current grammar's
root. Regex lookaround and anchors cannot see across independently supplied
lines; use whole-block highlighting for the reference behavior.

A registry synchronizes lazy grammar compilation and publishes immutable
compiled graphs. Internal `@unchecked Sendable` graph types rely on owner
lifetimes and explicit cycle teardown. The [implementation report](IMPLEMENTATION-REPORT.md)
records unresolved Thread Sanitizer warnings and the available controls; no
blanket race or leak freedom is implied.

No hard input-size, memory or time limits are enforced. Regex matching uses
Foundation and ICU; hostile patterns and inputs can consume substantial
resources. Task cancellation is cooperative and cannot forcibly stop a
synchronous ICU call. Set and enforce appropriate application-level limits.
