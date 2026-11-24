import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 1: three statements about the product and the "Start" button.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return StepScaffold(
      title: l10n.welcomeTitle,
      titleStyle: Theme.of(context).textTheme.displaySmall,
      actions: <Widget>[
        PrimaryButton(label: l10n.welcomeCta, onPressed: onStart),
      ],
      children: <Widget>[
        _Point(icon: Icons.menu_book_outlined, text: l10n.welcomePointPassport),
        _Point(icon: Icons.handshake_outlined, text: l10n.welcomePointHandover),
        _Point(icon: Icons.search, text: l10n.welcomePointWanted),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: LivadaSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Decorative: the text carries the meaning.
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(LivadaRadius.small),
              ),
              child: Padding(
                padding: const EdgeInsets.all(LivadaSpacing.sm),
                child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(width: LivadaSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: LivadaSpacing.sm),
              child: Text(text, style: theme.textTheme.titleMedium),
            ),
          ),
        ],
      ),
    );
  }
}
