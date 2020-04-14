// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MMSwiftPackage",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "BannerView",
            targets: ["BannerView"]),
        .library(
        name: "TagView",
        targets: ["TagView"]),
    ],
    dependencies: [
        .package(url: "https://gitee.com/one_half/Kingfisher.git","5.0.0" ..< "6.0.0"),
        .package(url: "https://gitee.com/one_half/SwiftyJSON.git","5.0.0" ..< "6.0.0"),
        .package(url: "https://gitee.com/one_half/SnapKit.git", "5.0.0" ..< "6.0.0"),
        .package(url: "https://gitee.com/one_half/RxSwift.git", "5.0.0" ..< "6.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BannerView",
            dependencies: ["Kingfisher","SwiftyJSON","SnapKit"]),
        .target(
        name: "TagView",
        dependencies: ["RxSwift","SwiftyJSON","SnapKit"]),
    ]
)
