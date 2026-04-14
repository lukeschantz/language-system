// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DisplayKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DisplayKit", targets: ["DisplayKit"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "DisplayKit", dependencies: ["SharedModels"]),
        .testTarget(name: "DisplayKitTests", dependencies: ["DisplayKit"]),
    ]
)
