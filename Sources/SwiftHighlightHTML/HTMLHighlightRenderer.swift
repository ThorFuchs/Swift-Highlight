internal import Foundation
public import SwiftHighlight

/// Produces HTML from UTF-16 token ranges. Class components must consist of
/// ASCII letters, digits, hyphens, or underscores; dots separate components.
public struct HTMLHighlightRenderer: Sendable {
    public enum RenderError: Error, Sendable, Equatable { case invalidClass(String); case nullCharacter }
    public init() {}

    /// Validates that this result belongs to exactly this source.
    public func render(_ source: String, result: HighlightResult) throws -> String {
        try result.validateSource(source)
        return try render(source, tokens: result.tokens)
    }

    /// Low-level API: callers are responsible for associating tokens with their source.
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
