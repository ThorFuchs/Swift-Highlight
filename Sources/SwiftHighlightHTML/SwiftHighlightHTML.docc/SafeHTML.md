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
