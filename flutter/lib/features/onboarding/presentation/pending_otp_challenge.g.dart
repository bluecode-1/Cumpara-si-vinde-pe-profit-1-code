// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_otp_challenge.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The code request shared by the Phone and Code steps. `null` when no code
/// is waiting to be entered (the router then keeps the user off Code).

@ProviderFor(PendingOtpChallenge)
final pendingOtpChallengeProvider = PendingOtpChallengeProvider._();

/// The code request shared by the Phone and Code steps. `null` when no code
/// is waiting to be entered (the router then keeps the user off Code).
final class PendingOtpChallengeProvider
    extends $NotifierProvider<PendingOtpChallenge, OtpChallenge?> {
  /// The code request shared by the Phone and Code steps. `null` when no code
  /// is waiting to be entered (the router then keeps the user off Code).
  PendingOtpChallengeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingOtpChallengeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingOtpChallengeHash();

  @$internal
  @override
  PendingOtpChallenge create() => PendingOtpChallenge();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpChallenge? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpChallenge?>(value),
    );
  }
}

String _$pendingOtpChallengeHash() =>
    r'7a3c86700a0192ecc6fda5058e30f673d7896092';

/// The code request shared by the Phone and Code steps. `null` when no code
/// is waiting to be entered (the router then keeps the user off Code).

abstract class _$PendingOtpChallenge extends $Notifier<OtpChallenge?> {
  OtpChallenge? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OtpChallenge?, OtpChallenge?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OtpChallenge?, OtpChallenge?>,
              OtpChallenge?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
