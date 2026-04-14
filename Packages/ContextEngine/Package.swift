// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ContextEngine",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ContextEngine", targets: ["ContextEngine"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "ContextEngine", dependencies: ["SharedModels"]),
        .testTarget(name: "ContextEngineTests", dependencies: ["ContextEngine"]),
    ]
)
