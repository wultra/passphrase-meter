// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "WultraPassphraseMeter",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "WultraPassphraseMeter", targets: ["WultraPassphraseMeter"]),
        .library(name: "WultraPassphraseMeterCZSKDictionary", targets: ["WultraPassphraseMeterCZSKDictionary"]),
        .library(name: "WultraPassphraseMeterENDictionary", targets: ["WultraPassphraseMeterENDictionary"])
    ],
    targets: [
        .binaryTarget(
            name: "WultraPassphraseMeter",
            url: "%ZIP_URL_WultraPassphraseMeter%",
            checksum: "%ZIP_HASH_WultraPassphraseMeter%"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "%ZIP_URL_WultraPassphraseMeterCZSKDictionary%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterCZSKDictionary%"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "%ZIP_URL_WultraPassphraseMeterENDictionary%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterENDictionary%")
    ],
    swiftLanguageVersions: [.v5]
)