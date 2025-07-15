// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "WultraPassphraseMeter",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "WultraPassphraseMeter", targets: ["WultraPassphraseMeter"]),
        .library(name: "WultraPassphraseMeterCore", targets: ["WultraPassphraseMeterCore"]),
        .library(name: "WultraPassphraseMeterCZSKDictionary", targets: ["WultraPassphraseMeterCZSKDictionary"]),
        .library(name: "WultraPassphraseMeterENDictionary", targets: ["WultraPassphraseMeterENDictionary"]),
        .library(name: "WultraPassphraseMeterRODictionary", targets: ["WultraPassphraseMeterRODictionary"])
    ],
    targets: [
        .binaryTarget(
            name: "WultraPassphraseMeter",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.3.0/WultraPassphraseMeter-1.3.0.xcframework.zip",
            checksum: "6e586de965b3e03f234dd056de5b2b71bec3da093e2fb2dd73b61c7470a35474"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.3.0/WultraPassphraseMeterCore-1.3.0.xcframework.zip",
            checksum: "6b831a8bdd4ff745e5b85d9a7261c93a4b22f604c4cac406039d57fc23d2f315"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.3.0/WultraPassphraseMeterCZSKDictionary-1.3.0.xcframework.zip",
            checksum: "5d4b6241dcb1575131845db7b4b72c56a5430528e3d2f85b109b3de6b6149047"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.3.0/WultraPassphraseMeterENDictionary-1.3.0.xcframework.zip",
            checksum: "3028da6f1244b3024b372bdc0d1638feec7ab6493281a35205a1221fc7b9d401"),
        .binaryTarget(
            name: "WultraPassphraseMeterRODictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.3.0/WultraPassphraseMeterRODictionary-1.3.0.xcframework.zip",
            checksum: "8eb2e7017dd91385234461ea4b9a5d3a1ac3fb1b447351903a9e7dd990727e79")
    ],
    swiftLanguageVersions: [.v5]
)
