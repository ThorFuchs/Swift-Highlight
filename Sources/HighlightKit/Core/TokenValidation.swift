internal import Foundation

/// Invalid token ranges must never be rendered as if they were valid.
public enum TokenValidationError: Error, Sendable, Equatable {
    /// The supplied text differs from the source retained by the result.
    case sourceMismatch
    /// The token at the given index has an invalid or overlapping range.
    case invalidRange(index: Int)
}

/// Checks token ordering, bounds, and UTF-16 scalar boundaries.
///
/// This validates ranges against `source`, but can't establish that the tokens
/// were produced from that exact source. For a result returned by a highlighter,
/// use ``HighlightResult/validateSource(_:)`` to check source identity as well.
/// Ranges may cross grapheme-cluster boundaries as long as they don't split a
/// UTF-16 surrogate pair.
///
/// - Parameters:
///   - tokens: Tokens in ascending, non-overlapping order.
///   - source: The string against which the UTF-16 ranges are validated.
/// - Throws: ``TokenValidationError/invalidRange(index:)`` for the first invalid
///   range, including an empty or overlapping range.
public func validateTokens(_ tokens: [HighlightToken], in source: String) throws {
    let units = source.utf16
    let count = units.count
    var end = 0
    for (index, token) in tokens.enumerated() {
        let range = token.range
        guard range.location != NSNotFound, range.location >= end, range.length > 0,
              range.location <= count, range.length <= count - range.location else {
            throw TokenValidationError.invalidRange(index: index)
        }
        let next = range.location + range.length
        func isScalarBoundary(_ offset: Int) -> Bool {
            guard offset > 0, offset < count else { return true }
            let index = units.index(units.startIndex, offsetBy: offset)
            let previous = units[units.index(before: index)]
            let current = units[index]
            return !(0xD800...0xDBFF).contains(previous) || !(0xDC00...0xDFFF).contains(current)
        }
        guard isScalarBoundary(range.location), isScalarBoundary(next) else {
            throw TokenValidationError.invalidRange(index: index)
        }
        end = next
    }
}
