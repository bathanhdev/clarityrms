import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements SimpleUseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  @override
  Future<bool> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}
