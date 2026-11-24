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

String _$apiConfigHash() => r'd6209511fd6c681a128b18fbbb928cba9ad64f6a';
