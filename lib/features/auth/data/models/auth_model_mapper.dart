import 'package:clarityrms/features/auth/data/models/auth_model.dart';
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';

extension AuthModelMapper on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
