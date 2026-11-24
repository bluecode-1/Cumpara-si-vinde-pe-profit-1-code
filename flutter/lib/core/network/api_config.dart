import 'package:flutter/foundation.dart';
import 'package:profitnet/core/network/certificate_pinning.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_config.g.dart';

/// Where and how the app talks to the backend.
final class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.useFakeApi = false,
    this.pinning = CertificatePinning.disabled,
  });

  /// Reads the compile-time configuration:
  ///
  ///  * `--dart-define=API_BASE_URL=...` (defaults to the staging host);
  ///  * `--dart-define=FAKE_API=true` serves `api/fixtures` instead of calling
  ///    the network. The flag is ignored in release builds.
  const ApiConfig.fromEnvironment()
    : baseUrl = const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.staging.profitnet.example/v1',
      ),
      useFakeApi = !kReleaseMode && const bool.fromEnvironment('FAKE_API'),
      pinning = CertificatePinning.disabled;

  final String baseUrl;

  /// Development only. The fake is additionally guarded by `kReleaseMode`
  /// where it is installed, so it is tree-shaken out of release builds.
  final bool useFakeApi;

  final CertificatePinning pinning;
}

@Riverpod(keepAlive: true)
ApiConfig apiConfig(Ref ref) => const ApiConfig.fromEnvironment();
