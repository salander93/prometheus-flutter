import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  // On web, fall back to simple in-memory storage
  // because flutter_secure_storage can fail on some
  // browsers.
  static final Map<String, String> _webFallback = {};
  static bool _useWebFallback = false;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> _write(String key, String value) async {
    if (kIsWeb && _useWebFallback) {
      _webFallback[key] = value;
      return;
    }
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      if (kIsWeb) {
        _useWebFallback = true;
        _webFallback[key] = value;
      }
    }
  }

  Future<String?> _read(String key) async {
    if (kIsWeb && _useWebFallback) {
      return _webFallback[key];
    }
    try {
      return await _storage.read(key: key);
    } catch (_) {
      if (kIsWeb) {
        _useWebFallback = true;
        return _webFallback[key];
      }
      return null;
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _write(_accessTokenKey, accessToken);
    await _write(_refreshTokenKey, refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    await _write(_accessTokenKey, accessToken);
  }

  Future<String?> getAccessToken() async {
    return _read(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _read(_refreshTokenKey);
  }

  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null;
  }

  Future<void> clearTokens() async {
    if (kIsWeb && _useWebFallback) {
      _webFallback.clear();
      return;
    }
    try {
      await _storage.deleteAll();
    } catch (_) {
      if (kIsWeb) {
        _useWebFallback = true;
        _webFallback.clear();
      }
    }
  }
}
