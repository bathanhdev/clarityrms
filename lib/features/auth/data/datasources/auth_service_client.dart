import 'dart:convert';

import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/constants/api_endpoints_auth.dart';
import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

class AuthServiceClient extends ApiClient {
  AuthServiceClient({String? baseUrl, List<Interceptor>? interceptors})
    : super(
        baseUrl ?? AppConfig.getInstance().authBaseUrl,
        contentType: 'application/json',
        interceptors: interceptors,
      );

  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final data = {'username': username, 'password': password};
    final response = await dio.post(
      AuthEndpoints.login,
      data: jsonEncode(data),
      options: Options(extra: {'ignoredToken': true}),
    );
    return AuthModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthModel> refreshToken({required String refreshToken}) async {
    final response = await dio.post(
      AuthEndpoints.refreshToken,
      data: jsonEncode({'refresh_token': refreshToken}),
      options: Options(extra: {'ignoredToken': true}),
    );
    return AuthModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await dio.post(AuthEndpoints.logout);
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await dio.get(AuthEndpoints.me);
    return response.data as Map<String, dynamic>;
  }
}
