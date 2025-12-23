import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'homeframe_state.dart';

class HomeframeCubit extends Cubit<HomeframeState> {
  HomeframeCubit()
      : super(
          HomeframeIdle(
            currentPageIndex: 0,
          ),
        );

  void changePage({required int pageIndex}) {
    emit(
      HomeframeIdle(
        currentPageIndex: pageIndex,
      ),
    );
  }
}
