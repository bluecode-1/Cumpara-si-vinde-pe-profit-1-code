import Accessibility
import DesignSystem
import SwiftUI

/// Accessibility identifiers used by the UI tests.
enum OnboardingID {
    static let welcomeStart = "onboarding.welcome.start"
    static let phoneField = "onboarding.phone.field"
    static let phoneSubmit = "onboarding.phone.submit"
    static let codeField = "onboarding.code.field"
    static let codeResend = "onboarding.code.resend"
    static let consentTerms = "onboarding.consents.terms"
    static let consentPrivacy = "onboarding.consents.privacy"
    static let consentMarketing = "onboarding.consents.marketing"
    static let consentAnalytics = "onboarding.consents.analytics"
    static let consentAi = "onboarding.consents.ai"
    static let consentsContinue = "onboarding.consents.continue"
    static let nameField = "onboarding.name.field"
    static let nameContinue = "onboarding.name.continue"
    static let locationUseMine = "onboarding.location.useMine"
    static let locationPickCity = "onboarding.location.pickCity"
    static let locationCityPrefix = "onboarding.location.city."
    static let interestsCategoryPrefix = "onboarding.interests.category."
    static let interestsFinish = "onboarding.interests.finish"
    static let interestsSkip = "onboarding.interests.skip"
    static let errorMessage = "onboarding.error"
}

/// Common layout of an onboarding step: a scrolling column with the title,
/// an optional subtitle and the step's content, plus a bottom bar with the
/// actions. The bottom bar stays above the keyboard.
@MainActor
struct OnboardingScaffold<Content: View, Actions: View>: View {
    private let title: String
    private let subtitle: String?
    private let content: Content
    private let actions: Actions

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        self.actions = actions()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PNSpacing.md) {
                Text(title)
                    .pnTextStyle(.headlineSmall)
                    .foregroundStyle(PNColors.onBackground)
                    .accessibilityAddTraits(.isHeader)
                if let subtitle {
                    Text(subtitle)
                        .pnTextStyle(.bodyLarge)
                        .foregroundStyle(PNColors.onSurfaceVariant)
                }
                VStack(alignment: .leading, spacing: PNSpacing.md) {
                    content
                }
                .padding(.top, PNSpacing.sm)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(PNSpacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(PNColors.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: PNSpacing.sm) {
                actions
            }
            .padding(.horizontal, PNSpacing.lg)
            .padding(.vertical, PNSpacing.md)
            .frame(maxWidth: .infinity)
            .background(PNColors.background)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Shows the current error of a screen, if any.
struct ErrorMessageView: View {
    let error: ScreenError?

    var body: some View {
        if let error {
            Text(L10n.string(error.key))
                .pnTextStyle(.bodyMedium)
                .foregroundStyle(PNColors.error)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier(OnboardingID.errorMessage)
        }
    }
}

extension View {
    /// Announces a new error to assistive technologies (VoiceOver).
    func announcesError(_ error: ScreenError?) -> some View {
        onChange(of: error) { _, newValue in
            guard let newValue else {
                return
            }
            AccessibilityNotification.Announcement(L10n.string(newValue.key)).post()
        }
    }
}
