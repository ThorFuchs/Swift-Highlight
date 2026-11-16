internal import Foundation

/// Invalid token ranges must never be rendered as if they were valid.
public enum TokenValidationError: Error, Sendable, Equatable {
    case sourceMismatch
    case invalidRange(index: Int)
}

/// Checks ordering, bounds and UTF-16 scalar boundaries against the supplied text.
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
