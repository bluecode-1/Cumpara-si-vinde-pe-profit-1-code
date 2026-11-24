import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_platform.dart';

/// A labelled on/off choice: a checkbox row on Android, a row with a
/// Cupertino switch on iOS (which has no native checkbox).
///
/// The whole row is one touch target (well above 48 dp) and one semantics
/// node carrying the label and the checked/toggled state. The label wraps,
/// so the row grows with the text scale.
class AdaptiveToggleTile extends StatelessWidget {
  const AdaptiveToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;

  /// `null` disables the control.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(label);
    final ValueChanged<bool>? callback = onChanged;
    if (isCupertinoPlatform(context)) {
      // One merged node: label + switch state + tap on the whole row.
      return MergeSemantics(
        child: ListTile(
          title: title,
          contentPadding: EdgeInsets.zero,
          trailing: CupertinoSwitch(
            value: value,
            onChanged: callback,
            activeTrackColor: Theme.of(context).colorScheme.primary,
          ),
          onTap: callback == null ? null : () => callback(!value),
        ),
      );
    }
    return CheckboxListTile(
      value: value,
      onChanged: callback == null
          ? null
          : (bool? checked) => callback(checked ?? false),
      title: title,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
