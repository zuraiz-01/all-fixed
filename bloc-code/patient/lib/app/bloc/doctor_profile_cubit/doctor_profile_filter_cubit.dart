import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:flutter/material.dart';

part 'doctor_profile_filter_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileFilterState> {
  DoctorProfileCubit()
      : super(
          DoctorProfileFilterState(
            doctorProfileFilterType: DoctorProfileFilterType.info,
            filterPageController: PageController(),
            doctor: null,
          ),
        );

  void changeFilterType(DoctorProfileFilterType type) {
    switch (type) {
      case DoctorProfileFilterType.info:
        if (state.filterPageController.page != 0) {
          state.filterPageController.jumpToPage(
            0,
          );
        }
        break;
      case DoctorProfileFilterType.experience:
        if (state.filterPageController.page != 1) {
          state.filterPageController.jumpToPage(
            1,
          );
        }
        break;
      case DoctorProfileFilterType.feedback:
        if (state.filterPageController.page != 2) {
          state.filterPageController.jumpToPage(
            2,
          );
        }
        break;
    }
    emit(
      state.copyWith(
        doctorProfileFilterType: type,
      ),
    );
  }

  void updateFilterType(DoctorProfileFilterType type) {
    emit(
      state.copyWith(
        doctorProfileFilterType: type,
      ),
    );
  }

  void updateSelectedDoctor(Doctor doctor) {
    emit(
      state.copyWith(
        doctor: doctor,
      ),
    );
  }
}
