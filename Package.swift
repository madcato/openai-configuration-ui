// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "openai-configuration-ui",
    platforms: [
       .iOS(.v14),
       .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OpenAIConfigurationUI",
            targets: ["OpenAIConfigurationUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MacPaw/OpenAI.git", branch: "main"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targedepend on other targets in this package and products from dependencies.
        .target(
            name: "OpenAIConfigurationUI",
            dependencies: [
              .product(name: "OpenAI", package: "OpenAI"),
              .product(name: "KeychainSwift", package: "keychain-swift"),
            ]
          ),
        .testTarget(
            name: "OpenAIConfigurationUITests",
            dependencies: ["OpenAIConfigurationUI"]
        ),
    ]
)
