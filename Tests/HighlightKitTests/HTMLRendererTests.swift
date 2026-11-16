import Foundation
import Testing
import SwiftHighlight
import SwiftHighlightHTML

@Suite("HTML rendering") struct HTMLRendererTests {
    @Test func fragmentAndEscaping() throws {
        let source = "let x = \"</code><script>&😀\"\r\n"
        let result = try Highlighter().highlightStrict(source, as: "swift")
        let html = try HTMLHighlightRenderer().render(source, tokens: result.tokens)
        #expect(html.contains("&lt;/code&gt;&lt;script&gt;&amp;😀"))
        #expect(!html.contains("<script>"))
        #expect(html.contains("hljs-keyword"))
    }
    @Test func invalidRangesAndClassesFail() throws {
        let renderer = HTMLHighlightRenderer()
        let source = "a😀b"
        #expect(throws: TokenValidationError.self) { try renderer.render(source, tokens: [HighlightToken(range: NSRange(location: 2, length: 1), scopes: ["string"])]) }
        #expect(throws: TokenValidationError.self) { try renderer.render(source, tokens: [HighlightToken(range: NSRange(location: 0, length: 2), scopes: ["string"])]) }
        #expect(throws: HTMLHighlightRenderer.RenderError.self) { try renderer.codeBlock(source, tokens: [], language: "x\" onclick=\"bad") }
        #expect(throws: HTMLHighlightRenderer.RenderError.self) { try renderer.render(source, tokens: [HighlightToken(range: NSRange(location: 0, length: 1), scopes: ["x\" bad"])]) }
    }
    @Test func lineEndingsAndNull() throws {
        let renderer = HTMLHighlightRenderer()
        #expect(try renderer.render("a\r\nb", tokens: []) == "a&#13;\nb")
        #expect(throws: HTMLHighlightRenderer.RenderError.self) { try renderer.render("a\0b", tokens: []) }
    }
    @Test func unknownLanguageAndPlaintextDiffer() throws {
        let highlighter = Highlighter()
        #expect(throws: HighlightError.self) { try highlighter.highlightStrict("x", as: "not-a-language") }
        let plain = try highlighter.highlightStrict("x", as: "plaintext")
        #expect(plain.tokens.isEmpty)
    }
}
