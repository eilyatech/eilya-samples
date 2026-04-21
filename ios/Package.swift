// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "EilyaSample",
    platforms: [
        .iOS(.v15),
    ],
    dependencies: [
        .package(url: "https://github.com/eilyatech/eilya-otp.git", from: "1.0.0"),
        .package(url: "https://github.com/eilyatech/eilya-chat.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "EilyaSample",
            dependencies: [
                .product(name: "EilyaOTP", package: "eilya-otp"),
                .product(name: "EilyaChat", package: "eilya-chat"),
            ],
            path: "EilyaSample"
        ),
    ]
)
