import Foundation
import SwiftHighlight
import SwiftHighlightHTML

/// Renders a highlighted source string as an HTML card with embedded styles.
///
/// The generated card uses semantic `pre` and `code` elements. Source and
/// header text are escaped. Styles are scoped to the card and require no
/// external assets. Treat surrounding HTML as a separate trust boundary.
public struct HTMLCodeCardRenderer: Sendable {
    /// Creates a stateless card renderer.
    public init() {}

    /// Highlights source using an explicit language and renders an HTML fragment.
    ///
    /// - Parameters:
    ///   - source: Source text to display, preserved inside the code element.
    ///   - language: A registered language name or alias.
    ///   - theme: The built-in color scheme.
    ///   - options: Header, wrapping and layout settings.
    /// - Returns: An embeddable card and its scoped stylesheet.
    /// - Throws: Highlighting and HTML validation errors.
    public func render(_ source: String, language: String, theme: CodeCardTheme = .githubDark,
                       options: CodeCardOptions = .default) throws -> String {
        let result = try Highlighter.shared.highlightStrict(source, as: language)
        let code = try HTMLHighlightRenderer().render(source, result: result)
        let name = escape(language.uppercased())
        let title = escape(options.title ?? language)
        let header = options.showHeader
            ? "<div class=\"sh-card__header\"><span class=\"sh-card__title\">\(title)</span><span class=\"sh-card__language\">\(name)</span></div>"
            : ""
        let wrapping = options.wrapLines ? "pre-wrap" : "pre"
        return """
        <style>\(Self.styles)</style>
        <div class="sh-code-card sh-code-card--\(theme.rawValue)" style="--sh-font-size:\(options.fontSize)px;--sh-padding:\(options.padding)px;--sh-radius:\(options.cornerRadius)px;--sh-white-space:\(wrapping)">
        \(header)<pre class="sh-card__pre"><code>\(code)</code></pre>
        </div>
        """
    }

    /// Renders a complete standalone UTF-8 HTML document containing one card.
    ///
    /// - Parameters:
    ///   - source: Source text to display.
    ///   - language: A registered language name or alias.
    ///   - theme: The built-in color scheme.
    ///   - options: Header, wrapping and layout settings.
    /// - Returns: A complete HTML document suitable for opening in a browser.
    /// - Throws: Highlighting and HTML validation errors.
    public func document(_ source: String, language: String, theme: CodeCardTheme = .githubDark,
                         options: CodeCardOptions = .default) throws -> String {
        let card = try render(source, language: language, theme: theme, options: options)
        return """
        <!doctype html>
        <html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>\(escape(options.title ?? language))</title></head>
        <body>\(card)</body></html>
        """
    }

    private func escape(_ value: String) -> String {
        value.replacingOccurrences(of: "\0", with: "\u{fffd}")
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
            .replacingOccurrences(of: "\r", with: "&#13;")
    }

    private static let styles = """
    .sh-code-card{box-sizing:border-box;background:var(--sh-bg);color:var(--sh-fg);border:1px solid var(--sh-border);border-radius:var(--sh-radius);overflow:hidden}
    .sh-code-card *{box-sizing:border-box}
    .sh-card__header{display:flex;justify-content:space-between;gap:1em;align-items:center;padding:var(--sh-padding);border-bottom:1px solid var(--sh-border);color:var(--sh-muted);font:600 .75rem/1.4 system-ui,sans-serif}
    .sh-card__title{overflow-wrap:anywhere}.sh-card__language{letter-spacing:.08em}
    .sh-card__pre{margin:0;padding:var(--sh-padding);overflow-x:auto;white-space:var(--sh-white-space);overflow-wrap:anywhere;font:var(--sh-font-size)/1.5 ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;tab-size:4}
    .sh-card__pre code{font:inherit;color:inherit}
    .sh-code-card--github-dark{--sh-bg:#0d1117;--sh-fg:#c9d1d9;--sh-border:#30363d;--sh-muted:#a4b2c4;--sh-keyword:#ff7b72;--sh-title:#d2a8ff;--sh-attr:#79c0ff;--sh-string:#a5d6ff;--sh-comment:#8b949e;--sh-name:#7ee787;--sh-built:#ffa657}
    .sh-code-card--github-light{--sh-bg:#ffffff;--sh-fg:#24292e;--sh-border:#d0d7de;--sh-muted:#57606a;--sh-keyword:#d73a49;--sh-title:#6f42c1;--sh-attr:#005cc5;--sh-string:#032f62;--sh-comment:#6a737d;--sh-name:#22863a;--sh-built:#e36209}
    .sh-code-card .hljs-keyword,.sh-code-card .hljs-doctag,.sh-code-card .hljs-template-tag,.sh-code-card .hljs-template-variable,.sh-code-card .hljs-type{color:var(--sh-keyword)}
    .sh-code-card .hljs-title,.sh-code-card .hljs-title-function,.sh-code-card .hljs-title-class{color:var(--sh-title)}
    .sh-code-card .hljs-attr,.sh-code-card .hljs-attribute,.sh-code-card .hljs-number,.sh-code-card .hljs-literal,.sh-code-card .hljs-property,.sh-code-card .hljs-operator,.sh-code-card .hljs-meta{color:var(--sh-attr)}
    .sh-code-card .hljs-string,.sh-code-card .hljs-regexp,.sh-code-card .hljs-meta-string{color:var(--sh-string)}
    .sh-code-card .hljs-comment,.sh-code-card .hljs-code,.sh-code-card .hljs-formula{color:var(--sh-comment)}
    .sh-code-card .hljs-tag,.sh-code-card .hljs-name,.sh-code-card .hljs-selector-tag,.sh-code-card .hljs-quote{color:var(--sh-name)}
    .sh-code-card .hljs-built_in,.sh-code-card .hljs-variable,.sh-code-card .hljs-symbol{color:var(--sh-built)}
    .sh-code-card .hljs-selector-attr,.sh-code-card .hljs-selector-class,.sh-code-card .hljs-selector-id,.sh-code-card .hljs-variable-constant{color:var(--sh-attr)}
    .sh-code-card .hljs-selector-pseudo,.sh-code-card .hljs-char-escape{color:var(--sh-name)}
    .sh-code-card .hljs-subst,.sh-code-card .hljs-params,.sh-code-card .hljs-punctuation{color:var(--sh-fg)}
    .sh-code-card .hljs-link{color:var(--sh-string)}.sh-code-card .hljs-emphasis{font-style:italic}.sh-code-card .hljs-strong{font-weight:bold}
    """
}
