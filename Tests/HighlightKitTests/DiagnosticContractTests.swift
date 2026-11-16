import Foundation
import Testing
@testable import SwiftHighlight
import SwiftHighlightHTML

@Suite("Source binding and strict diagnostics")
struct DiagnosticContractTests {
    @Test func resultUsesExactUTF16Source() throws {
        let source = "let s = \"e\u{301}\""
        let result = try Highlighter().highlightStrict(source, as: "swift")
        try result.validateSource(source)
        let differentNormalization = "let s = \"é\""
        #expect(throws: TokenValidationError.sourceMismatch) {
            try result.validateSource(differentNormalization)
        }
        #expect(throws: TokenValidationError.sourceMismatch) {
            try HTMLHighlightRenderer().render("let x = \"e\u{301}\"", result: result)
        }
        #expect(!(try HTMLHighlightRenderer().render(source, result: result)).isEmpty)
        let fallback = Highlighter().highlight(source, as: "unknown")
        try fallback.validateSource(source)
    }

    @Test func strictNestedFailuresAndTolerantFallback() throws {
        let missing = LanguageDescriptor(name: "host") {
            LanguageDefinition(name: "host", root: Mode(subLanguage: ["missing"]))
        }
        let recursive = LanguageDescriptor(name: "recursive") {
            LanguageDefinition(name: "recursive", root: Mode(subLanguage: ["recursive"]))
        }
        let automatic = LanguageDescriptor(name: "auto") {
            LanguageDefinition(name: "auto", root: Mode(subLanguage: []))
        }
        let h = Highlighter(languages: [missing, recursive, automatic])
        #expect(throws: HighlightFailure.nestedLanguage("missing")) { try h.highlightStrict("abc", as: "host") }
        #expect(throws: HighlightFailure.nestedLanguage("recursive")) { try h.highlightStrict("abc", as: "recursive") }
        #expect(throws: HighlightFailure.nestedAutoDetection) { try h.highlightStrict("abc", as: "auto") }
        for language in ["host", "recursive", "auto"] {
            #expect(h.highlight("abc", as: language).tokens.isEmpty)
        }
    }
}
