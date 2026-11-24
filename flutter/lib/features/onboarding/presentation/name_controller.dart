import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/core/session/onboarding_step.dart';
import 'package:profitnet/core/session/session_controller.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/display_name_validator.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'name_controller.freezed.dart';
part 'name_controller.g.dart';

@freezed
abstract class NameState with _$NameState {
  const factory NameState({
    @Default(false) bool isSubmitting,

    /// The name failed the 2-40 characters rule; no request was made.
    @Default(false) bool isInvalidLength,
    AppError? error,
  }) = _NameState;
}

/// Step 5: validates and saves the display name.
@riverpod
class NameController extends _$NameController {
  @override
  NameState build() => const NameState();

  void inputChanged() {
    if (state.isInvalidLength || state.error != null) {
      state = const NameState();
    }
  }

  Future<void> submit(String rawInput) async {
    if (state.isSubmitting) {
      return;
    }
    final String? name = DisplayNameValidator.normalize(rawInput);
    if (name == null) {
      state = const NameState(isInvalidLength: true);
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final SessionController session = ref.read(
      sessionControllerProvider.notifier,
    );
    state = const NameState(isSubmitting: true);
    try {
      final UserProfile profile = await repository.updateDisplayName(name);
      await session.advanceTo(
        OnboardingStep.location,
        displayName: profile.displayName,
      );
    } on AppError catch (error) {
      if (ref.mounted) {
        state = NameState(error: error);
      }
    }
  }
}
