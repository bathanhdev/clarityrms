import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<APIResponse<UserEntity>> getUserProfile();
}
