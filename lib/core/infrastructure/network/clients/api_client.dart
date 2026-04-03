import 'package:dio/dio.dart';

/// Base client cho mọi microservice API.
class ApiClient {
  final Dio dio;

  /// Construct an `ApiClient` from an existing `Dio` instance.
  ApiClient.fromDio(this.dio);

  /// Lấy HTTP client (Dio) để gọi API.
  Dio get client => dio;
}
