import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:profitnet/core/error/app_error.dart';
import 'package:profitnet/features/onboarding/di/onboarding_providers.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:profitnet/features/onboarding/domain/onboarding_repository.dart';
import 'package:profitnet/features/onboarding/domain/phone_number_normalizer.dart';
import 'package:profitnet/features/onboarding/presentation/pending_otp_challenge.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'phone_controller.freezed.dart';
part 'phone_controller.g.dart';

@freezed
abstract class PhoneState with _$PhoneState {
  const factory PhoneState({
    @Default(false) bool isSubmitting,

    /// The input failed local validation; no request was made.
    @Default(false) bool isInvalidNumber,

    /// The request failed.
    AppError? error,

    /// Set once the code has been sent: the screen moves on to Code.
    OtpChallenge? sentChallenge,
  }) = _PhoneState;
}

/// Step 2: validates the number and requests the SMS code.
@riverpod
class PhoneController extends _$PhoneController {
  @override
  PhoneState build() => const PhoneState();

  /// Clears a previous error as soon as the user edits the number.
  void inputChanged() {
    if (state.isInvalidNumber || state.error != null) {
      state = const PhoneState();
    }
  }

  Future<void> submit(String rawInput) async {
    if (state.isSubmitting) {
      return;
    }
    final String? phone = PhoneNumberNormalizer.normalize(rawInput);
    if (phone == null) {
      state = const PhoneState(isInvalidNumber: true);
      return;
    }
    final OnboardingRepository repository = ref.read(
      onboardingRepositoryProvider,
    );
    final PendingOtpChallenge pending = ref.read(
      pendingOtpChallengeProvider.notifier,
    );
    state = const PhoneState(isSubmitting: true);
    try {
      final OtpChallenge challenge = await repository.requestOtp(phone);
      pending.set(challenge);
      if (ref.mounted) {
        state = PhoneState(sentChallenge: challenge);
      }
    } on AppError catch (error) {
      if (ref.mounted) {
        state = PhoneState(error: error);
      }
    }
  }
}
