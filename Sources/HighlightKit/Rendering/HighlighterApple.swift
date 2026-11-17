#if canImport(UIKit) || canImport(AppKit)
public import Foundation
public import SwiftHighlight

extension Highlighter {
    /// Highlights and renders source in one tolerant operation.
    ///
    /// When `language` is `nil`, the highlighter uses automatic detection.
    /// Analysis or rendering failures return plain attributed text. To observe
    /// errors or reuse analysis with multiple themes, call the strict core API
    /// and then `HighlightResult.attributedString(for:theme:)`.
    ///
    /// - Parameters:
    ///   - code: The source to analyze and render.
    ///   - language: A registered language name or alias, or `nil` to detect it.
    ///   - theme: The theme to apply; defaults to the adaptive GitHub theme.
    /// - Returns: Highlighted text, or plain attributed text on failure.
    public func attributedString(for code: String, language: String? = nil, theme: HighlightTheme = .github) -> NSAttributedString {
        let result = language.map { highlight(code, as: $0) } ?? highlightAuto(code)
        return (try? result.attributedString(for: code, theme: theme)) ?? NSAttributedString(string: code)
    }
}
#endif
