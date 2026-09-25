// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SinopiaCore",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SinopiaCore", targets: ["SinopiaCore"]),
    ],
    targets: [
        .target(name: "SinopiaCore"),
        .testTarget(name: "SinopiaCoreTests", dependencies: ["SinopiaCore"]),
    ]
)
