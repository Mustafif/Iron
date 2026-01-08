// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Iron",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Iron",
            targets: ["Iron"]
        ),
        .executable(
            name: "IronApp",
            targets: ["IronApp"]
        ),
    ],
    dependencies: [
        // No external dependencies - using only system frameworks
    ],
    targets: [
        .target(
            name: "Iron",
            dependencies: [],
            resources: [
                .process("UI/Metal/Shaders.metal")
            ]
        ),
        .executableTarget(
            name: "IronApp",
            dependencies: ["Iron"]
        ),
        .testTarget(
            name: "IronTests",
            dependencies: ["Iron"]
        ),
    ]
)
