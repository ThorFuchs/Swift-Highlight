#if canImport(SwiftUI) && (canImport(AppKit) || canImport(UIKit))
import SwiftUI
import SwiftHighlight
import SwiftHighlightApple
import SwiftHighlightCodeCard

/// A selectable, syntax-highlighted code card for SwiftUI applications.
///
/// Initialize the view when its source or language changes. Highlighting is
/// performed once during initialization; reuse the resulting view or construct
/// it away from frequently updated view bodies for large inputs. Long lines
/// wrap by default; set `CodeCardOptions.wrapLines` to `false` for horizontal
/// scrolling. Errors from strict highlighting are propagated to the caller.
public struct CodeCardView: View {
    private let source: String
    private let language: String
    private let result: HighlightResult
    private let theme: HighlightTheme
    private let options: CodeCardOptions
    @ScaledMetric(relativeTo: .body) private var fontScale: CGFloat = 1

    /// Creates a card and highlights the supplied source once.
    ///
    /// - Parameters:
    ///   - source: Source code to display.
    ///   - language: A registered language name or alias.
    ///   - theme: An existing built-in or custom Apple highlight theme.
    ///   - options: Header, wrapping and layout settings.
    /// - Throws: An error from strict highlighting.
    public init(source: String, language: String, theme: HighlightTheme = .githubDark,
                options: CodeCardOptions = .default) throws {
        self.source = source
        self.language = language
        self.theme = theme
        self.options = options
        self.result = try Highlighter.shared.highlightStrict(source, as: language)
    }

    /// The card's SwiftUI content.
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if options.showHeader {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(verbatim: options.title ?? language)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    Text(verbatim: language.uppercased())
                        .tracking(0.8)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(theme.foregroundColor).opacity(0.8))
                .padding(CGFloat(options.padding))
                Rectangle()
                    .fill(Color(theme.foregroundColor).opacity(0.2))
                    .frame(height: 1)
                    .accessibilityHidden(true)
            }
            if options.wrapLines {
                codeText
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(CGFloat(options.padding))
            } else {
                ScrollView(.horizontal) {
                    codeText.fixedSize(horizontal: true, vertical: true)
                        .padding(CGFloat(options.padding))
                }
            }
        }
        .background(Color(theme.backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(options.cornerRadius)))
        .overlay {
            RoundedRectangle(cornerRadius: CGFloat(options.cornerRadius))
                .stroke(Color(theme.foregroundColor).opacity(0.2), lineWidth: 1)
                .accessibilityHidden(true)
        }
    }

    private var codeText: some View {
        var sizedTheme = theme
        sizedTheme.font.size = CGFloat(options.fontSize) * fontScale
        // The result and source are captured together by the initializer, so
        // validation cannot fail unless the library's invariants change.
        let styled = (try? result.attributedString(for: source, theme: sizedTheme))
            ?? NSAttributedString(string: source)
        #if canImport(AppKit)
        let text = (try? AttributedString(styled, including: \.appKit)) ?? AttributedString(source)
        #else
        let text = (try? AttributedString(styled, including: \.uiKit)) ?? AttributedString(source)
        #endif
        #if os(macOS) || os(iOS) || os(visionOS)
        return Text(text).textSelection(.enabled).fixedSize(horizontal: false, vertical: true)
        #else
        return Text(text).fixedSize(horizontal: false, vertical: true)
        #endif
    }
}
#endif
