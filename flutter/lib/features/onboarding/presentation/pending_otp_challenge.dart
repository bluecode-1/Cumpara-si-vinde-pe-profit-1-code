import 'package:profitnet/features/onboarding/domain/onboarding_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_otp_challenge.g.dart';

/// The code request shared by the Phone and Code steps. `null` when no code
/// is waiting to be entered (the router then keeps the user off Code).
@Riverpod(keepAlive: true)
class PendingOtpChallenge extends _$PendingOtpChallenge {
  @override
  OtpChallenge? build() => null;

  void set(OtpChallenge challenge) => state = challenge;

  void clear() => state = null;
}
