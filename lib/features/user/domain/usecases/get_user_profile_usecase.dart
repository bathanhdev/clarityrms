import 'package:clarityrms/core/infrastructure/network/api_response_handler.dart';
import 'package:clarityrms/features/user/domain/entities/user_entity.dart';
import 'package:clarityrms/features/user/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<APIResponse<UserEntity>> call() async {
    return await repository.getUserProfile();
  }
}
