import DesignSystem
import SwiftUI

/// Provisional home screen: a greeting and the logout button. The real
/// content arrives with the home feature.
@MainActor
public struct HomeView: View {
    private let viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PNSpacing.md) {
                Text(L10n.format(.homeGreeting, viewModel.state.displayName))
                    .pnTextStyle(.headlineSmall)
                    .foregroundStyle(PNColors.onBackground)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("home.greeting")
                Text(L10n.string(.homePlaceholder))
                    .pnTextStyle(.bodyLarge)
                    .foregroundStyle(PNColors.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(PNSpacing.lg)
        }
        .background(PNColors.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            PNButton(
                L10n.string(.actionLogout),
                kind: .secondary,
                isLoading: viewModel.state.isLoggingOut
            ) {
                Task { await viewModel.logout() }
            }
            .accessibilityIdentifier("home.logout")
            .padding(.horizontal, PNSpacing.lg)
            .padding(.vertical, PNSpacing.md)
            .background(PNColors.background)
        }
        .task {
            await viewModel.refresh()
        }
    }
}
