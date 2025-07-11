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
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.2.0/WultraPassphraseMeter-1.2.0.xcframework.zip",
            checksum: "7c4aaa1f669aa254448e2aa461f5b2af653ce207dcef1b155dbfeb62a5855bc7"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.2.0/WultraPassphraseMeterCore-1.2.0.xcframework.zip",
            checksum: "113184771fae724761ce69493427b18a5d512f8dbc2a8f7676d16ebdbd40d26e"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.2.0/WultraPassphraseMeterCZSKDictionary-1.2.0.xcframework.zip",
            checksum: "c408ee45322d1defe5818c15806683ba29c9e4e1cf423a35663596e65bf4fc6b"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.2.0/WultraPassphraseMeterENDictionary-1.2.0.xcframework.zip",
            checksum: "d24cb28a116e5af136fbfa3b44c86f94d4dcbbe2d36081a56b01b78286cd3f01"),
        .binaryTarget(
            name: "WultraPassphraseMeterRODictionary",
            url: "https://github.com/wultra/passphrase-meter/releases/download/1.2.0/WultraPassphraseMeterRODictionary-1.2.0.xcframework.zip",
            checksum: "8d4d34db6ef441a0f199c4958b44d8ca736047366f3ec6fbc64bb661e631218a")
    ],
    swiftLanguageVersions: [.v5]
)
