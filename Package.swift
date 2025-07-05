// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FormatterKit",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "FormatterKit",
            targets: ["FormatterKit"]
        )
    ],
    targets: [
        .target(
            name: "FormatterKit",
            path: "FormatterKit",
            exclude: [
                "Info.plist", 
                "include",
                "FormatterKit.bundle"
            ],
            sources: [
                "TTTAddressFormatter.m",
                "TTTArrayFormatter.m", 
                "TTTColorFormatter.m",
                "TTTLocationFormatter.m",
                "TTTNameFormatter.m",
                "TTTOrdinalNumberFormatter.m",
                "TTTTimeIntervalFormatter.m",
                "TTTUnitOfInformationFormatter.m",
                "TTTURLRequestFormatter.m",
                "NSBundle+FormatterKit.m",
                "TTTAddressFormatter.h",
                "TTTArrayFormatter.h", 
                "TTTColorFormatter.h",
                "TTTLocationFormatter.h",
                "TTTNameFormatter.h",
                "TTTOrdinalNumberFormatter.h",
                "TTTTimeIntervalFormatter.h",
                "TTTUnitOfInformationFormatter.h",
                "TTTURLRequestFormatter.h",
                "NSBundle+FormatterKit.h"
            ],
            resources: [
                .process("FormatterKit.bundle")
            ],
            cSettings: [
                .headerSearchPath(".")
            ],
            linkerSettings: [
                .linkedFramework("AddressBook", .when(platforms: [.iOS, .macOS])),
                .linkedFramework("AddressBookUI", .when(platforms: [.iOS])),
                .linkedFramework("CoreLocation")
            ]
        )
    ]
)
