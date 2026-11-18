// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "ShowcaseGenerator",
    platforms: [.macOS(.v15)],
    dependencies: [.package(name: "SwiftHighlightLocal", path: "../..")],
    targets: [
        .executableTarget(
            name: "ShowcaseGenerator",
            dependencies: [
                .product(name: "SwiftHighlight", package: "SwiftHighlightLocal"),
                .product(name: "SwiftHighlightApple", package: "SwiftHighlightLocal"),
            ]
        ),
    ]
)
