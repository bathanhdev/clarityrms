import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_service_client.dart';
import 'package:clarityrms/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String username, String password);

  Future<AuthModel> socialLogin({
    required String provider,
    required String token,
    String? email,
    String? displayName,
  });

  Future<AuthModel> refreshToken(String refreshToken);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthServiceClient serviceClient;

  AuthRemoteDataSourceImpl({required this.serviceClient});

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

  @override
  Future<AuthModel> socialLogin({
    required String provider,
    required String token,
    String? email,
    String? displayName,
  }) async {
    try {
      return await serviceClient.socialLogin(
        provider: provider,
        token: token,
        email: email,
        displayName: displayName,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi kết nối Server',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

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
