import 'package:equatable/equatable.dart';

enum SocialAuthProvider { google, facebook }

class SocialLoginParams extends Equatable {
  final SocialAuthProvider provider;
  final String token;
  final String? email;
  final String? displayName;

  const SocialLoginParams({
    required this.provider,
    required this.token,
    this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [provider, token, email, displayName];
}
