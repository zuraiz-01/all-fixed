import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/get_doctor_rating_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

part 'doctor_rating_state.dart';

class DoctorRatingCubit extends Cubit<DoctorRatingState> {
  DoctorRatingCubit()
      : super(
          DoctorRatingState(
            doctorId: "",
            isLoading: false,
          ),
        );

  void setDoctorId(String id) {
    emit(
      state.copyWith(
        doctorId: id,
      ),
    );
  }

  Future<void> getDoctorRating() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    GetDoctorRatingModel getDoctorRatingModel = await ApiRepo().getDoctorRating(
      state.doctorId,
    );
    emit(
      state.copyWith(
        isLoading: false,
        getDoctorRatingModel: getDoctorRatingModel,
      ),
    );
  }
}
