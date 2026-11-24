import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/presentation/code_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 3: the 6-digit SMS code. Submits automatically at the 6th digit.
class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key});

  static const int codeLength = 6;

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  final TextEditingController _input = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final CodeState state = ref.watch(codeControllerProvider);
    final AppError? error = state.error;

    ref.listen<CodeState>(codeControllerProvider, (
      CodeState? previous,
      CodeState next,
    ) {
      if (previous != null &&
          next.clearInputSignal != previous.clearInputSignal) {
        _input.clear();
        _focus.requestFocus();
      }
      final AppError? nextError = next.error;
      if (nextError != null && nextError != previous?.error) {
        announceForAccessibility(context, messageForError(l10n, nextError));
      }
    });

    return StepScaffold(
      showBackButton: true,
      title: l10n.codeTitle,
      subtitle: l10n.codeSubtitle(state.phone),
      children: <Widget>[
        TextField(
          controller: _input,
          focusNode: _focus,
          autofocus: true,
          readOnly: state.isSubmitting,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.oneTimeCode],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(CodeScreen.codeLength),
          ],
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 8),
          decoration: InputDecoration(
            labelText: l10n.codeLabel,
            errorText: error == null ? null : messageForError(l10n, error),
          ),
          onChanged: (String value) {
            if (value.length == CodeScreen.codeLength) {
              unawaited(
                ref.read(codeControllerProvider.notifier).submit(value),
              );
            }
          },
        ),
        const SizedBox(height: LivadaSpacing.md),
        if (state.isSubmitting || state.isResending)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(LivadaSpacing.sm),
              child: CircularProgressIndicator.adaptive(
                semanticsLabel: l10n.a11yLoading,
              ),
            ),
          )
        else
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: state.canResend
                  ? ref.read(codeControllerProvider.notifier).resend
                  : null,
              child: Text(
                state.secondsUntilResend > 0
                    ? l10n.codeResendIn(state.secondsUntilResend)
                    : l10n.codeResend,
              ),
            ),
          ),
      ],
    );
  }
}
