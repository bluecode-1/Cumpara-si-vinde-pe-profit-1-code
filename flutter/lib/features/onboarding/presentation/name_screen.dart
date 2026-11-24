import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/presentation/name_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 5: the public display name (2-40 characters).
class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  String? _errorText(AppLocalizations l10n, NameState state) {
    if (state.isInvalidLength) {
      return l10n.nameErrorLength;
    }
    final AppError? error = state.error;
    return error == null ? null : messageForError(l10n, error);
  }

  void _submit() =>
      ref.read(nameControllerProvider.notifier).submit(_input.text);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final NameState state = ref.watch(nameControllerProvider);

    ref.listen<NameState>(nameControllerProvider, (
      NameState? previous,
      NameState next,
    ) {
      final String? message = _errorText(l10n, next);
      if (message != null && previous != next) {
        announceForAccessibility(context, message);
      }
    });

    return StepScaffold(
      title: l10n.nameTitle,
      subtitle: l10n.nameSubtitle,
      actions: <Widget>[
        PrimaryButton(
          label: l10n.actionContinue,
          isLoading: state.isSubmitting,
          onPressed: _submit,
        ),
      ],
      children: <Widget>[
        TextField(
          controller: _input,
          autofocus: true,
          enabled: !state.isSubmitting,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.givenName],
          inputFormatters: <TextInputFormatter>[
            // Generous cap; the 40-character rule is reported as an error
            // rather than silently truncating what the user types.
            LengthLimitingTextInputFormatter(80),
          ],
          decoration: InputDecoration(
            labelText: l10n.nameLabel,
            errorText: _errorText(l10n, state),
          ),
          onChanged: (_) =>
              ref.read(nameControllerProvider.notifier).inputChanged(),
          onSubmitted: (_) => _submit(),
        ),
      ],
    );
  }
}
