// swift-tools-version:5.3
import PackageDescription

let pkg = Package(
    name: "Medi8",

    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14)
    ],

    products: [
        .library(
            name: "Medi8",
            targets: ["Medi8"]
        )
    ],

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git", .branch("main"))
    ],

    targets: [
        .target(
            name: "Medi8",
            dependencies: ["Stylobate"],
            path: "Medi8",
            resources: [
                .process("Core Data/Medi8.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "Medi8Tests",
            dependencies: ["Medi8"],
            path: "Medi8Tests",
            resources: [
                .copy("Core Data/MockData.json"),
            ]
        )
    ]
)
