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
indicated on the result. Strict nested automatic detection ranks successful
candidates while surfacing compilation or engine failures. Candidates that
opt out, reject the input as illegal, or would recurse without progress are
skipped; a missing listed candidate or recursion with no viable candidate
produces a diagnostic.
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
| Linux x86_64 Core/HTML | Yes | Debug, Swift 6.1.3, 6.2.4 and 6.4.2 | `swift test -j 4`: 254 tests on Swift 6.1.3, 6.2.4 and 6.4.2, including 375 fixture cases | Swift 6.4.2 standard release and separate consumer passed |
| macOS Core/HTML/Apple | In progress | No | No | Apple SDK unavailable |
| iOS Apple | In progress | No | No | Apple SDK unavailable |
| WASI Preview 1 (wasm32) | Core/HTML | Swift.org 6.4.2 | One Swift/HTML consumer smoke under Node 24 | Full fixture suite and Apple-host build unverified |
| Linux arm64, musl | Not established | No | No | SDK/toolchain unavailable |

After the branch was pushed, the user reported a successful local Apple build
(`BUILD SUCCEEDED`) using the supplied commands. This is a user-reported result;
the specific SDK, Xcode/Swift versions, destination, and individual test results
have not yet been independently recorded. The table above reflects the checks
performed in the cloud environment; it does not claim that local tests or WASI
have been verified.

Retained license texts and unresolved fixture provenance are described in
`THIRD_PARTY_NOTICES.md` and `Documentation/FIXTURE-PROVENANCE.md`. Raw byte
comparison found 354 matches against the pinned highlight.js tree. Of the 21
non-identical fixtures, 15 closely resemble reference files, two extend a
reference file, and four exactly match fixtures at later highlight.js commits
whose root BSD-3-Clause license is unchanged. This is not proof of ownership
of all contributed content. This is not a completed distribution audit. No release,
tag, PR or publish was created by this work.

The 6.2.4 Linux test run used `swift:6.2.4` (image digest
`sha256:3459518b2e723a7c363d0f8cfa44fc796c77ecd8c18e92fd10e6f92dd78c0b12`)
on x86_64. One upstream Mach-specific memory test is excluded on Linux.
The earlier standard release command `swift build -c release -j 3` on Swift 6.2.4
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
in two allocations with stacks in XCTest's suite/runner. Repeating the same
targeted test with `--disable-xctest` executed one Swift Testing test and passed
with exit 0 and no ASan/LSan report. This isolates the original report to the
XCTest-enabled run; it does not prove the whole application leak-free.

Follow-up: the full suite passed on Linux x86_64 with Swift 6.2.4, 6.1.3 and 6.4.2,
254 tests each including 375 fixture cases. Tests cover exact source binding,
nested diagnostics, combining-character and ZWJ boundaries, and rejection of
surrogate splits. HTML NUL remains unrepresentable through an HTML5 parse and
is rejected explicitly. The read-only pinned reference check passed all 375
fixture pairs, with zero synthetic EOF units clipped.

An independent consumer rendered Swift code containing combining marks, a ZWJ
emoji, script-like text, ampersands, and CRLF. Python's `html.parser.HTMLParser`
recovered the exact original UTF-8 text (49 bytes) after entity decoding, and
no raw script tag appeared in the fragment. This is one representative
round-trip, not a proof for all inputs or a full HTML document adapter.

The isolated `Scripts/NSLockSanitizerControl.swift` counter completed under
Swift 6.4.2 TSan without warnings (10,000 increments), whereas the
`Synchronization.Mutex` control on the same toolchain reported two warnings.
This narrows the toolchain symptom to the Mutex-based control; it is still not
a proof that the package's seven reported accesses are safe.

Strict auto-detection was subsequently validated with an unlabelled Markdown
fence: its token output matched the tolerant path. Candidate compilation errors,
missing candidates and self-only recursive detection have dedicated tests.
After extending the nested engine loop-fuse test, the full 254-test suites passed again with Swift 6.1.3, 6.2.4 and 6.4.2.

The standard, unmodified `swift build -c release -j 4` succeeded on Linux
x86_64 using the `swift:6.4` image (Swift 6.4.2, digest
`sha256:0384f00cf80f81064a907c249a0ad56a1648906f65075a95b1827e88de666e21`)
from a frozen checkout of this version of the package source. It took 274.02
seconds; no alternative optimization flags were used. After this snapshot,
only test and documentation files were edited, not package source.

