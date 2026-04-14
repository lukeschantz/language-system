// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MemoryKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MemoryKit", targets: ["MemoryKit"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "MemoryKit", dependencies: ["SharedModels"]),
        .testTarget(name: "MemoryKitTests", dependencies: ["MemoryKit"]),
    ]
)
