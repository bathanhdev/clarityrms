import 'package:clarityrms/core/constants/secure_storage_constants.dart';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interface định nghĩa các hoạt động đọc/ghi dữ liệu Auth cục bộ.
abstract class AuthLocalDataSource {
  /// Lưu trữ Access Token vào bộ nhớ bảo mật.
  Future<void> cacheAccessToken(String token);

  /// Lấy Access Token từ bộ nhớ bảo mật.
  /// @throws [CacheException] nếu không tìm thấy token.
  Future<String> getCachedAccessToken();

  /// Lưu trữ Refresh Token vào bộ nhớ bảo mật.
  Future<void> cacheRefreshToken(String token);

  /// Lấy Refresh Token từ bộ nhớ bảo mật.
  /// @throws [CacheException] nếu không tìm thấy token.
  Future<String> getCachedRefreshToken();

  /// Xóa tất cả token khi đăng xuất.
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  // ==========================================================
  // HÀM LƯU TRỮ CHUNG
  // ==========================================================

  Future<void> _cacheToken(String key, String token) async {
    try {
      await secureStorage.write(key: key, value: token);
    } catch (e) {
      throw StorageWriteException(
        message: 'Không thể lưu trữ Token vào Secure Storage: $e',
      );
    }
  }

  // ==========================================================
  // HÀM TRUY XUẤT CHUNG
  // ==========================================================

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
      // Nếu là CacheException của chúng ta, ném lại.
      if (e is CacheException) rethrow;
      // Bất kỳ lỗi đọc/giải mã nào khác ném CacheException chung.
      throw const CacheException(
        message: 'Lỗi khi truy xuất Token từ Secure Storage.',
      );
    }
  }

  // ==========================================================
  // TRIỂN KHAI INTERFACE
  // ==========================================================

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
