import Foundation

/// Every user-facing string key. The keys are shared with the Android and
/// Flutter apps (docs/06-flux-onboarding.md §4); the texts live in the app
/// target's `Localizable.xcstrings` (Romanian source, English translation).
public enum L10nKey: String, CaseIterable, Sendable {
    case welcomeTitle = "welcome_title"
    case welcomePointPassport = "welcome_point_passport"
    case welcomePointHandover = "welcome_point_handover"
    case welcomePointWanted = "welcome_point_wanted"
    case welcomeCta = "welcome_cta"

    case phoneTitle = "phone_title"
    case phoneSubtitle = "phone_subtitle"
    case phoneLabel = "phone_label"
    case phoneErrorInvalid = "phone_error_invalid"
    case phoneCta = "phone_cta"

    case codeTitle = "code_title"
    /// One `%@` argument: the phone number.
    case codeSubtitle = "code_subtitle"
    case codeLabel = "code_label"
    case codeResend = "code_resend"
    /// One `%lld` argument: the remaining seconds.
    case codeResendIn = "code_resend_in"

    case consentsTitle = "consents_title"
    case consentTerms = "consent_terms"
    case consentPrivacy = "consent_privacy"
    case consentMarketing = "consent_marketing"
    case consentAnalytics = "consent_analytics"
    case consentAi = "consent_ai"
    case consentsRequiredHint = "consents_required_hint"
    case consentsOptionalHeader = "consents_optional_header"

    case nameTitle = "name_title"
    case nameSubtitle = "name_subtitle"
    case nameLabel = "name_label"
    case nameErrorLength = "name_error_length"

    case locationTitle = "location_title"
    case locationSubtitle = "location_subtitle"
    case locationUseMine = "location_use_mine"
    case locationPickCity = "location_pick_city"
    case locationDenied = "location_denied"

    case interestsTitle = "interests_title"
    case interestsSubtitle = "interests_subtitle"
    case interestsSkip = "interests_skip"

    case actionContinue = "action_continue"
    case actionFinish = "action_finish"
    case actionLogout = "action_logout"

    /// One `%@` argument: the display name.
    case homeGreeting = "home_greeting"
    case homePlaceholder = "home_placeholder"

    case errorOtpInvalid = "error_otp_invalid"
    case errorRateLimited = "error_rate_limited"
    case errorNetwork = "error_network"
    case errorGeneric = "error_generic"
}

/// Looks up localized strings in the app bundle's `Localizable` table.
///
/// The string catalog lives in the app target, so lookups resolve when the
/// code runs inside the app. In package unit tests (no app bundle) the key
/// itself is returned, which is why view models expose keys, not texts.
public enum L10n {
    /// The localized text for `key`.
    public static func string(_ key: L10nKey) -> String {
        Bundle.main.localizedString(forKey: key.rawValue, value: nil, table: nil)
    }

    /// The localized text for `key` with `String(format:)` arguments
    /// (`%@` for strings, `%lld` for integers).
    public static func format(_ key: L10nKey, _ arguments: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forKey: key.rawValue, value: nil, table: nil)
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}
