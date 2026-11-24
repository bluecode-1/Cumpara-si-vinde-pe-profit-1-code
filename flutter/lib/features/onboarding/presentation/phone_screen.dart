import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/domain/phone_number_normalizer.dart';
import 'package:profitnet/features/onboarding/presentation/phone_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 2: phone number with the fixed `+40` prefix.
class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({required this.onCodeSent, super.key});

  /// Called once the SMS code has been requested successfully.
  final VoidCallback onCodeSent;

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  String? _errorText(AppLocalizations l10n, PhoneState state) {
    if (state.isInvalidNumber) {
      return l10n.phoneErrorInvalid;
    }
    final error = state.error;
    return error == null ? null : messageForError(l10n, error);
  }

  void _submit() =>
      ref.read(phoneControllerProvider.notifier).submit(_input.text);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PhoneState state = ref.watch(phoneControllerProvider);

    ref.listen<PhoneState>(phoneControllerProvider, (
      PhoneState? previous,
      PhoneState next,
    ) {
      if (next.sentChallenge != null && previous?.sentChallenge == null) {
        widget.onCodeSent();
      }
      final String? message = _errorText(l10n, next);
      if (message != null && previous != next) {
        announceForAccessibility(context, message);
      }
    });

    return StepScaffold(
      showBackButton: true,
      title: l10n.phoneTitle,
      subtitle: l10n.phoneSubtitle,
      actions: <Widget>[
        PrimaryButton(
          label: l10n.phoneCta,
          isLoading: state.isSubmitting,
          onPressed: _submit,
        ),
      ],
      children: <Widget>[
        TextField(
          controller: _input,
          autofocus: true,
          enabled: !state.isSubmitting,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.telephoneNumberNational],
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
            LengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            labelText: l10n.phoneLabel,
            prefixText: '${PhoneNumberNormalizer.countryPrefix} ',
            errorText: _errorText(l10n, state),
          ),
          onChanged: (_) =>
              ref.read(phoneControllerProvider.notifier).inputChanged(),
          onSubmitted: (_) => _submit(),
        ),
      ],
    );
  }
}
