import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/core/infrastructure/network/network.dart'; // MỚI
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';

class LogoutUserUseCase implements SimpleUseCase<APIResponse<void>, NoParams> {
  final AuthRepository repository;

  LogoutUserUseCase({required this.repository});

  @override
  Future<APIResponse<void>> call(NoParams params) async {
    return await repository.logout();
  }
}
