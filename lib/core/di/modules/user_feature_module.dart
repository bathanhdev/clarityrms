import 'package:clarityrms/core/infrastructure/network/api_client_factory.dart';
import 'package:clarityrms/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clarityrms/features/user/data/datasources/user_service_client.dart';
import 'package:clarityrms/features/user/data/repositories/user_repository_impl.dart';
import 'package:clarityrms/features/user/domain/repositories/user_repository.dart';
import 'package:clarityrms/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/config/app_config.dart';

void registerUserFeatureDependencies() {
  if (!sl.isRegistered<UserServiceClient>()) {
    sl.registerLazySingleton<UserServiceClient>(
      () => UserServiceClient(
        baseUrl: sl<AppConfig>().userBaseUrl,
        interceptors: sl<ApiClientFactory>().getInterceptors(
          authRequired: true,
        ),
      ),
    );
  }

  if (!sl.isRegistered<UserRemoteDataSource>()) {
    sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(serviceClient: sl()),
    );
  }

  if (!sl.isRegistered<UserRepository>()) {
    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
  }

  sl.registerFactory(() => GetUserProfileUseCase(repository: sl()));
}
