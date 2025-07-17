// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MyModule",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MyModule",
            targets: ["MyModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-saanalytics.git", exact: "1.0.0"),
        .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-sanetwork.git", exact: "1.1.5"),
        .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-sacordinator.git", from: "2.2.8"),
        .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-saworkspace.git", from: "1.5.4")
    ],
    targets: [
        .target(
            name: "MyModule",
            dependencies: [
                .product(name: "SAAnalytics", package: "org-ml1-dep-ios-saanalytics"),
                .product(name: "SANetwork", package:  "org-ml1-dep-ios-sanetwork"),
                .product(name: "SACoordinator", package: "org-ml1-dep-ios-sacordinator"),
                .product(name: "SAWorkspace", package: "org-ml1-dep-ios-saworkspace")
            ],
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ],
    .testTargets(
        name: "MyModuleTests",
        dependencies: [
            .target(name: "MyModule")
        ],
        resources: [
            .process("TestResources")
        ]
    ),
)
