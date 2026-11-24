import Core
import Foundation
import HomeFeature
import Observation
import OnboardingFeature

/// Decides what the app shows: the onboarding flow or the home screen.
@MainActor
@Observable
final class AppModel {
    enum Phase {
        /// Deciding where to start.
        case loading
        case onboarding(OnboardingCoordinatorModel)
        case home(HomeViewModel)
    }

    private(set) var phase: Phase = .loading

    let dependencies: AppDependencies

    @ObservationIgnored private var hasStarted = false
    @ObservationIgnored private var sessionExpiryTask: Task<Void, Never>?

    private static let hasLaunchedKey = "hasLaunchedBefore"

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    /// Called once when the root view appears.
    func start() async {
        guard !hasStarted else {
            return
        }
        hasStarted = true
        observeSessionExpiry()
        await prepareLocalState()

        let progress = await dependencies.onboardingRepository.loadProgress()
        let hasSession = (try? dependencies.tokenStore.load()) != nil

        guard hasSession else {
            // No session: start over, keeping the phone number if the user
            // had already typed it.
            let resumesAtPhone = progress?.step == .phone || progress?.step == .code
            showOnboarding(
                startStep: resumesAtPhone ? .phone : .welcome,
                phone: progress?.phone,
                displayName: nil
            )
            return
        }

        if let progress, progress.step == .completed {
            showHome(displayName: progress.displayName ?? "")
            return
        }
        if let progress, progress.step.requiresSession {
            // Session and an unfinished flow: resume at the saved step.
            showOnboarding(
                startStep: progress.step,
                phone: progress.phone,
                displayName: progress.displayName
            )
            return
        }

        // A session without usable local progress: ask the server.
        await resumeFromServer(phone: progress?.phone)
    }

    // MARK: - Phases

    private func showOnboarding(startStep: OnboardingStep, phone: String?, displayName: String?) {
        let model = OnboardingCoordinatorModel(
            repository: dependencies.onboardingRepository,
            locationProvider: dependencies.locationProvider,
            startStep: startStep,
            prefilledPhone: phone,
            displayName: displayName,
            onCompleted: { [weak self] me in
                self?.showHome(displayName: me.displayName)
            }
        )
        phase = .onboarding(model)
    }

    private func showHome(displayName: String) {
        let viewModel = HomeViewModel(
            displayName: displayName,
            repository: dependencies.homeRepository,
            onLoggedOut: { [weak self] in
                self?.showOnboarding(startStep: .welcome, phone: nil, displayName: nil)
            }
        )
        phase = .home(viewModel)
    }

    private func resumeFromServer(phone: String?) async {
        do {
            let me = try await dependencies.onboardingRepository.currentUser()
            if me.onboardingCompleted {
                await dependencies.onboardingRepository.saveProgress(
                    OnboardingProgress(step: .completed, phone: me.phone, displayName: me.displayName)
                )
                showHome(displayName: me.displayName)
            } else {
                showOnboarding(startStep: .consents, phone: me.phone, displayName: me.displayName)
            }
        } catch {
            let appError = AppError.wrapping(error)
            if appError.code == AppError.Code.unauthorized {
                // The session is gone (refresh rejected or no tokens).
                showOnboarding(startStep: .welcome, phone: phone, displayName: nil)
            } else {
                // Offline or a server problem: continue with the first
                // authenticated step; its request shows the error if needed.
                showOnboarding(startStep: .consents, phone: phone, displayName: nil)
            }
        }
    }

    // MARK: - Session

    /// When a token refresh is rejected the API client clears the session;
    /// the user then returns to Welcome.
    private func observeSessionExpiry() {
        let expirations = dependencies.client.sessionExpired
        sessionExpiryTask = Task { [weak self] in
            for await _ in expirations {
                await self?.sessionExpired()
            }
        }
    }

    private func sessionExpired() async {
        do {
            try await dependencies.progressStore.clear()
        } catch {
            // A stale row is harmless: without a session the app starts over.
        }
        showOnboarding(startStep: .welcome, phone: nil, displayName: nil)
    }

    private func prepareLocalState() async {
        let defaults = UserDefaults.standard

        // Keychain items survive app deletion. On the first launch after an
        // install, remove any session left behind by a previous install.
        if !defaults.bool(forKey: AppModel.hasLaunchedKey) {
            try? dependencies.tokenStore.clear()
            defaults.set(true, forKey: AppModel.hasLaunchedKey)
        }

        if AppConfiguration.shouldResetState {
            try? dependencies.tokenStore.clear()
            do {
                try await dependencies.progressStore.clear()
            } catch {
                // Ignored: only used by UI tests.
            }
        }
    }
}
