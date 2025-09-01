// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "THE-APP",
    platforms: [
        .macOS(.v13),
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "THE-APP",
            targets: ["THE-APP"]
        ),
    ],
    dependencies: [
        // SwiftUI related dependencies
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0"),
        .package(url: "https://github.com/SwiftGen/SwiftGen.git", from: "6.6.0"),

        // Architecture and utilities
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),

        // Testing and development
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.15.0"),
    ],
    targets: [
        .executableTarget(
            name: "THE-APP",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Alamofire",
                "Kingfisher"
            ],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "THE-APPTests",
            dependencies: [
                "THE-APP",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/THE-APPTests"
        ),
        .testTarget(
            name: "THE-APPUITests",
            dependencies: ["THE-APP"],
            path: "Tests/THE-APPUITests"
        ),
    ]
)
