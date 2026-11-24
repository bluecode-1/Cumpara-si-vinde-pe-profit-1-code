# ProfitNet for iOS

Native iOS app (Swift, SwiftUI, iOS 17+). This step contains the foundation
(networking, session, storage, theme) and the onboarding flow described in
[`docs/06-flux-onboarding.md`](../docs/06-flux-onboarding.md).

## Layout

```
ios/
├── project.yml                  # XcodeGen description of ProfitNet.xcodeproj (the project is generated, not committed)
├── ProfitNet/                   # thin app target: composition root, RootView, Info.plist, string catalogs
├── ProfitNetUITests/            # XCUITest, runs against the demo API
├── Packages/ProfitNetKit/       # local Swift package, one target per module
│   ├── Sources/
│   │   ├── Core/                # AppError, Money, GeoPoint, models, validators (Foundation only)
│   │   ├── Networking/          # APIClient, Endpoint, token refresh actor, PinningDelegate, TokenStore
│   │   ├── SecureStorage/       # KeychainTokenStore
│   │   ├── Persistence/         # SwiftData model + store for the onboarding progress
│   │   ├── DesignSystem/        # Livadă colours, Manrope, text styles, buttons, fields, L10n keys
│   │   ├── FakeAPI/             # demo API (URLProtocol), compiled only in DEBUG
│   │   ├── OnboardingFeature/   # Domain/ Data/ UI/ for the seven onboarding steps
│   │   └── HomeFeature/         # provisional home screen (greeting + logout)
│   └── Tests/                   # XCTest per module
├── Scripts/sync-fixtures.sh     # copies api/fixtures, design/fonts and design/tokens.json into the package
└── ci/ios.yml                   # suggested GitHub Actions workflow (move to .github/workflows/)
```

Dependencies between modules (enforced by the compiler):

```
Core ◄── Networking ◄── SecureStorage
Core ◄── Persistence
DesignSystem, FakeAPI            (no dependencies)
OnboardingFeature, HomeFeature ──► Core, Networking, Persistence, DesignSystem
```

There are no third-party dependencies.

## Requirements

- Xcode 15.3 or newer (Swift 5.9+, iOS 17 SDK)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Generate the project and run

```sh
cd ios
brew install xcodegen
xcodegen generate
open ProfitNet.xcodeproj
```

Select the `ProfitNet` scheme and an iOS 17+ simulator, then Run.

Run `xcodegen generate` again whenever `project.yml` changes or files are
added to or removed from `ProfitNet/` or `ProfitNetUITests/`. Files inside the
package are picked up automatically.

## Demo mode (fake API)

The backend does not exist yet. In **debug builds** the app can answer every
request in-process from the files in `api/fixtures`:

- enable with the launch argument `-FAKE_API 1` or the environment variable
  `FAKE_API=1` (the generated `ProfitNet` scheme passes `-FAKE_API 1` on Run);
- any valid phone number receives a code; the code `123456` signs in, any
  other code returns `OTP_INVALID`;
- `PATCH /me` and `PUT /me/consents` keep their changes in memory until the
  app process ends.

`-RESET_STATE 1` (debug builds only) deletes the stored session and the saved
onboarding progress at launch; the UI tests use it.

The fake API sources are wrapped in `#if DEBUG`, and a build phase removes the
fixture bundle from Release builds, so nothing of the demo mode ships. Without
`-FAKE_API` the app talks to the base URL from the `API_BASE_URL` build setting
in `project.yml` (placeholder hosts for now).

## Shared files

`api/fixtures/*.json`, `design/fonts/*` and `design/tokens.json` are the source
of truth for all three platforms. The package needs copies of them as
resources:

```sh
ios/Scripts/sync-fixtures.sh          # copy
ios/Scripts/sync-fixtures.sh --check  # verify the copies are up to date (CI)
```

Run the script after changing any of those files and commit the result.

## Tests

The package declares iOS as its only platform, so `swift test` (which builds
for macOS) does **not** work. Use `xcodebuild` with a simulator:

```sh
# Unit tests of all modules
cd ios/Packages/ProfitNetKit
xcodebuild -list                       # shows the scheme name: ProfitNetKit or ProfitNetKit-Package
xcodebuild test -scheme ProfitNetKit \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'

# App build + UI tests
cd ios
xcodegen generate
xcodebuild test -project ProfitNet.xcodeproj -scheme ProfitNet \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'
```

In Xcode: open `Packages/ProfitNetKit/Package.swift` to run the unit tests, or
the generated project to run the UI tests.

What is covered:

| Target | Tests |
|---|---|
| `CoreTests` | phone normalisation (accepted and rejected forms), display name and code validation, coordinate rounding, city list |
| `NetworkingTests` | contract tests decoding every onboarding fixture, request bodies, `problem+json` mapping, token refresh (401 → refresh → one retry, concurrent 401s refresh once, rejected refresh clears the session) |
| `SecureStorageTests` | keychain round trip (skipped when the test process has no keychain access) |
| `PersistenceTests` | onboarding progress store on an in-memory container |
| `DesignSystemTests` | palette, type scale and spacing match `design/tokens.json`; Manrope registration |
| `FakeAPITests` | the demo-mode rules |
| `OnboardingFeatureTests` | view models of every step and the coordinator, with a fake repository |
| `HomeFeatureTests` | home view model |
| `ProfitNetUITests` | onboarding happy path, wrong code, invalid phone (demo API) |

## Conventions

- View models are `@Observable` classes on `@MainActor` with an immutable-style
  state `struct`; views never talk to repositories directly.
- Navigation uses `NavigationStack` with the typed `OnboardingRoute` enum.
- All user-facing text comes from `ProfitNet/Resources/Localizable.xcstrings`
  (Romanian source, English translation) through `L10nKey` / `L10n` in
  `DesignSystem`. The keys are the cross-platform keys from the specification.
  Because the catalog lives in the app target, package unit tests see the keys,
  not the texts; view models therefore expose keys.
- Errors are `AppError(code, status)`; the message is chosen from `code`, the
  server's `detail` is never shown.
- Colours and type sizes are defined once in `DesignSystem` and verified against
  `design/tokens.json` by a unit test. Fonts scale with Dynamic Type.
- Certificate pinning: `PinningDelegate` is installed on the URL session with an
  empty pin set (disabled). Add pins in `AppConfiguration.pinnedKeyHashes` when
  the production domain exists.
