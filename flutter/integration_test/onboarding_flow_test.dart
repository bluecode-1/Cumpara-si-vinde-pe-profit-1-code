import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:profitnet/app/app.dart';
import 'package:profitnet/core/database/app_database.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/network/api_config.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/onboarding/presentation/welcome_screen.dart';

import '../test/support/fakes.dart';
import '../test/support/onboarding_flow_robot.dart';

/// End-to-end happy path on a device or emulator, against the fake API
/// (fixtures bundled in `assets/fixtures`):
///
///     flutter test integration_test/onboarding_flow_test.dart
///
/// Storage is replaced by in-memory equivalents so that every run starts
/// signed out, and the location plugin by a "permission denied" fake so no
/// system dialog appears; everything else is the production code path
/// (router, Dio pipeline, repositories, Drift on a real SQLite engine).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding happy path: Welcome to Home, then logout', (
    WidgetTester tester,
  ) async {
    final AppDatabase database = AppDatabase(NativeDatabase.memory());
    final InMemoryTokenStore tokenStore = InMemoryTokenStore();
    final ProviderContainer container = ProviderContainer(
      overrides: [
        apiConfigProvider.overrideWithValue(
          const ApiConfig(baseUrl: 'https://api.invalid/v1', useFakeApi: true),
        ),
        tokenStoreProvider.overrideWithValue(tokenStore),
        appDatabaseProvider.overrideWithValue(database),
        locationServiceProvider.overrideWithValue(
          FakeLocationService(const LocationPermissionDenied()),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });

    await container.read(sessionControllerProvider.notifier).restore();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ProfitNetApp(),
      ),
    );

    final OnboardingFlowRobot robot = OnboardingFlowRobot(tester);
    await robot.completeOnboarding();

    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedIn(displayName: OnboardingFlowRobot.displayName),
    );
    expect(await tokenStore.read(), isNotNull);

    await robot.logout();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedOut(),
    );
    expect(await tokenStore.read(), isNull);
  });
}
