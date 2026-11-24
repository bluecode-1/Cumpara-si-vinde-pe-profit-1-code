import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/database/app_database.dart';
import 'package:profitnet/core/database/drift_session_progress_store.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:profitnet/core/session/session_state.dart';

const AuthTokens _tokens = AuthTokens(accessToken: 'a', refreshToken: 'r');

void main() {
  group('DriftSessionProgressStore', () {
    late AppDatabase database;
    late DriftSessionProgressStore store;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      store = DriftSessionProgressStore(database);
    });
    tearDown(() => database.close());

    test('is empty at first', () async {
      expect(await store.read(), isNull);
    });

    test('round-trips every step and the completed state', () async {
      for (final OnboardingStep? step in <OnboardingStep?>[
        ...OnboardingStep.values,
        null,
      ]) {
        final SessionProgress progress = SessionProgress(
          displayName: 'Ioana',
          pendingStep: step,
        );
        await store.write(progress);
        expect(await store.read(), progress);
      }
    });

    test('keeps a single row and can be cleared', () async {
      await store.write(const SessionProgress(displayName: 'A'));
      await store.write(const SessionProgress(displayName: 'B'));
      expect(
        await database.select(database.onboardingProgress).get(),
        hasLength(1),
      );
      await store.clear();
      expect(await store.read(), isNull);
    });
  });

  group('SessionController', () {
    late AppDatabase database;
    late InMemoryTokenStore tokenStore;

    /// A new container on the same storage simulates an app restart.
    ProviderContainer launch() => ProviderContainer.test(
      overrides: [
        tokenStoreProvider.overrideWithValue(tokenStore),
        appDatabaseProvider.overrideWithValue(database),
      ],
    );

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      tokenStore = InMemoryTokenStore();
    });
    tearDown(() => database.close());

    test('starts signed out', () async {
      final ProviderContainer container = launch();
      await container.read(sessionControllerProvider.notifier).restore();
      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedOut(),
      );
    });

    test(
      'a new user starts onboarding at Consents; tokens are stored',
      () async {
        final ProviderContainer container = launch();
        await container
            .read(sessionControllerProvider.notifier)
            .signIn(
              tokens: _tokens,
              displayName: '',
              onboardingCompleted: false,
            );
        expect(
          container.read(sessionControllerProvider),
          const SessionState.signedIn(
            displayName: '',
            pendingStep: OnboardingStep.consents,
          ),
        );
        expect(await tokenStore.read(), _tokens);
      },
    );

    test('a returning user goes straight to Home', () async {
      final ProviderContainer container = launch();
      await container
          .read(sessionControllerProvider.notifier)
          .signIn(
            tokens: _tokens,
            displayName: 'Ioana',
            onboardingCompleted: true,
          );
      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedIn(displayName: 'Ioana'),
      );
    });

    test(
      'the flow resumes at the saved step after the app is killed',
      () async {
        final SessionController first = launch().read(
          sessionControllerProvider.notifier,
        );
        await first.signIn(
          tokens: _tokens,
          displayName: '',
          onboardingCompleted: false,
        );
        await first.advanceTo(OnboardingStep.name);
        await first.advanceTo(OnboardingStep.location, displayName: 'Ioana');

        final ProviderContainer relaunched = launch();
        await relaunched.read(sessionControllerProvider.notifier).restore();
        expect(
          relaunched.read(sessionControllerProvider),
          const SessionState.signedIn(
            displayName: 'Ioana',
            pendingStep: OnboardingStep.location,
          ),
        );

        await relaunched
            .read(sessionControllerProvider.notifier)
            .completeOnboarding();
        final ProviderContainer third = launch();
        await third.read(sessionControllerProvider.notifier).restore();
        expect(
          third.read(sessionControllerProvider),
          const SessionState.signedIn(displayName: 'Ioana'),
        );
      },
    );

    test('signing out clears tokens and progress', () async {
      final ProviderContainer container = launch();
      final SessionController controller = container.read(
        sessionControllerProvider.notifier,
      );
      await controller.signIn(
        tokens: _tokens,
        displayName: 'Ioana',
        onboardingCompleted: true,
      );
      await controller.signOut();

      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedOut(),
      );
      expect(await tokenStore.read(), isNull);
      expect(await DriftSessionProgressStore(database).read(), isNull);
    });

    test('tokens without local progress (e.g. Keychain surviving a '
        'reinstall) are discarded', () async {
      await tokenStore.write(_tokens);
      final ProviderContainer container = launch();
      await container.read(sessionControllerProvider.notifier).restore();
      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedOut(),
      );
      expect(await tokenStore.read(), isNull);
    });

    test('progress without tokens is discarded', () async {
      await DriftSessionProgressStore(database)
          .write(const SessionProgress(displayName: 'Ioana'));
      final ProviderContainer container = launch();
      await container.read(sessionControllerProvider.notifier).restore();
      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedOut(),
      );
      expect(await DriftSessionProgressStore(database).read(), isNull);
    });

    test('step changes are ignored when signed out', () async {
      final ProviderContainer container = launch();
      await container
          .read(sessionControllerProvider.notifier)
          .advanceTo(OnboardingStep.name);
      expect(
        container.read(sessionControllerProvider),
        const SessionState.signedOut(),
      );
    });
  });
}
