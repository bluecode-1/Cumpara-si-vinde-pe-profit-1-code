import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:profitnet/core/security/auth_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_store.g.dart';

/// Persists the session tokens. The only implementation used in production
/// is backed by the platform Keystore / Keychain.
abstract interface class TokenStore {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

/// [TokenStore] on `flutter_secure_storage` (Android Keystore-encrypted
/// preferences, iOS Keychain).
final class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              // Readable by background tasks after the first unlock, never
              // migrated to another device through backups.
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  static const String _accessKey = 'session.access_token';
  static const String _refreshKey = 'session.refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final String? access = await _storage.read(key: _accessKey);
    final String? refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) {
      return null;
    }
    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}

/// Volatile [TokenStore] for tests and integration runs that must start from
/// a clean, device-independent state.
final class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore([this._tokens]);

  AuthTokens? _tokens;

  @override
  Future<AuthTokens?> read() async => _tokens;

  @override
  Future<void> write(AuthTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore();
