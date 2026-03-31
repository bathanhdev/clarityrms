import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/constants/api_endpoints_user.dart';
import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/user/data/models/user_model.dart';
import 'package:dio/dio.dart';

class UserServiceClient extends ApiClient {
  UserServiceClient({String? baseUrl, List<Interceptor>? interceptors})
    : super(
        baseUrl ?? AppConfig.getInstance().userBaseUrl,
        contentType: 'application/json',
        interceptors: interceptors,
      );

  Future<UserModel> getProfile() async {
    final response = await dio.get(UserEndpoints.userProfile);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
