// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'appointment_filter_cubit.dart';

enum AppointmentFilterType {
  past,
  upcoming,
  followup,
}

class AppointmentFilterState extends Equatable {
  AppointmentFilterType appointmentType;
  PageController appointmentPageController;
  AppointmentFilterState({
    required this.appointmentType,
    required this.appointmentPageController,
  });

  @override
  List<Object> get props => [
        appointmentType,
        appointmentPageController,
      ];

  AppointmentFilterState copyWith({
    AppointmentFilterType? appointmentType,
    PageController? appointmentPageController,
  }) {
    return AppointmentFilterState(
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentPageController: appointmentPageController ?? this.appointmentPageController,
    );
  }
}
