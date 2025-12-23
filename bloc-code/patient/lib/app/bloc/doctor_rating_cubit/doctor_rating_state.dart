// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'doctor_rating_cubit.dart';

class DoctorRatingState extends Equatable {
  String doctorId;
  bool isLoading;
  GetDoctorRatingModel? getDoctorRatingModel;
  DoctorRatingState({
    required this.doctorId,
    required this.isLoading,
    this.getDoctorRatingModel,
  });

  @override
  List<Object> get props => [
        doctorId,
        doctorId.hashCode,
        isLoading,
        getDoctorRatingModel.hashCode,
      ];

  DoctorRatingState copyWith({
    String? doctorId,
    bool? isLoading,
    GetDoctorRatingModel? getDoctorRatingModel,
  }) {
    return DoctorRatingState(
      doctorId: doctorId ?? this.doctorId,
      isLoading: isLoading ?? this.isLoading,
      getDoctorRatingModel: getDoctorRatingModel ?? this.getDoctorRatingModel,
    );
  }
}
