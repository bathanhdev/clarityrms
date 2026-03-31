import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:clarityrms/core/utils/log_util.dart';

// ==========================================================
// 1. STATE
// ==========================================================

/// Lớp trạng thái cơ sở cho NetworkCubit
abstract class NetworkState extends Equatable {
  final bool isConnected;
  const NetworkState(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

/// Trạng thái khi có kết nối mạng
class NetworkConnected extends NetworkState {
  const NetworkConnected() : super(true);
}

/// Trạng thái khi mất kết nối mạng
class NetworkDisconnected extends NetworkState {
  const NetworkDisconnected() : super(false);
}

// ==========================================================
// 2. CUBIT
// ==========================================================

/// Quản lý trạng thái kết nối mạng toàn cục
class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  StreamSubscription? _subscription;

  // Khởi tạo ban đầu với trạng thái MẤT KẾT NỐI (an toàn nhất)
  NetworkCubit({required this.networkInfo})
    : super(const NetworkDisconnected()) {
    Log.d('Đang bắt đầu lắng nghe trạng thái mạng...');
    _observeNetworkStatus();
    _checkInitialStatus();
  }

  // Kiểm tra trạng thái ban đầu một lần
  Future<void> _checkInitialStatus() async {
    final isInitialConnected = await networkInfo.isConnected;
    if (isInitialConnected) {
      emit(const NetworkConnected());
    }
  }

  // Lắng nghe Stream thay đổi từ NetworkInfo
  void _observeNetworkStatus() {
    // Lắng nghe Stream<bool> từ NetworkInfoImpl
    _subscription = networkInfo.connectionStatusStream.listen((isConnected) {
      if (isConnected) {
        // Chỉ phát ra trạng thái MỚI nếu khác trạng thái HIỆN TẠI
        if (state is NetworkDisconnected) {
          emit(const NetworkConnected());
          Log.d('Mạng: Đã kết nối lại (Connected).');
        }
      } else {
        if (state is NetworkConnected) {
          emit(const NetworkDisconnected());
          Log.w('Mạng: Đã mất kết nối (Disconnected)!');
        }
      }
    });
  }

  /// Override close để hủy subscription khi Cubit bị đóng
  @override
  Future<void> close() {
    _subscription?.cancel();
    Log.d('Đã hủy lắng nghe trạng thái mạng.');
    return super.close();
  }
}
