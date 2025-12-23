import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/keys/shared_pref_keys.dart';

part 'doctor_list_state.dart';

class DoctorListCubit extends Cubit<DoctorListState> {
  DoctorListCubit()
      : super(
          DoctorListState(
              isLoading: false,
              doctorListResponseData: null,
              specialtyList: [],
              selectedSpecialty: null,
              currentRating: '',
              minConsultationFee: 0,
              maxConsultationFee: 1000,
              doctorList: [],
              scrollController: null,
              pageNo: 1,
              lastPage: -44),
        );

  Future<void> refreshData() async {
    log('refreshing data...');
    emit(state.copyWith(pageNo: 1, lastPage: -100, doctorList: []));
    getSearchDoctorList({});
  }

  initScrollListener() {
    state.scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    log(state.scrollController!.position.extentAfter.toString());
    if (state.scrollController!.position.extentAfter == 0) {
      log("true");
      log("state.pageNo ${state.pageNo}");
      log("state.lastPage ${state.lastPage}");
      // getTransactionsList();
      // increasePageNumber();
      if (state.pageNo! <= state.lastPage!) {
        if (!state.isLoading) {
          Map<String, String> parameters = Map<String, String>();
          parameters["page"] = "${state.pageNo}";
          // parameters["limit"] = "20";
          getSearchDoctorList(parameters);
        }
      }
    }
  }

  void updateCurrentRating(String selectedRating) {
    emit(state.copyWith(currentRating: selectedRating));
  }

  void resetState() {
    emit(
      DoctorListState(
          isLoading: false,
          doctorListResponseData: state.doctorListResponseData,
          specialtyList: state.specialtyList,
          selectedSpecialty: null,
          currentRating: '',
          minConsultationFee: 0,
          maxConsultationFee: 1000,
          doctorList: [],
          scrollController: state.scrollController,
          pageNo: 1,
          lastPage: -11),
    );
    getSearchDoctorList({});
  }

  void updateSelectedSpecialty(Specialty selectedSpecialty) {
    emit(state.copyWith(selectedSpecialty: selectedSpecialty));
  }

  void updateConsultationFee(
      {required int minConsultationFee, required int maxConsultationFee}) {
    log("minConsultationFee $minConsultationFee");
    log("maxConsultationFee $maxConsultationFee");
    emit(state.copyWith(
        minConsultationFee: minConsultationFee,
        maxConsultationFee: maxConsultationFee));
  }

  Future<void> getSearchDoctorList(Map<String, String> parameters,
      {bool isFromSearch = false}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emit(
      DoctorListState(
          isLoading: true,
          doctorListResponseData: state.doctorListResponseData,
          specialtyList: state.specialtyList,
          selectedSpecialty: state.selectedSpecialty,
          currentRating: state.currentRating,
          minConsultationFee: state.minConsultationFee,
          maxConsultationFee: state.maxConsultationFee,
          doctorList: state.doctorList,
          scrollController: state.scrollController,
          pageNo: state.pageNo,
          lastPage: state.lastPage),
    );

    if (!isFromSearch) {
      String? doctorListString =
          await preferences.getString(getAllDoctorListKey);

      if (doctorListString != null) {
        try {
          DoctorListResponseModel doctorList =
              DoctorListResponseModel.fromJson(jsonDecode(doctorListString));
          emitDoctorListFromApi(doctorList, isFromSearch);
        } catch (e) {}
      }
    }

    DoctorListResponseModel apiRes =
        await ApiRepo().getPatientDoctor(parameters);
    log("Doctor List: ${apiRes.toJson()}");
    preferences.setString(getAllDoctorListKey, jsonEncode(apiRes.toJson()));
    emitDoctorListFromApi(apiRes, isFromSearch);
  }

  Future<void> getSpecialtiesList() async {
    emit(
      DoctorListState(
          isLoading: true,
          doctorListResponseData: state.doctorListResponseData,
          specialtyList: state.specialtyList,
          selectedSpecialty: state.selectedSpecialty,
          currentRating: state.currentRating,
          minConsultationFee: state.minConsultationFee,
          maxConsultationFee: state.maxConsultationFee,
          doctorList: state.doctorList,
          scrollController: state.scrollController,
          pageNo: state.pageNo,
          lastPage: state.lastPage),
    );
    final apiRes = await ApiRepo().getSpecialtiesList();
    if (apiRes.status == 'success') {
      emit(
        SpecialtyListSuccessful(
            isLoading: false,
            toastMessage: apiRes.message!,
            doctorListResponseData: state.doctorListResponseData,
            specialtyList: apiRes.specialtyList,
            selectedSpecialty: state.selectedSpecialty,
            currentRating: state.currentRating,
            minConsultationFee: state.minConsultationFee,
            maxConsultationFee: state.maxConsultationFee,
            doctorList: state.doctorList,
            scrollController: state.scrollController,
            pageNo: state.pageNo,
            lastPage: state.lastPage),
      );
    } else {
      emit(
        SpecialtyListFailed(
            isLoading: false,
            errorMessage: apiRes.message!,
            doctorListResponseData: state.doctorListResponseData,
            specialtyList: state.specialtyList,
            selectedSpecialty: state.selectedSpecialty,
            currentRating: state.currentRating,
            minConsultationFee: state.minConsultationFee,
            maxConsultationFee: state.maxConsultationFee,
            doctorList: state.doctorList,
            scrollController: state.scrollController,
            pageNo: state.pageNo,
            lastPage: state.lastPage),
      );
    }
  }

  emitDoctorListFromApi(DoctorListResponseModel apiRes, bool isFromSearch) {
    if (apiRes.status == 'success') {
      List<Doctor>? tempDoctorList = [];
      state.doctorList?.clear();
      if (!isFromSearch) {
        tempDoctorList.addAll(state.doctorList!);
      }
      tempDoctorList.addAll(apiRes.doctorListResponseData!.doctorList!);
      emit(
        DoctorListSuccessful(
            isLoading: false,
            toastMessage: apiRes.message!,
            doctorListResponseData: apiRes.doctorListResponseData,
            specialtyList: state.specialtyList,
            selectedSpecialty: state.selectedSpecialty,
            currentRating: state.currentRating,
            minConsultationFee: state.minConsultationFee,
            maxConsultationFee: state.maxConsultationFee,
            doctorList: tempDoctorList,
            scrollController: state.scrollController,
            pageNo: apiRes.doctorListResponseData!.page! + 1,
            lastPage: apiRes.doctorListResponseData!.totalPages),
      );
    } else {
      emit(
        DoctorListFailed(
            isLoading: false,
            errorMessage: apiRes.message!,
            doctorListResponseData: state.doctorListResponseData,
            specialtyList: state.specialtyList,
            selectedSpecialty: state.selectedSpecialty,
            currentRating: state.currentRating,
            minConsultationFee: state.minConsultationFee,
            maxConsultationFee: state.maxConsultationFee,
            doctorList: state.doctorList,
            scrollController: state.scrollController,
            pageNo: state.pageNo,
            lastPage: state.lastPage),
      );
    }
  }
}
