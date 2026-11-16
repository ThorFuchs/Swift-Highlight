import Foundation

/// A complete grammar for one language: the root mode plus
/// language-level metadata (port of the highlight.js `Language` object).
public struct LanguageDefinition {
    /// The canonical language name.
    public var name: String
    /// Alternate names accepted by the registry.
    public var aliases: [String]
    /// Whether grammar matching uses case-insensitive options.
    public var caseInsensitive: Bool
    /// Maps grammar-internal scope names to public ones.
    public var classNameAliases: [String: String]
    /// Whether automatic detection excludes this language.
    public var disableAutodetect: Bool
    /// Name of a language this one is a superset of (for example C++ for
    /// Arduino); breaks relevance ties during auto-detection.
    public var supersetOf: String?
    /// The top-level mode: its `keywords`, `contains` and `illegal` drive
    /// parsing from column zero.
    public var root: Mode

    /// Creates a language definition and its root mode.
    public init(
        name: String,
        aliases: [String] = [],
        caseInsensitive: Bool = false,
        classNameAliases: [String: String] = [:],
        disableAutodetect: Bool = false,
        supersetOf: String? = nil,
        root: Mode
    ) {
        self.name = name
        self.aliases = aliases
        self.caseInsensitive = caseInsensitive
        self.classNameAliases = classNameAliases
        self.disableAutodetect = disableAutodetect
        self.supersetOf = supersetOf
        self.root = root
    }
}

/// A lazily built grammar: the factory is invoked (and its result
/// compiled) the first time the language is needed. The factory must
/// return a freshly constructed mode tree on every call. Factories are
/// synchronous construction closures: they must not call back into a
/// `Highlighter` or ask any registry to compile another language.
public struct LanguageDescriptor: Sendable {
    /// The canonical name used for registry lookup.
    public let name: String
    /// Alternate names registered alongside the canonical name.
    public let aliases: [String]
    /// A factory that constructs a fresh language definition for compilation.
    public let build: @Sendable () -> LanguageDefinition

    /// Creates a descriptor with a fresh-definition factory.
    public init(name: String, aliases: [String] = [], build: @escaping @Sendable () -> LanguageDefinition) {
        self.name = name
        self.aliases = aliases
        self.build = build
    }
}
