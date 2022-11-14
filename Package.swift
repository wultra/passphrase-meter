// swift-tools-version:5.4

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
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.1.0/WultraPassphraseMeter-1.1.0.xcframework.zip",
            checksum: "bc239a1d8b0b95da318eee8a2a774a99f06f96e64194f3d85103566843262edb"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.1.0/WultraPassphraseMeterCore-1.1.0.xcframework.zip",
            checksum: "d93399b50a7bb98592b0b01ae51fcee50d2661dc112748de8bb18a11441df935"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.1.0/WultraPassphraseMeterCZSKDictionary-1.1.0.xcframework.zip",
            checksum: "f57de3626f8435d74e13ca4a4f04149594249b110f5ff294535f7d15da826e14"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.1.0/WultraPassphraseMeterENDictionary-1.1.0.xcframework.zip",
            checksum: "c75265729b87fd16abd86e952e3e57172e0fb93ff64ab1ee29ceb4f9f76dfe0d"),
        .binaryTarget(
            name: "WultraPassphraseMeterRODictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.1.0/WultraPassphraseMeterRODictionary-1.1.0.xcframework.zip",
            checksum: "c1fe2b505ad364e1df1df9e22156932b9789e44b6287c46b794ba7b3ceb17ae5")
    ],
    swiftLanguageVersions: [.v5]
)
