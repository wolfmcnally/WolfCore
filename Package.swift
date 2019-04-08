// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WolfCore",
    products: [
        .library(
            name: "WolfCore",
            targets: ["WolfCore"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfNesting", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNumerics", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfOSBridge", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/ExtensibleEnumeratedName", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfWith", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfStrings", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "WolfCore",
            dependencies: [
                "WolfNesting",
                "WolfNumerics",
                "WolfOSBridge",
                "WolfPipe",
                "ExtensibleEnumeratedName",
                "WolfWith",
                "WolfStrings",
                "WolfFoundation"
            ])
        ]
)
