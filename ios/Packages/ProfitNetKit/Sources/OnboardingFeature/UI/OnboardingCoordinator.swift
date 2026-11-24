import Core
import DesignSystem
import Foundation
import Observation
import SwiftUI

/// The screens of the onboarding flow as navigation routes.
public enum OnboardingRoute: Hashable, Sendable {
    case welcome
    case phone
    case code
    case consents
    case name
    case location
    case interests
}

/// Owns the navigation state and the view models of the onboarding flow and
/// saves the current step so the flow can be resumed after the app is killed.
@MainActor
@Observable
public final class OnboardingCoordinatorModel {
    /// The screen at the bottom of the stack. It changes to `.consents` after
    /// verification so that "back" never returns to the phone or code step.
    public private(set) var root: OnboardingRoute
    /// The screens pushed on top of `root`.
    public var path: [OnboardingRoute] = []

    let phoneViewModel: PhoneViewModel
    let consentsViewModel: ConsentsViewModel
    let nameViewModel: NameViewModel
    let locationViewModel: LocationViewModel
    let interestsViewModel: InterestsViewModel
    private(set) var codeViewModel: CodeViewModel? = nil

    private let repository: OnboardingRepository
    private let onCompleted: (Me) -> Void
    @ObservationIgnored private var phone: String?
    @ObservationIgnored private var displayName: String?

    /// - Parameters:
    ///   - startStep: Where to start. `.code` starts at the phone step (a
    ///     code challenge is not resumed) and `.completed` at Welcome.
    ///   - prefilledPhone: E.164 number entered in an earlier run, if any.
    ///   - onCompleted: Called when the user is done: after the interests
    ///     step, or right after verification for an already onboarded user.
    public init(
        repository: OnboardingRepository,
        locationProvider: LocationProviding,
        startStep: OnboardingStep = .welcome,
        prefilledPhone: String? = nil,
        displayName: String? = nil,
        onCompleted: @escaping (Me) -> Void
    ) {
        self.repository = repository
        self.onCompleted = onCompleted
        self.phone = prefilledPhone
        self.displayName = displayName
        self.root = OnboardingCoordinatorModel.route(for: startStep)

        self.phoneViewModel = PhoneViewModel(repository: repository, prefilledPhone: prefilledPhone)
        self.consentsViewModel = ConsentsViewModel(repository: repository)
        self.nameViewModel = NameViewModel(repository: repository, initialName: displayName)
        self.locationViewModel = LocationViewModel(
            repository: repository,
            locationProvider: locationProvider
        )
        self.interestsViewModel = InterestsViewModel(repository: repository)

        phoneViewModel.onCodeRequested = { [weak self] phone, challenge in
            self?.codeRequested(phone: phone, challenge: challenge)
        }
        consentsViewModel.onSaved = { [weak self] in
            self?.advance(to: .name)
        }
        nameViewModel.onSaved = { [weak self] me in
            self?.displayName = me.displayName
            self?.advance(to: .location)
        }
        locationViewModel.onSaved = { [weak self] _ in
            self?.advance(to: .interests)
        }
        interestsViewModel.onCompleted = { [weak self] me in
            self?.finish(with: me)
        }
    }

    /// "Start" on the Welcome screen.
    func start() {
        path.append(.phone)
        persist(step: .phone)
    }

    // MARK: - Transitions

    private func codeRequested(phone: String, challenge: OTPChallenge) {
        self.phone = phone
        let viewModel = CodeViewModel(phone: phone, challenge: challenge, repository: repository)
        viewModel.onVerified = { [weak self] me in
            self?.verified(me)
        }
        codeViewModel = viewModel
        path.append(.code)
        persist(step: .code)
    }

    private func verified(_ me: Me) {
        if me.onboardingCompleted {
            finish(with: me)
            return
        }
        if !me.displayName.isEmpty {
            displayName = me.displayName
            nameViewModel.state.name = me.displayName
        }
        // Replace the whole stack: the pre-authentication screens are gone.
        root = .consents
        path = []
        codeViewModel = nil
        persist(step: .consents)
    }

    private func advance(to route: OnboardingRoute) {
        path.append(route)
        persist(step: OnboardingCoordinatorModel.step(for: route))
    }

    private func finish(with me: Me) {
        displayName = me.displayName
        let progress = OnboardingProgress(step: .completed, phone: me.phone, displayName: me.displayName)
        Task {
            // Save first so that a relaunch goes straight to the home screen.
            await self.repository.saveProgress(progress)
            self.onCompleted(me)
        }
    }

    private func persist(step: OnboardingStep) {
        let progress = OnboardingProgress(step: step, phone: phone, displayName: displayName)
        Task {
            await self.repository.saveProgress(progress)
        }
    }

    // MARK: - Mapping

    static func route(for step: OnboardingStep) -> OnboardingRoute {
        switch step {
        case .welcome, .completed:
            return .welcome
        case .phone, .code:
            return .phone
        case .consents:
            return .consents
        case .name:
            return .name
        case .location:
            return .location
        case .interests:
            return .interests
        }
    }

    static func step(for route: OnboardingRoute) -> OnboardingStep {
        switch route {
        case .welcome:
            return .welcome
        case .phone:
            return .phone
        case .code:
            return .code
        case .consents:
            return .consents
        case .name:
            return .name
        case .location:
            return .location
        case .interests:
            return .interests
        }
    }
}

/// The onboarding flow: a `NavigationStack` driven by `OnboardingRoute`.
@MainActor
public struct OnboardingCoordinatorView: View {
    @Bindable private var model: OnboardingCoordinatorModel

    public init(model: OnboardingCoordinatorModel) {
        self._model = Bindable(wrappedValue: model)
    }

    public var body: some View {
        NavigationStack(path: $model.path) {
            screen(for: model.root)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    screen(for: route)
                }
        }
        .tint(PNColors.primary)
    }

    @ViewBuilder
    private func screen(for route: OnboardingRoute) -> some View {
        switch route {
        case .welcome:
            WelcomeView(onStart: { model.start() })
        case .phone:
            PhoneView(viewModel: model.phoneViewModel)
        case .code:
            if let codeViewModel = model.codeViewModel {
                CodeView(viewModel: codeViewModel)
            }
        case .consents:
            ConsentsView(viewModel: model.consentsViewModel)
        case .name:
            NameView(viewModel: model.nameViewModel)
        case .location:
            LocationView(viewModel: model.locationViewModel)
        case .interests:
            InterestsView(viewModel: model.interestsViewModel)
        }
    }
}
