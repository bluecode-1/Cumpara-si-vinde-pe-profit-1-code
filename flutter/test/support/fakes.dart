import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:profitnet/core/location/location_service.dart';

/// [LocationService] returning a canned result.
final class FakeLocationService implements LocationService {
  FakeLocationService(this.result);

  LocationResult result;
  int calls = 0;

  @override
  Future<LocationResult> currentLocation() async {
    calls++;
    return result;
  }
}

/// What a [ScriptedHttpAdapter] answers to one request.
final class ScriptedResponse {
  const ScriptedResponse(this.status, [this.body]);

  final int status;
  final Object? body;
}

/// HTTP adapter that records requests and answers from a callback, so the
/// whole Dio pipeline (interceptors included) runs without a network.
final class ScriptedHttpAdapter implements HttpClientAdapter {
  ScriptedHttpAdapter(this._respond);

  final Future<ScriptedResponse> Function(RequestOptions options) _respond;

  /// Every request seen, in order.
  final List<RequestOptions> requests = <RequestOptions>[];

  /// The `Authorization` header of each request at the time it was sent
  /// (the options object itself is reused, and mutated, by retries).
  final List<String?> authorizations = <String?>[];

  Iterable<RequestOptions> requestsTo(String path) =>
      requests.where((RequestOptions request) => request.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    authorizations.add(options.headers['Authorization'] as String?);
    final ScriptedResponse response = await _respond(options);
    return ResponseBody.fromString(
      response.body == null ? '' : jsonEncode(response.body),
      response.status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[
          response.status >= 400
              ? 'application/problem+json'
              : Headers.jsonContentType,
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
