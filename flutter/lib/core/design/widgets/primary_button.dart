import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Full-width call-to-action. While [isLoading] it shows a progress
/// indicator, ignores taps and tells assistive technology it is busy.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;

  /// `null` renders the button disabled.
  final VoidCallback? onPressed;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  semanticsLabel: AppLocalizations.of(context).a11yLoading,
                ),
              )
            // The label wraps (and the button grows) at large text scales.
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: LivadaSpacing.xs),
                child: Text(label, textAlign: TextAlign.center),
              ),
      ),
    );
  }
}
