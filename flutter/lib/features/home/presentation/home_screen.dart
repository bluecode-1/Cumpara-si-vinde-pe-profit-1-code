import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/home/presentation/home_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Provisional Home: greeting and "Log out". The real content ("Aproape de
/// tine azi") arrives in step 4c.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SessionState session = ref.watch(sessionControllerProvider);
    final HomeState state = ref.watch(homeControllerProvider);
    final String name = session is SignedIn ? session.displayName : '';

    return StepScaffold(
      title: l10n.homeGreeting(name),
      subtitle: l10n.homePlaceholder,
      actions: <Widget>[
        OutlinedButton(
          onPressed: state.isLoggingOut
              ? null
              : ref.read(homeControllerProvider.notifier).logout,
          child: state.isLoggingOut
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    semanticsLabel: l10n.a11yLoading,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: LivadaSpacing.xs,
                  ),
                  child: Text(l10n.actionLogout, textAlign: TextAlign.center),
                ),
        ),
      ],
      children: const <Widget>[],
    );
  }
}