WASI follow-up: On Linux x86_64, the official Swift.org 6.4.2 toolchain and
`swift-6.4.2-RELEASE_wasm` SDK built both library products successfully. The
SDK archive SHA-256 (`83baca83553f8c443cda7b84800912e6e709c3acd2e7ebf277794ca5836c0da5`)
was checked against the Swift.org release data. The standalone
`Examples/WASISmoke` package built as a wasm32-wasip1 executable; Node.js
24.22.1's WASI Preview 1 implementation ran it successfully, checking a
Swift keyword token and HTML escaping. This is a representative runtime smoke
test, not full language or fixture coverage.

The user's macOS build using Apple Swift 6.4.2 from the Xcode toolchain failed
while importing the SDK's precompiled Foundation module with a compiler-version
mismatch. Swift.org's Wasm instructions call for the matching Swift.org
toolchain even on macOS with Xcode installed. The successful Linux cross-build
supports that toolchain mismatch as the likely cause. The user subsequently
reported that both `SwiftHighlight` and `SwiftHighlightHTML` built successfully
on macOS arm64 with a swiftly-selected `swift-6.4.2-RELEASE` toolchain and
the matching WASI SDK. The reported output contained three unused-public-import warnings; these
imports were narrowed in a later change. Both WASI library products were then
rebuilt on Linux using Swift 6.4.2 with `-Xswiftc -warnings-as-errors`; both
passed. The full 254-test Linux suite also passed with Swift 6.1.3. No local
WASI execution or full fixture test was reported.

## Public-release preparation

The project documentation was aligned with the structure of Swift-GFM. DocC
catalogs now cover the core, HTML and Apple layers. On Linux x86_64 with Swift
6.4.2, `Tools/build-docc.sh` built the core and HTML archives with DocC warnings
as errors and checked documentation on 215/215 and 8/8 source-declared public
symbols respectively. The Apple archive was skipped because this host has no
Apple SDK; its symbols and documentation have not been verified here. The
local-link checker, 254-test Swift 6.4.2 suite, and a separate Swift 6.1.3
consumer using the documented core and HTML APIs also passed. The added CI
documentation job has not yet run on GitHub.

The four previously unmatched code fixtures were compared byte-for-byte to
later highlight.js commits, and the root BSD-3-Clause text at each commit
matched the retained license. Seventeen other fixtures differ from the pinned
reference; similarities and exact-prefix relationships are recorded in the
provenance inventory. Quoted material and individual contributions still need
release review; this analysis is not a legal opinion.

Before public release, verify the Apple DocC and SDK checks on the intended
Apple toolchain, review the unresolved sanitizer observations and third-party
material, enable and verify a private vulnerability-reporting channel, and
confirm CI for the exact release commit. The local `0.1.0` tag refers to
HighlightKit's initial commit, not a Swift-Highlight release; the proposed
initial release was subsequently changed to `1.0.0`. See [RELEASING.md](../RELEASING.md)
before creating a release tag or publishing.

The public-preparation source state was also built in standard release mode on
Linux x86_64 with Swift 6.4.2 using `swift build -c release -j 4`; it completed
successfully in 227.76 seconds. The WASI core and HTML products were rebuilt
with the matching 6.4.2 SDK and `-Xswiftc -warnings-as-errors`, both passing.

## 1.0.0 release preparation and macOS DocC feedback

The maintainer selected `1.0.0` for the planned initial release. Neither a
local nor remote `1.0.0` tag was found when checked. The existing local
`0.1.0`, `0.1.1` and `0.2.0` tags belong to HighlightKit history and must not
be published as Swift-Highlight releases by a blanket tag push.

On macOS, the user reported the `Tools/build-docc.sh` run following commit
`e36d69d`. Its output confirms a successful build and 215/215 documented Core
symbols, followed by creation of `SwiftHighlight.doccarchive`. The output does
not show HTML or Apple archives or a shell exit status. It therefore does not
establish that those archives were built. The script was updated to locate each
module's symbol graph separately, and its corrected macOS run remains to be
verified.

The subsequent macOS run at `fe6fc79` built the Core and HTML DocC archives
with 215/215 and 8/8 documented public symbols. It did not build the Apple
archive: the checker reported `HighlightResult`, `Highlighter`, and `NSColor`
as undocumented and exited 1 (87/90). A separate two-module Swift 6.4.2
reproduction showed that cross-module and Foundation extensions emit synthetic
`swift.extension` container symbols alongside their separately declared public
members. The checker now skips only those containers; it still requires every
public member's documentation and rejects graphs containing only containers.
The fix and its regression tests were checked on Linux; the Apple DocC run must
be repeated on macOS before calling it verified.

The macOS run at `6dd7545` confirmed 215/215 Core, 8/8 HTML, and 87/87 Apple
public symbols documented. Apple archive conversion then failed because a
documentation link to the Core type `HighlightToken` could not be resolved in
the Apple-only symbol graphs. That reference now uses inline code instead of a
DocC symbol link. Apple archive conversion must be rerun on macOS to verify the
fix.
