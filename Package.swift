// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "EspressoMartini",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "MockServer",
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
          dependencies: [.target(name: "MockServer")],
          resources: [.copy("file.json")]
        ),
        .testTarget(name: "MockServerTests", dependencies: [
            .target(name: "MockServer"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
