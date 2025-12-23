import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/medication_tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/repo/api_repo.dart';
import '../medication_tracker_cubit/medication_tracker_cubit.dart';

part 'add_medication_state.dart';

class AddMedicationCubit extends Cubit<AddMedicationState> {
  AddMedicationCubit()
      : super(
          AddMedicationState(
            isLoading: false,
            timeList: const [],
            dayList: const [
              'Sunday',
              'Moday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
            ],
          ),
        );

  void addNewTime(String time) {
    emit(
      state.copyWith(
        timeList: [
          ...state.timeList,
          time,
        ],
      ),
    );
  }

  void updateFullTimeList(List<String> times) {
    emit(
      state.copyWith(
        timeList: times,
      ),
    );
  }

  void updateFullDayList(List<String> days) {
    emit(
      state.copyWith(
        dayList: days,
      ),
    );
  }

  void addNewDay(String day) {
    emit(
      state.copyWith(
        dayList: [
          ...state.dayList,
          day,
        ],
      ),
    );
  }

  void removeDay(String day) {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final selectedDays = state.dayList..remove(day);
    log(selectedDays.toString());
    emit(
      state.copyWith(
        isLoading: false,
        dayList: selectedDays,
      ),
    );
  }

  void toogleDay(String day) {
    if (state.dayList.contains(day)) {
      removeDay(day);
    } else {
      addNewDay(day);
    }
  }

  void resetState() {
    emit(
      AddMedicationState(
        isLoading: false,
        timeList: state.timeList,
        dayList: state.dayList,
      ),
    );
  }

  void resetEverythingState() {
    emit(
      AddMedicationState(
        isLoading: false,
        timeList: [],
        dayList: [],
      ),
    );
  }

  Future updateMedication(
    Medication medication,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final apiResponse = await ApiRepo().updateMedication(medication: medication);
    if (apiResponse.status == 'success') {
      await context.read<MedicationTrackerCubit>().getMedications();
      emit(
        MedicationUpdateSuccessState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          toastMessage: apiResponse.message,
        ),
      );
    } else {
      emit(
        MedicationUpdateErrorState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          errorMessage: apiResponse.message,
        ),
      );
    }
  }

  Future addMedication(
    Medication medication,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final apiResponse = await ApiRepo().addMedication(medication: medication);
    if (apiResponse.status == 'success') {
      await context.read<MedicationTrackerCubit>().getMedications();
      emit(
        MedicationUpdateSuccessState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          toastMessage: apiResponse.message,
        ),
      );
    } else {
      emit(
        MedicationUpdateErrorState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          errorMessage: apiResponse.message,
        ),
      );
    }
  }

  Future deleteMedication(
    Medication medication,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final apiResponse = await ApiRepo().deleteMedication(id: medication.id ?? "");
    if (apiResponse.status == 'success') {
      await context.read<MedicationTrackerCubit>().getMedications();
      emit(
        MedicationUpdateSuccessState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          toastMessage: apiResponse.message,
        ),
      );
    } else {
      emit(
        MedicationUpdateErrorState(
          isLoading: false,
          timeList: state.timeList,
          dayList: state.dayList,
          errorMessage: apiResponse.message,
        ),
      );
    }
  }
}
