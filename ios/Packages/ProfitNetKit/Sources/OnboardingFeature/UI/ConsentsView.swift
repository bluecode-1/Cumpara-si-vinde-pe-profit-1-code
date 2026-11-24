import DesignSystem
import SwiftUI

/// Step 4: required and optional consents.
@MainActor
struct ConsentsView: View {
    @Bindable var viewModel: ConsentsViewModel

    var body: some View {
        OnboardingScaffold(title: L10n.string(.consentsTitle)) {
            VStack(alignment: .leading, spacing: PNSpacing.xs) {
                PNCheckboxRow(L10n.string(.consentTerms), isOn: $viewModel.state.terms)
                    .accessibilityIdentifier(OnboardingID.consentTerms)
                PNCheckboxRow(L10n.string(.consentPrivacy), isOn: $viewModel.state.privacy)
                    .accessibilityIdentifier(OnboardingID.consentPrivacy)

                Text(L10n.string(.consentsRequiredHint))
                    .pnTextStyle(.bodyMedium)
                    .foregroundStyle(PNColors.onSurfaceVariant)
                    .padding(.bottom, PNSpacing.md)

                Text(L10n.string(.consentsOptionalHeader))
                    .pnTextStyle(.titleMedium)
                    .foregroundStyle(PNColors.onBackground)
                    .accessibilityAddTraits(.isHeader)

                PNCheckboxRow(L10n.string(.consentMarketing), isOn: $viewModel.state.marketing)
                    .accessibilityIdentifier(OnboardingID.consentMarketing)
                PNCheckboxRow(L10n.string(.consentAnalytics), isOn: $viewModel.state.analytics)
                    .accessibilityIdentifier(OnboardingID.consentAnalytics)
                PNCheckboxRow(L10n.string(.consentAi), isOn: $viewModel.state.aiPhotoProcessing)
                    .accessibilityIdentifier(OnboardingID.consentAi)
            }

            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            PNButton(L10n.string(.actionContinue), isLoading: viewModel.state.isSubmitting) {
                Task { await viewModel.submit() }
            }
            .disabled(!viewModel.state.canContinue)
            .accessibilityHint(L10n.string(.consentsRequiredHint))
            .accessibilityIdentifier(OnboardingID.consentsContinue)
        }
        .announcesError(viewModel.state.error)
    }
}
