# Implementation status

Work in progress on `feature/bootstrap-swift-highlight`, based directly on
HighlightKit commit `524c185b0553756498c1b6a1765e8d119c4623a6` with its Git
history retained. Target origin was an empty unborn repository. The independent
highlight.js reference commit `08cb242e7d4aee787114eb04cc7ab18314d82f92`
was also checked out and verified. There are 375 code and 375 JSON fixture
files across 65 directories. The imported tests previously returned an empty
fixture set when discovery failed; an inventory assertion has been added.

Baseline: Linux x86_64, official Swift 6.1.3 container. `swift test -j 4`
failed: Apple-only theme symbols, missing Linux `autoreleasepool`, Foundation
callback signature differences, and Swift grammar type-checking timeout.
Both `swift test -j 4` and `swift build -c release -j 4` exited 1. No baseline test pass is claimed.

Core/HTML/Apple separation and strict explicit-language diagnostics are implemented.
The tolerant API falls back to plain text. Strict highlighting reports top-level
compile/engine failures and failed explicit sub-languages; illegal input is
indicated on the result. Nested automatic detection is explicitly rejected in
strict mode because the inherited candidate ranking suppresses errors.
Public highlighter results retain the source and result-based renderers compare
its exact UTF-16 before applying validated ranges. The low-level token-only HTML
API cannot prove source association; its caller must supply the original input.

`Scripts/verify-fixtures.py` checks all 375 checked-in token expectations against the pinned Node reference build without changing files. Its optional output mode generated 375 JSON files into a separate temporary directory for review. A Node reference build of the pinned source and `Scripts/difftest.py` with 20 generated cases and seed 42 passed for swift (108 inputs), javascript (114), xml (72), css (69), json (51), yaml (69), ruby (69) and bash (72). Reference matching does not establish
universal parity: ICU and JavaScript Unicode semantics differ. The internal
compiled graphs use `@unchecked Sendable`; owners and continuation state keep
compiled graphs alive until the last reader, after which cycles are broken.
No race or leak freedom is inferred without instrumentation.

| Platform | Implemented | Built | Tested | Limitation |
| --- | --- | --- | --- | --- |
| Linux x86_64 Core/HTML | Yes | Debug, Swift 6.1.3, 6.2.4 and 6.4.2 | `swift test -j 4`: 252 tests on Swift 6.1.3, 6.2.4 and 6.4.2, including 375 fixture cases | Standard release not yet verified; non-WMO releases and separate consumer passed |
| macOS Core/HTML/Apple | In progress | No | No | Apple SDK unavailable |
| iOS Apple | In progress | No | No | Apple SDK unavailable |
| Linux arm64, WASI, musl | Not established | No | No | SDK/toolchain unavailable |

Retained license texts and unresolved fixture provenance are described in
`THIRD_PARTY_NOTICES.md` and `Documentation/FIXTURE-PROVENANCE.md`. Raw byte
comparison found 354 matches against the pinned highlight.js tree and 21
unmatched files; this is not proof of ownership of contributed content. This is not a completed distribution audit. No release,
tag, PR or publish was created by this work.

The 6.2.4 Linux test run used `swift:6.2.4` (image digest
`sha256:3459518b2e723a7c363d0f8cfa44fc796c77ecd8c18e92fd10e6f92dd78c0b12`)
on x86_64. One upstream Mach-specific memory test is excluded on Linux.
The standard release command `swift build -c release -j 3` on Swift 6.2.4
was stopped after over five minutes of compiler CPU time without completing.
A subsequent run from a frozen snapshot of the intermediate follow-up state was
stopped after ten minutes without completing; it was not the final Unicode fix.
Neither interruption is a pass or a compiler failure. The current code passed `swift build -c release -Xswiftc -no-whole-module-optimization` on Swift 6.2.4. On Swift 6.4.2, the same release flags passed with `--build-system native`; its default build system failed twice to open a dependencies file. The native build system reports that it is deprecated. The changed CI matrix is configured,
not verified by a hosted CI run.
HTML rendering rejects NUL explicitly because HTML parsing replaces NUL; CR
is emitted as a character reference to preserve CRLF. No hard time or input
size limits are enforced. Thread Sanitizer was run with Swift 6.2.4 on Linux x86_64 using
`swift test --sanitize=thread --filter contendedLazyCompilation`: the test's
assertions passed, but the process exited 1 and TSan reported seven race
warnings in `LanguageRegistry.Entry.compiledLanguage` (lines 115 and 127)
while reading/writing the state inside `Synchronization.Mutex.withLock`. The
same selected test with Swift 6.4.2 also exited 1 with seven warnings, even
though the test assertion passed.
A separate minimal `Synchronization.Mutex<Int>` plus
`DispatchQueue.concurrentPerform` program, compiled and run with the same
Swift 6.2.4 container and TSan, also produced three Swift access race warnings
and exit 66 despite its lock. The same control under Swift 6.4.2 produced two
warnings and exit 66. This is evidence of a sanitizer/toolchain
interaction, but does not prove that every package warning is spurious.
The package warnings have not been resolved or classified conclusively;
do not consider concurrency verified. The targeted Swift 6.2.4 run
`swift test --sanitize=address --filter compilationReleasesDetachedRawModes`
passed its Swift Testing assertion but exited 1: LeakSanitizer reported 144 bytes
in two allocations with stacks in XCTest's suite/runner. This is not a clean
instrumented pass or a proof about application leak freedom.

Follow-up: the full suite passed on Linux x86_64 with Swift 6.2.4, 6.1.3 and 6.4.2,
252 tests each including 375 fixture cases. Tests cover exact source binding,
nested diagnostics, combining-character and ZWJ boundaries, and rejection of
surrogate splits. HTML NUL remains unrepresentable through an HTML5 parse and
is rejected explicitly. The read-only pinned reference check passed all 375
fixture pairs, with zero synthetic EOF units clipped.

An independent consumer rendered Swift code containing combining marks, a ZWJ
emoji, script-like text, ampersands, and CRLF. Python's `html.parser.HTMLParser`
recovered the exact original UTF-8 text (49 bytes) after entity decoding, and
no raw script tag appeared in the fragment. This is one representative
round-trip, not a proof for all inputs or a full HTML document adapter.
