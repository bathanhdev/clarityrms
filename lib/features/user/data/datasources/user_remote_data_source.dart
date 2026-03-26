import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/features/user/data/datasources/user_service_client.dart';
import 'package:clarityrms/features/user/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> getUserProfile();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserServiceClient serviceClient;

  UserRemoteDataSourceImpl({required this.serviceClient});

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      return await serviceClient.getProfile();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Lỗi lấy thông tin user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Lỗi không xác định: $e');
    }
  }
}
