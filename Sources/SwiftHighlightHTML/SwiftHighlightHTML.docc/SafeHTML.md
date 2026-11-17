# HTML safety and scope classes

Render only validated source and tokens into an HTML code block.

Text is escaped for HTML, including `&`, `<`, `>`, quotes and apostrophes.
Carriage returns become character references so HTML parsing can preserve
CRLF. NUL is rejected because HTML parsing cannot round-trip it. This API does
not locate code blocks inside arbitrary HTML or sanitize other document markup.

Each scope is represented by a nested `span`. Class components must be nonempty
ASCII letters, digits, underscores or hyphens; dots separate components and
map to hyphens. `title.function` therefore produces `hljs-title-function`.
The optional code-block wrapper validates the language class under the same
rules. Invalid class values and token ranges throw instead of returning partial
markup.

The result-based renderer verifies input identity. The `tokens:` overload and
code-block wrapper only validate ranges; callers must associate them with the
original input themselves.

## Render a complete code block

The fragment API checks source identity. The wrapper API accepts tokens, so
validate the source-bound result before passing it to that lower-level method:

<!-- docc-verify: html -->
```swift
import SwiftHighlight
import SwiftHighlightHTML

let source = "let value = \"<hello>\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let renderer = HTMLHighlightRenderer()
let fragment = try renderer.render(source, result: result)
precondition(fragment.contains("&lt;hello&gt;"))

try result.validateSource(source)
let block = try renderer.codeBlock(source, tokens: result.tokens, language: "swift")
precondition(block.hasPrefix("<pre><code class=\"language-swift\">"))
```

Insert the resulting markup into an appropriate HTML context and provide your
own stylesheet. Don't escape the returned markup a second time; escape or
sanitize any separately composed content according to its own context.
