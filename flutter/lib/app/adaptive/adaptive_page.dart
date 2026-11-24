import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:profitnet/app/adaptive/adaptive_platform.dart';

/// Route page for the router: `CupertinoPage` on iOS (native push/pop
/// animation and interactive swipe-back gesture), `MaterialPage` elsewhere
/// (Material transitions and Android predictive back).
Page<T> buildAdaptivePage<T>({
  required BuildContext context,
  required LocalKey key,
  required Widget child,
  String? name,
}) => isCupertinoPlatform(context)
    ? CupertinoPage<T>(key: key, name: name, child: child)
    : MaterialPage<T>(key: key, name: name, child: child);

/// Transitions for routes pushed outside the router (dialogs excluded), so
/// they match [buildAdaptivePage].
const PageTransitionsTheme adaptivePageTransitions = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
  },
);
