import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/social_login_params.dart';

class SocialLoginUseCase implements UseCase<AuthEntity, SocialLoginParams> {
  final AuthRepository repository;

  SocialLoginUseCase({required this.repository});

  @override
  Future<APIResponse<AuthEntity>> call(SocialLoginParams params) async {
    return await repository.socialLogin(params);
  }
}
