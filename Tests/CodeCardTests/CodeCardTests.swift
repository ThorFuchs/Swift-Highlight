import Foundation
import Testing
@testable import SwiftHighlightCodeCard

@Suite("Code cards")
struct CodeCardTests {
    @Test func htmlEscapesSourceAndHeader() throws {
        let source = "let value = \"</code><script>alert(1)</script>&\"\n"
        let title = "<script> & \"test\""
        let options = try CodeCardOptions(title: title)
        let html = try HTMLCodeCardRenderer().document(source, language: "swift", options: options)
        #expect(html.contains("&lt;script&gt; &amp; &quot;test&quot;"))
        #expect(!html.contains("<script>"))
        #expect(html.contains("&lt;/code&gt;&lt;script&gt;"))
        #expect(html.contains("<pre class=\"sh-card__pre\"><code>"))
        #expect(html.contains("hljs-"))
    }

    @Test func optionsControlRendering() throws {
        let options = try CodeCardOptions(title: "demo.swift", showHeader: false,
                                          wrapLines: false, fontSize: 18, padding: 0, cornerRadius: 4)
        let html = try HTMLCodeCardRenderer().render("let x = 42", language: "swift",
                                                     theme: .githubLight, options: options)
        #expect(html.contains("sh-code-card--github-light"))
        #expect(html.contains("--sh-font-size:18.0px"))
        #expect(html.contains("--sh-white-space:pre"))
        #expect(!html.contains("<div class=\"sh-card__header\">"))
    }

    @Test func invalidPresentationValuesAreRejected() {
        #expect(throws: CodeCardOptions.ValidationError.fontSize) { try CodeCardOptions(fontSize: .infinity) }
        #expect(throws: CodeCardOptions.ValidationError.padding) { try CodeCardOptions(padding: -1) }
        #expect(throws: CodeCardOptions.ValidationError.cornerRadius) { try CodeCardOptions(cornerRadius: .nan) }
    }

    @Test func unknownLanguageAndNullSourceAreRejected() {
        #expect(throws: (any Error).self) {
            try HTMLCodeCardRenderer().render("let x = 1", language: "not-a-language")
        }
        #expect(throws: (any Error).self) {
            try HTMLCodeCardRenderer().render("a\0b", language: "plaintext")
        }
    }
}
