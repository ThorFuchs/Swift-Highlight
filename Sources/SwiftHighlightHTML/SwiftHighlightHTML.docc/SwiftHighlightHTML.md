# ``SwiftHighlightHTML``

Render validated syntax tokens as escaped HTML fragments or code blocks.

## Overview

Use the result-based renderer when possible: it checks that tokens came from
exactly the supplied UTF-16 source. The output is the content of a code element,
not an entire HTML document. Stylesheets and document sanitization belong to
the consuming application.

```swift
import SwiftHighlight
import SwiftHighlightHTML

let source = "let x = \"<hello>\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let fragment = try HTMLHighlightRenderer().render(source, result: result)
```

## Topics

### Guides

- <doc:SafeHTML>

### Rendering

- ``HTMLHighlightRenderer``
- ``HTMLHighlightRenderer/RenderError``
