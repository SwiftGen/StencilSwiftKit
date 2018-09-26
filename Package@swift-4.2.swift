// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "StencilSwiftKit",
  products: [
      .library(name: "StencilSwiftKit", targets: ["StencilSwiftKit"])
  ],
  dependencies: [
      .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMinor(from: "0.13.0"))
  ],
  targets: [
    .target(
      name: "StencilSwiftKit",
      dependencies: [
        "Stencil"
      ]
    ),
    .testTarget(
      name: "StencilSwiftKitTests",
      dependencies: [
        "StencilSwiftKit"
      ]
    )
  ],
  swiftLanguageVersions: [.v4, .v4_2]
)
