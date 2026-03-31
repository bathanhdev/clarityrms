import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clarityrms/features/user/domain/entities/user_entity.dart';
import 'package:clarityrms/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<APIResponse<UserEntity>> getUserProfile() async {
    return await handleNetworkCall<UserEntity>(
      networkInfo: networkInfo,
      apiCall: () async {
        final user = await remoteDataSource.getUserProfile();
        return user;
      },
    );
  }
}
