// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "WASISmoke",
    dependencies: [.package(name: "SwiftHighlightLocal", path: "../..")],
    targets: [
        .executableTarget(name: "WASISmoke", dependencies: [
            .product(name: "SwiftHighlight", package: "SwiftHighlightLocal"),
            .product(name: "SwiftHighlightHTML", package: "SwiftHighlightLocal"),
            .product(name: "SwiftHighlightCodeCard", package: "SwiftHighlightLocal"),
        ]),
    ]
)
