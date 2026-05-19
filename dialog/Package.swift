// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CommitDialog",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "CommitDialog", targets: ["CommitDialog"]),
        .library(name: "CommitDialogCore", targets: ["CommitDialogCore"])
    ],
    targets: [
        .executableTarget(
            name: "CommitDialog",
            dependencies: ["CommitDialogCore"],
            path: "Sources/CommitDialog"
        ),
        .target(
            name: "CommitDialogCore",
            path: "Sources/CommitDialogCore"
        ),
        .testTarget(
            name: "CommitDialogCoreTests",
            dependencies: ["CommitDialogCore"],
            path: "Tests/CommitDialogCoreTests"
        )
    ]
)
