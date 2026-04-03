// UI_TOKENS_IGNORE
class HomeState {
  final int counter;
  final bool isDataLoading;

  const HomeState({required this.counter, required this.isDataLoading});

  // Khởi tạo trạng thái ban đầu
  factory HomeState.initial() =>
      const HomeState(counter: 0, isDataLoading: false);

  // Phương thức copyWith để cập nhật trạng thái
  HomeState copyWith({int? counter, bool? isDataLoading}) {
    return HomeState(
      counter: counter ?? this.counter,
      isDataLoading: isDataLoading ?? this.isDataLoading,
    );
  }
}
