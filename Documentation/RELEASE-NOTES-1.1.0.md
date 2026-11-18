# Swift-Highlight 1.1.0

This minor release adds configurable code cards and a command-line exporter.
Existing core, HTML, and Apple rendering APIs remain available.

- `SwiftHighlightCodeCard` produces escaped HTML cards with scoped styles,
  GitHub light and dark themes, and configurable titles, wrapping and layout.
- `SwiftHighlightSwiftUI` provides a native card view using built-in or custom
  Apple highlight themes. On macOS, it can export the view as PNG.
- `highlight-card` reads UTF-8 source from a file or standard input and writes
  HTML on supported platforms or PNG on macOS. PNG export requires wrapping
  and validates image dimensions to avoid hiding code outside the viewport.
- Ten original language examples and a reproducible image gallery show actual
  highlighting output. DocC catalogs cover all five library products.

Swift-Highlight requires Swift 6.1 or later. To use this release:

```swift
.package(url: "https://github.com/ThorFuchs/Swift-Highlight.git", from: "1.1.0")
```

The [README](https://github.com/ThorFuchs/Swift-Highlight/blob/1.1.0/README.md)
includes SwiftUI and command-line examples. Swift Package Index documentation
is configured for all five library products; hosting depends on the index
accepting and processing the package.

The engine does not enforce hard time or input-size limits. WASI coverage is a
representative consumer smoke test; simulator builds are not device runtime
tests. Linux sanitizer checks cover targeted paths and do not prove blanket
race freedom. See the [implementation report](https://github.com/ThorFuchs/Swift-Highlight/blob/1.1.0/Documentation/IMPLEMENTATION-REPORT.md)
for verification scope and remaining limitations.

Examples replaced in 1.0.1 remain in the published 1.0.0 tag and imported Git
history. Their replacement does not establish additional rights in historical
copies. See the [third-party notices](https://github.com/ThorFuchs/Swift-Highlight/blob/1.1.0/THIRD_PARTY_NOTICES.md)
and [fixture provenance](https://github.com/ThorFuchs/Swift-Highlight/blob/1.1.0/Documentation/FIXTURE-PROVENANCE.md).
