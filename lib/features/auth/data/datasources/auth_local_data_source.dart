import 'package:clarityrms/core/constants/secure_storage_constants.dart';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAccessToken(String token);

  Future<String> getCachedAccessToken();

  Future<void> cacheRefreshToken(String token);

  Future<String> getCachedRefreshToken();

  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  Future<void> _cacheToken(String key, String token) async {
    try {
      await secureStorage.write(key: key, value: token);
    } catch (e) {
      throw StorageWriteException(
        message: 'Không thể lưu trữ Token vào Secure Storage: $e',
      );
    }
  }

  Future<String> _getCachedToken(String key) async {
    try {
      final token = await secureStorage.read(key: key);
      if (token == null || token.isEmpty) {
        throw const CacheException(
          message: 'Không tìm thấy Token trong Secure Storage.',
        );
      }
      return token;
    } catch (e) {
      if (e is CacheException) rethrow;

      throw const CacheException(
        message: 'Lỗi khi truy xuất Token từ Secure Storage.',
      );
    }
  }

  @override
  Future<void> cacheAccessToken(String token) =>
      _cacheToken(SecureStorageConstants.accessTokenKey, token);

  @override
  Future<void> cacheRefreshToken(String token) =>
      _cacheToken(SecureStorageConstants.refreshTokenKey, token);

  @override
  Future<String> getCachedAccessToken() =>
      _getCachedToken(SecureStorageConstants.accessTokenKey);

  @override
  Future<String> getCachedRefreshToken() =>
      _getCachedToken(SecureStorageConstants.refreshTokenKey);

  @override
  Future<void> clearAuthData() async {
    await secureStorage.delete(key: SecureStorageConstants.accessTokenKey);
    await secureStorage.delete(key: SecureStorageConstants.refreshTokenKey);
  }
}
