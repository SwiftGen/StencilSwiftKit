// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "StencilSwiftKit",
  products: [
    .library(name: "StencilSwiftKit", targets: ["StencilSwiftKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMajor(from: "0.14.0"))
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
  swiftLanguageVersions: [.v5]
)
