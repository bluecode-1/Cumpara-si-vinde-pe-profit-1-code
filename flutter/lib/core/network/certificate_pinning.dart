import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Certificate pinning by SHA-256 fingerprint of the server (leaf)
/// certificate, checked in the HTTP adapter in addition to the normal chain
/// validation.
///
/// The mechanism is in place but **disabled**: real pins can only be added
/// once the production domain and its certificates exist. Until then
/// [CertificatePinning.disabled] is used everywhere (and the fake API never
/// opens a connection at all).
final class CertificatePinning {
  const CertificatePinning({this.sha256Fingerprints = const <String>{}});

  static const CertificatePinning disabled = CertificatePinning();

  /// Lower-case hex SHA-256 digests of the DER-encoded pinned certificates.
  /// Keep at least two (current + backup) when enabling.
  final Set<String> sha256Fingerprints;

  bool get isEnabled => sha256Fingerprints.isNotEmpty;

  /// Whether a certificate with the given DER encoding is acceptable.
  bool isTrusted(Uint8List certificateDer) =>
      !isEnabled ||
      sha256Fingerprints.contains(sha256.convert(certificateDer).toString());

  /// Installs the validation on [dio]. A no-op while pinning is disabled.
  void applyTo(Dio dio) {
    if (!isEnabled) {
      return;
    }
    dio.httpClientAdapter = IOHttpClientAdapter(
      validateCertificate: (
        X509Certificate? certificate,
        String host,
        int port,
      ) => certificate != null && isTrusted(certificate.der),
    );
  }
}
