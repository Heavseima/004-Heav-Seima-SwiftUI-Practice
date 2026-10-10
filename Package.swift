// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "recipe-app",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "recipe_app",
            targets: ["recipe_app"]
        ),
    ],
    targets: [
        .target(name: "RecipeCore"),
        .target(
            name: "recipe_app",
            dependencies: ["RecipeCore"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "RecipeCoreTests", dependencies: ["RecipeCore"]),
    ]
)
