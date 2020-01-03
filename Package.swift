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

    dependencies: [
        .package(url: "https://github.com/jrtibbetts/Stylobate.git", from: "0.27.0")
    ],

    targets: [
        .target(
            name: "Medi8",
            path: "Medi8"
        )
    ]
)

