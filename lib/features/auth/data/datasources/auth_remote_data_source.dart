import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_service_client.dart';
import 'package:clarityrms/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

/// Interface định nghĩa các hoạt động giao tiếp với API Auth.
abstract class AuthRemoteDataSource {
  /// Gọi API để đăng nhập và lấy token.
  /// @throws [ServerException] nếu phản hồi lỗi (4xx, 5xx).
  Future<AuthModel> login(String username, String password);

  /// Gọi API để làm mới token.
  /// @throws [ServerException]
  Future<AuthModel> refreshToken(String refreshToken);

  /// Gọi API để đăng xuất (Hủy token trên server).
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthServiceClient serviceClient;

  AuthRemoteDataSourceImpl({required this.serviceClient});

  // 1. LOGIN
  @override
  Future<AuthModel> login(String username, String password) async {
    try {
      return await serviceClient.login(username: username, password: password);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi kết nối Server',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

  // 2. REFRESH TOKEN
  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      return await serviceClient.refreshToken(refreshToken: refreshToken);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Refresh token lỗi kết nối',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi làm mới token không xác định: $e');
    }
  }

  // 3. LOGOUT
  @override
  Future<void> logout() async {
    try {
      return await serviceClient.logout();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi kết nối khi đăng xuất',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi đăng xuất không xác định: $e');
    }
  }
}
