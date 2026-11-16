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
