# ``SwiftHighlightCodeCard``

Create portable, self-contained HTML code cards from highlighted source.

## Overview

`SwiftHighlightCodeCard` combines the core highlighter and HTML renderer with
scoped styles and a semantic `pre`/`code` wrapper. It does not depend on SwiftUI
or Apple UI frameworks. The two built-in schemes use the package's GitHub light
and dark palette. Callers can embed a fragment or write a complete document.

<!-- docc-verify: card -->
```swift
import SwiftHighlightCodeCard

let options = try CodeCardOptions(title: "Example.swift", wrapLines: true)
let html = try HTMLCodeCardRenderer().document(
    "let greeting = \"Hello!\"", language: "swift",
    theme: .githubDark, options: options
)
print(html.contains("<pre"))
```

The source and header text are escaped; the renderer does not sanitize any
surrounding document. Long lines wrap by default, or scroll horizontally when
wrapping is disabled. Invalid languages, NUL in source, and invalid presentation
values produce errors. The returned HTML includes a scoped stylesheet; a host
page's own CSS or content security policy may affect its display.

## Topics

### HTML cards

- ``HTMLCodeCardRenderer``
- ``CodeCardOptions``
- ``CodeCardTheme``
