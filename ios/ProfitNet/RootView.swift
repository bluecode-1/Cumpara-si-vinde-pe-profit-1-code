import DesignSystem
import HomeFeature
import OnboardingFeature
import SwiftUI

/// Switches between the onboarding flow and the (provisional) home screen.
/// Tabs and deep-link routing are added with the features that need them.
@MainActor
struct RootView: View {
    let appModel: AppModel

    var body: some View {
        content
            .task {
                await appModel.start()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch appModel.phase {
        case .loading:
            ZStack {
                PNColors.background.ignoresSafeArea()
                ProgressView()
            }
        case .onboarding(let model):
            OnboardingCoordinatorView(model: model)
                // A new flow (after logout or session expiry) gets a fresh stack.
                .id(ObjectIdentifier(model))
        case .home(let viewModel):
            HomeView(viewModel: viewModel)
                .id(ObjectIdentifier(viewModel))
        }
    }
}
