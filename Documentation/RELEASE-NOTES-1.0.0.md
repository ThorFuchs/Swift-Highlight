# Swift-Highlight 1.0.0

Swift-Highlight is a native Swift syntax-highlighting package with separate
libraries for analysis, HTML, and Apple attributed text. Its core produces
UTF-16 token ranges and scopes for 65 registered languages. The strict API
reports language, grammar, and engine failures; the HTML renderer escapes code
and validates scope and language class names. Apple themes can be applied to
an existing result without repeating analysis.

The package requires Swift 6.1 or later. Once the `1.0.0` tag is available,
add it to a Swift package using:

```swift
.package(url: "https://github.com/ThorFuchs/Swift-Highlight.git", from: "1.0.0")
```

The project retains the history of HighlightKit at commit
`524c185b0553756498c1b6a1765e8d119c4623a6` and uses fixture expectations from
highlight.js 11.11.1 at `08cb242e7d4aee787114eb04cc7ab18314d82f92`. The test
suite checks 375 fixture pairs; this is not a claim of universal highlight.js
or GitHub.com parity. See the [third-party notices](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.0/THIRD_PARTY_NOTICES.md).

Linux x86_64 builds and tests have passed on Swift 6.1.3, 6.2.4 and 6.4.2.
Core and HTML have passed WASI Preview 1 builds and one runtime smoke test.
The maintainer reported all CI jobs green at `d101ac3`; the macOS workflow
includes tests, a release build, a generic iOS Simulator build and DocC for
all three archives. Those CI results have not been independently inspected.
An earlier macOS DocC run at `cb3fb8c` documented 215/215 Core, 8/8 HTML,
and 87/87 Apple public source symbols.

## Known limitations

- The engine uses regular expressions and enforces no hard time or input-size
  limit. Callers handling untrusted input must provide their own resource controls.
- Linux Thread Sanitizer reported warnings in a contended compilation test and
  also in an independent Swift `Mutex` control. The package warnings have not
  been conclusively classified; see the
  [implementation report](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.0/Documentation/IMPLEMENTATION-REPORT.md).
- WASI coverage is a representative smoke test; an iOS Simulator build is not
  a device runtime test.
