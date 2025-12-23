// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'medication_tracker_cubit.dart';

class MedicationTrackerState extends Equatable {
  bool isLoading;
  MedicationTrackerApiResponseData? medicationTrackerData;
  MedicationTrackerState({
    required this.isLoading,
    this.medicationTrackerData,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];

  MedicationTrackerState copyWith({
    bool? isLoading,
    MedicationTrackerApiResponseData? medicationTrackerData,
  }) {
    return MedicationTrackerState(
      isLoading: isLoading ?? this.isLoading,
      medicationTrackerData: medicationTrackerData ?? this.medicationTrackerData,
    );
  }
}

class MedicationTrackerSuccess extends MedicationTrackerState {
  String toastMessage;
  MedicationTrackerSuccess({
    required super.isLoading,
    required this.toastMessage,
    super.medicationTrackerData,
  });
}

class MedicationTrackerFailed extends MedicationTrackerState {
  String errorMessage;
  MedicationTrackerFailed({
    required super.isLoading,
    required this.errorMessage,
    super.medicationTrackerData,
  });
}
