import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_platform.dart';

/// Lets the user pick one of [options]: a Cupertino action sheet on iOS, a
/// Material modal bottom sheet on Android. Returns `null` when dismissed.
Future<T?> showAdaptiveOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required String Function(T option) labelOf,
}) {
  if (isCupertinoPlatform(context)) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext sheetContext) => CupertinoActionSheet(
        title: Text(title),
        actions: <Widget>[
          for (final T option in options)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(option),
              child: Text(labelOf(option)),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(MaterialLocalizations.of(sheetContext).cancelButtonLabel),
        ),
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (BuildContext _, ScrollController scrollController) => ListView(
        controller: scrollController,
        children: <Widget>[
          Semantics(
            header: true,
            child: ListTile(
              title: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
          ),
          for (final T option in options)
            ListTile(
              title: Text(labelOf(option)),
              onTap: () => Navigator.of(sheetContext).pop(option),
            ),
        ],
      ),
    ),
  );
}
