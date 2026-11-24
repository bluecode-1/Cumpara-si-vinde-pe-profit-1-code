import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/home/di/home_providers.dart';
import 'package:profitnet/features/home/domain/logout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.freezed.dart';
part 'home_controller.g.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({@Default(false) bool isLoggingOut}) = _HomeState;
}

/// Placeholder Home: only knows how to log out.
@riverpod
class HomeController extends _$HomeController {
  @override
  HomeState build() => const HomeState();

  /// Calls `POST /auth/logout`, then clears the local session. The local
  /// session is cleared even when the server cannot be reached: a user who
  /// asks to leave must never stay signed in on the device.
  Future<void> logout() async {
    if (state.isLoggingOut) {
      return;
    }
    final LogoutRepository repository = ref.read(logoutRepositoryProvider);
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    state = const HomeState(isLoggingOut: true);
    try {
      await repository.logout();
    } on AppError {
      // Best effort; the refresh token expires server-side on its own.
    } finally {
      await session.signOut();
    }
  }
}
