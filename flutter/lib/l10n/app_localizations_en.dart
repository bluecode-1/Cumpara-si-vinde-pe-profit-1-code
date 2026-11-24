// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ProfitNet';

  @override
  String get welcomeTitle => 'Good things deserve a second home';

  @override
  String get welcomePointPassport =>
      'Every item has a passport with its history';

  @override
  String get welcomePointHandover =>
      'You pay safely and get your money at handover';

  @override
  String get welcomePointWanted =>
      'Say what you are looking for and get matches';

  @override
  String get welcomeCta => 'Get started';

  @override
  String get phoneTitle => 'What is your phone number?';

  @override
  String get phoneSubtitle => 'We will text you a code to confirm your number.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneErrorInvalid =>
      'Enter a valid mobile number, for example 0712 345 678.';

  @override
  String get phoneCta => 'Send code';

  @override
  String get codeTitle => 'Enter the code you received';

  @override
  String codeSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String get codeLabel => 'Verification code';

  @override
  String get codeResend => 'Resend code';

  @override
  String codeResendIn(int seconds) {
    return 'You can resend the code in $seconds s';
  }

  @override
  String get consentsTitle => 'Before you continue';

  @override
  String get consentTerms => 'I agree to the Terms and Conditions';

  @override
  String get consentPrivacy => 'I have read the Privacy Policy';

  @override
  String get consentMarketing => 'I want to receive news and offers';

  @override
  String get consentAnalytics =>
      'I help improve the app with anonymous usage data';

  @override
  String get consentAi =>
      'I allow automatic photo analysis for title and category suggestions';

  @override
  String get consentsRequiredHint =>
      'The first two are required to use the app.';

  @override
  String get consentsOptionalHeader => 'Optional';

  @override
  String get nameTitle => 'What should we call you?';

  @override
  String get nameSubtitle =>
      'Your name appears on your profile and in conversations.';

  @override
  String get nameLabel => 'Display name';

  @override
  String get nameErrorLength =>
      'The name must be between 2 and 40 characters long.';

  @override
  String get locationTitle => 'Where are you usually?';

  @override
  String get locationSubtitle =>
      'We show you what is nearby. We only keep the approximate area, not your address.';

  @override
  String get locationUseMine => 'Use my location';

  @override
  String get locationPickCity => 'Choose a city';

  @override
  String get locationDenied =>
      'We cannot access your location. You can choose your city from the list.';

  @override
  String get interestsTitle => 'What are you interested in?';

  @override
  String get interestsSubtitle =>
      'Pick a few categories. You can change them anytime.';

  @override
  String get interestsSkip => 'Skip';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionFinish => 'Done';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homePlaceholder => 'The home screen is under construction.';

  @override
  String get actionLogout => 'Log out';

  @override
  String get errorOtpInvalid => 'The code is incorrect or has expired.';

  @override
  String get errorRateLimited =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get actionRetry => 'Try again';

  @override
  String get a11yLoading => 'Loading';
}
