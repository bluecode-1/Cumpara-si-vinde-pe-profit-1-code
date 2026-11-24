import Core
import DesignSystem
import SwiftUI

/// Step 2: phone number with the fixed `+40` prefix.
@MainActor
struct PhoneView: View {
    @Bindable var viewModel: PhoneViewModel
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        OnboardingScaffold(
            title: L10n.string(.phoneTitle),
            subtitle: L10n.string(.phoneSubtitle)
        ) {
            HStack(spacing: PNSpacing.sm) {
                Text(verbatim: PhoneNumberNormalizer.countryPrefix)
                    .foregroundStyle(PNColors.onSurfaceVariant)
                    .accessibilityHidden(true)
                TextField(L10n.string(.phoneLabel), text: $viewModel.state.input)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .focused($isFieldFocused)
                    .frame(minHeight: PNMetrics.minTouchTarget)
                    .accessibilityLabel(L10n.string(.phoneLabel))
                    .accessibilityHint(L10n.string(.phoneSubtitle))
                    .accessibilityIdentifier(OnboardingID.phoneField)
            }
            .pnFieldStyle(isError: viewModel.state.error != nil)

            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            PNButton(L10n.string(.phoneCta), isLoading: viewModel.state.isSubmitting) {
                Task { await viewModel.submit() }
            }
            .accessibilityIdentifier(OnboardingID.phoneSubmit)
        }
        .announcesError(viewModel.state.error)
        .onAppear {
            isFieldFocused = true
        }
    }
}
