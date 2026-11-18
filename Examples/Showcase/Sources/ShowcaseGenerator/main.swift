import AppKit
import Foundation
import SwiftHighlight
import SwiftHighlightApple

struct Sample {
    let language: String
    let label: String
    let filename: String
    let image: String
}

let samples: [Sample] = [
    .init(language: "swift", label: "SWIFT", filename: "Greeting.swift", image: "swift.png"),
    .init(language: "python", label: "PYTHON", filename: "greetings.py", image: "python.png"),
    .init(language: "typescript", label: "TYPESCRIPT", filename: "greetings.ts", image: "typescript.png"),
    .init(language: "javascript", label: "JAVASCRIPT", filename: "greetings.js", image: "javascript.png"),
    .init(language: "rust", label: "RUST", filename: "greetings.rs", image: "rust.png"),
    .init(language: "go", label: "GO", filename: "greetings.go", image: "go.png"),
    .init(language: "ruby", label: "RUBY", filename: "greetings.rb", image: "ruby.png"),
    .init(language: "sql", label: "SQL", filename: "greetings.sql", image: "sql.png"),
    .init(language: "xml", label: "HTML", filename: "greetings.html", image: "html.png"),
    .init(language: "bash", label: "BASH", filename: "greetings.sh", image: "bash.png"),
]

enum ShowcaseError: Error {
    case usage
    case missingTokens(String)
    case failedToCreateImage(String)
    case codeTooWide(String)
}

func render(_ sample: Sample, source: String, output: URL) throws {
    let result = try Highlighter.shared.highlightStrict(source, as: sample.language)
    guard !result.tokens.isEmpty else { throw ShowcaseError.missingTokens(sample.filename) }

    var theme = HighlightTheme.githubDark
    theme.font = .init(size: 16)
    let code = try result.attributedString(for: source, theme: theme)
    let width: CGFloat = 600
    let inset: CGFloat = 28
    let headerHeight: CGFloat = 54
    let codeWidth = width - 2 * inset
    // Catch overflow rather than silently producing a misleading or clipped image.
    for line in source.split(separator: "\n", omittingEmptySubsequences: false) {
        let lineWidth = (String(line) as NSString).size(withAttributes: [.font: theme.font.resolved()]).width
        guard lineWidth <= codeWidth else { throw ShowcaseError.codeTooWide(sample.filename) }
    }
    let codeHeight = ceil(code.boundingRect(
        with: CGSize(width: codeWidth, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading]
    ).height)
    let size = CGSize(width: width, height: headerHeight + 24 + codeHeight + 28)
    let scale: CGFloat = 2
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: Int(size.width * scale),
        pixelsHigh: Int(ceil(size.height * scale)), bitsPerSample: 8,
        samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
        throw ShowcaseError.failedToCreateImage(sample.filename)
    }
    bitmap.size = size

    NSGraphicsContext.saveGraphicsState()
    defer { NSGraphicsContext.restoreGraphicsState() }
    NSGraphicsContext.current = context
    context.cgContext.scaleBy(x: scale, y: scale)
    theme.backgroundColor.setFill()
    NSRect(origin: .zero, size: size).fill()

    let muted = NSColor(srgbRed: 0.55, green: 0.61, blue: 0.69, alpha: 1)
    let labelColor = NSColor(srgbRed: 0.63, green: 0.72, blue: 0.83, alpha: 1)
    let filename = NSAttributedString(string: sample.filename, attributes: [
        .font: NSFont.monospacedSystemFont(ofSize: 12, weight: .medium),
        .foregroundColor: muted,
    ])
    filename.draw(at: CGPoint(x: inset, y: size.height - 34))
    let label = NSAttributedString(string: sample.label, attributes: [
        .font: NSFont.systemFont(ofSize: 10, weight: .semibold),
        .foregroundColor: labelColor,
        .kern: 1.0,
    ])
    label.draw(at: CGPoint(x: width - inset - label.size().width, y: size.height - 32))
    NSColor(srgbRed: 0.19, green: 0.23, blue: 0.29, alpha: 1).setFill()
    NSRect(x: inset, y: size.height - headerHeight, width: codeWidth, height: 1).fill()
    code.draw(with: NSRect(x: inset, y: 28, width: codeWidth, height: codeHeight),
              options: [.usesLineFragmentOrigin, .usesFontLeading])

    guard let png = bitmap.representation(using: .png, properties: [:]) else {
        throw ShowcaseError.failedToCreateImage(sample.filename)
    }
    try png.write(to: output, options: .atomic)
    print("Rendered \(sample.filename): \(result.tokens.count) tokens → \(output.path)")
}

let arguments = CommandLine.arguments
guard arguments.count == 3 else { throw ShowcaseError.usage }
let sources = URL(fileURLWithPath: arguments[1], isDirectory: true)
let images = URL(fileURLWithPath: arguments[2], isDirectory: true)
try FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
for sample in samples {
    let source = try String(contentsOf: sources.appendingPathComponent(sample.filename), encoding: .utf8)
    try render(sample, source: source, output: images.appendingPathComponent(sample.image))
}
