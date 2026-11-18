# ``SwiftHighlightSwiftUI``

Display and export styled, syntax-highlighted code cards on Apple platforms.

## Overview

`CodeCardView` is an optional SwiftUI view. It accepts source, an explicit
language, an existing `HighlightTheme`, and the shared card options. Strict
highlighting happens during initialization and reports invalid languages as
errors. Create or cache the card when source changes rather than repeatedly
highlighting large inputs in a frequently invalidated view body.

<!-- docc-verify: swiftui -->
```swift
import SwiftHighlightApple
import SwiftHighlightCodeCard
import SwiftHighlightSwiftUI

let options = try CodeCardOptions(title: "Example.swift")
let card = try CodeCardView(source: "let answer = 42", language: "swift",
                            theme: .githubDark, options: options)
print(type(of: card))
```

Long lines wrap by default. With wrapping disabled, the view scrolls horizontally.
On macOS, `CodeCardPNGRenderer` exports the same view to PNG; wrapping is required
for image export so text cannot be hidden outside a scroll viewport. The PNG
exporter is unavailable on other platforms. The core and HTML products remain
independent of SwiftUI. When sharing an exported image, provide alternative text
or the original source alongside it so the code remains accessible.

## Topics

### Views and export

- ``CodeCardView``
- ``CodeCardPNGRenderer``
