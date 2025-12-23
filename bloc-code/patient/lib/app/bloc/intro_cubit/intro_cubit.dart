import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit()
      : super(
          IntroIdle(
            currentPageIndex: 0,
          ),
        );

  void changePage({required int pageIndex}) {
    emit(
      IntroIdle(
        currentPageIndex: pageIndex,
      ),
    );
  }
}
