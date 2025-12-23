import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

part 'favorites_doctor_state.dart';

class FavoritesDoctorCubit extends Cubit<FavoritesDoctorState> {
  FavoritesDoctorCubit()
      : super(
          FavoritesDoctorState(
            isLoading: false,
            doctorListResponseData: null,
          ),
        );

  void resetState() {
    emit(
      FavoritesDoctorState(
        isLoading: false,
        doctorListResponseData: state.doctorListResponseData,
      ),
    );
  }

  Future<void> refreshData() async {
    log('refreshing data...');
    getFavoritesDoctorList();
  }

  Future<void> getFavoritesDoctorList() async {
    emit(FavoritesDoctorState(isLoading: true, doctorListResponseData: null));
    final favoritesDoctorApiResponse = await ApiRepo().getFavoritesDoctor();
    if (favoritesDoctorApiResponse.status == 'success') {
      emit(
        FavoritesDoctorSuccessful(
          isLoading: false,
          toastMessage: favoritesDoctorApiResponse.message!,
          doctorListResponseData: favoritesDoctorApiResponse.doctorListResponseData,
        ),
      );
    } else {
      emit(
        FavoritesDoctorFailed(
          isLoading: false,
          errorMessage: favoritesDoctorApiResponse.message!,
          doctorListResponseData: favoritesDoctorApiResponse.doctorListResponseData,
        ),
      );
    }
  }

  Future<void> removeDoctorFromFavoritesDoctorList(String doctorId, int index) async {
    emit(FavoritesDoctorState(isLoading: true, doctorListResponseData: state.doctorListResponseData));
    final favoritesDoctorApiResponse = await ApiRepo().removeDoctorFromFavoritesDoctorList(doctorId);

    if (favoritesDoctorApiResponse.status == 'success') {
      List<Doctor>? tempDoctorList = state.doctorListResponseData?.doctorList;

      if (tempDoctorList != null) {
        Doctor? doc = tempDoctorList.firstWhere((element) => element.id == doctorId);
        int index = tempDoctorList.indexWhere((element) => element.id == doc.id);
        tempDoctorList.removeAt(index);
        state.doctorListResponseData!.doctorList = tempDoctorList;
      }
      log(tempDoctorList.toString());
      emit(
        FavoritesDoctorSuccessful(
          isLoading: false,
          toastMessage: favoritesDoctorApiResponse.message!,
          doctorListResponseData: state.doctorListResponseData,
        ),
      );
    } else {
      emit(
        FavoritesDoctorFailed(
          isLoading: false,
          errorMessage: favoritesDoctorApiResponse.message!,
          doctorListResponseData: state.doctorListResponseData,
        ),
      );
    }
  }

  Future<void> addDoctorToFavoritesDoctorList(String doctorId) async {
    emit(FavoritesDoctorState(isLoading: true, doctorListResponseData: state.doctorListResponseData));
    final favoritesDoctorApiResponse = await ApiRepo().addDoctorToFavoritesDoctorList(doctorId);
    if (favoritesDoctorApiResponse.status == 'success') {
      getFavoritesDoctorList();
    } else {
      emit(
        FavoritesDoctorFailed(
          isLoading: false,
          errorMessage: favoritesDoctorApiResponse.message!,
          doctorListResponseData: state.doctorListResponseData,
        ),
      );
    }
  }
}
