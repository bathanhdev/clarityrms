// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:clarityrms/core/infrastructure/network/api_response_handler.dart';
import 'package:clarityrms/core/infrastructure/network/network_handler.dart';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/core/infrastructure/network/network_info.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clarityrms/features/auth/data/models/auth_model.dart';
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';
import 'package:clarityrms/features/auth/data/models/auth_model_mapper.dart';
import 'package:clarityrms/core/utils/log_util.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ==========================================================
  // 1. LOGIN
  // ==========================================================
  @override
  Future<APIResponse<AuthEntity>> login({
    required String username,
    required String password,
  }) async {
    return handleNetworkCall<AuthEntity>(
      networkInfo: networkInfo,
      apiCall: () async {
        final AuthModel authModel = await remoteDataSource.login(
          username,
          password,
        );
        await localDataSource.cacheAccessToken(authModel.accessToken);
        await localDataSource.cacheRefreshToken(authModel.refreshToken);
        return authModel.toEntity();
      },
    );
  }

  // ==========================================================
  // 2. REFRESH TOKEN
  // ==========================================================
  @override
  Future<APIResponse<AuthEntity>> refreshToken(String refreshToken) async {
    return handleNetworkCall<AuthEntity>(
      networkInfo: networkInfo,
      apiCall: () async {
        final AuthModel authModel = await remoteDataSource.refreshToken(
          refreshToken,
        );
        await localDataSource.cacheAccessToken(authModel.accessToken);
        await localDataSource.cacheRefreshToken(authModel.refreshToken);
        return authModel.toEntity();
      },
    );
  }

  // ==========================================================
  // 3. CHECK AUTH STATUS
  // ==========================================================
  @override
  Future<bool> checkAuthStatus() async {
    try {
      final token = await localDataSource.getCachedAccessToken();
      // Trả về true nếu có token
      return token.isNotEmpty;
    } on CacheException {
      // Nếu có lỗi Cache (ví dụ: lỗi parsing local data), coi như chưa đăng nhập
      return false;
    } catch (e, st) {
      Log.e(
        'Error checking auth status',
        error: e,
        stackTrace: st,
        name: 'AUTH_REPOSITORY',
      );
      // Bất kỳ lỗi nào khác, coi như chưa đăng nhập
      return false;
    }
  }

  // ==========================================================
  // 4. LOGOUT
  // ==========================================================
  @override
  Future<APIResponse<void>> logout() async {
    return handleNetworkCall<void>(
      networkInfo: networkInfo,
      apiCall: () async {
        // Bắt buộc: Xóa Token cục bộ
        await localDataSource.clearAuthData();
        // Không cần return giá trị vì APIResponse<void>
      },
    );
  }
}
