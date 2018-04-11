// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "StencilSwiftKit",
    products: [
        .library(name: "StencilSwiftKit", targets: ["StencilSwiftKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Stencil.git", .upToNextMinor(from: "0.11.0"))
    ],
    targets: [
      .target(
        name: "StencilSwiftKit",
        dependencies: [
          "Stencil"
        ],
        path: "",
        sources: ["Sources"]
      ),
      .testTarget(
        name: "StencilSwiftKitTests",
        dependencies: [
          "StencilSwiftKit"
        ],
        path: "Tests"
      )
    ],
    swiftLanguageVersions: [4]
)
