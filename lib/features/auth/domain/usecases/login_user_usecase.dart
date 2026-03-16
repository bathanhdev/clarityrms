import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/core/infrastructure/network/api_response_handler.dart'; // MỚI
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/login_params.dart';

class LoginUserUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUserUseCase({required this.repository});

  @override
  Future<APIResponse<AuthEntity>> call(LoginParams params) async {
    return await repository.login(
      username: params.username,
      password: params.password,
    );
  }
}
