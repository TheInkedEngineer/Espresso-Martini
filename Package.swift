// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "EspressoMartini",
  platforms: [
    .macOS(.v12),
    .iOS(.v13)
  ],
  products: [
    .library(
      name: "EspressoMartini",
      targets: ["EMMockServer"]
    ),
    .executable(
      name: "espressomartini-cli",
      targets: [
        "EspressoMartiniCLI"
      ]
    )
  ],
  dependencies: [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", exact: "4.68.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "EMMockServer",
      dependencies: [
        .target(name: "EMLogger"),
        .product(name: "Vapor", package: "vapor"),
      ]
    ),
    .target(
      name: "EMLogger",
      dependencies: [
        .product(name: "Vapor", package: "vapor")
      ]
    ),
    .executableTarget(
      name: "EspressoMartiniCLI",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .target(name: "EMLogger"),
        .target(name: "EMMockServer")
      ]
    ),
    .testTarget(
      name: "EMMockServerTests",
      dependencies: [
        .target(name: "EMMockServer"),
        .product(name: "XCTVapor", package: "vapor"),
      ],
      resources: [.copy("Resources/")]
    )
  ]
)
