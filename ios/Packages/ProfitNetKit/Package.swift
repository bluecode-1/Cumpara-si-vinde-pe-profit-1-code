// swift-tools-version: 5.9
import PackageDescription

// ProfitNetKit: one target per module. Module boundaries are enforced by the
// compiler; only modules needed by the onboarding step exist so far.
//
// Naming notes:
// - The keychain module is called `SecureStorage` (not `Security`) because a
//   target named `Security` would shadow Apple's Security framework.
// - `FakeAPI` contains the demo-mode API. Its sources are wrapped in
//   `#if DEBUG`, so no fake code is compiled into release builds.
let package = Package(
    name: "ProfitNetKit",
    defaultLocalization: "ro",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ProfitNetKit",
            targets: [
                "Core",
                "Networking",
                "SecureStorage",
                "Persistence",
                "DesignSystem",
                "FakeAPI",
                "OnboardingFeature",
                "HomeFeature",
            ]
        ),
    ],
    targets: [
        .target(name: "Core"),
        .target(name: "Networking", dependencies: ["Core"]),
        .target(name: "SecureStorage", dependencies: ["Core", "Networking"]),
        .target(name: "Persistence", dependencies: ["Core"]),
        .target(
            name: "DesignSystem",
            resources: [.process("Resources/Fonts")]
        ),
        .target(
            name: "FakeAPI",
            resources: [.copy("Fixtures")]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: ["Core", "Networking", "Persistence", "DesignSystem"]
        ),
        .target(
            name: "HomeFeature",
            dependencies: ["Core", "Networking", "Persistence", "DesignSystem"]
        ),

        .testTarget(name: "CoreTests", dependencies: ["Core"]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Core", "Networking"],
            resources: [.copy("Fixtures")]
        ),
        .testTarget(name: "SecureStorageTests", dependencies: ["Core", "SecureStorage"]),
        .testTarget(name: "PersistenceTests", dependencies: ["Core", "Persistence"]),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            resources: [.copy("Tokens")]
        ),
        .testTarget(name: "FakeAPITests", dependencies: ["FakeAPI"]),
        .testTarget(
            name: "OnboardingFeatureTests",
            dependencies: ["Core", "DesignSystem", "OnboardingFeature"]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["Core", "HomeFeature"]
        ),
    ]
)
