import Foundation

/// A built-in color scheme shared by the HTML and SwiftUI code cards.
public enum CodeCardTheme: String, CaseIterable, Sendable {
    /// A dark theme based on the package's GitHub dark palette.
    case githubDark = "github-dark"
    /// A light theme based on the package's GitHub light palette.
    case githubLight = "github-light"
}

/// Presentation settings for an HTML or SwiftUI code card.
///
/// Values are validated at initialization so they can safely be used in layout
/// and CSS. These settings describe presentation, not syntax highlighting.
public struct CodeCardOptions: Sendable, Equatable {
    /// An optional filename or other header title.
    public let title: String?
    /// Whether the header is visible.
    public let showHeader: Bool
    /// Whether long lines wrap instead of scrolling horizontally.
    public let wrapLines: Bool
    /// The code font size in points (SwiftUI) or CSS pixels (HTML).
    public let fontSize: Double
    /// The content inset in points (SwiftUI) or CSS pixels (HTML).
    public let padding: Double
    /// The card corner radius in points (SwiftUI) or CSS pixels (HTML).
    public let cornerRadius: Double

    /// A presentation value falls outside its supported finite range.
    public enum ValidationError: Error, Sendable, Equatable {
        /// Font size must be between 8 and 72.
        case fontSize
        /// Padding must be between 0 and 128.
        case padding
        /// Corner radius must be between 0 and 128.
        case cornerRadius
    }

    /// Creates a card configuration with validated presentation values.
    ///
    /// - Throws: ``ValidationError`` when a number is non-finite or outside
    ///   the range documented on the corresponding error case.
    public init(title: String? = nil, showHeader: Bool = true, wrapLines: Bool = true,
                fontSize: Double = 16, padding: Double = 24, cornerRadius: Double = 12) throws {
        guard fontSize.isFinite, (8...72).contains(fontSize) else { throw ValidationError.fontSize }
        guard padding.isFinite, (0...128).contains(padding) else { throw ValidationError.padding }
        guard cornerRadius.isFinite, (0...128).contains(cornerRadius) else { throw ValidationError.cornerRadius }
        self.title = title
        self.showHeader = showHeader
        self.wrapLines = wrapLines
        self.fontSize = fontSize
        self.padding = padding
        self.cornerRadius = cornerRadius
    }

    /// The default card presentation.
    public static let `default` = try! CodeCardOptions()
}
