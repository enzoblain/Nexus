// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NexusRust",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NexusRust",
            targets: ["NexusRust"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "NexusRust",
            path: "Frameworks/Nexus.xcframework"
        )
    ]
)
