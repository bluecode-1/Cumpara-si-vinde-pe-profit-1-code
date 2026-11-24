// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(logoutRepository)
final logoutRepositoryProvider = LogoutRepositoryProvider._();

final class LogoutRepositoryProvider
    extends
        $FunctionalProvider<
          LogoutRepository,
          LogoutRepository,
          LogoutRepository
        >
    with $Provider<LogoutRepository> {
  LogoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<LogoutRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutRepository create(Ref ref) {
    return logoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutRepository>(value),
    );
  }
}

String _$logoutRepositoryHash() => r'a67748007b32db0ec83bd9d2de2fba4505746d3b';
