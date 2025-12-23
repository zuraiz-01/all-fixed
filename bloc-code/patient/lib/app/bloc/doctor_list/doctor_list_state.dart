part of 'doctor_list_cubit.dart';

class DoctorListState extends Equatable {
  bool isLoading;
  DoctorListResponseData? doctorListResponseData;
  int? selectedDoctorIndex;
  List<Specialty>? specialtyList;
  Specialty? selectedSpecialty;
  String? currentRating;
  int? minConsultationFee;
  int? maxConsultationFee;
  ScrollController? scrollController;
  int? pageNo = 1;
  int? lastPage = -11;
  List<Doctor>? doctorList;

  DoctorListState({
    required this.isLoading,
    required this.doctorListResponseData,
    required this.specialtyList,
    required this.selectedSpecialty,
    required this.currentRating,
    required this.minConsultationFee,
    required this.maxConsultationFee,
    required this.scrollController,
    required this.pageNo,
    required this.lastPage,
    required this.doctorList,
  });

  @override
  List<Object> get props => [
        isLoading,
        selectedSpecialty.hashCode,
        specialtyList!.length,
        specialtyList!.hashCode,
        selectedDoctorIndex.hashCode,
        currentRating.hashCode,
        minConsultationFee.hashCode,
        maxConsultationFee.hashCode,
        scrollController.hashCode,
        pageNo.hashCode,
        doctorList.hashCode,
        lastPage.hashCode,
      ];

  DoctorListState copyWith({
    bool? isLoading,
    DoctorListResponseData? doctorListResponseData,
    List<Specialty>? specialtyList,
    Specialty? selectedSpecialty,
    String? currentRating,
    int? minConsultationFee,
    int? maxConsultationFee,
    int? lastPage,
    int? pageNo,
    ScrollController? scrollController,
    List<Doctor>? doctorList,
  }) {
    return DoctorListState(
        isLoading: isLoading ?? this.isLoading,
        doctorListResponseData: doctorListResponseData ?? this.doctorListResponseData,
        specialtyList: specialtyList ?? this.specialtyList,
        selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
        currentRating: currentRating ?? this.currentRating,
        minConsultationFee: minConsultationFee ?? this.minConsultationFee,
        maxConsultationFee: maxConsultationFee ?? this.maxConsultationFee,
        scrollController: scrollController ?? this.scrollController,
        pageNo: pageNo ?? this.pageNo,
        lastPage: lastPage ?? this.lastPage,
        doctorList: doctorList ?? this.doctorList);
  }
}

class DoctorListInitial extends DoctorListState {
  DoctorListInitial(
      {required super.isLoading,
      required super.doctorListResponseData,
      required super.specialtyList,
      required super.selectedSpecialty,
      required super.currentRating,
      required super.minConsultationFee,
      required super.maxConsultationFee, required super.scrollController, required super.pageNo, required super.lastPage, required super.doctorList});
}

class DoctorListSuccessful extends DoctorListState {
  DoctorListSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.doctorListResponseData,
    required super.specialtyList,
    required super.selectedSpecialty,
    required super.currentRating,
    required super.minConsultationFee,
    required super.maxConsultationFee, required super.scrollController, required super.pageNo, required super.lastPage, required super.doctorList,
  });

  String toastMessage;
}

class DoctorListFailed extends DoctorListState {
  DoctorListFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.doctorListResponseData,
    required super.specialtyList,
    required super.selectedSpecialty,
    required super.currentRating,
    required super.minConsultationFee,
    required super.maxConsultationFee, required super.scrollController, required super.pageNo, required super.lastPage, required super.doctorList,
  });

  String errorMessage;
}

class SpecialtyListSuccessful extends DoctorListState {
  SpecialtyListSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.doctorListResponseData,
    required super.specialtyList,
    required super.selectedSpecialty,
    required super.currentRating,
    required super.minConsultationFee,
    required super.maxConsultationFee, required super.scrollController, required super.pageNo, required super.lastPage, required super.doctorList,
  });

  String toastMessage;
}

class SpecialtyListFailed extends DoctorListState {
  SpecialtyListFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.doctorListResponseData,
    required super.specialtyList,
    required super.selectedSpecialty,
    required super.currentRating,
    required super.minConsultationFee,
    required super.maxConsultationFee, required super.scrollController, required super.pageNo, required super.lastPage, required super.doctorList,
  });

  String errorMessage;
}
