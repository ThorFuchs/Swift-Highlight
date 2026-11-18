#if os(macOS) && canImport(SwiftUI)
import AppKit
import SwiftUI
import SwiftHighlightApple
import SwiftHighlightCodeCard

/// Exports the SwiftUI card as PNG data on macOS.
@MainActor
public enum CodeCardPNGRenderer {
    /// A card cannot be exported with the supplied dimensions or content.
    public enum ExportError: Error, Sendable, Equatable {
        /// Width or scale is outside its supported range, or padding leaves
        /// insufficient room to display the configured font.
        case invalidDimensions
        /// Non-wrapping code may be clipped by an image's fixed viewport.
        case wrappingRequired
        /// SwiftUI could not produce a PNG image.
        case imageUnavailable
    }

    /// Highlights source and exports a card as a PNG image.
    ///
    /// - Parameters:
    ///   - source: Source code to display.
    ///   - language: A registered language name or alias.
    ///   - theme: A built-in or custom Apple highlight theme.
    ///   - options: Card presentation; wrapping must be enabled for export.
    ///   - width: Card width in points, from 160 through 4096.
    ///   - scale: Pixels per point, from 1 through 4.
    /// - Returns: PNG-encoded image data.
    /// - Throws: ``ExportError`` or a strict highlighting error.
    public static func render(source: String, language: String, theme: HighlightTheme = .githubDark,
                              options: CodeCardOptions = .default, width: Double = 720,
                              scale: Double = 2) throws -> Data {
        guard width.isFinite, scale.isFinite, (160...4096).contains(width), (1...4).contains(scale) else {
            throw ExportError.invalidDimensions
        }
        guard width - 2 * options.padding >= max(24, options.fontSize * 1.5) else {
            throw ExportError.invalidDimensions
        }
        guard options.wrapLines else { throw ExportError.wrappingRequired }
        let view = try CodeCardView(source: source, language: language, theme: theme, options: options)
        let renderer = ImageRenderer(content: view.frame(width: width))
        renderer.scale = scale
        renderer.proposedSize = ProposedViewSize(width: width, height: nil)
        guard let image = renderer.nsImage,
              let tiff = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let data = bitmap.representation(using: .png, properties: [:]) else {
            throw ExportError.imageUnavailable
        }
        return data
    }
}
#endif
