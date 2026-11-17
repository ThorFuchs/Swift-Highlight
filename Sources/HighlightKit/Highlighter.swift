internal import Foundation

/// Analyzes source code and returns syntax scopes in UTF-16 ranges.
///
/// Create a highlighter with the bundled languages, then use
/// ``highlightStrict(_:as:ignoreIllegals:)`` when your application needs to
/// distinguish a failure from a successful result with no scoped tokens:
///
/// ```swift
/// let source = "let answer = 42"
/// let result = try Highlighter.shared.highlightStrict(source, as: "swift")
/// for token in result.tokens {
///     print(token.range, token.scopes)
/// }
/// ```
///
/// The core does not render HTML or attributed text. Use the separate
/// `SwiftHighlightHTML` or `SwiftHighlightApple` product for those outputs.
/// Grammar compilation is lazy and cached per instance. A highlighter can be
/// shared between tasks; ``register(_:)`` synchronizes changes to its registry.
///
/// - Important: The engine imposes no hard input-size or execution-time limit.
///   Set appropriate resource limits when processing untrusted input.
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

    /// Registers a grammar or replaces the current generation for its name.
    ///
    /// Names and aliases are case-insensitive. In-flight operations retain the
    /// generation they started with; a continuation from an earlier generation
    /// cannot resume the replacement grammar.
    ///
    /// - Parameter language: A descriptor whose factory creates a fresh mode tree.
    public func register(_ language: LanguageDescriptor) {
        registry.register([language])
    }

    /// Canonical names of all registered languages, sorted.
    public var languageNames: [String] {
        registry.languageNames
    }

    /// Returns whether a canonical name or alias is registered.
    ///
    /// - Parameter name: A case-insensitive language name or alias.
    /// - Returns: `true` when the registry resolves the name.
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
    /// - Returns: A source-bound result. On an unknown language, grammar error,
    ///   or engine failure, returns an unhighlighted result instead of throwing.
    ///   An empty token array can also be a successful scan with no scoped text.
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

    /// Highlights source in an explicit language and reports failures.
    ///
    /// Language names and aliases are case-insensitive. Nested language errors
    /// are reported too. This method analyzes the whole input and doesn't accept
    /// a continuation; use ``highlight(_:as:ignoreIllegals:continuation:)`` for
    /// incremental highlighting with tolerant fallback.
    ///
    /// - Parameters:
    ///   - code: The exact source to analyze.
    ///   - language: A registered canonical name or alias.
    ///   - ignoreIllegals: When `false`, an illegal match produces a result
    ///     with ``HighlightResult/illegal`` set and no tokens. Defaults to `true`.
    /// - Returns: A result bound to the input's exact UTF-16 sequence.
    /// - Throws: ``HighlightError`` for an unknown language or invalid grammar,
    ///   or ``HighlightFailure`` when the engine or nested highlighting fails.
    public func highlightStrict(_ code: String, as language: String, ignoreIllegals: Bool = true) throws -> HighlightResult {
        try registry.highlight(code, languageName: language, ignoreIllegals: ignoreIllegals, strictErrors: true).bindingSource(code)
    }

    /// Detects a language by ranking registered candidates by relevance.
    ///
    /// This is a best-effort, tolerant operation: invalid or unsuitable
    /// candidates are skipped. Use explicit strict highlighting when a known
    /// language or a diagnostic is required.
    ///
    /// - Parameters:
    ///   - code: The source to analyze.
    ///   - subset: Candidate names or aliases; `nil` considers all registered
    ///     languages. A subset limits the work and avoids unrelated guesses.
    /// - Returns: A source-bound result with the winning language and, when
    ///   available, ``HighlightResult/secondBest``.
    public func highlightAuto(_ code: String, subset: [String]? = nil) -> HighlightResult {
        registry.highlightAuto(code, subset: subset).bindingSource(code)
    }

    /// Detects a language with a bounded window of concurrent candidates.
    ///
    /// Without cancellation, ranking follows the synchronous overload. On
    /// cancellation, scheduling stops, active parser work is interrupted
    /// cooperatively, and the method ranks the candidates that completed.
    /// Cancellation cannot forcibly interrupt a synchronous ICU regex call.
    ///
    /// - Parameters:
    ///   - code: The source to analyze.
    ///   - subset: Candidate names or aliases, or `nil` for all languages.
    /// - Returns: A source-bound result; on cancellation it can reflect only a
    ///   subset of the candidates.
    public func highlightAuto(_ code: String, subset: [String]? = nil) async -> HighlightResult {
        await registry.highlightAuto(code, subset: subset).bindingSource(code)
    }

}

/// An engine stopped before completing its scan.
public enum HighlightFailure: Error, Sendable, Equatable {
    /// The engine stopped before completing the scan.
    case engineAborted
    /// A nested language or automatic-detection candidate failed to compile or run.
    case nestedLanguage(String)
    /// Nested detection had missing candidates or could not progress.
    case nestedAutoDetection
}
