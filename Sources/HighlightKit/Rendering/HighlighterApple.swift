#if canImport(UIKit) || canImport(AppKit)
public import Foundation
public import SwiftHighlight

extension Highlighter {
    /// Convenience path; on analysis or rendering failure returns plain text.
    public func attributedString(for code: String, language: String? = nil, theme: HighlightTheme = .github) -> NSAttributedString {
        let result = language.map { highlight(code, as: $0) } ?? highlightAuto(code)
        return (try? result.attributedString(for: code, theme: theme)) ?? NSAttributedString(string: code)
    }
}
#endif
