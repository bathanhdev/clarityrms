import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_service_client.dart';
import 'package:clarityrms/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';
import 'package:clarityrms/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/social_login_usecase.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';

void registerAuthModuleDependencies() {
  if (!sl.isRegistered<AuthLocalDataSource>()) {
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: sl()),
    );
  }

  if (!sl.isRegistered<AuthServiceClient>()) {
    // Create an ApiClient configured for the auth service and register
    // the service client using its Dio instance.
    final authApiClient = sl<ApiClientFactory>().createApiClient(
      baseUrl: sl<AppConfig>().authBaseUrl,
      authRequired: true,
    );

    sl.registerLazySingleton<AuthServiceClient>(
      () => AuthServiceClient.fromDio(authApiClient.client),
    );

    if (!sl.isRegistered<AuthRemoteDataSource>()) {
      sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceClient: sl()),
      );
    }

    if (!sl.isRegistered<AuthRepository>()) {
      sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl(),
          networkInfo: sl(),
        ),
      );
    }

    sl.registerFactory(() => LoginUserUseCase(repository: sl()));
    sl.registerFactory(() => SocialLoginUseCase(repository: sl()));
    sl.registerFactory(() => CheckAuthStatusUseCase(repository: sl()));
    sl.registerFactory(() => LogoutUserUseCase(repository: sl()));
  }
}
