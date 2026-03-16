import 'package:clarityrms/core/constants/api_endpoints.dart';
import 'package:clarityrms/core/error/exceptions.dart';
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
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // ==========================================================
  // 1. LOGIN
  // ==========================================================
  @override
  Future<AuthModel> login(String username, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.statusMessage ?? 'Đăng nhập không thành công',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi kết nối Server',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }

  // ==========================================================
  // 2. REFRESH TOKEN
  // ==========================================================
  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken}, // Tùy thuộc vào API backend
      );

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else {
        // Nếu refresh token không hợp lệ (ví dụ: 401, 403), ném lỗi
        throw ServerException(
          message: response.statusMessage ?? 'Refresh token không hợp lệ',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Bắt lỗi Dio để ném ServerException
      throw ServerException(
        message: e.response?.data['message'] ?? 'Refresh token lỗi kết nối',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi làm mới token không xác định: $e');
    }
  }

  // ==========================================================
  // 3. LOGOUT
  // ==========================================================
  @override
  Future<void> logout() async {
    try {
      // API Logout thường là POST hoặc DELETE
      final response = await dio.post(
        ApiEndpoints.logout,
        // Có thể cần gửi Access Token hoặc Refresh Token trong body/header
      );

      // Thường API logout sẽ trả về 200/204 khi thành công
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Đăng xuất thành công, không cần trả về gì
        return;
      } else {
        // Xử lý các mã lỗi không mong muốn
        throw ServerException(
          message: response.statusMessage ?? 'Đăng xuất thất bại trên Server',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Bắt lỗi Dio. Thường lỗi logout sẽ không quan trọng bằng lỗi login/refresh
      // Nhưng vẫn nên ném lỗi để Repository biết và có thể ghi log.
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi kết nối khi đăng xuất',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi đăng xuất không xác định: $e');
    }
  }
}
