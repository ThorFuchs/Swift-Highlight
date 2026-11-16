#if canImport(UIKit) || canImport(AppKit)
import SwiftHighlight
/// A token's semantic role — `.keyword`, `.titleFunction`, … — matching
/// highlight.js scope names.
///
/// Typed like `Notification.Name`: a transparent wrapper over the scope
/// string, so the standard scopes get autocomplete and typo safety while
/// remaining an *open* set — grammars (including ones you register) can
/// introduce scopes no enum could represent, and dot-path scopes like
/// `"title.function.invoke"` resolve through structural fallback rather
/// than a flat case list. Performance is identical to raw strings by
/// construction (same hashing, same storage); the render path is
/// dominated by `NSAttributedString` itself, not key lookup.
public struct HighlightScope: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral {
    /// The unmodified scope name.
    public var rawValue: String

    /// Creates a scope from its raw name.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a scope from a string literal.
    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    /// Creates a scope from an arbitrary name.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

// The standard highlight.js scopes
// (https://highlightjs.readthedocs.io/en/latest/css-classes-reference.html).
extension HighlightScope {
    // Language syntax
    /// The `keyword` scope.
    public static let keyword: Self = "keyword"
    /// The `built_in` scope.
    public static let builtIn: Self = "built_in"
    /// The `type` scope.
    public static let type: Self = "type"
    /// The `literal` scope.
    public static let literal: Self = "literal"
    /// The `number` scope.
    public static let number: Self = "number"
    /// The `operator` scope.
    public static let `operator`: Self = "operator"
    /// The `punctuation` scope.
    public static let punctuation: Self = "punctuation"
    /// The `property` scope.
    public static let property: Self = "property"
    /// The `regexp` scope.
    public static let regexp: Self = "regexp"
    /// The `string` scope.
    public static let string: Self = "string"
    /// The `char.escape` scope.
    public static let charEscape: Self = "char.escape"
    /// The `subst` scope.
    public static let subst: Self = "subst"
    /// The `symbol` scope.
    public static let symbol: Self = "symbol"
    /// The `variable` scope.
    public static let variable: Self = "variable"
    /// The `variable.language` scope.
    public static let variableLanguage: Self = "variable.language"
    /// The `variable.constant` scope.
    public static let variableConstant: Self = "variable.constant"
    /// The `title` scope.
    public static let title: Self = "title"
    /// The `title.class` scope.
    public static let titleClass: Self = "title.class"
    /// The `title.class.inherited` scope.
    public static let titleClassInherited: Self = "title.class.inherited"
    /// The `title.function` scope.
    public static let titleFunction: Self = "title.function"
    /// The `title.function.invoke` scope.
    public static let titleFunctionInvoke: Self = "title.function.invoke"
    /// The `params` scope.
    public static let params: Self = "params"
    /// The `comment` scope.
    public static let comment: Self = "comment"
    /// The `doctag` scope.
    public static let doctag: Self = "doctag"
    /// The `meta` scope.
    public static let meta: Self = "meta"
    /// The `meta.prompt` scope.
    public static let metaPrompt: Self = "meta.prompt"
    /// The `meta.string` scope.
    public static let metaString: Self = "meta.string"

    // Markup
    /// The `section` scope.
    public static let section: Self = "section"
    /// The `tag` scope.
    public static let tag: Self = "tag"
    /// The `name` scope.
    public static let name: Self = "name"
    /// The `attr` scope.
    public static let attr: Self = "attr"
    /// The `attribute` scope.
    public static let attribute: Self = "attribute"
    /// The `bullet` scope.
    public static let bullet: Self = "bullet"
    /// The `code` scope.
    public static let code: Self = "code"
    /// The `emphasis` scope.
    public static let emphasis: Self = "emphasis"
    /// The `strong` scope.
    public static let strong: Self = "strong"
    /// The `formula` scope.
    public static let formula: Self = "formula"
    /// The `link` scope.
    public static let link: Self = "link"
    /// The `quote` scope.
    public static let quote: Self = "quote"

    // CSS
    /// The `selector-tag` scope.
    public static let selectorTag: Self = "selector-tag"
    /// The `selector-id` scope.
    public static let selectorId: Self = "selector-id"
    /// The `selector-class` scope.
    public static let selectorClass: Self = "selector-class"
    /// The `selector-attr` scope.
    public static let selectorAttr: Self = "selector-attr"
    /// The `selector-pseudo` scope.
    public static let selectorPseudo: Self = "selector-pseudo"

    // Templates and diffs
    /// The `template-tag` scope.
    public static let templateTag: Self = "template-tag"
    /// The `template-variable` scope.
    public static let templateVariable: Self = "template-variable"
    /// The `addition` scope.
    public static let addition: Self = "addition"
    /// The `deletion` scope.
    public static let deletion: Self = "deletion"
}

#endif
