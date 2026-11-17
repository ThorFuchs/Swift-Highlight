# Swift-Highlight 1.0.1

This patch release replaces identified third-party quotations and a named
example in three test fixtures with neutral text. The syntax cases remain
covered, and all 375 fixture pairs have been checked against the pinned
highlight.js reference.

The Linux language registry now uses NSLock-protected state so targeted
contended compilation paths can be checked under Thread Sanitizer. The new
Linux CI checks both successful and failed compilation paths repeatedly with
Swift 6.2.4 and 6.4. The independent `Synchronization.Mutex` control can
still report warnings; the package tests and NSLock control must pass. These
checks do not establish blanket race freedom.

A paired Linux release benchmark found that warm highlighting and
warm auto-detection were approximately unchanged in the measured workloads;
warm contention was slower by 7.7% with eight tasks and 5.9% with 32 tasks.
See the [benchmark record](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.1/Benchmarks/Results/2026-11-17-linux-lock-ab/README.md)
for intervals, raw samples and limitations.

The original examples remain in the published 1.0.0 tag and imported Git
history. The replacement does not constitute a legal review or establish
additional rights in those historical copies. See the
[third-party notices](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.1/THIRD_PARTY_NOTICES.md)
and [fixture provenance](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.1/Documentation/FIXTURE-PROVENANCE.md).

Swift-Highlight requires Swift 6.1 or later. To use this release:

```swift
.package(url: "https://github.com/ThorFuchs/Swift-Highlight.git", from: "1.0.1")
```

The engine does not enforce hard time or input-size limits. WASI coverage is a
representative smoke test, and an iOS Simulator build is not a device runtime
test. See the [implementation report](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.1/Documentation/IMPLEMENTATION-REPORT.md)
for the scope of verification and remaining limitations.
