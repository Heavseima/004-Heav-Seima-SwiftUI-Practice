#!/usr/bin/env bash
set -euo pipefail

# Linux can't import SwiftUI. A temporary package runs the same core sources and tests.
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
test_dir="$(mktemp -d /tmp/mise-tests.XXXXXX)"
trap 'rm -rf "$test_dir"' EXIT
mkdir -p "$test_dir/Sources" "$test_dir/Tests"
cp -R "$project_dir/Sources/RecipeCore" "$test_dir/Sources/"
cp -R "$project_dir/Tests/RecipeCoreTests" "$test_dir/Tests/"
cat > "$test_dir/Package.swift" <<'SWIFT'
// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "MiseCoreTests",
    targets: [
        .target(name: "RecipeCore"),
        .testTarget(name: "RecipeCoreTests", dependencies: ["RecipeCore"])
    ]
)
SWIFT
swift test --package-path "$test_dir" --cache-path "$test_dir/cache"
