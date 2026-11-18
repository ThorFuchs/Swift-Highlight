import Foundation
import SwiftHighlightCodeCard
#if os(macOS) && canImport(SwiftUI)
import SwiftHighlightApple
import SwiftHighlightSwiftUI
#endif
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(WASILibc)
import WASILibc
#endif

private struct UsageError: Error, CustomStringConvertible {
    let description: String
    init(_ message: String) { description = message }
}

private struct Arguments {
    var language: String?
    var input: String?
    var output: String?
    var format = "html"
    var theme = CodeCardTheme.githubDark
    var title: String?
    var header = true
    var wrap = true
    var fontSize: Double = 16
    var padding: Double = 24
    var radius: Double = 12
    var width: Double = 720
    var scale: Double = 2
    var pngSizingSpecified = false
    var showHelp = false

    init(_ arguments: [String]) throws {
        var iterator = arguments.makeIterator()
        func value(_ name: String) throws -> String {
            guard let value = iterator.next() else { throw UsageError("Missing value for \(name)") }
            return value
        }
        func number(_ name: String) throws -> Double {
            let raw = try value(name)
            guard let value = Double(raw), value.isFinite else { throw UsageError("Invalid number for \(name): \(raw)") }
            return value
        }
        while let argument = iterator.next() {
            switch argument {
            case "-h", "--help": showHelp = true
            case "-l", "--language": language = try value(argument)
            case "-i", "--input": input = try value(argument)
            case "-o", "--output": output = try value(argument)
            case "-f", "--format": format = try value(argument).lowercased()
            case "--theme":
                let name = try value(argument).lowercased()
                guard let selected = CodeCardTheme(rawValue: name) else { throw UsageError("Unknown theme: \(name)") }
                theme = selected
            case "--title": title = try value(argument)
            case "--no-header": header = false
            case "--no-wrap": wrap = false
            case "--font-size": fontSize = try number(argument)
            case "--padding": padding = try number(argument)
            case "--radius": radius = try number(argument)
            case "--width": width = try number(argument); pngSizingSpecified = true
            case "--scale": scale = try number(argument); pngSizingSpecified = true
            default: throw UsageError("Unknown argument: \(argument)")
            }
        }
    }
}

@main
private enum HighlightCardCLI {
    static let help = """
    Usage: highlight-card --language LANGUAGE [options]

    Reads UTF-8 source from --input FILE or standard input and writes to
    --output FILE or standard output. HTML is portable; PNG requires macOS.

      -l, --language NAME     Explicit registered language (required)
      -i, --input FILE        Source file; '-' means standard input
      -o, --output FILE       Output file; '-' means standard output
      -f, --format FORMAT     html (default) or png (macOS)
          --theme NAME        github-dark (default) or github-light
          --title TEXT        Header title (defaults to language)
          --no-header         Hide the card header
          --no-wrap           Scroll long HTML lines; unavailable for PNG
          --font-size N       8–72 (default: 16)
          --padding N         0–128 (default: 24)
          --radius N          0–128 (default: 12)
          --width N           PNG width in points, 160–4096 (default: 720)
          --scale N           PNG pixels per point, 1–4 (default: 2)
      -h, --help              Show this help
    """

    @MainActor
    static func main() {
        do {
            let arguments = try Arguments(Array(CommandLine.arguments.dropFirst()))
            if arguments.showHelp {
                print(help)
                return
            }
            guard let language = arguments.language, !language.isEmpty else {
                throw UsageError("--language is required")
            }
            guard ["html", "png"].contains(arguments.format) else {
                throw UsageError("--format must be html or png")
            }
            if arguments.format == "html" && arguments.pngSizingSpecified {
                throw UsageError("--width and --scale are only available for PNG output")
            }
            if arguments.format == "png" && !arguments.wrap {
                throw UsageError("PNG requires wrapping; remove --no-wrap to avoid clipping")
            }
            if arguments.format == "png" && (!(160...4096).contains(arguments.width) || !(1...4).contains(arguments.scale)) {
                throw UsageError("PNG width must be 160–4096 and scale must be 1–4")
            }
            let input: Data
            if let path = arguments.input, path != "-" {
                input = try Data(contentsOf: URL(fileURLWithPath: path))
            } else {
                input = FileHandle.standardInput.readDataToEndOfFile()
            }
            guard let source = String(data: input, encoding: .utf8) else {
                throw UsageError("Input must be valid UTF-8")
            }
            let options: CodeCardOptions
            do {
                options = try CodeCardOptions(title: arguments.title, showHeader: arguments.header,
                                              wrapLines: arguments.wrap, fontSize: arguments.fontSize,
                                              padding: arguments.padding, cornerRadius: arguments.radius)
            } catch {
                throw UsageError("Invalid card settings: \(error). See --help for valid ranges.")
            }
            let data: Data
            if arguments.format == "html" {
                data = Data(try HTMLCodeCardRenderer().document(source, language: language,
                                                                theme: arguments.theme, options: options).utf8)
            } else {
                #if os(macOS) && canImport(SwiftUI)
                let theme: HighlightTheme = arguments.theme == .githubDark ? .githubDark : .githubLight
                do {
                    data = try CodeCardPNGRenderer.render(source: source, language: language, theme: theme,
                                                          options: options, width: arguments.width, scale: arguments.scale)
                } catch CodeCardPNGRenderer.ExportError.invalidDimensions {
                    throw UsageError("PNG width leaves too little room for the selected padding and font size")
                }
                #else
                throw UsageError("PNG export requires macOS; use --format html on this platform")
                #endif
            }
            if let path = arguments.output, path != "-" {
                try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            } else {
                try FileHandle.standardOutput.write(contentsOf: data)
            }
        } catch {
            let message = "highlight-card: \(error)\nUse --help for usage.\n"
            FileHandle.standardError.write(Data(message.utf8))
            exit(1)
        }
    }
}
