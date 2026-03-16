import 'package:clarityrms/core/infrastructure/network/api_response_handler.dart';
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';

/// Interface cho Auth Repository. Nằm ở Tầng Domain.
/// Tất cả các phương thức mạng trả về [APIResponse], các phương thức cục bộ trả về kết quả thuần túy.
abstract class AuthRepository {
  // 1. LOGIN
  Future<APIResponse<AuthEntity>> login({
    required String username,
    required String password,
  });

  // 2. REFRESH TOKEN
  Future<APIResponse<AuthEntity>> refreshToken(String refreshToken);

  // 3. CHECK AUTH STATUS
  Future<bool> checkAuthStatus();

  // 4. LOGOUT
  Future<APIResponse<void>> logout();
}
