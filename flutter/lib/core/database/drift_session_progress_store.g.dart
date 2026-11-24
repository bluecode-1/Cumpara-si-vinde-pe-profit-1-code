// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_session_progress_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionProgressStore)
final sessionProgressStoreProvider = SessionProgressStoreProvider._();

final class SessionProgressStoreProvider
    extends
        $FunctionalProvider<
          SessionProgressStore,
          SessionProgressStore,
          SessionProgressStore
        >
    with $Provider<SessionProgressStore> {
  SessionProgressStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProgressStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionProgressStoreHash();

  @$internal
  @override
  $ProviderElement<SessionProgressStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionProgressStore create(Ref ref) {
    return sessionProgressStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionProgressStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionProgressStore>(value),
    );
  }
}

String _$sessionProgressStoreHash() =>
    r'644e8e6cda893ddcbcf5bc5ac5ebbbe4ab7589ea';
