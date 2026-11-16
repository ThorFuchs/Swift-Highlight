// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "SwiftHighlight",
    platforms: [.iOS(.v18), .macOS(.v15), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(name: "SwiftHighlight", targets: ["SwiftHighlight"]),
        .library(name: "SwiftHighlightHTML", targets: ["SwiftHighlightHTML"]),
        .library(name: "SwiftHighlightApple", targets: ["SwiftHighlightApple"]),
    ],
    targets: [
        .target(name: "SwiftHighlight", path: "Sources/HighlightKit", exclude: ["Rendering"], swiftSettings: [
            .enableUpcomingFeature("ExistentialAny"), .enableUpcomingFeature("InternalImportsByDefault")]),
        .target(name: "SwiftHighlightHTML", dependencies: ["SwiftHighlight"]),
        .target(name: "SwiftHighlightApple", dependencies: ["SwiftHighlight"], path: "Sources/HighlightKit/Rendering"),
        .testTarget(name: "HighlightKitTests", dependencies: ["SwiftHighlight", "SwiftHighlightApple", "SwiftHighlightHTML"], resources: [.copy("Fixtures")]),
        .executableTarget(name: "highlight-bench", dependencies: ["SwiftHighlight", "SwiftHighlightApple"], path: "Benchmarks/highlight-bench"),
    ]
)
