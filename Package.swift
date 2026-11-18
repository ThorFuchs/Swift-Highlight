// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "SwiftHighlight",
    platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(name: "SwiftHighlight", targets: ["SwiftHighlight"]),
        .library(name: "SwiftHighlightHTML", targets: ["SwiftHighlightHTML"]),
        .library(name: "SwiftHighlightApple", targets: ["SwiftHighlightApple"]),
        .library(name: "SwiftHighlightCodeCard", targets: ["SwiftHighlightCodeCard"]),
        .library(name: "SwiftHighlightSwiftUI", targets: ["SwiftHighlightSwiftUI"]),
        .executable(name: "highlight-card", targets: ["highlight-card"]),
    ],
    targets: [
        .target(name: "SwiftHighlight", path: "Sources/HighlightKit", exclude: ["Rendering"], swiftSettings: [
            .enableUpcomingFeature("ExistentialAny"), .enableUpcomingFeature("InternalImportsByDefault")]),
        .target(name: "SwiftHighlightHTML", dependencies: ["SwiftHighlight"]),
        .target(name: "SwiftHighlightApple", dependencies: ["SwiftHighlight"], path: "Sources/HighlightKit/Rendering"),
        .target(name: "SwiftHighlightCodeCard", dependencies: ["SwiftHighlight", "SwiftHighlightHTML"]),
        .target(name: "SwiftHighlightSwiftUI", dependencies: ["SwiftHighlight", "SwiftHighlightApple", "SwiftHighlightCodeCard"]),
        .executableTarget(name: "highlight-card", dependencies: [
            "SwiftHighlight", "SwiftHighlightCodeCard",
            .target(name: "SwiftHighlightSwiftUI", condition: .when(platforms: [.macOS])),
        ]),
        .testTarget(name: "CodeCardTests", dependencies: ["SwiftHighlight", "SwiftHighlightCodeCard", "SwiftHighlightSwiftUI"]),
        .testTarget(name: "HighlightKitTests", dependencies: ["SwiftHighlight", "SwiftHighlightApple", "SwiftHighlightHTML"], resources: [.copy("Fixtures")]),
        .executableTarget(name: "highlight-bench", dependencies: ["SwiftHighlight", "SwiftHighlightApple"], path: "Benchmarks/highlight-bench"),
    ]
)
