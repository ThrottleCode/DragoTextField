// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DragoTextField",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DragoTextField",
            targets: ["DragoTextField"]
        ),
    ],
    targets: [
        .target(
            name: "DragoTextField",
            path: "Sources/DragoTextField"
        ),
    ]
)

