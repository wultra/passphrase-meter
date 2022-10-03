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
        .library(name: "WultraPassphraseMeterENDictionary", targets: ["WultraPassphraseMeterENDictionary"]),
        .library(name: "WultraPassphraseMeterRODictionary", targets: ["WultraPassphraseMeterRODictionary"])
    ],
    targets: [
        .binaryTarget(
            name: "WultraPassphraseMeter",
            url: "%ZIP_URL_WultraPassphraseMeter%",
            checksum: "%ZIP_HASH_WultraPassphraseMeter%"),
        .binaryTarget(
            name: "WultraPassphraseMeterCore",
            url: "%ZIP_URL_WultraPassphraseMeterCore%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterCore%"),
        .binaryTarget(
            name: "WultraPassphraseMeterCZSKDictionary",
            url: "%ZIP_URL_WultraPassphraseMeterCZSKDictionary%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterCZSKDictionary%"),
        .binaryTarget(
            name: "WultraPassphraseMeterENDictionary",
            url: "%ZIP_URL_WultraPassphraseMeterENDictionary%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterENDictionary%"),
        .binaryTarget(
            name: "WultraPassphraseMeterRODictionary",
            url: "%ZIP_URL_WultraPassphraseMeterRODictionary%",
            checksum: "%ZIP_HASH_WultraPassphraseMeterRODictionary%")
    ],
    swiftLanguageVersions: [.v5]
)