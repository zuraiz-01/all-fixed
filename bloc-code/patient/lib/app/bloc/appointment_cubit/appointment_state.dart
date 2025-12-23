// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';

import '../../api/model/appointment_doctor_model.dart';

class AppointmentState extends Equatable {
  bool isLoading;
  bool isAppointmentButtonLoading;
  String appointmentId;
  GetAppointmentApiResponse? getPastAppointmentApiResponse;
  GetAppointmentApiResponse? getUpcomingAppointmentApiResponse;
  GetAppointmentApiResponse? getFollowupAppointmentApiResponse;
  MyPatient patient;
  AppointmentState({
    required this.isLoading,
    required this.getPastAppointmentApiResponse,
    required this.getUpcomingAppointmentApiResponse,
    required this.getFollowupAppointmentApiResponse,
    required this.patient,
    required this.isAppointmentButtonLoading,
    required this.appointmentId,
  });

  @override
  List<Object> get props => [
        isLoading,
        patient.id!,
        getPastAppointmentApiResponse.hashCode,
        getUpcomingAppointmentApiResponse.hashCode,
        getFollowupAppointmentApiResponse.hashCode,
        isAppointmentButtonLoading,
        appointmentId,
      ];

  AppointmentState copyWith({
    bool? isLoading,
    bool? isAppointmentButtonLoading,
    String? appointmentId,
    GetAppointmentApiResponse? getPastAppointmentApiResponse,
    GetAppointmentApiResponse? getUpcomingAppointmentApiResponse,
    GetAppointmentApiResponse? getFollowupAppointmentApiResponse,
    MyPatient? patient,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isAppointmentButtonLoading: isAppointmentButtonLoading ?? this.isAppointmentButtonLoading,
      appointmentId: appointmentId ?? this.appointmentId,
      getPastAppointmentApiResponse: getPastAppointmentApiResponse ?? this.getPastAppointmentApiResponse,
      getUpcomingAppointmentApiResponse: getUpcomingAppointmentApiResponse ?? this.getUpcomingAppointmentApiResponse,
      getFollowupAppointmentApiResponse: getFollowupAppointmentApiResponse ?? this.getFollowupAppointmentApiResponse,
      patient: patient ?? this.patient,
    );
  }
}
