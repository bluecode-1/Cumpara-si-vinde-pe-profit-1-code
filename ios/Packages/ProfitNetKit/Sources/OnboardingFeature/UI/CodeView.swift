import DesignSystem
import SwiftUI

/// Step 3: the six-digit SMS code. Submits automatically at the sixth digit.
@MainActor
struct CodeView: View {
    @Bindable var viewModel: CodeViewModel
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        OnboardingScaffold(
            title: L10n.string(.codeTitle),
            subtitle: L10n.format(.codeSubtitle, viewModel.phone)
        ) {
            TextField(L10n.string(.codeLabel), text: $viewModel.state.code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .multilineTextAlignment(.center)
                .focused($isFieldFocused)
                .accessibilityLabel(L10n.string(.codeLabel))
                .accessibilityIdentifier(OnboardingID.codeField)
                .pnFieldStyle(isError: viewModel.state.error != nil)

            if viewModel.state.isSubmitting {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .accessibilityHidden(true)
            }

            ErrorMessageView(error: viewModel.state.error)
        } actions: {
            if viewModel.state.secondsUntilResend > 0 {
                Text(L10n.format(.codeResendIn, viewModel.state.secondsUntilResend))
                    .pnTextStyle(.bodyMedium)
                    .foregroundStyle(PNColors.onSurfaceVariant)
                    .frame(maxWidth: .infinity, minHeight: PNMetrics.minTouchTarget)
            } else {
                PNButton(
                    L10n.string(.codeResend),
                    kind: .secondary,
                    isLoading: viewModel.state.isResending
                ) {
                    Task { await viewModel.resend() }
                }
                .disabled(!viewModel.state.canResend)
                .accessibilityIdentifier(OnboardingID.codeResend)
            }
        }
        .announcesError(viewModel.state.error)
        .onChange(of: viewModel.state.code) { _, _ in
            Task { await viewModel.codeChanged() }
        }
        .task {
            // Drives the resend countdown while the screen is visible.
            viewModel.tick()
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                viewModel.tick()
            }
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}
