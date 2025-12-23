import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/repo/api_repo.dart';
import '../test_result/test_result_cubit.dart';

part 'app_eye_test_state.dart';

class AppEyeTestCubit extends Cubit<AppEyeTestState> {
  AppEyeTestCubit()
      : super(
          AppEyeTestState(
            isLefteye: true,
            leftEyeScore: "0/0",
            rightEyeScore: "0/0",
          ),
        );

  updateCurrentEye(bool isLefteye) {
    emit(
      state.copyWith(
        isLefteye: isLefteye,
      ),
    );
  }

  updateScore(String score) {
    if (state.isLefteye == true) {
      emit(
        state.copyWith(
          leftEyeScore: score,
        ),
      );
    } else {
      emit(
        state.copyWith(
          rightEyeScore: score,
        ),
      );
    }
    log("Current left eye score: ${state.leftEyeScore}");
    log("Current right eye score: ${state.rightEyeScore}");
  }

  resetScore() {
    emit(
      state.copyWith(
        isLefteye: true,
        leftEyeScore: "0/0",
        rightEyeScore: "0/0",
      ),
    );
  }

  updateAppEyeTestTestResult(BuildContext context,String patientId, Map<String, dynamic> parameters) {
    ApiRepo().updateAppEyeTestResults(
      patientId,
      parameters: parameters,
    );

  }
}
