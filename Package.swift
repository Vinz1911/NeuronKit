// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NeuronKit",
    platforms: [
        .iOS(.v13), .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NeuronKit",
            targets: ["NeuronKit"]),
    ],
    dependencies: [
           .package(url: "https://github.com/pusher/NWWebSocket.git",
                    .upToNextMajor(from: "0.5.3")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NeuronKit",
            dependencies: ["NWWebSocket"]),
        .testTarget(
            name: "NeuronKitTests",
            dependencies: ["NeuronKit"]),
    ]
)
