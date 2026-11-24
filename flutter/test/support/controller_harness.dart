import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profitnet/core/database/drift_session_progress_store.dart';
import 'package:profitnet/core/location/location_service.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:profitnet/core/security/token_store.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/core/session/session_progress_store.dart';
import 'package:profitnet/core/session/session_state.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';

import 'fakes.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

const AuthTokens testTokens = AuthTokens(
  accessToken: 'access',
  refreshToken: 'refresh',
);

/// Everything a controller or screen test needs: a mocked repository and
/// in-memory session storage, wired into Riverpod overrides.
final class Harness {
  Harness({LocationResult location = const LocationPermissionDenied()})
    : locationService = FakeLocationService(location);

  final MockOnboardingRepository repository = MockOnboardingRepository();
  final InMemoryTokenStore tokenStore = InMemoryTokenStore();
  final InMemorySessionProgressStore progressStore =
      InMemorySessionProgressStore();
  final FakeLocationService locationService;

  List<Override> get overrides => <Override>[
    onboardingRepositoryProvider.overrideWithValue(repository),
    tokenStoreProvider.overrideWithValue(tokenStore),
    sessionProgressStoreProvider.overrideWithValue(progressStore),
    locationServiceProvider.overrideWithValue(locationService),
  ];

  late final ProviderContainer container = ProviderContainer.test(
    overrides: overrides,
  );

  SessionState get session => container.read(sessionControllerProvider);

  /// Puts the session in the state right after phone verification, at
  /// [step].
  Future<void> signInAt(OnboardingStep step, {String displayName = ''}) async {
    final SessionController controller = container.read(
      sessionControllerProvider.notifier,
    );
    await controller.signIn(
      tokens: testTokens,
      displayName: displayName,
      onboardingCompleted: false,
    );
    await controller.advanceTo(step);
  }
}
