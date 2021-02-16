// swift-tools-version:5.3
import PackageDescription

let pkg = Package(
    name: "Medi8",

    platforms: [
        .iOS(.v14),
        .macOS(.v10_14),
        .tvOS(.v14)
    ],

    products: [
        .library(
            name: "Medi8",
            targets: ["Medi8"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git", .upToNextMajor(from: "0.33.1"))
    ],

    targets: [
        .target(
            name: "Medi8",
            dependencies: ["Stylobate"],
            path: "Sources",
            exclude: ["Info.plist"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "Medi8Tests",
            dependencies: ["Medi8"],
            path: "Tests",
            exclude: ["Info.plist"]
        )
    ]
)
