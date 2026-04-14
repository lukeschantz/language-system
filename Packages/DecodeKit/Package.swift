// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DecodeKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DecodeKit", targets: ["DecodeKit"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "DecodeKit", dependencies: ["SharedModels"]),
        .testTarget(name: "DecodeKitTests", dependencies: ["DecodeKit"]),
    ]
)
