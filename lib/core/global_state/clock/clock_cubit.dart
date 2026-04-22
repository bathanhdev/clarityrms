import 'dart:async';

import 'package:bloc/bloc.dart';

/// Global clock state that emits the current time and stays aligned to minute boundaries.
class ClockCubit extends Cubit<DateTime> {
  Timer? _timer;

  ClockCubit() : super(DateTime.now()) {
    _scheduleNextTick();
  }

  void refreshNow() {
    emit(DateTime.now());
    _scheduleNextTick();
  }

  void _scheduleNextTick() {
    _timer?.cancel();

    final now = DateTime.now();
    final nextTick = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );
    final delay = nextTick.difference(now);

    _timer = Timer(delay, () {
      if (isClosed) return;
      emit(DateTime.now());
      _scheduleNextTick();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
