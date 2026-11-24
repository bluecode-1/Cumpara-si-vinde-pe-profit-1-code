import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profitnet/app/app.dart';
import 'package:profitnet/core/session/session_controller.dart';

/// Starts the app: restores the persisted session before the first frame
/// (so the router opens directly on the right screen) and runs the root
/// widget inside a [ProviderContainer].
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ProviderContainer container = ProviderContainer();
  await container.read(sessionControllerProvider.notifier).restore();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ProfitNetApp(),
    ),
  );
}
