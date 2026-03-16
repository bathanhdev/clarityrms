import 'package:equatable/equatable.dart';

/// AuthEntity đại diện cho đối tượng token ở Tầng Domain.
/// Nó độc lập với cơ chế lấy dữ liệu (API/Cache).
class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, expiresIn];
}
