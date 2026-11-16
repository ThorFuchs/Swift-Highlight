public import Foundation

/// A regex reference in a grammar: either a single pattern, or an ordered
/// list of patterns that are concatenated at compile time so that scopes
/// can be assigned per part (highlight.js "multi-class" matches).
public enum RegexRef: Sendable {
    /// A single regex source.
    case re(String)
    /// Ordered regex sources concatenated for a multi-part match.
    case parts([String])

    var single: String? {
        if case .re(let s) = self { return s }
        return nil
    }
}

extension RegexRef: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    /// Creates a single-pattern reference from a string literal.
    public init(stringLiteral value: String) { self = .re(value) }
}

extension RegexRef: ExpressibleByArrayLiteral {
    /// Creates a multi-part reference from a string array literal.
    public init(arrayLiteral elements: String...) { self = .parts(elements) }
}

/// A scope assignment: a single scope name for the whole mode, or a map of
/// capture-group number → scope name for multi-part matches.
public enum ScopeRef: Sendable {
    /// A scope applied to the entire match.
    case name(String)
    /// Scopes indexed by capture-group number.
    case multi([Int: String])
    /// Explicitly *no* scope — lets a variant cancel its base mode's
    /// scope (JavaScript's `className: null`).
    case none
}

extension ScopeRef: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    /// Creates a single scope from a string literal.
    public init(stringLiteral value: String) { self = .name(value) }
}

extension ScopeRef: ExpressibleByDictionaryLiteral {
    /// Creates capture-group scopes from a dictionary literal.
    public init(dictionaryLiteral elements: (Int, String)...) {
        self = .multi(Dictionary(uniqueKeysWithValues: elements))
    }
}

/// Read-only view of a regex match handed to grammar callbacks.
/// Group numbers are relative to the mode's own pattern.
public struct CallbackMatch {
    let source: NSString
    /// Capture groups; synthesized matches describe theirs inline and
    /// carry no `NSTextCheckingResult`.
    let groups: MatchGroups
    let matchRange: NSRange

    /// The full text being highlighted (zero-copy; UTF-16 indexed).
    public var input: NSString { source }

    /// UTF-16 offset of the match in the highlighted code.
    public var index: Int {
        matchRange.location
    }

    /// The matched text for a (mode-relative) capture group. Out-of-range
    /// groups answer nil — JavaScript's `match[N]` is undefined there,
    /// where `NSTextCheckingResult.range(at:)` would raise.
    public subscript(group: Int) -> String? {
        let r = groups.range(at: group, in: matchRange)
        guard r.location != NSNotFound else { return nil }
        return source.substring(with: r)
    }

    /// The single UTF-16 unit immediately preceding the match, if any.
    public var precedingUnit: UInt16? {
        let i = index
        guard i > 0 else { return nil }
        return source.character(at: i - 1)
    }
}

/// Mutable response object passed to grammar callbacks; lets a callback
/// veto a match and stash data shared between `onBegin` and `onEnd` of the
/// same mode (per highlight run).
public final class Response {
    /// Whether this callback has vetoed the current match.
    public private(set) var isMatchIgnored = false

    /// Free-form storage shared between the begin and end callbacks of a
    /// mode during a single highlight run.
    public var data: [String: String]

    init(data: [String: String] = [:]) {
        self.data = data
    }

    /// Vetoes the current match so the engine can consider another rule.
    public func ignoreMatch() {
        isMatchIgnored = true
    }
}

/// A grammar callback fired when a mode begins or ends.
public typealias ModeCallback = @Sendable (CallbackMatch, Response) -> Void

/// A single grammar rule (port of the highlight.js `Mode` object).
///
/// Modes form a tree via `contains`; the engine walks the tree while
/// scanning the input. Instances are mutable while a grammar is being
/// built and are consumed by the compiler; a grammar factory must return a
/// freshly built tree on every call so compilation never mutates shared
/// state.
public final class Mode {
    // MARK: Matching

    /// Matches a complete expression (sugar for `begin` with an implicit
    /// zero-length `end`). Mutually exclusive with `begin`/`end`.
    public var match: RegexRef?
    /// The regex that begins this mode.
    public var begin: RegexRef?
    /// The regex that ends this mode.
    public var end: RegexRef?
    /// If matched inside this mode (and illegals are honored), parsing of
    /// the whole snippet is aborted.
    public var illegal: [String]?

    /// Space-separated keywords; sugar that generates a `begin` matching
    /// any of the words. The match is vetoed when preceded by a dot.
    public var beginKeywords: String?
    /// Requires `beforeMatch` to appear directly before `begin` (the mode
    /// is rewritten at compile time into a parent/child pair).
    public var beforeMatch: RegexRef?

    // MARK: Scoping

    /// The scope assigned to the mode contents.
    public var scope: ScopeRef?
    /// The scope or capture-group scopes assigned to the begin match.
    public var beginScope: ScopeRef?
    /// The scope or capture-group scopes assigned to the end match.
    public var endScope: ScopeRef?

    // MARK: Behavior flags

