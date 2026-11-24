// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the session: tokens in the secure store plus the locally persisted
/// onboarding progress. Every change is written through before the state is
/// published, so a process death never loses a completed step.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// Owns the session: tokens in the secure store plus the locally persisted
/// onboarding progress. Every change is written through before the state is
/// published, so a process death never loses a completed step.
final class SessionControllerProvider
    extends $NotifierProvider<SessionController, SessionState> {
  /// Owns the session: tokens in the secure store plus the locally persisted
  /// onboarding progress. Every change is written through before the state is
  /// published, so a process death never loses a completed step.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState>(value),
    );
  }
}

String _$sessionControllerHash() => r'e6a837069765680591af73c07686ce2a67c3628f';

/// Owns the session: tokens in the secure store plus the locally persisted
/// onboarding progress. Every change is written through before the state is
/// published, so a process death never loses a completed step.

abstract class _$SessionController extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionState, SessionState>,
              SessionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
