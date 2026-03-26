import 'package:flutter/foundation.dart';
import 'env.dart';
import 'package:clarityrms/core/utils/log_util.dart';

enum Environment { dev, prod }

class AppConfig {
  static AppConfig? _instance;

  final Environment environment;
  final String baseUrl;
  final String authBaseUrl;
  final String userBaseUrl;
  final String firebaseApiKey;

  const AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.authBaseUrl,
    required this.userBaseUrl,
    required this.firebaseApiKey,
  });

  static AppConfig getInstance() {
    if (_instance == null) {
      throw Exception(
        "AppConfig must be initialized before calling getInstance.",
      );
    }
    return _instance!;
  }

  static void initialize({required Environment environment}) {
    if (_instance != null) {
      debugPrint("AppConfig has already been initialized.");
      return;
    }

    final String finalBaseUrl;
    final String finalFirebaseApiKey;

    String finalAuthBaseUrl;
    String finalUserBaseUrl;
    switch (environment) {
      case Environment.dev:
        finalBaseUrl = EnvDev.baseUrl;
        finalAuthBaseUrl = EnvDev.authBaseUrl;
        finalUserBaseUrl = EnvDev.userBaseUrl;
        finalFirebaseApiKey = EnvDev.firebaseApiKey;
        Log.d('App environment: DEV', name: 'CONFIG');
        break;

      case Environment.prod:
        finalBaseUrl = EnvProd.baseUrl;
        finalAuthBaseUrl = EnvProd.authBaseUrl;
        finalUserBaseUrl = EnvProd.userBaseUrl;
        finalFirebaseApiKey = EnvProd.firebaseApiKey;
        Log.d('App environment: PROD', name: 'CONFIG');
        break;
    }

    _instance = AppConfig._(
      environment: environment,
      baseUrl: finalBaseUrl,
      authBaseUrl: finalAuthBaseUrl,
      userBaseUrl: finalUserBaseUrl,
      firebaseApiKey: finalFirebaseApiKey,
    );
    Log.d('Resolved baseUrl: $finalBaseUrl', name: 'CONFIG');
  }

  bool get isProduction => environment == Environment.prod;
  bool get isDevelopment => environment == Environment.dev;

  String getServiceBaseUrl(String serviceName) {
    switch (serviceName) {
      case 'auth':
        return authBaseUrl;
      case 'user':
        return userBaseUrl;
      default:
        return baseUrl;
    }
  }
}
