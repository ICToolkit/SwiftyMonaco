// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyMonaco",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyMonaco",
            targets: ["SwiftyMonaco"]),
        .library(
            name: "SwiftyMonacoDynamic",
            type: .dynamic,
            targets: ["SwiftyMonaco"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyMonaco",
            dependencies: [],
            resources: [
                .process("Resources"), // Fails code signing with .copy for some reason.
            ]),
        .testTarget(
            name: "SwiftyMonacoTests",
            dependencies: ["SwiftyMonaco"]),
    ]
)
