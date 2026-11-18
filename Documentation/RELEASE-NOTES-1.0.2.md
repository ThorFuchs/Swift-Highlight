# Swift-Highlight 1.0.2

This documentation-focused patch expands the inline API reference and adds
guides for getting started, tokens and diagnostics, language detection,
incremental highlighting, custom grammars, concurrency and limits, safe HTML,
and Apple themes. Executable documentation examples are checked in CI.

The package includes DocC catalogs and Swift Package Index documentation
configuration for all three library products: `SwiftHighlight`,
`SwiftHighlightHTML`, and `SwiftHighlightApple`. Indexing and hosted
documentation depend on the Swift Package Index processing the package.

Swift-Highlight requires Swift 6.1 or later. To use this release:

```swift
.package(url: "https://github.com/ThorFuchs/Swift-Highlight.git", from: "1.0.2")
```

The engine does not enforce hard time or input-size limits. WASI coverage is a
representative smoke test, and an iOS Simulator build is not a device runtime
test. See the [implementation report](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.2/Documentation/IMPLEMENTATION-REPORT.md)
for verification scope and remaining limitations.

The original examples replaced in 1.0.1 remain in the published 1.0.0 tag and
imported Git history. Their replacement does not establish additional rights
in historical copies. See the [third-party notices](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.2/THIRD_PARTY_NOTICES.md)
and [fixture provenance](https://github.com/ThorFuchs/Swift-Highlight/blob/1.0.2/Documentation/FIXTURE-PROVENANCE.md).
