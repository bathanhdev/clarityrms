import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface (Abstraction) định nghĩa trách nhiệm kiểm tra kết nối mạng.
abstract class NetworkInfo {
  // Future<bool> để kiểm tra trạng thái tức thời (thường dùng trong Repository)
  Future<bool> get isConnected;

  /// Cung cấp một Stream để lắng nghe các thay đổi trạng thái kết nối
  /// Trả về true nếu CÓ kết nối, false nếu KHÔNG.
  Stream<bool> get connectionStatusStream;
}

/// Implementation (Concrete Class)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  // Hàm tiện ích để ánh xạ kết quả ConnectivityResult sang boolean
  bool _isConnectionValid(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn);
  }

  // 1. Phương thức kiểm tra tức thời (Future)
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return _isConnectionValid(connectivityResult);
  }

  // 2. Stream lắng nghe thay đổi (Stream)
  @override
  Stream<bool> get connectionStatusStream {
    // onConnectivityChanged trả về Stream của List<ConnectivityResult>
    return connectivity.onConnectivityChanged.map((results) {
      return _isConnectionValid(results);
    });
  }
}
