import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void incrementCounter() {
    emit(state.copyWith(counter: state.counter + 1));
  }

  void decrementCounter() {
    if (state.counter > 0) {
      emit(state.copyWith(counter: state.counter - 1));
    }
  }

  // Ví dụ hàm bất đồng bộ
  Future<void> fetchData() async {
    emit(state.copyWith(isDataLoading: true));
    await Future.delayed(const Duration(seconds: 1)); // Giả lập API call
    // Giả sử API call thành công, không làm gì cả hoặc cập nhật dữ liệu.
    emit(state.copyWith(isDataLoading: false));
  }
}
