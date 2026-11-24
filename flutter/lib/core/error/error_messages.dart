import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Resolves the text shown for an [AppError]. The text always comes from the
/// app resources, never from the server.
String messageForError(AppLocalizations l10n, AppError error) =>
    switch (error.code) {
      AppErrorCode.otpInvalid => l10n.errorOtpInvalid,
      AppErrorCode.rateLimited => l10n.errorRateLimited,
      AppErrorCode.network => l10n.errorNetwork,
      _ => l10n.errorGeneric,
    };
