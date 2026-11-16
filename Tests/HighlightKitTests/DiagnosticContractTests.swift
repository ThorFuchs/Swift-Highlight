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
        let selfOnly = Highlighter(languages: [automatic])
        #expect(throws: HighlightFailure.nestedAutoDetection) { try selfOnly.highlightStrict("abc", as: "auto") }
        for language in ["host", "recursive", "auto"] {
            #expect(h.highlight("abc", as: language).tokens.isEmpty)
        }
    }
    @Test func strictNestedAutoDetectionAndCandidateErrors() throws {
        let selected = LanguageDescriptor(name: "selected") {
            LanguageDefinition(name: "selected", root: Mode(contains: [Mode(scope: "keyword", match: "HELLO")]))
        }
        let other = LanguageDescriptor(name: "other") {
            LanguageDefinition(name: "other", root: Mode(contains: [Mode(scope: "string", match: "OTHER")]))
        }
        let host = LanguageDescriptor(name: "host-auto") {
            LanguageDefinition(name: "host-auto", root: Mode(subLanguage: ["selected", "other"]))
        }
        let h = Highlighter(languages: [host, selected, other])
        let strict = try h.highlightStrict("HELLO", as: "host-auto")
        let tolerant = h.highlight("HELLO", as: "host-auto")
        #expect(!strict.tokens.isEmpty)
        #expect(strict.tokens == tolerant.tokens)

        let bad = LanguageDescriptor(name: "bad") {
            LanguageDefinition(name: "bad", root: Mode(contains: [Mode(begin: ["a", "b"])]))
        }
        let brokenHost = LanguageDescriptor(name: "broken-auto") {
            LanguageDefinition(name: "broken-auto", root: Mode(subLanguage: ["selected", "bad"]))
        }
        let broken = Highlighter(languages: [selected, bad, brokenHost])
        #expect(throws: HighlightFailure.nestedLanguage("bad")) { try broken.highlightStrict("HELLO", as: "broken-auto") }
        #expect(!broken.highlight("HELLO", as: "broken-auto").tokens.isEmpty)

        let loop = LanguageDescriptor(name: "loop") {
            LanguageDefinition(name: "loop", root: Mode(contains: [
                Mode(begin: "x", end: "$", onEnd: { _, response in response.ignoreMatch() })
            ]))
        }
        let loopHost = LanguageDescriptor(name: "loop-auto") {
            LanguageDefinition(name: "loop-auto", root: Mode(subLanguage: ["selected", "loop"]))
        }
        let looping = Highlighter(languages: [selected, loop, loopHost])
        #expect(throws: HighlightFailure.engineAborted) { try looping.highlightStrict("x", as: "loop-auto") }
        #expect(looping.highlight("x", as: "loop-auto").tokens.isEmpty)

        let missingHost = LanguageDescriptor(name: "missing-auto") {
            LanguageDefinition(name: "missing-auto", root: Mode(subLanguage: ["selected", "missing"]))
        }
        let missing = Highlighter(languages: [selected, missingHost])
        #expect(throws: HighlightFailure.nestedAutoDetection) { try missing.highlightStrict("HELLO", as: "missing-auto") }
    }

    @Test func strictMarkdownUnlabelledFenceUsesAutoDetection() throws {
        let source = "```\nlet x = 1\n```\n"
        let highlighter = Highlighter()
        let strict = try highlighter.highlightStrict(source, as: "markdown")
        let tolerant = highlighter.highlight(source, as: "markdown")
        #expect(!strict.tokens.isEmpty)
        #expect(strict.tokens == tolerant.tokens)
    }

}