    /// Whether the begin match is attributed to the parent rather than this mode.
    public var excludeBegin = false
    /// Whether the end match is attributed to the parent rather than this mode.
    public var excludeEnd = false
    /// Whether to reprocess the begin match in the new mode.
    public var returnBegin = false
    /// Whether to reprocess the end match in the parent mode.
    public var returnEnd = false
    /// Content is matched but attributed to the parent mode's buffer.
    public var skip = false
    /// When this mode ends, its parent ends too.
    public var endsParent = false
    /// This mode ends wherever its parent could end.
    public var endsWithParent = false
    /// When true, the same text that begins the mode also ends it
    /// (compared via the first capture group).
    public var endSameAsBegin = false

    // MARK: Content

    /// Keyword groups recognized within this mode.
    public var keywords: Keywords?
    /// `nil` means "unset" (inheritable by variants); `[]` means
    /// explicitly no children — the distinction matters when merging
    /// variants, mirroring JavaScript object-key presence.
    public var contains: [Mode]?
    /// Alternative mode definitions expanded during grammar compilation.
    public var variants: [Mode]?
    /// Mode entered immediately after this one ends.
    public var starts: Mode?
    /// Delegate the mode's content to other registered languages
    /// (auto-detected among the listed names; empty = all).
    public var subLanguage: [String]?
    /// The relevance contribution used by automatic detection.
    public var relevance: Double?
    /// Free-form marker so other grammars can find and replace this mode
    /// (for example TypeScript extending JavaScript).
    public var label: String?

    // MARK: Callbacks

    /// A callback that can inspect or veto a begin match.
    public var onBegin: ModeCallback?
    /// A callback that can inspect or veto an end match.
    public var onEnd: ModeCallback?

    // MARK: Internal compilation state

    /// Set by the `beginKeywords` compiler extension.
    var internalBeforeBegin: ModeCallback?
    var cachedVariants: [Mode]?

    /// Creates a mutable grammar mode. Return a fresh mode tree from each language factory.
    public init(
        scope: ScopeRef? = nil,
        match: RegexRef? = nil,
        begin: RegexRef? = nil,
        beginScope: ScopeRef? = nil,
        beginKeywords: String? = nil,
        beforeMatch: RegexRef? = nil,
        end: RegexRef? = nil,
        endScope: ScopeRef? = nil,
        endSameAsBegin: Bool = false,
        keywords: Keywords? = nil,
        illegal: [String]? = nil,
        contains: [Mode]? = nil,
        variants: [Mode]? = nil,
        starts: Mode? = nil,
        subLanguage: [String]? = nil,
        relevance: Double? = nil,
        label: String? = nil,
        excludeBegin: Bool = false,
        excludeEnd: Bool = false,
        returnBegin: Bool = false,
        returnEnd: Bool = false,
        skip: Bool = false,
        endsParent: Bool = false,
        endsWithParent: Bool = false,
        onBegin: ModeCallback? = nil,
        onEnd: ModeCallback? = nil
    ) {
        self.scope = scope
        self.match = match
        self.begin = begin
        self.beginScope = beginScope
        self.beginKeywords = beginKeywords
        self.beforeMatch = beforeMatch
        self.end = end
        self.endScope = endScope
        self.endSameAsBegin = endSameAsBegin
        self.keywords = keywords
        self.illegal = illegal
        self.contains = contains
        self.variants = variants
        self.starts = starts
        self.subLanguage = subLanguage
        self.relevance = relevance
        self.label = label
        self.excludeBegin = excludeBegin
        self.excludeEnd = excludeEnd
        self.returnBegin = returnBegin
        self.returnEnd = returnEnd
        self.skip = skip
        self.endsParent = endsParent
        self.endsWithParent = endsWithParent
        self.onBegin = onBegin
        self.onEnd = onEnd
    }

    /// Marker used inside `contains` to refer to the containing mode
    /// itself (highlight.js `'self'`). Never compiled or mutated; only
    /// compared by identity and replaced during compilation.
    nonisolated(unsafe) public static let selfReference = Mode()

    /// Shallow copy, optionally applying overrides — the port of
    /// highlight.js `inherit(mode, overrides)`.
    func copied(_ configure: ((Mode) -> Void)? = nil) -> Mode {
        let m = Mode()
        m.scope = scope
        m.match = match
        m.begin = begin
        m.beginScope = beginScope
        m.beginKeywords = beginKeywords
        m.beforeMatch = beforeMatch
        m.end = end
        m.endScope = endScope
        m.endSameAsBegin = endSameAsBegin
        m.keywords = keywords
        m.illegal = illegal
        m.contains = contains
        m.variants = variants
        m.starts = starts
        m.subLanguage = subLanguage
        m.relevance = relevance
        m.label = label
        m.excludeBegin = excludeBegin
        m.excludeEnd = excludeEnd
        m.returnBegin = returnBegin
        m.returnEnd = returnEnd
        m.skip = skip
        m.endsParent = endsParent
        m.endsWithParent = endsWithParent
        m.onBegin = onBegin
        m.onEnd = onEnd
        m.internalBeforeBegin = internalBeforeBegin
        m.cachedVariants = cachedVariants
        configure?(m)
        return m
    }
}
