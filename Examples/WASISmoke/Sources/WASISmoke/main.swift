import SwiftHighlight
import SwiftHighlightHTML
import SwiftHighlightCodeCard

let source = "let message = \"<hello>&\""
let result = try Highlighter().highlightStrict(source, as: "swift")
let html = try HTMLHighlightRenderer().render(source, result: result)
precondition(result.tokens.contains { $0.scope == "keyword" })
precondition(html.contains("&lt;hello&gt;&amp;"))
let card = try HTMLCodeCardRenderer().document(source, language: "swift")
precondition(card.contains("&lt;hello&gt;&amp;"))
precondition(card.contains("sh-code-card--github-dark"))
print("WASI highlight, HTML and code card smoke passed")
