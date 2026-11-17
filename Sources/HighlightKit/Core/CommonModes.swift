import Foundation

/// Reusable mode fragments shared by many grammars — the port of
/// highlight.js `lib/modes.js`.
///
/// Every accessor builds a *fresh* mode tree: grammars are compiled by
/// mutating their modes, so shared static instances would leak state
/// between languages (highlight.js prevents this by deep-freezing and
/// cloning; we prevent it by construction).
public enum CommonModes {
    // MARK: Common pattern sources

    /// A regex source that never matches.
    public static let matchNothingRe = "\\b\\B"
    /// A regex source for an ASCII-letter-led identifier.
    public static let identRe = "[a-zA-Z]\\w*"
    /// A regex source for an identifier that may start with an underscore.
    public static let underscoreIdentRe = "[a-zA-Z_]\\w*"
    /// A regex source for a simple decimal number.
    public static let numberRe = "\\b\\d+(\\.\\d+)?"
    /// A regex source for hexadecimal, decimal, and exponent-form numbers.
    public static let cNumberRe = "(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)"
    /// A regex source for binary numbers prefixed with `0b`.
    public static let binaryNumberRe = "\\b(0b[01]+)"
    /// A regex source for tokens that can precede a regular-expression literal.
    public static let reStartersRe =
        "!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~"

    // MARK: Common modes

    /// `#!/usr/bin/env …` — optionally requiring a specific binary.
    public static func shebang(binary: String? = nil, relevance: Double = 0) -> Mode {
        let beginShebang = "^#![ ]*\\/"
        let begin: String
        if let binary {
            begin = beginShebang + ".*\\b" + binary + "\\b.*"
        } else {
            begin = beginShebang
        }
        return Mode(
            scope: "meta",
            begin: .re(begin),
            end: "$",
            relevance: relevance,
            onBegin: { match, response in
                if match.index != 0 { response.ignoreMatch() }
            }
        )
    }

    /// A fresh mode matching a backslash escape.
    public static var backslashEscape: Mode {
        Mode(begin: "\\\\[\\s\\S]", relevance: 0)
    }

    /// A fresh single-quoted string mode with escapes.
    public static var aposStringMode: Mode {
        Mode(scope: "string", begin: "'", end: "'", illegal: ["\\n"], contains: [backslashEscape])
    }

    /// A fresh double-quoted string mode with escapes.
    public static var quoteStringMode: Mode {
        Mode(scope: "string", begin: "\"", end: "\"", illegal: ["\\n"], contains: [backslashEscape])
    }

    /// A fresh relevance mode for common prose words.
    public static var phrasalWordsMode: Mode {
        Mode(begin: "\\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\\b")
    }

    /// Builds a comment mode with doctag (`TODO:` …) and english-prose
    /// relevance boosters.
    public static func comment(_ begin: String, _ end: String, _ configure: ((Mode) -> Void)? = nil) -> Mode {
        let mode = Mode(scope: "comment", begin: .re(begin), end: .re(end), contains: [])

        var contains: [Mode] = [
            Mode(
                scope: "doctag",
                begin: "[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
                end: "(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):",
                relevance: 0,
                excludeBegin: true
            ),
        ]
        // sequences of 3 english words in a row strongly suggest that we
        // really are inside a comment
        contains.append(
            Mode(begin: .re(proseSequencePattern))
        )

        configure?(mode)
        // configure may replace `contains`; extend whatever is there,
        // matching highlight.js (which pushes onto the merged mode).
        mode.contains = (mode.contains ?? []) + contains
        return mode
    }

    /// The comment "prose" relevance booster: three english words in a
    /// row. Referenced by name so the matcher can install a specialized
    /// prefilter for it (see `CompiledRule.Prefilter.commentProse`).
    static let proseSequencePattern: String = {
        let englishWord = RegexSource.either(
            "I", "a", "is", "so", "us", "to", "at", "if", "in", "it", "on",
            "[A-Za-z]+['](d|ve|re|ll|t|s|n)",
            "[A-Za-z]+[-][a-z]+",
            "[A-Za-z][a-z]{2,}"
        )
        return "[ ]+(\(englishWord)[.]?[:]?([.][ ]|[ ])){3}"
    }()

    /// A fresh C-style line-comment mode.
    public static var cLineCommentMode: Mode {
        comment("//", "$")
    }

    /// A fresh C-style block-comment mode.
    public static var cBlockCommentMode: Mode {
        comment("/\\*", "\\*/")
    }

    /// A fresh hash-prefixed line-comment mode.
    public static var hashCommentMode: Mode {
        comment("#", "$")
    }

    /// A fresh simple-decimal number mode.
    public static var numberMode: Mode {
        Mode(scope: "number", begin: .re(numberRe), relevance: 0)
    }

    /// A fresh C-style number mode.
    public static var cNumberMode: Mode {
        Mode(scope: "number", begin: .re(cNumberRe), relevance: 0)
    }

    /// A fresh binary-number mode.
    public static var binaryNumberMode: Mode {
        Mode(scope: "number", begin: .re(binaryNumberRe), relevance: 0)
    }

    /// A fresh slash-delimited regular-expression mode.
    public static var regexpMode: Mode {
        Mode(
            scope: "regexp",
            begin: "\\/(?=[^/\\n]*\\/)",
            end: "\\/[gimuy]*",
            contains: [
                backslashEscape,
                Mode(begin: "\\[", end: "\\]", contains: [backslashEscape], relevance: 0),
            ]
        )
    }

    /// A fresh title mode using a letter-led identifier.
    public static var titleMode: Mode {
        Mode(scope: "title", begin: .re(identRe), relevance: 0)
    }

    /// A fresh title mode allowing an initial underscore.
    public static var underscoreTitleMode: Mode {
        Mode(scope: "title", begin: .re(underscoreIdentRe), relevance: 0)
    }

    /// Excludes trailing method calls (`.foo`) from keyword processing.
    public static var methodGuard: Mode {
        Mode(begin: .re("\\.\\s*" + underscoreIdentRe), relevance: 0)
    }
}
