// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'patient_list_cubit.dart';

class PatientListState extends Equatable {
  bool isLoading;
  XFile selectedProfile;

  List<MyPatient> myPatientList;
  PatientListState({
    required this.isLoading,
    required this.myPatientList,
    required this.selectedProfile,
  });

  @override
  List<Object> get props => [
        myPatientList.length,
        isLoading,
        selectedProfile.path,
      ];

  PatientListState copyWith({
    bool? isLoading,
    List<MyPatient>? myPatientList,
    XFile? selectedProfile,
  }) {
    return PatientListState(
      isLoading: isLoading ?? this.isLoading,
      myPatientList: myPatientList ?? this.myPatientList,
      selectedProfile: selectedProfile ?? this.selectedProfile,
    );
  }
}

class PatientListFetchedSuccessfully extends PatientListState {
  String toastMessage;
  PatientListFetchedSuccessfully({
    required super.isLoading,
    required super.myPatientList,
    required this.toastMessage,
    required super.selectedProfile,
  });
}

class PatientListFetchFailed extends PatientListState {
  String errorMessage;
  PatientListFetchFailed({
    required super.isLoading,
    required super.myPatientList,
    required this.errorMessage,
    required super.selectedProfile,
  });
}
