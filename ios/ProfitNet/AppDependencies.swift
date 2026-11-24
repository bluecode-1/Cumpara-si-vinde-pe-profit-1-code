import Core
import FakeAPI
import Foundation
import HomeFeature
import Networking
import OnboardingFeature
import Persistence
import SecureStorage
import SwiftData

/// The composition root: every long-lived object of the app, created once.
@MainActor
struct AppDependencies {
    let modelContainer: ModelContainer
    let tokenStore: TokenStore
    let client: APIClient
    let progressStore: OnboardingProgressStore
    let onboardingRepository: OnboardingRepository
    let homeRepository: HomeRepository
    let locationProvider: LocationProviding

    static func live() -> AppDependencies {
        let modelContainer = makeModelContainer()
        let tokenStore = KeychainTokenStore()
        let client = APIClient(
            baseURL: AppConfiguration.apiBaseURL,
            session: makeURLSession(),
            tokenStore: tokenStore
        )
        let progressStore = OnboardingProgressStore(modelContainer: modelContainer)

        return AppDependencies(
            modelContainer: modelContainer,
            tokenStore: tokenStore,
            client: client,
            progressStore: progressStore,
            onboardingRepository: DefaultOnboardingRepository(
                client: client,
                tokenStore: tokenStore,
                progressStore: progressStore
            ),
            homeRepository: DefaultHomeRepository(
                client: client,
                tokenStore: tokenStore,
                progressStore: progressStore
            ),
            locationProvider: CoreLocationProvider()
        )
    }

    private static func makeModelContainer() -> ModelContainer {
        do {
            return try PersistenceContainer.make()
        } catch {
            // The on-disk store could not be opened. The app still works with
            // an in-memory store; only resuming the flow after a kill is lost.
            do {
                return try PersistenceContainer.make(inMemory: true)
            } catch {
                fatalError("Could not create a ModelContainer: \(error)")
            }
        }
    }

    private static func makeURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        #if DEBUG
        if AppConfiguration.isFakeAPIEnabled {
            DemoAPI.install(in: configuration)
        }
        #endif

        // Public-key pinning: the mechanism is in place but the pin set is
        // empty (disabled) until the production domain exists.
        let delegate = PinningDelegate(pinnedKeyHashes: AppConfiguration.pinnedKeyHashes)
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
}

/// Build- and launch-time configuration.
enum AppConfiguration {
    /// The API base URL from Info.plist (`APIBaseURL`, set per build
    /// configuration in project.yml).
    static var apiBaseURL: URL {
        if let text = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
           let url = URL(string: text),
           url.scheme != nil {
            return url
        }
        // The literal is a valid URL, so the fallback below cannot fail.
        return URL(string: "https://api.profitnet.example/v1") ?? URL(fileURLWithPath: "/")
    }

    /// Base64 SHA-256 public-key pins. Empty = pinning disabled.
    static let pinnedKeyHashes: Set<String> = []

    /// Demo mode (debug builds only): `-FAKE_API 1` or `FAKE_API=1`.
    static var isFakeAPIEnabled: Bool {
        #if DEBUG
        return DemoAPI.isRequested()
        #else
        return false
        #endif
    }

    /// UI tests (debug builds only): `-RESET_STATE 1` deletes the session
    /// and the saved onboarding progress at launch.
    static var shouldResetState: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-RESET_STATE")
        #else
        return false
        #endif
    }
}
