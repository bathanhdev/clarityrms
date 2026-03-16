import 'package:clarityrms/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clarityrms/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';
import 'package:clarityrms/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:clarityrms/core/di/locator.dart';

/// Đăng ký tất cả các phụ thuộc của Auth Feature.
void registerAuthFeatureDependencies() {
  // Register dependencies for Auth feature

  // 1. DATA SOURCES
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // 2. REPOSITORY
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // 3. USE CASES
  sl.registerFactory(() => LoginUserUseCase(repository: sl()));
  sl.registerFactory(() => CheckAuthStatusUseCase(repository: sl()));
  sl.registerFactory(() => LogoutUserUseCase(repository: sl()));

  // Auth feature registrations complete
}
