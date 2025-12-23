// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'doctor_profile_filter_cubit.dart';

enum DoctorProfileFilterType {
  info,
  experience,
  feedback,
}

class DoctorProfileFilterState extends Equatable {
  DoctorProfileFilterType doctorProfileFilterType;
  PageController filterPageController;
  Doctor? doctor;
  DoctorProfileFilterState({
    required this.doctorProfileFilterType,
    required this.filterPageController,
    required this.doctor,
  });

  @override
  List<Object> get props => [
        doctorProfileFilterType,
        filterPageController,
      ];

  DoctorProfileFilterState copyWith({DoctorProfileFilterType? doctorProfileFilterType, PageController? filterPageController, Doctor? doctor}) {
    return DoctorProfileFilterState(
      doctorProfileFilterType: doctorProfileFilterType ?? this.doctorProfileFilterType,
      filterPageController: filterPageController ?? this.filterPageController,
      doctor: doctor ?? this.doctor,
    );
  }
}
