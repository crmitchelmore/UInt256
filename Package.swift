// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "UInt256",
    products: [
        .library(name: "UInt256", targets: ["UInt256"])
    ],
    targets: [
        .target(name: "CUInt256", dependencies: []),
        .target(name: "UInt256", dependencies: ["CUInt256"])
    ]
)
