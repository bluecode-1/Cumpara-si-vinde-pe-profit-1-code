import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profitnet/core/network/certificate_pinning.dart';

void main() {
  final Uint8List certificate = Uint8List.fromList(<int>[1, 2, 3, 4]);

  test('is disabled until real pins exist', () {
    expect(CertificatePinning.disabled.isEnabled, isFalse);
    expect(CertificatePinning.disabled.isTrusted(certificate), isTrue);

    final Dio dio = Dio();
    final HttpClientAdapter before = dio.httpClientAdapter;
    CertificatePinning.disabled.applyTo(dio);
    expect(dio.httpClientAdapter, same(before));
  });

  test('when enabled, only pinned fingerprints are trusted', () {
    final CertificatePinning pinning = CertificatePinning(
      sha256Fingerprints: <String>{sha256.convert(certificate).toString()},
    );
    expect(pinning.isEnabled, isTrue);
    expect(pinning.isTrusted(certificate), isTrue);
    expect(pinning.isTrusted(Uint8List.fromList(<int>[9, 9])), isFalse);

    final Dio dio = Dio();
    final HttpClientAdapter before = dio.httpClientAdapter;
    pinning.applyTo(dio);
    expect(dio.httpClientAdapter, isNot(same(before)));
  });
}
