import PackageDescription

let package = Package(
    name: "StencilSwiftKit",
    targets: [
        Target(name: "StencilSwiftKit", dependencies: [])
    ],
    dependencies: [
        // https://github.com/kylef/Stencil/pull/84
        .Package(url: "https://github.com/vknabel/Stencil.git", majorVersion: 0, minor: 7),
        // Requires new release including https://github.com/kylef/PathKit/commit/7b17207
        .Package(url: "https://github.com/vknabel/PathKit.git", majorVersion: 0, minor: 7),
    ]
)
