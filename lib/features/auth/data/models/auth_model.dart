import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends Equatable {
  // Access Token dùng để truy cập các API được bảo vệ
  @JsonKey(name: 'access_token')
  final String accessToken;

  // Refresh Token dùng để làm mới Access Token khi hết hạn
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  // Thời gian hết hạn của Access Token (thường là giây)
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  const AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  // Factory constructor để deserialize JSON thành AuthModel
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  // Phương thức to JSON để serialize AuthModel thành JSON
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  @override
  List<Object> get props => [accessToken, refreshToken, expiresIn];
}
