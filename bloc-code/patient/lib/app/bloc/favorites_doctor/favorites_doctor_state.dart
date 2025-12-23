part of 'favorites_doctor_cubit.dart';

class FavoritesDoctorState extends Equatable {
  bool isLoading;
  DoctorListResponseData? doctorListResponseData;

  FavoritesDoctorState({
    required this.isLoading,
    required this.doctorListResponseData,
  });

  @override
  List<Object> get props => [
        isLoading,
    doctorListResponseData.hashCode,
      ];

  FavoritesDoctorState copyWith({
    bool? isLoading,
    DoctorListResponseData? doctorListResponseData,List<Doctor>? doctorList
  }) {
    return FavoritesDoctorState(
      isLoading: isLoading ?? this.isLoading,
      doctorListResponseData: doctorListResponseData ?? this.doctorListResponseData,
    );
  }
}

class FavoritesDoctorInitial extends FavoritesDoctorState {
  FavoritesDoctorInitial({required super.isLoading, required super.doctorListResponseData});
}

class FavoritesDoctorSuccessful extends FavoritesDoctorState {
  FavoritesDoctorSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.doctorListResponseData,
  });

  String toastMessage;
}

class FavoritesDoctorFailed extends FavoritesDoctorState {
  FavoritesDoctorFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.doctorListResponseData,
  });

  String errorMessage;
}

class RemoveDoctorFromFavoritesDoctorSuccessful extends FavoritesDoctorState {
  RemoveDoctorFromFavoritesDoctorSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.doctorListResponseData,
  });

  String toastMessage;
}

class AddDoctorToFavoritesDoctorSuccessful extends FavoritesDoctorState {
  AddDoctorToFavoritesDoctorSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.doctorListResponseData,
  });

  String toastMessage;
}
