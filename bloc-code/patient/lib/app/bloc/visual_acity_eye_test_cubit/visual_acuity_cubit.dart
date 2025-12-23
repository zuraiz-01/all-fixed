import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:flutter/cupertino.dart';

part 'visual_acuity_state.dart';

class VisualAcuityCubit extends Cubit<VisualAcuityState> {
  VisualAcuityCubit()
      : super(
          VisualAcuityState(
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

  updateVisualAcuityTestResult(
      BuildContext context,
    String patientId,
  ) {
    ApiRepo().updateVisualAcuityTestResults(
      context,
      patientId,
      state.leftEyeScore,
      state.rightEyeScore,
    );
  }
}
