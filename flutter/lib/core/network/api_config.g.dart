// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiConfig)
final apiConfigProvider = ApiConfigProvider._();

final class ApiConfigProvider
    extends $FunctionalProvider<ApiConfig, ApiConfig, ApiConfig>
    with $Provider<ApiConfig> {
  ApiConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiConfigHash();

  @$internal
  @override
  $ProviderElement<ApiConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiConfig create(Ref ref) {
    return apiConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiConfig>(value),
    );
  }
}

String _$apiConfigHash() => r'1903e9aae195c7cd542af2bde9c8c81ec48bf1e8';
