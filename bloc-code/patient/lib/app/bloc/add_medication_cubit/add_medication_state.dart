part of 'add_medication_cubit.dart';

class AddMedicationState extends Equatable {
  AddMedicationState({
    required this.timeList,
    required this.dayList,
    required this.isLoading,
  });
  List<String> timeList;
  List<String> dayList;
  bool isLoading;

  @override
  List<Object> get props => [
        timeList,
        timeList.length,
        dayList,
        dayList.length,
        isLoading,
      ];

  AddMedicationState copyWith({
    List<String>? timeList,
    List<String>? dayList,
    bool? isLoading,
  }) {
    return AddMedicationState(
      timeList: timeList ?? this.timeList,
      dayList: dayList ?? this.dayList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MedicationUpdateErrorState extends AddMedicationState {
  String errorMessage;
  MedicationUpdateErrorState({
    required super.timeList,
    required super.dayList,
    required super.isLoading,
    required this.errorMessage,
  });
}

class MedicationUpdateSuccessState extends AddMedicationState {
  String toastMessage;
  MedicationUpdateSuccessState({
    required super.timeList,
    required super.dayList,
    required super.isLoading,
    required this.toastMessage,
  });
}
