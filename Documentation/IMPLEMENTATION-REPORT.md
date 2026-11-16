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

The Core/HTML/Apple separation and strict API are implemented but remain incomplete pending the checks and limitations below.
The existing tolerant API returns plain output for errors; the strict path
reports top-level compile and engine failures and exposes illegal input on the
result. The inherited nested-language error handling still needs a separate
review: do not assume every nested failure is reported. A result does not bind
itself to the source content, so a different string with compatible ranges
cannot be detected. Caller must use the original source.

The upstream scripts use a pinned reference checkout but the fixture test
source references a non-shipped `scratchpad/hljs-ref/gen-fixtures.mjs`.
A Node reference build of the pinned source and `Scripts/difftest.py` with 20 generated cases and seed 42 passed for swift (108 inputs), javascript (114), xml (72), css (69), json (51), yaml (69), ruby (69) and bash (72). Reference matching does not establish
universal parity: ICU and JavaScript Unicode semantics differ. The internal
compiled graphs use `@unchecked Sendable`; owners and continuation state keep
compiled graphs alive until the last reader, after which cycles are broken.
No race or leak freedom is inferred without instrumentation.

| Platform | Implemented | Built | Tested | Limitation |
| --- | --- | --- | --- | --- |
| Linux x86_64 Core/HTML | Yes | Debug, Swift 6.1.3 and 6.2.4 | `swift test -j 3`: Swift 6.1.3: 249 tests; Swift 6.2.4: 248 tests, including 375 fixture cases passed | Standard release interrupted; non-WMO release and separate consumer passed |
| macOS Core/HTML/Apple | In progress | No | No | Apple SDK unavailable |
| iOS Apple | In progress | No | No | Apple SDK unavailable |
| Linux arm64, WASI, musl | Not established | No | No | SDK/toolchain unavailable |

Retained license texts and unresolved fixture provenance are described in
`THIRD_PARTY_NOTICES.md`. This is not a completed distribution audit. No release,
tag, PR or publish was created by this work.

The 6.2.4 Linux test run used `swift:6.2.4` (image digest
`sha256:3459518b2e723a7c363d0f8cfa44fc796c77ecd8c18e92fd10e6f92dd78c0b12`)
on x86_64. One upstream Mach-specific memory test is excluded on Linux.
The standard release command `swift build -c release -j 3` on Swift 6.2.4
was stopped after over five minutes of compiler CPU time without completing;
it is not a pass or a compiler failure. A separate `swift build -c release -Xswiftc -no-whole-module-optimization -j 3` passed with Swift 6.2.4 on Linux in 34.38 seconds. The changed CI matrix is configured,
not verified by a hosted CI run.
HTML rendering rejects NUL explicitly because HTML parsing replaces NUL; CR
is emitted as a character reference to preserve CRLF. No hard time or input
size limits are enforced. Thread Sanitizer was run with Swift 6.2.4 on Linux x86_64 using
`swift test --sanitize=thread --filter contendedLazyCompilation`: the test's
assertions passed, but the process exited 1 and TSan reported seven race
warnings in `LanguageRegistry.Entry.compiledLanguage` (lines 115 and 127)
while reading/writing the state inside `Synchronization.Mutex.withLock`.
A separate minimal `Synchronization.Mutex<Int>` plus
`DispatchQueue.concurrentPerform` program, compiled and run with the same
Swift 6.2.4 container and TSan, also produced three Swift access race warnings
and exit 66 despite its lock. This is evidence of a sanitizer/toolchain
interaction, but does not prove that every package warning is spurious.
The package warnings have not been resolved or classified conclusively;
do not consider concurrency verified. No leak instrumentation was run.

The four HTML tests including the CRLF and NUL cases passed under Swift 6.2.4 after the full 248-test run. The full 249-test suite passed under Swift 6.1.3.
