public import Foundation

/// Invalid token ranges must never be rendered as if they were valid.
public enum TokenValidationError: Error, Sendable, Equatable {
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
        let startIndex = units.index(units.startIndex, offsetBy: range.location)
        let endIndex = units.index(units.startIndex, offsetBy: next)
        guard String.Index(startIndex, within: source) != nil,
              String.Index(endIndex, within: source) != nil else {
            throw TokenValidationError.invalidRange(index: index)
        }
        end = next
    }
}
