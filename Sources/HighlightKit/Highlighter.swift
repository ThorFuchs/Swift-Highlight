internal import Foundation

/// Syntax highlighter with a highlight.js-compatible parsing engine and
/// grammars, producing scope tokens (`NSRange` + scope name) and
/// `NSAttributedString`s instead of HTML.
///
/// ```swift
/// let result = Highlighter.shared.highlight(code, as: "swift")
/// for token in result.tokens {
///     print(token.range, token.scope)
/// }
/// ```
///
/// Instances are immutable-after-configuration and safe to share across
/// threads; compiled grammars are cached per instance.
public final class Highlighter: Sendable {
    /// A process-wide instance with every bundled language registered.
    /// Grammars compile lazily on first use, so the cost of the shared
    /// instance scales with the languages actually highlighted.
    public static let shared = Highlighter()

    let registry: LanguageRegistry

    /// Creates a highlighter with the given grammars registered.
    /// - Parameter languages: grammars to register; defaults to all
    ///   bundled languages.
    public init(languages: [LanguageDescriptor] = LanguageCatalog.all) {
        self.registry = LanguageRegistry(languages: languages)
    }

    /// Registers an additional (or replacement) grammar.
    public func register(_ language: LanguageDescriptor) {
        registry.register([language])
    }

    /// Canonical names of all registered languages, sorted.
    public var languageNames: [String] {
        registry.languageNames
    }

    /// Whether `name` (a canonical name or an alias) is registered.
    public func hasLanguage(named name: String) -> Bool {
        registry.hasLanguage(named: name)
    }

    /// Highlights `code` as the given language.
    ///
    /// - Parameters:
    ///   - code: source text to highlight.
    ///   - languageName: language name or alias (case-insensitive).
    ///   - ignoreIllegals: when `false`, input that is illegal for the
    ///     grammar aborts highlighting and the result has
    ///     ``HighlightResult/illegal`` set. Defaults to `true`.
    ///   - continuation: parser state from a previous result to continue
    ///     from (for incremental, line-by-line highlighting).
    /// - Returns: the tokens; falls back to an unhighlighted result if
    ///   the language is unknown.
    public func highlight(
        _ code: String,
        as languageName: String,
        ignoreIllegals: Bool = true,
        continuation: Continuation? = nil
    ) -> HighlightResult {
        do {
            return try registry.highlight(
                code,
                languageName: languageName,
                ignoreIllegals: ignoreIllegals,
                continuation: continuation
            ).bindingSource(code)
        } catch {
            return HighlightResult.plain().bindingSource(code)
        }
    }

    /// Explicit-language path that reports unknown languages, invalid grammars,
    /// and top-level engine aborts. Illegal input is indicated by result.illegal.
    public func highlightStrict(_ code: String, as language: String, ignoreIllegals: Bool = true) throws -> HighlightResult {
        try registry.highlight(code, languageName: language, ignoreIllegals: ignoreIllegals, strictErrors: true).bindingSource(code)
    }

    /// Highlights `code`, detecting the language automatically by
    /// relevance among `subset` (or all registered languages).
    public func highlightAuto(_ code: String, subset: [String]? = nil) -> HighlightResult {
        registry.highlightAuto(code, subset: subset).bindingSource(code)
    }

    /// Concurrent ``highlightAuto(_:subset:)``: candidate grammars are
    /// evaluated through a processor-bounded child-task window. The ranking
    /// is identical to the synchronous version — same input, same result. In
    /// an `async` context this overload is chosen automatically; cancellation
    /// stops scheduling new candidates and cooperatively interrupts active
    /// parser work, then ranks whatever completed.
    public func highlightAuto(_ code: String, subset: [String]? = nil) async -> HighlightResult {
        await registry.highlightAuto(code, subset: subset).bindingSource(code)
    }

}

/// An engine stopped before completing its scan.
public enum HighlightFailure: Error, Sendable, Equatable {
    case engineAborted
    case nestedLanguage(String)
    case nestedAutoDetection
}
