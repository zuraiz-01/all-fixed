import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'appointment_filter_state.dart';

class AppointmentFilterCubit extends Cubit<AppointmentFilterState> {
  AppointmentFilterCubit()
      : super(
          AppointmentFilterState(
            appointmentType: AppointmentFilterType.past,
            appointmentPageController: PageController(),
          ),
        );

  void changeAppointmentType(AppointmentFilterType type) {
    log('Changing Appointment page');
    // switch (type) {
    //   case AppointmentFilterType.past:
    //     if (state.appointmentPageController.page != 0) {
    //       // state.appointmentPageController.jumpToPage(
    //       //   0,
    //       // );
    //     }
    //     break;
    //   case AppointmentFilterType.upcoming:
    //     if (state.appointmentPageController.page != 1) {
    //       // state.appointmentPageController.jumpToPage(
    //       //   1,
    //       // );
    //     }
    //     break;
    //   case AppointmentFilterType.followup:
    //     if (state.appointmentPageController.page != 2) {
    //       // state.appointmentPageController.jumpToPage(
    //       //   2,
    //       // );
    //     }
    //     break;
    // }
    emit(
      state.copyWith(
        appointmentType: type,
      ),
    );
  }

  void updateAppointmentType(AppointmentFilterType type) {
    emit(
      state.copyWith(
        appointmentType: type,
      ),
    );
  }
}
