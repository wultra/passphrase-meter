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
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.3/WultraPassphraseMeter-1.0.3.xcframework.zip",
            checksum: "0020bc99846cfb7aae8bd394b87a469a6fb134742191a89a8e6139fdb0e03c72"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.3/WultraPassphraseMeterCore-1.0.3.xcframework.zip",
            checksum: "b3090a9838c762a0a0455e437a481eaec9f1eaae65058d94fb19e8b476a2bda4"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.3/WultraPassphraseMeterCZSKDictionary-1.0.3.xcframework.zip",
            checksum: "b1d51cc8b280e9f87e236779caf967c80998d57c0d89b0d92224fbc7b4e99d4d"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.0.3/WultraPassphraseMeterENDictionary-1.0.3.xcframework.zip",
            checksum: "cd8d38c2beaa0ea535f4ea89ba64547e68ddb10a17eb3b283d75824c9f8af394")
    ],
    swiftLanguageVersions: [.v5]
)
