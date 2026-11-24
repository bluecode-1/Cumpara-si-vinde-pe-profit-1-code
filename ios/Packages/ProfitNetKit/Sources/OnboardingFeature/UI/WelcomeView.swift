import DesignSystem
import SwiftUI

/// Step 1: three statements about the product and the "Start" button.
@MainActor
struct WelcomeView: View {
    let onStart: () -> Void

    private let points: [L10nKey] = [
        .welcomePointPassport,
        .welcomePointHandover,
        .welcomePointWanted,
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PNSpacing.lg) {
                Text(L10n.string(.welcomeTitle))
                    .pnTextStyle(.displaySmall)
                    .foregroundStyle(PNColors.onBackground)
                    .accessibilityAddTraits(.isHeader)

                VStack(alignment: .leading, spacing: PNSpacing.md) {
                    ForEach(points, id: \.self) { point in
                        HStack(alignment: .firstTextBaseline, spacing: PNSpacing.md) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(PNColors.primary)
                                .accessibilityHidden(true)
                            Text(L10n.string(point))
                                .pnTextStyle(.bodyLarge)
                                .foregroundStyle(PNColors.onBackground)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(PNSpacing.lg)
            .padding(.top, PNSpacing.xl)
        }
        .background(PNColors.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            PNButton(L10n.string(.welcomeCta), action: onStart)
                .accessibilityIdentifier(OnboardingID.welcomeStart)
                .padding(.horizontal, PNSpacing.lg)
                .padding(.vertical, PNSpacing.md)
                .background(PNColors.background)
        }
    }
}
