# Swift-Highlight 1.0.0 — draft release notes

This is a draft for review, not a published release or tag.

Swift-Highlight provides a native Swift syntax-highlighting engine with a
separate HTML renderer and Apple attributed-text renderer. The core produces
UTF-16 token ranges and scopes for 65 registered languages. The strict API
reports language, grammar, and engine failures; the HTML renderer escapes code
and validates scope and language class names. Apple themes can be applied to an
existing result without repeating analysis.

The project retains the history of HighlightKit at commit
`524c185b0553756498c1b6a1765e8d119c4623a6` and uses fixture expectations from
highlight.js 11.11.1 at `08cb242e7d4aee787114eb04cc7ab18314d82f92`. The test
suite checks 375 fixture pairs; this is not a claim of universal highlight.js
or GitHub.com parity. See [third-party notices](../THIRD_PARTY_NOTICES.md).

Linux x86_64 builds and tests have passed on Swift 6.1.3, 6.2.4 and 6.4.2.
Core and HTML have passed WASI Preview 1 builds and one runtime smoke test.
The maintainer reported all CI jobs green at `d101ac3`; the macOS workflow
includes tests, a release build, a generic iOS Simulator build and DocC for
all three archives. Those CI results have not been independently inspected.
An earlier macOS DocC run at `cb3fb8c` documented 215/215 Core, 8/8 HTML,
and 87/87 Apple public source symbols.

Before publishing, complete the checks in [RELEASING.md](../RELEASING.md),
including upstream tag provenance, third-party rights review,
private security reporting, Apple checks, Thread Sanitizer findings, and CI for
the exact release commit. No hard time or input-size limit is enforced; callers
must account for regex resource use on untrusted input.
