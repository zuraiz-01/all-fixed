import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/bloc/test_result_bloc/test_results_tab_state.dart';
import 'package:flutter/material.dart';

class TestResultTabCubit extends Cubit<TestResultTabState> {
  TestResultTabCubit()
      : super(
          TestResultTabState(
            testResultTabType: TestResultTabType.appTest,
            testResultTabPageController: PageController(),
          ),
        );

  void changeAppointmentType(TestResultTabType type) {
    log('Changing Appointment page');
    switch (type) {
      case TestResultTabType.appTest:
        if (state.testResultTabPageController.page != 0) {
          state.testResultTabPageController.jumpToPage(
            0,
          );
        }
        break;
      case TestResultTabType.clinicalResult:
        if (state.testResultTabPageController.page != 1) {
          state.testResultTabPageController.jumpToPage(
            1,
          );
        }
        break;
    }
    emit(
      state.copyWith(
        testResultTabType: type,
      ),
    );
  }

  void updateAppointmentType(TestResultTabType type) {
    emit(
      state.copyWith(
        testResultTabType: type,
      ),
    );
  }
}
