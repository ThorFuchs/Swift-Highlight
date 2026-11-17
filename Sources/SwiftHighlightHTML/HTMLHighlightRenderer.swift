internal import Foundation
public import SwiftHighlight

/// Renders syntax tokens as escaped HTML fragments or code blocks.
///
/// Prefer ``render(_:result:)`` when you have a `HighlightResult`: it checks
/// that the result was produced from the exact supplied source. The lower-level
/// token APIs validate ranges but can't verify their association with a source.
/// Scope and language class components accept ASCII letters, digits, hyphens,
/// and underscores; dots separate components and become hyphens in class names.
///
/// This renderer escapes the code it receives. It doesn't sanitize surrounding
/// HTML, locate code blocks in an existing document, or include a stylesheet.
public struct HTMLHighlightRenderer: Sendable {
    /// An error specific to HTML text or class rendering.
    public enum RenderError: Error, Sendable, Equatable {
        /// A scope or language name cannot be mapped to a safe class.
        case invalidClass(String)
        /// The source contains NUL, which HTML parsing cannot round-trip.
        case nullCharacter
    }
    /// Creates a stateless HTML renderer.
    public init() {}

    /// Renders a source-bound result as an HTML fragment.
    ///
    /// - Parameters:
    ///   - source: The exact input passed to the highlighter.
    ///   - result: The result produced for that input.
    /// - Returns: Escaped text and nested `span` elements, without a wrapper.
    /// - Throws: `TokenValidationError` for a source mismatch or invalid range,
    ///   or ``RenderError`` for a NUL character or invalid scope class.
    public func render(_ source: String, result: HighlightResult) throws -> String {
        try result.validateSource(source)
        return try render(source, tokens: result.tokens)
    }

    /// Renders externally supplied tokens as an HTML fragment.
    ///
    /// - Important: Range validation can't establish that `tokens` belong to
    ///   `source`. Keep this association in the caller, or use
    ///   ``render(_:result:)`` for a source-bound result.
    /// - Parameters:
    ///   - source: The text against which ranges are validated.
    ///   - tokens: Ordered, non-overlapping UTF-16 token ranges.
    /// - Returns: Escaped text and nested `span` elements, without a wrapper.
    /// - Throws: `TokenValidationError` for an invalid range, or ``RenderError``
    ///   for a NUL character or invalid scope class.
    public func render(_ source: String, tokens: [HighlightToken]) throws -> String {
        guard !source.unicodeScalars.contains(where: { $0.value == 0 }) else { throw RenderError.nullCharacter }
        try validateTokens(tokens, in: source)
        let text = source as NSString
        var output = ""
        var position = 0
        for token in tokens {
            output += escape(text.substring(with: NSRange(location: position, length: token.range.location - position)))
            for scope in token.scopes {
                output += "<span class=\"hljs-\(try cssName(scope))\">"
            }
            output += escape(text.substring(with: token.range))
            for _ in token.scopes { output += "</span>" }
            position = token.range.location + token.range.length
        }
        output += escape(text.substring(from: position))
        return output
    }

    /// Renders escaped code in a `<pre><code>` wrapper.
    ///
    /// - Important: The caller must associate `tokens` with their original
    ///   `source`; this method validates ranges but not source identity.
    /// - Parameters:
    ///   - source: The text against which ranges are validated.
    ///   - tokens: Ordered, non-overlapping UTF-16 token ranges.
    ///   - language: An optional language class component, such as `swift`.
    /// - Returns: A complete `<pre><code>` element containing escaped source.
    /// - Throws: `TokenValidationError` for invalid ranges, or ``RenderError``
    ///   for NUL or an invalid scope or language class.
    public func codeBlock(_ source: String, tokens: [HighlightToken], language: String? = nil) throws -> String {
        let attribute = try language.map { " class=\"language-\(try cssName($0))\"" } ?? ""
        return "<pre><code\(attribute)>\(try render(source, tokens: tokens))</code></pre>"
    }

    private func cssName(_ value: String) throws -> String {
        let parts = value.split(separator: ".", omittingEmptySubsequences: false)
        guard !parts.isEmpty, parts.allSatisfy({ !$0.isEmpty && $0.utf8.allSatisfy {
            (65...90).contains($0) || (97...122).contains($0) || (48...57).contains($0) || $0 == 45 || $0 == 95
        } }) else { throw RenderError.invalidClass(value) }
        return parts.joined(separator: "-")
    }
    private func escape(_ value: String) -> String {
        value.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
            .replacingOccurrences(of: "\r", with: "&#13;")
    }
}
