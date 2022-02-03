// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "WultraPassphraseMeter",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "WultraPassphraseMeter", targets: ["WultraPassphraseMeter"]),
        .library(name: "WultraPassphraseMeterCore", targets: ["WultraPassphraseMeterCore"]),
        .library(name: "WultraPassphraseMeterCZSKDictionary", targets: ["WultraPassphraseMeterCZSKDictionary"]),
        .library(name: "WultraPassphraseMeterENDictionary", targets: ["WultraPassphraseMeterENDictionary"])
    ],
    targets: [
        .binaryTarget(
            name: "WultraPassphraseMeter",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.2/WultraPassphraseMeter-1.0.2.xcframework.zip",
            checksum: "9181ac95fd718b92cb97d4a2f7efbd86ae83cba4e40d60c080fa120b2f8898a0"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.2/WultraPassphraseMeterCore-1.0.2.xcframework.zip",
            checksum: "3eba1c9c5badec3f6dded4bb2f969035f12794993b4063a5e6be7353217681c0"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.2/WultraPassphraseMeterCZSKDictionary-1.0.2.xcframework.zip",
            checksum: "d678a7ce01ecbb3438eb58481a77e307ddaae409e57a933272efd7aefd5c21eb"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.2/WultraPassphraseMeterENDictionary-1.0.2.xcframework.zip",
            checksum: "d5479ad29c1e2d57f44de4a90355752e460c06bf3860d422a6ef241de596aabd")
    ],
    swiftLanguageVersions: [.v5]
)
