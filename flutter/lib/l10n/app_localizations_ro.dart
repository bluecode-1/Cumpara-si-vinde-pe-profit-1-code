// ignore_for_file: deprecated_member_use

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'ProfitNet';

  @override
  String get welcomeTitle => 'Lucrurile bune merită o a doua casă';

  @override
  String get welcomePointPassport =>
      'Fiecare obiect are un pașaport cu istoricul lui';

  @override
  String get welcomePointHandover =>
      'Plătești în siguranță și primești banii la predare';

  @override
  String get welcomePointWanted => 'Spui ce cauți și primești potriviri';

  @override
  String get welcomeCta => 'Începe';

  @override
  String get phoneTitle => 'Care este numărul tău de telefon?';

  @override
  String get phoneSubtitle =>
      'Îți trimitem un cod prin SMS ca să-ți confirmăm numărul.';

  @override
  String get phoneLabel => 'Număr de telefon';

  @override
  String get phoneErrorInvalid =>
      'Introdu un număr de mobil valid, de exemplu 0712 345 678.';

  @override
  String get phoneCta => 'Trimite codul';

  @override
  String get codeTitle => 'Introdu codul primit';

  @override
  String codeSubtitle(String phone) {
    return 'Am trimis un cod din 6 cifre la $phone.';
  }

  @override
  String get codeLabel => 'Cod de verificare';

  @override
  String get codeResend => 'Retrimite codul';

  @override
  String codeResendIn(int seconds) {
    return 'Poți retrimite codul în $seconds s';
  }

  @override
  String get consentsTitle => 'Înainte să continui';

  @override
  String get consentTerms => 'Sunt de acord cu Termenii și condițiile';

  @override
  String get consentPrivacy => 'Am citit Politica de confidențialitate';

  @override
  String get consentMarketing => 'Vreau să primesc noutăți și oferte';

  @override
  String get consentAnalytics =>
      'Ajut la îmbunătățirea aplicației cu date de utilizare anonime';

  @override
  String get consentAi =>
      'Permit analiza automată a fotografiilor pentru sugestii de titlu și categorie';

  @override
  String get consentsRequiredHint =>
      'Primele două sunt necesare pentru a folosi aplicația.';

  @override
  String get consentsOptionalHeader => 'Opțional';

  @override
  String get nameTitle => 'Cum vrei să-ți spunem?';

  @override
  String get nameSubtitle => 'Numele apare în profilul tău și în conversații.';

  @override
  String get nameLabel => 'Nume afișat';

  @override
  String get nameErrorLength =>
      'Numele trebuie să aibă între 2 și 40 de caractere.';

  @override
  String get locationTitle => 'Unde ești de obicei?';

  @override
  String get locationSubtitle =>
      'Îți arătăm ce e aproape de tine. Păstrăm doar zona aproximativă, nu adresa.';

  @override
  String get locationUseMine => 'Folosește locația mea';

  @override
  String get locationPickCity => 'Aleg orașul';

  @override
  String get locationDenied =>
      'Nu avem acces la locație. Poți alege orașul din listă.';

  @override
  String get interestsTitle => 'Ce te interesează?';

  @override
  String get interestsSubtitle =>
      'Alege câteva categorii. Le poți schimba oricând.';

  @override
  String get interestsSkip => 'Sari peste';

  @override
  String get actionContinue => 'Continuă';

  @override
  String get actionFinish => 'Gata';

  @override
  String homeGreeting(String name) {
    return 'Bună, $name';
  }

  @override
  String get homePlaceholder => 'Ecranul principal este în lucru.';

  @override
  String get actionLogout => 'Ieși din cont';

  @override
  String get errorOtpInvalid => 'Codul nu este corect sau a expirat.';

  @override
  String get errorRateLimited =>
      'Prea multe încercări. Încearcă din nou peste câteva minute.';

  @override
  String get errorNetwork =>
      'Nu există conexiune la internet. Verifică rețeaua și încearcă din nou.';

  @override
  String get errorGeneric => 'Ceva nu a mers. Încearcă din nou.';

  @override
  String get actionRetry => 'Reîncearcă';

  @override
  String get a11yLoading => 'Se încarcă';
}
