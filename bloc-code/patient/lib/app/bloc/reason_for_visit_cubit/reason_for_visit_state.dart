// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reason_for_visit_cubit.dart';

class ReasonForVisitState extends Equatable {
  List<XFile> eyePhotoList;
  List<File> reportAndPrescriptionList;
  bool isLoading;
  AppointmentMarkAsPaidApiResponseModel? appointmentMarkAsPaidApiResponseModel;
  Appointment? selectedAppointment;

  ReasonForVisitState({
    required this.eyePhotoList,
    required this.reportAndPrescriptionList,
    required this.isLoading,
    this.appointmentMarkAsPaidApiResponseModel,
    this.selectedAppointment,
  });

  @override
  List<Object> get props => [
        eyePhotoList.length,
        reportAndPrescriptionList.length,
        eyePhotoList,
        reportAndPrescriptionList,
        isLoading,
        selectedAppointment.hashCode,
        selectedAppointment?.totalAmount ?? 00,
        selectedAppointment?.vat ?? 00,
        selectedAppointment?.grandTotal ?? 00,
      ];

  ReasonForVisitState copyWith({
    List<XFile>? eyePhotoList,
    List<File>? reportAndPrescriptionList,
    bool? isLoading,
  }) {
    return ReasonForVisitState(
      eyePhotoList: eyePhotoList ?? this.eyePhotoList,
      reportAndPrescriptionList: reportAndPrescriptionList ?? this.reportAndPrescriptionList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReasonForVisitSuccessState extends ReasonForVisitState {
  String toastMessage;
  String gatewayUrl;

  @override
  List<Object> get props => [
        gatewayUrl.hashCode,
      ];

  ReasonForVisitSuccessState({
    required super.eyePhotoList,
    required super.reportAndPrescriptionList,
    required super.isLoading,
    required this.toastMessage,
    required super.selectedAppointment,
    required super.appointmentMarkAsPaidApiResponseModel,
    required this.gatewayUrl,
  });
}

class ReasonForVisitErrorState extends ReasonForVisitState {
  String errorMessage;
  ReasonForVisitErrorState({
    required super.eyePhotoList,
    required super.reportAndPrescriptionList,
    required super.isLoading,
    required this.errorMessage,
    required super.selectedAppointment,
  });
}
