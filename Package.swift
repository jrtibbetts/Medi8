// swift-tools-version:5.0
import PackageDescription

let pkg = Package(
    name: "Medi8",

    platforms: [
        .iOS(.v10)
    ],

    products: [
        .library(
            name: "Medi8",
            targets: ["Medi8"]
        )
    ],

    dependencies: [ ],

    targets: [
        .target(
            name: "Medi8",
            path: "Medi8"
        )
    ]
)

