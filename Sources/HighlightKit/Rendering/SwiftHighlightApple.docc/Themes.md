# Themes and attributed text

Apply a theme after analysis and reuse the result for appearance changes.

The built-in GitHub and Xcode themes provide light and dark variants. Adaptive
variants follow supported platform appearance changes. A custom
``HighlightTheme`` maps ``HighlightScope`` values to ``ScopeStyle`` values and
specifies the base foreground, background suggestion and font.

`HighlightResult.attributedString(for:theme:)` validates that its input is the
exact source analyzed by the result, then validates every token range. Invalid
or mismatched input throws rather than partially styling an unrelated string.
The convenience method on `Highlighter` is tolerant and falls back to plain
text if analysis or rendering fails.

## Reuse analysis across themes

<!-- docc-verify: apple -->
```swift
import SwiftHighlight
import SwiftHighlightApple

let source = "let answer = 42"
let result = try Highlighter().highlightStrict(source, as: "swift")
let lightText = try result.attributedString(for: source, theme: .githubLight)
let darkText = try result.attributedString(for: source, theme: .githubDark)
precondition(lightText.string == source && darkText.string == source)
```

Apply the theme's suggested `backgroundColor` to the enclosing view; the
attributed string applies foreground and font attributes. Adaptive themes such
as `.github` use appearance-aware colors on supported platforms. The font and
non-color traits of a combined adaptive theme come from the light theme, with
scope traits falling back to the dark theme when the light theme lacks a scope.
