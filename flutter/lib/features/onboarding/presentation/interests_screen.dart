import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/presentation/interests_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 7: optional multi-selection of the top-level categories.
class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final InterestsState state = ref.watch(interestsControllerProvider);
    final InterestsController controller = ref.read(
      interestsControllerProvider.notifier,
    );
    final List<InterestCategory>? categories = state.categories;
    final AppError? loadError = state.loadError;
    final AppError? submitError = state.submitError;

    return StepScaffold(
      title: l10n.interestsTitle,
      subtitle: l10n.interestsSubtitle,
      actions: <Widget>[
        PrimaryButton(
          label: l10n.actionFinish,
          isLoading: state.isSubmitting,
          onPressed: controller.finish,
        ),
        TextButton(
          onPressed: state.isSubmitting ? null : controller.skip,
          child: Text(l10n.interestsSkip),
        ),
      ],
      children: <Widget>[
        if (state.isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(LivadaSpacing.lg),
              child: CircularProgressIndicator.adaptive(
                semanticsLabel: l10n.a11yLoading,
              ),
            ),
          ),
        if (loadError != null) ...<Widget>[
          ErrorMessage(messageForError(l10n, loadError)),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: controller.retryLoad,
              child: Text(l10n.actionRetry),
            ),
          ),
        ],
        if (categories != null)
          Wrap(
            spacing: LivadaSpacing.sm,
            runSpacing: LivadaSpacing.xs,
            children: <Widget>[
              for (final InterestCategory category in categories)
                FilterChip(
                  // Chips report "selected" to screen readers themselves.
                  label: Text(category.name),
                  selected: state.selectedIds.contains(category.id),
                  onSelected: state.isSubmitting
                      ? null
                      : (_) => controller.toggle(category.id),
                ),
            ],
          ),
        ErrorMessage(
          submitError == null ? null : messageForError(l10n, submitError),
        ),
      ],
    );
  }
}
