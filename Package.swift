// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XboxISOExtractor",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "XboxISOExtractor",
            targets: ["XboxISOExtractor"]
        ),
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .executableTarget(
            name: "XboxISOExtractor",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
    ]
) 