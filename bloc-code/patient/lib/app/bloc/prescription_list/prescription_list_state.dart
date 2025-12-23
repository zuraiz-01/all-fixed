import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';

import '../../api/model/prescription_list_response_model.dart';

class PrescriptionListState extends Equatable {
  bool isLoading;
  PrescriptionListData? prescriptionListData;
  List<Prescription>? prescriptionList;
  MyPatient patient;

  PrescriptionListState({
    required this.isLoading,
    required this.prescriptionListData,
    required this.patient,
    required this.prescriptionList,
  });

  @override
  List<Object> get props => [
        isLoading,
    prescriptionList.hashCode,
        patient.id!,
      ];

  PrescriptionListState copyWith({
    bool? isLoading,
    PrescriptionListData? prescriptionListData,
    MyPatient? patient,
    List<Prescription>? prescriptionList
  }) {
    return PrescriptionListState(
        isLoading: isLoading ?? this.isLoading, prescriptionListData: prescriptionListData ?? this.prescriptionListData, patient: patient ?? this.patient,

        prescriptionList: prescriptionList ?? this.prescriptionList);
  }
}

class PrescriptionListInitial extends PrescriptionListState {
  PrescriptionListInitial({required super.isLoading, required super.prescriptionListData, required super.patient, required super.prescriptionList});
}

class PrescriptionListSuccessful extends PrescriptionListState {
  PrescriptionListSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.prescriptionListData,
    required super.patient, required super.prescriptionList,
  });

  String toastMessage;
}

class PrescriptionListFailed extends PrescriptionListState {
  PrescriptionListFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.prescriptionListData,
    required super.patient, required super.prescriptionList,
  });

  String errorMessage;
}

class DeletePrescriptionSuccessful extends PrescriptionListState {
  DeletePrescriptionSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.prescriptionListData,
    required super.patient, required super.prescriptionList,
  });

  String toastMessage;
}

class DeletePrescriptionFailed extends PrescriptionListState {
  DeletePrescriptionFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.prescriptionListData,
    required super.patient, required super.prescriptionList,
  });

  String errorMessage;
}
