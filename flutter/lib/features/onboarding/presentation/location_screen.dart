import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_option_picker.dart';
import 'package:profitnet/core/design/livada_tokens.dart';
import 'package:profitnet/core/design/widgets/error_message.dart';
import 'package:profitnet/core/design/widgets/primary_button.dart';
import 'package:profitnet/core/design/widgets/step_scaffold.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/error/error_messages.dart';
import 'package:profitnet/features/onboarding/domain/city.dart';
import 'package:profitnet/features/onboarding/presentation/location_controller.dart';
import 'package:profitnet/l10n/app_localizations.dart';

/// Step 6: explains why the area is needed and offers the device location
/// or a manual city choice. Refusing the permission never blocks the user.
class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  Future<void> _pickCity(BuildContext context, WidgetRef ref) async {
    final City? city = await showAdaptiveOptionPicker<City>(
      context: context,
      title: AppLocalizations.of(context).locationPickCity,
      options: manualCities,
      labelOf: (City city) => city.name,
    );
    if (city != null) {
      await ref.read(locationControllerProvider.notifier).pickCity(city);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final LocationState state = ref.watch(locationControllerProvider);
    final AppError? error = state.error;
    final String? message = error != null
        ? messageForError(l10n, error)
        : state.isLocationDenied
        ? l10n.locationDenied
        : null;

    return StepScaffold(
      title: l10n.locationTitle,
      subtitle: l10n.locationSubtitle,
      actions: <Widget>[
        PrimaryButton(
          label: l10n.locationUseMine,
          isLoading: state.isBusy,
          onPressed: ref
              .read(locationControllerProvider.notifier)
              .useMyLocation,
        ),
        OutlinedButton(
          onPressed: state.isBusy ? null : () => _pickCity(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: LivadaSpacing.xs),
            child: Text(l10n.locationPickCity, textAlign: TextAlign.center),
          ),
        ),
      ],
      children: <Widget>[
        ExcludeSemantics(
          child: Icon(
            Icons.place_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        ErrorMessage(message),
      ],
    );
  }
}
