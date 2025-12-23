import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/model/prescription_list_response_model.dart';
import '../../utils/keys/shared_pref_keys.dart';
import '../../views/global_widgets/toast.dart';

class PrescriptionListCubit extends Cubit<PrescriptionListState> {
  PrescriptionListCubit()
      : super(
          PrescriptionListState(
            isLoading: false,
            prescriptionListData: null,
            patient: MyPatient(id: "001"),
            prescriptionList: [],
          ),
        );

  void resetState() {
    emit(
      PrescriptionListState(
        isLoading: false,
        prescriptionListData: state.prescriptionListData,
        patient: state.patient,
        prescriptionList: [],
      ),
    );
  }

  Future<void> updatePatientForPrescription(MyPatient patient) async {
    emit(state.copyWith(
      patient: patient,
      isLoading: true,
    ));
    getPrescriptionList(loadFromStorage: false);
  }

  Future<void> refreshScreen() async {
    getPrescriptionList();
  }

  Future<File> downloadFile(
      {required BuildContext context,
      required String url,
      required String filename}) async {
    emit(state.copyWith(isLoading: true));
    String extension = "jpg";
    if (url.contains("jpg") || url.contains("png")) {
      extension = "jpg";
    } else {
      extension = "pdf";
    }

    var httpClient = HttpClient();
    try {
      // showToast(message: "Your prescription is invalid", context: context);
      var request = await httpClient.getUrl(Uri.parse(url.trim()));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = Platform.isAndroid
          ? await getDownloadsDirectory()
          : await getApplicationDocumentsDirectory();
      File file = File('${dir?.path}/${filename.trim()}.$extension');
      await file.writeAsBytes(bytes);
      String filePath = file.path.trim().replaceAll(" ", "");
      log('downloaded file path = $filePath');
      // showToast(message:"Worksheet stored at $filePath", context:  context);
      // await OpenFile.open(filePath);
      return file;
    } catch (error) {
      log('pdf downloading error = $error');
      return File('');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> getPrescriptionList({
    bool loadFromStorage = true,
  }) async {
    Map<String, String> parameters = Map<String, String>();
    parameters["patient"] = "${state.patient.id}";

    emit(PrescriptionListState(
        isLoading: true,
        prescriptionListData: null,
        patient: state.patient,
        prescriptionList: []));

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? prescriptionListString =
        await preferences.getString(getAllPrescriptionListKey);

    if (prescriptionListString != null && loadFromStorage) {
      try {
        PrescriptionListResponseModel prescriptionList =
            PrescriptionListResponseModel.fromJson(
                jsonDecode(prescriptionListString));
        emitPrescriptionList(prescriptionList);
      } catch (e) {}
    }

    PrescriptionListResponseModel prescriptionListResponse =
        await ApiRepo().getPrescriptionList(parameters);
    preferences.setString(getAllPrescriptionListKey,
        jsonEncode(prescriptionListResponse.toJson()));
    emitPrescriptionList(prescriptionListResponse);
  }

  emitPrescriptionList(PrescriptionListResponseModel promosApiResponse) {
    if (promosApiResponse.status == 'success') {
      emit(
        PrescriptionListSuccessful(
            isLoading: false,
            toastMessage: promosApiResponse.message!,
            prescriptionListData: promosApiResponse.prescriptionListData,
            patient: state.patient,
            prescriptionList:
                promosApiResponse.prescriptionListData?.prescriptionList),
      );
    } else {
      emit(
        PrescriptionListFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          prescriptionListData: promosApiResponse.prescriptionListData,
          patient: state.patient,
          prescriptionList: [],
        ),
      );
    }
  }

  Future<void> deletePrescriptionFromList(String prescriptionId) async {
    emit(PrescriptionListState(
        isLoading: true,
        prescriptionListData: state.prescriptionListData,
        patient: state.patient,
        prescriptionList: state.prescriptionList));
    final promosApiResponse =
        await ApiRepo().deletePrescriptionFromList(prescriptionId);
    if (promosApiResponse.status == 'success') {
      emit(
        DeletePrescriptionSuccessful(
            isLoading: false,
            toastMessage: promosApiResponse.message!,
            prescriptionListData: state.prescriptionListData,
            patient: state.patient,
            prescriptionList: state.prescriptionList),
      );
      getPrescriptionList();
    } else {
      emit(
        DeletePrescriptionFailed(
            isLoading: false,
            errorMessage: promosApiResponse.message!,
            prescriptionListData: state.prescriptionListData,
            patient: state.patient,
            prescriptionList: state.prescriptionList),
      );
    }
  }
}
