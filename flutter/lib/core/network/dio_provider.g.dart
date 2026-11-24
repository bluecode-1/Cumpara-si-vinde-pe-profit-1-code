// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The in-memory backend used in demo mode; `null` in every other case.
///
/// `kReleaseMode` is a compile-time constant, so in release builds this is
/// constant-folded to `null` and the fake is removed by tree shaking.

@ProviderFor(fakeApi)
final fakeApiProvider = FakeApiProvider._();

/// The in-memory backend used in demo mode; `null` in every other case.
///
/// `kReleaseMode` is a compile-time constant, so in release builds this is
/// constant-folded to `null` and the fake is removed by tree shaking.

final class FakeApiProvider
    extends
        $FunctionalProvider<
          FakeApiInterceptor?,
          FakeApiInterceptor?,
          FakeApiInterceptor?
        >
    with $Provider<FakeApiInterceptor?> {
  /// The in-memory backend used in demo mode; `null` in every other case.
  ///
  /// `kReleaseMode` is a compile-time constant, so in release builds this is
  /// constant-folded to `null` and the fake is removed by tree shaking.
  FakeApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeApiHash();

  @$internal
  @override
  $ProviderElement<FakeApiInterceptor?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FakeApiInterceptor? create(Ref ref) {
    return fakeApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeApiInterceptor? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeApiInterceptor?>(value),
    );
  }
}

String _$fakeApiHash() => r'c5fb944af6889ffec0d93bcb295f46b328be8c6f';

/// The HTTP client used by every feature.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// The HTTP client used by every feature.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// The HTTP client used by every feature.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'ab4be312815cd6be924a799d9792fe50c5ab6846';
