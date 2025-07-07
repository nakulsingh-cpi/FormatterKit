// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FormatterKit",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "FormatterKit",
            targets: ["FormatterKit"]
        ),
    ],
    targets: [
        .target(
            name: "FormatterKit",
            path: "Sources/FormatterKit",
            exclude: ["include/Info.plist"],
            resources: [
                .copy("include/FormatterKit.bundle")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
                .define("SWIFT_PACKAGE")
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("AddressBook", .when(platforms: [.iOS, .macOS])),
                .linkedFramework("AddressBookUI", .when(platforms: [.iOS])),
                .linkedFramework("CoreLocation")
            ]
        ),
    ]
)
