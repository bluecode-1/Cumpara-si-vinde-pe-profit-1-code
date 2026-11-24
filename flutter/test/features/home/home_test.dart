import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/database/drift_session_progress_store.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/home/di/home_providers.dart';
import 'package:profitnet/features/home/domain/logout_repository.dart';
import 'package:profitnet/features/home/presentation/home_controller.dart';
import 'package:profitnet/features/home/presentation/home_screen.dart';

import '../../support/test_app.dart';

class _MockLogoutRepository extends Mock implements LogoutRepository {}

void main() {
  late _MockLogoutRepository repository;
  late InMemoryTokenStore tokenStore;
  late InMemorySessionProgressStore progressStore;
  late ProviderContainer container;

  setUp(() async {
    repository = _MockLogoutRepository();
    tokenStore = InMemoryTokenStore();
    progressStore = InMemorySessionProgressStore();
    container = ProviderContainer.test(
      overrides: [
        logoutRepositoryProvider.overrideWithValue(repository),
        tokenStoreProvider.overrideWithValue(tokenStore),
        sessionProgressStoreProvider.overrideWithValue(progressStore),
      ],
    );
    await container
        .read(sessionControllerProvider.notifier)
        .signIn(
          tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
          displayName: 'Ioana',
          onboardingCompleted: true,
        );
  });

  testWidgets('greets the user by name and offers logout', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester, const HomeScreen(), container: container);

    expect(find.text('Bună, Ioana'), findsOneWidget);
    expect(find.text('Ecranul principal este în lucru.'), findsOneWidget);
    expect(find.text('Ieși din cont'), findsOneWidget);
  });

  testWidgets('logout calls the server, then clears the local session', (
    WidgetTester tester,
  ) async {
    when(() => repository.logout()).thenAnswer((_) async {});
    await pumpScreen(tester, const HomeScreen(), container: container);

    await tapText(tester, ro.actionLogout);
    await tester.pump();

    verify(() => repository.logout()).called(1);
    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedOut(),
    );
    expect(await tokenStore.read(), isNull);
    expect(await progressStore.read(), isNull);
  });

  test('logout clears the local session even when the server cannot be '
      'reached', () async {
    when(() => repository.logout()).thenThrow(const AppError.network());
    container.listen(homeControllerProvider, (_, _) {});

    await container.read(homeControllerProvider.notifier).logout();

    expect(
      container.read(sessionControllerProvider),
      const SessionState.signedOut(),
    );
    expect(await tokenStore.read(), isNull);
  });
}
