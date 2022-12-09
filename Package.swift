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
      )
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.68.0"),
    ],
    targets: [
        .target(
            name: "EMMockServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(
          name: "Run",
          dependencies: [.target(name: "EMMockServer")],
          resources: [.copy("Resources/")]
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
