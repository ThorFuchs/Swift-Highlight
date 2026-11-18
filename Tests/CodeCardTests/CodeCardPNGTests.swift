#if os(macOS) && canImport(SwiftUI)
import AppKit
import Testing
import SwiftHighlightApple
import SwiftHighlightCodeCard
import SwiftHighlightSwiftUI

@Suite("Code card PNG export")
@MainActor
struct CodeCardPNGTests {
    @Test func exportsTheRequestedPixelWidthAndWrapsLongContent() throws {
        let short = try CodeCardPNGRenderer.render(source: "let x = 1", language: "swift", width: 320, scale: 2)
        let long = try CodeCardPNGRenderer.render(source: String(repeating: "word ", count: 100),
                                                  language: "plaintext", width: 320, scale: 2)
        let unbroken = try CodeCardPNGRenderer.render(source: String(repeating: "x", count: 300),
                                                      language: "plaintext", width: 320, scale: 2)
        let shortImage = try #require(NSBitmapImageRep(data: short))
        let longImage = try #require(NSBitmapImageRep(data: long))
        let unbrokenImage = try #require(NSBitmapImageRep(data: unbroken))
        #expect(short.starts(with: [137, 80, 78, 71, 13, 10, 26, 10]))
        #expect(shortImage.pixelsWide == 640)
        #expect(longImage.pixelsWide == 640)
        #expect(longImage.pixelsHigh > shortImage.pixelsHigh)
        #expect(unbrokenImage.pixelsHigh > shortImage.pixelsHigh)
    }

    @Test func rejectsInvalidDimensionsAndClippedExport() throws {
        #expect(throws: CodeCardPNGRenderer.ExportError.invalidDimensions) {
            try CodeCardPNGRenderer.render(source: "x", language: "plaintext", width: .nan)
        }
        let excessivePadding = try CodeCardOptions(padding: 128)
        #expect(throws: CodeCardPNGRenderer.ExportError.invalidDimensions) {
            try CodeCardPNGRenderer.render(source: "x", language: "plaintext", options: excessivePadding, width: 160)
        }
        let options = try CodeCardOptions(wrapLines: false)
        #expect(throws: CodeCardPNGRenderer.ExportError.wrappingRequired) {
            try CodeCardPNGRenderer.render(source: "x", language: "plaintext", options: options)
        }
    }
}
#endif
