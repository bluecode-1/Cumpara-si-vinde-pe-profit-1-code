// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
  ];

  /// Application name shown by the OS task switcher.
  ///
  /// In ro, this message translates to:
  /// **'ProfitNet'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Lucrurile bune merită o a doua casă'**
  String get welcomeTitle;

  /// No description provided for @welcomePointPassport.
  ///
  /// In ro, this message translates to:
  /// **'Fiecare obiect are un pașaport cu istoricul lui'**
  String get welcomePointPassport;

  /// No description provided for @welcomePointHandover.
  ///
  /// In ro, this message translates to:
  /// **'Plătești în siguranță și primești banii la predare'**
  String get welcomePointHandover;

  /// No description provided for @welcomePointWanted.
  ///
  /// In ro, this message translates to:
  /// **'Spui ce cauți și primești potriviri'**
  String get welcomePointWanted;

  /// No description provided for @welcomeCta.
  ///
  /// In ro, this message translates to:
  /// **'Începe'**
  String get welcomeCta;

  /// No description provided for @phoneTitle.
  ///
  /// In ro, this message translates to:
  /// **'Care este numărul tău de telefon?'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Îți trimitem un cod prin SMS ca să-ți confirmăm numărul.'**
  String get phoneSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In ro, this message translates to:
  /// **'Număr de telefon'**
  String get phoneLabel;

  /// No description provided for @phoneErrorInvalid.
  ///
  /// In ro, this message translates to:
  /// **'Introdu un număr de mobil valid, de exemplu 0712 345 678.'**
  String get phoneErrorInvalid;

  /// No description provided for @phoneCta.
  ///
  /// In ro, this message translates to:
  /// **'Trimite codul'**
  String get phoneCta;

  /// No description provided for @codeTitle.
  ///
  /// In ro, this message translates to:
  /// **'Introdu codul primit'**
  String get codeTitle;

  /// No description provided for @codeSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Am trimis un cod din 6 cifre la {phone}.'**
  String codeSubtitle(String phone);

  /// No description provided for @codeLabel.
  ///
  /// In ro, this message translates to:
  /// **'Cod de verificare'**
  String get codeLabel;

  /// No description provided for @codeResend.
  ///
  /// In ro, this message translates to:
  /// **'Retrimite codul'**
  String get codeResend;

  /// No description provided for @codeResendIn.
  ///
  /// In ro, this message translates to:
  /// **'Poți retrimite codul în {seconds} s'**
  String codeResendIn(int seconds);

  /// No description provided for @consentsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Înainte să continui'**
  String get consentsTitle;

  /// No description provided for @consentTerms.
  ///
  /// In ro, this message translates to:
  /// **'Sunt de acord cu Termenii și condițiile'**
  String get consentTerms;

  /// No description provided for @consentPrivacy.
  ///
  /// In ro, this message translates to:
  /// **'Am citit Politica de confidențialitate'**
  String get consentPrivacy;

  /// No description provided for @consentMarketing.
  ///
  /// In ro, this message translates to:
  /// **'Vreau să primesc noutăți și oferte'**
  String get consentMarketing;

  /// No description provided for @consentAnalytics.
  ///
  /// In ro, this message translates to:
  /// **'Ajut la îmbunătățirea aplicației cu date de utilizare anonime'**
  String get consentAnalytics;

  /// No description provided for @consentAi.
  ///
  /// In ro, this message translates to:
  /// **'Permit analiza automată a fotografiilor pentru sugestii de titlu și categorie'**
  String get consentAi;

  /// No description provided for @consentsRequiredHint.
  ///
  /// In ro, this message translates to:
  /// **'Primele două sunt necesare pentru a folosi aplicația.'**
  String get consentsRequiredHint;

  /// No description provided for @consentsOptionalHeader.
  ///
  /// In ro, this message translates to:
  /// **'Opțional'**
  String get consentsOptionalHeader;

  /// No description provided for @nameTitle.
  ///
  /// In ro, this message translates to:
  /// **'Cum vrei să-ți spunem?'**
  String get nameTitle;

  /// No description provided for @nameSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Numele apare în profilul tău și în conversații.'**
  String get nameSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In ro, this message translates to:
  /// **'Nume afișat'**
  String get nameLabel;

  /// No description provided for @nameErrorLength.
  ///
  /// In ro, this message translates to:
  /// **'Numele trebuie să aibă între 2 și 40 de caractere.'**
  String get nameErrorLength;

  /// No description provided for @locationTitle.
  ///
  /// In ro, this message translates to:
  /// **'Unde ești de obicei?'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Îți arătăm ce e aproape de tine. Păstrăm doar zona aproximativă, nu adresa.'**
  String get locationSubtitle;

  /// No description provided for @locationUseMine.
  ///
  /// In ro, this message translates to:
  /// **'Folosește locația mea'**
  String get locationUseMine;

  /// No description provided for @locationPickCity.
  ///
  /// In ro, this message translates to:
  /// **'Aleg orașul'**
  String get locationPickCity;

  /// No description provided for @locationDenied.
  ///
  /// In ro, this message translates to:
  /// **'Nu avem acces la locație. Poți alege orașul din listă.'**
  String get locationDenied;

  /// No description provided for @interestsTitle.
  ///
  /// In ro, this message translates to:
  /// **'Ce te interesează?'**
  String get interestsTitle;

  /// No description provided for @interestsSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Alege câteva categorii. Le poți schimba oricând.'**
  String get interestsSubtitle;

  /// No description provided for @interestsSkip.
  ///
  /// In ro, this message translates to:
  /// **'Sari peste'**
  String get interestsSkip;

  /// No description provided for @actionContinue.
  ///
  /// In ro, this message translates to:
  /// **'Continuă'**
  String get actionContinue;

  /// No description provided for @actionFinish.
  ///
  /// In ro, this message translates to:
  /// **'Gata'**
  String get actionFinish;

  /// No description provided for @homeGreeting.
  ///
  /// In ro, this message translates to:
  /// **'Bună, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homePlaceholder.
  ///
  /// In ro, this message translates to:
  /// **'Ecranul principal este în lucru.'**
  String get homePlaceholder;

  /// No description provided for @actionLogout.
  ///
  /// In ro, this message translates to:
  /// **'Ieși din cont'**
  String get actionLogout;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In ro, this message translates to:
  /// **'Codul nu este corect sau a expirat.'**
  String get errorOtpInvalid;

  /// No description provided for @errorRateLimited.
  ///
  /// In ro, this message translates to:
  /// **'Prea multe încercări. Încearcă din nou peste câteva minute.'**
  String get errorRateLimited;

  /// No description provided for @errorNetwork.
  ///
  /// In ro, this message translates to:
  /// **'Nu există conexiune la internet. Verifică rețeaua și încearcă din nou.'**
  String get errorNetwork;

  /// No description provided for @errorGeneric.
  ///
  /// In ro, this message translates to:
  /// **'Ceva nu a mers. Încearcă din nou.'**
  String get errorGeneric;

  /// Flutter-only: retry button shown when the category list fails to load.
  ///
  /// In ro, this message translates to:
  /// **'Reîncearcă'**
  String get actionRetry;

  /// Flutter-only: screen reader label for progress indicators.
  ///
  /// In ro, this message translates to:
  /// **'Se încarcă'**
  String get a11yLoading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
