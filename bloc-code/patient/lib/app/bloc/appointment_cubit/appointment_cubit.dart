import 'dart:convert';

import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_state.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit()
      : super(
          AppointmentState(
            isLoading: false,
            isAppointmentButtonLoading: false,
            getPastAppointmentApiResponse: null,
            getFollowupAppointmentApiResponse: null,
            getUpcomingAppointmentApiResponse: null,
            patient: MyPatient(
              id: "001",
            ),
            appointmentId: "",
          ),
        );

  Future<void> updatePatient(MyPatient patient) async {
    emit(state.copyWith(patient: patient));

    getAppointments();
  }

  Future<void> refreshScreen() async {
    getAppointments();
  }

  Future<void> saveAppointmentToStorage({
    required GetAppointmentApiResponse getPastAppointmentApiResponse,
    required GetAppointmentApiResponse getUpcomingAppointmentApiResponse,
    required GetAppointmentApiResponse getFollowupAppointmentApiResponse,
    required AppointmentState state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      state.patient.id! + "-getPastAppointmentApiResponse",
      jsonEncode(getPastAppointmentApiResponse.toJson()),
    );
    prefs.setString(
      state.patient.id! + "-getUpcomingAppointmentApiResponse",
      jsonEncode(getUpcomingAppointmentApiResponse.toJson()),
    );
    prefs.setString(
      state.patient.id! + "-getFollowupAppointmentApiResponse",
      jsonEncode(getFollowupAppointmentApiResponse.toJson()),
    );
  }

  Future<void> getAppointmentFromStorage({
    required AppointmentState state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? getPastAppointmentApiResponseJson = prefs.getString(
      state.patient.id! + "-getPastAppointmentApiResponse",
    );
    String? getUpcomingAppointmentApiResponseJson = prefs.getString(
      state.patient.id! + "-getUpcomingAppointmentApiResponse",
    );
    String? getFollowupAppointmentApiResponseJson = prefs.getString(
      state.patient.id! + "-getFollowupAppointmentApiResponse",
    );
    if (getPastAppointmentApiResponseJson != null &&
        getFollowupAppointmentApiResponseJson != null &&
        getUpcomingAppointmentApiResponseJson != null) {
      try {
        GetAppointmentApiResponse getPastAppointmentApiResponse =
            await GetAppointmentApiResponse.fromJson(
                jsonDecode(getPastAppointmentApiResponseJson));
        GetAppointmentApiResponse getUpcomingAppointmentApiResponse =
            await GetAppointmentApiResponse.fromJson(
                jsonDecode(getUpcomingAppointmentApiResponseJson));
        GetAppointmentApiResponse getFollowupAppointmentApiResponse =
            await GetAppointmentApiResponse.fromJson(
                jsonDecode(getFollowupAppointmentApiResponseJson));
        emit(
          AppointmentState(
            isLoading: false,
            getPastAppointmentApiResponse: getPastAppointmentApiResponse,
            getUpcomingAppointmentApiResponse:
                getUpcomingAppointmentApiResponse,
            getFollowupAppointmentApiResponse:
                getFollowupAppointmentApiResponse,
            patient: state.patient,
            isAppointmentButtonLoading: state.isAppointmentButtonLoading,
            appointmentId: state.appointmentId,
          ),
        );
      } catch (err) {}
    }
  }

  Future<void> getAppointments({
    bool loadFromStorage = true,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    if (loadFromStorage) {
      getAppointmentFromStorage(state: state);
    }

    GetAppointmentApiResponse getPastAppointmentApiResponse =
        await ApiRepo().getAppointments("past", state.patient.id!);
    GetAppointmentApiResponse getUpcomingAppointmentApiResponse =
        await ApiRepo().getAppointments("upcoming", state.patient.id!);
    GetAppointmentApiResponse getFollowupAppointmentApiResponse =
        await ApiRepo().getAppointments("followup", state.patient.id!);

    await saveAppointmentToStorage(
      getPastAppointmentApiResponse: getPastAppointmentApiResponse,
      getUpcomingAppointmentApiResponse: getUpcomingAppointmentApiResponse,
      getFollowupAppointmentApiResponse: getFollowupAppointmentApiResponse,
      state: state,
    );
    if (getPastAppointmentApiResponse.status == "success" &&
        getFollowupAppointmentApiResponse.status == "success" &&
        getUpcomingAppointmentApiResponse.status == "success") {
      emit(
        AppointmentState(
          isLoading: false,
          isAppointmentButtonLoading: state.isAppointmentButtonLoading,
          getPastAppointmentApiResponse: getPastAppointmentApiResponse,
          getUpcomingAppointmentApiResponse: getUpcomingAppointmentApiResponse,
          getFollowupAppointmentApiResponse: getFollowupAppointmentApiResponse,
          patient: state.patient,
          appointmentId: state.appointmentId,
        ),
      );
    } else {
      emit(
        AppointmentState(
          isLoading: false,
          getPastAppointmentApiResponse: null,
          getUpcomingAppointmentApiResponse: null,
          getFollowupAppointmentApiResponse: null,
          patient: state.patient,
          isAppointmentButtonLoading: state.isAppointmentButtonLoading,
          appointmentId: state.appointmentId,
        ),
      );
    }
  }

  Future<Doctor?> getDoctorByPhone(
    String phoneNumber,
    String appointmentId,
  ) async {
    emit(
      state.copyWith(
        isAppointmentButtonLoading: true,
        appointmentId: appointmentId,
      ),
    );
    Doctor? doc = await ApiRepo().getDoctorByPhoneNumber(phoneNumber);
    emit(
      state.copyWith(
        isAppointmentButtonLoading: false,
        appointmentId: appointmentId,
      ),
    );
    return doc;
  }

  Future<Doctor?> getDoctorById({
    required String appointmentId,
    required String docId,
  }) async {
    emit(
      state.copyWith(
        isAppointmentButtonLoading: true,
        appointmentId: appointmentId,
      ),
    );
    Doctor? doc = await ApiRepo().getDoctorById(docId);
    emit(
      state.copyWith(
        isAppointmentButtonLoading: false,
        appointmentId: appointmentId,
      ),
    );
    return doc;
  }

  Future<void> submitRating(
    Map<String, dynamic> params,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    ApiRepo()
        .submitRating(
      parameters: params,
    )
        .then((value) {
      context.read<AppointmentCubit>().getAppointments(
            loadFromStorage: false,
          );
      showToast(
        message: "Thanks for your feedback!",
        context: context,
      );
      NavigatorServices()
          .toPushAndRemoveUntil(context: context, widget: BottomNavBarScreen());
    });
  }
}
