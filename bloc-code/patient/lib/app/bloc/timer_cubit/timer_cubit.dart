import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<int> {
  Timer? _timer;

  TimerCubit() : super(5);

  void startStopwatch() {
    resetStopwatch();
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (state > 0) {
        emit(state - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetStopwatch() {
    _timer?.cancel();
    emit(5);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
