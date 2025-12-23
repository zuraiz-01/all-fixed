import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/medication_tracker_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/repo/api_repo.dart';

part 'medication_tracker_state.dart';

class MedicationTrackerCubit extends Cubit<MedicationTrackerState> {
  MedicationTrackerCubit()
      : super(
          MedicationTrackerState(
            isLoading: false,
          ),
        );

  void resetState() {
    emit(
      MedicationTrackerState(
        isLoading: false,
        medicationTrackerData: state.medicationTrackerData,
      ),
    );
  }

  Future<void> getMedications() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final apiResponse = await ApiRepo().getMedications();
    log(apiResponse.data.toString());
    if (apiResponse.status == 'success') {
      apiResponse.data?.docs?.forEach((element) {
        log("Medication data: " + element.toString());
      });
      log(apiResponse.data.toString());
      emit(
        MedicationTrackerSuccess(
          isLoading: false,
          medicationTrackerData: apiResponse.data,
          toastMessage: "Medication list updated.",
        ),
      );
    } else {
      emit(
        MedicationTrackerSuccess(
          isLoading: false,
          toastMessage: apiResponse.message,
        ),
      );
    }
  }

  Future<void> deleteMedication(String selectedTitle) async {
    var prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("getMedicationListJson");
    List jsonMedication = jsonDecode(jsonData ?? "[]");
    List jsonMedicationIds = jsonMedication.where((element) => element["title"] == selectedTitle).toList().map((e) => e["_id"]).toList();
    log(jsonMedicationIds.toString());
    emit(
      MedicationTrackerState(
        isLoading: true,
      ),
    );

    jsonMedicationIds.forEach((element) async {
      await ApiRepo().deleteMedication(id: element);
    });

    await Future.delayed(Duration(seconds: 4));
    await getMedications();

    emit(
      MedicationTrackerSuccess(isLoading: false, toastMessage: "Medication deleted successfully"),
    );
  }

  Future toogleNotification(
    Medication medication,
    BuildContext context,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    medication.status = medication.status == "active" ? "inactive" : "active";
    final apiResponse = await ApiRepo().updateMedication(medication: medication);
    if (apiResponse.status == 'success') {
      emit(
        MedicationTrackerSuccess(
          isLoading: false,
          medicationTrackerData: state.medicationTrackerData,
          toastMessage: apiResponse.message,
        ),
      );
    } else {
      emit(
        MedicationTrackerFailed(
          isLoading: false,
          errorMessage: apiResponse.message,
          medicationTrackerData: state.medicationTrackerData,
        ),
      );
    }
  }
}
