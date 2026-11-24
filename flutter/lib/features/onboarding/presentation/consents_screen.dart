import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_toggle_tile.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/consents_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 4: Terms and Privacy (required) plus three optional consents, all
/// unticked by default.
class ConsentsScreen extends ConsumerWidget {
  const ConsentsScreen({super.key});

  static String _label(AppLocalizations l10n, ConsentPurpose purpose) =>
      switch (purpose) {
        ConsentPurpose.terms => l10n.consentTerms,
        ConsentPurpose.privacy => l10n.consentPrivacy,
        ConsentPurpose.marketing => l10n.consentMarketing,
        ConsentPurpose.analytics => l10n.consentAnalytics,
        ConsentPurpose.aiPhotoProcessing => l10n.consentAi,
        // Decided on the Location step, never listed here.
        ConsentPurpose.location => '',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ConsentsState state = ref.watch(consentsControllerProvider);
    final ConsentsController controller = ref.read(
      consentsControllerProvider.notifier,
    );
    final AppError? error = state.error;

    Widget tile(ConsentPurpose purpose) => AdaptiveToggleTile(
      key: ValueKey<ConsentPurpose>(purpose),
      label: _label(l10n, purpose),
      value: state.granted.contains(purpose),
      onChanged: state.isSubmitting
          ? null
          : (bool granted) => controller.setGranted(purpose, granted: granted),
    );

    return StepScaffold(
      title: l10n.consentsTitle,
      actions: <Widget>[
        PrimaryButton(
          label: l10n.actionContinue,
          isLoading: state.isSubmitting,
          onPressed: state.canContinue ? controller.submit : null,
        ),
      ],
      children: <Widget>[
        for (final ConsentPurpose purpose in ConsentsController.purposes)
          if (purpose.isRequired) tile(purpose),
        const SizedBox(height: LivadaSpacing.sm),
        Text(
          l10n.consentsRequiredHint,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: LivadaSpacing.lg),
        Semantics(
          header: true,
          child: Text(
            l10n.consentsOptionalHeader,
            style: theme.textTheme.titleMedium,
          ),
        ),
        for (final ConsentPurpose purpose in ConsentsController.purposes)
          if (!purpose.isRequired) tile(purpose),
        ErrorMessage(error == null ? null : messageForError(l10n, error)),
      ],
    );
  }
}
