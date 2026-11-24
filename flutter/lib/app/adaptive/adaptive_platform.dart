import 'package:material_ui/material_ui.dart';

/// Whether the UI should follow Apple conventions (Cupertino controls,
/// swipe-back, iOS page transitions). Derived from the theme so that it can
/// be overridden in tests and previews.
bool isCupertinoPlatform(BuildContext context) =>
    switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => true,
      _ => false,
    };
