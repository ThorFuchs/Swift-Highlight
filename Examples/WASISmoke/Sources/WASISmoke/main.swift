import SwiftHighlight
import SwiftHighlightHTML

let source = "let message = \"<hello>&\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let html = try HTMLHighlightRenderer().render(source, result: result)
precondition(result.tokens.contains { $0.scope == "keyword" })
precondition(html.contains("&lt;hello&gt;&amp;"))
print("WASI highlight and HTML smoke passed")
