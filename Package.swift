import PackageDescription

let package = Package(
    name: "StencilSwiftKit",
    targets: [
        Target(name: "StencilSwiftKit", dependencies: [])
    ],
    dependencies: [
        .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 9),
    ]
)
