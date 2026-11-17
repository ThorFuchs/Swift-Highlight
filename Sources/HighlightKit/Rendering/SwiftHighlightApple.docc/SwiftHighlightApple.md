# ``SwiftHighlightApple``

Apply Apple-platform colors and fonts to syntax tokens.

## Overview

Analyze code with SwiftHighlight and apply a theme to the resulting tokens.
A theme change reuses the result; it does not require another grammar scan.
The renderer validates the result against the exact input before applying ranges.

<!-- docc-verify: apple -->
```swift
import SwiftHighlight
import SwiftHighlightApple

let source = "let answer = 42"
let result = try Highlighter().highlightStrict(source, as: "swift")
let styled = try result.attributedString(for: source, theme: .githubLight)
```

The Apple layer uses UIKit or AppKit. Its SDK builds and tests need an Apple
toolchain; the Linux core and HTML checks do not verify those targets.

## Topics

### Guides

- <doc:Themes>

### Themes and scopes

- ``HighlightTheme``
- ``ScopeStyle``
- ``HighlightScope``
- ``HighlightColor``
- ``HighlightFont``
