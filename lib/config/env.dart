import 'package:envied/envied.dart';

part 'env.g.dart';

abstract class BaseEnv {
  static String baseUrl = '';
  static String authBaseUrl = '';
  static String userBaseUrl = '';
  static String firebaseApiKey = '';
}

@Envied(path: 'assets/env/.env.dev', obfuscate: true)
class EnvDev extends BaseEnv {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _EnvDev.baseUrl;
  @EnviedField(varName: 'AUTH_BASE_URL')
  static String authBaseUrl = _EnvDev.authBaseUrl;
  @EnviedField(varName: 'USER_BASE_URL')
  static String userBaseUrl = _EnvDev.userBaseUrl;
  @EnviedField(varName: 'FIREBASE_API_KEY')
  static String firebaseApiKey = _EnvDev.firebaseApiKey;
}

@Envied(path: 'assets/env/.env.prod', obfuscate: true)
class EnvProd extends BaseEnv {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _EnvProd.baseUrl;
  @EnviedField(varName: 'AUTH_BASE_URL')
  static String authBaseUrl = _EnvProd.authBaseUrl;
  @EnviedField(varName: 'USER_BASE_URL')
  static String userBaseUrl = _EnvProd.userBaseUrl;
  @EnviedField(varName: 'FIREBASE_API_KEY')
  static String firebaseApiKey = _EnvProd.firebaseApiKey;
}
