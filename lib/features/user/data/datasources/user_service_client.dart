import 'package:clarityrms/core/constants/api_endpoints_user.dart';
import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/features/user/data/models/user_model.dart';

class UserServiceClient extends ApiClient {
  /// Create from an existing Dio instance (used for per-Dio interceptor migration).
  UserServiceClient.fromDio(super.dio) : super.fromDio();

  Future<UserModel> getProfile() async {
    final response = await dio.get(UserEndpoints.userProfile);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
