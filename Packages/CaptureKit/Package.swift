// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CaptureKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "CaptureKit", targets: ["CaptureKit"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "CaptureKit", dependencies: ["SharedModels"]),
        .testTarget(name: "CaptureKitTests", dependencies: ["CaptureKit"]),
    ]
)
