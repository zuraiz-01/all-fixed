import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/controller/app_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/global_widgets/inter_text.dart';

part 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  PatientListCubit()
      : super(
          PatientListState(
            isLoading: false,
            myPatientList: [],
            selectedProfile: XFile(""),
          ),
        );

  Future resetState() async {
    emit(
      PatientListFetchedSuccessfully(
        isLoading: state.isLoading,
        myPatientList: state.myPatientList,
        toastMessage: "",
        selectedProfile: XFile(""),
      ),
    );
  }

  Future savePatientListToStorage({
    required GetPatientListApiResponse getPatientListApiResponse,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("my-patient-list", getPatientListApiResponse.toJson());
  }

  Future getPatientListFromStorage({
    required PatientListState state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? getPatientListApiResponseJson = prefs.getString(
      "my-patient-list",
    );
    if (getPatientListApiResponseJson != null) {
      GetPatientListApiResponse apiResponse =
          GetPatientListApiResponse.fromJson(
        getPatientListApiResponseJson,
      );
      emit(
        PatientListFetchedSuccessfully(
          isLoading: false,
          myPatientList: apiResponse.data!,
          toastMessage: apiResponse.message,
          selectedProfile: state.selectedProfile,
        ),
      );
    }
  }

  Future<void> getPatientList() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    // getPatientListFromStorage(
    //   state: state,
    // );
    GetPatientListApiResponse apiResponse = await ApiRepo().getMyPatientList();
    savePatientListToStorage(
      getPatientListApiResponse: apiResponse,
    );
    if (apiResponse.status == "success") {
      emit(
        PatientListFetchedSuccessfully(
          isLoading: false,
          myPatientList: apiResponse.data!,
          toastMessage: apiResponse.message,
          selectedProfile: state.selectedProfile,
        ),
      );
    } else {
      emit(
        PatientListFetchFailed(
          isLoading: false,
          myPatientList: apiResponse.data!,
          errorMessage: apiResponse.message,
          selectedProfile: state.selectedProfile,
        ),
      );
    }
  }

  Future<String> xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    return base64Image;
  }

  String getFileExtension(String filePath) {
    int extensionIndex = filePath.lastIndexOf('.');
    if (extensionIndex != -1 && extensionIndex < filePath.length - 1) {
      return "." + filePath.substring(extensionIndex + 1);
    } else {
      return '.jpg';
    }
  }

  Future<void> saveMyPatient({
    required MyPatient myPatient,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );

    Map<String, dynamic> data = myPatient.toMap();
    data.addAll({
      "profilePhoto": {
        "base64String": await xFileToBase64(
          state.selectedProfile,
        ),
        "fileExtension": getFileExtension(state.selectedProfile.path)
      },
    });
    GetPatientListApiResponse apiResponse = await ApiRepo().saveMyPatient(
      params: data,
    );
    if (apiResponse.status == "success") {
      getPatientList();
    } else {
      emit(
        PatientListFetchFailed(
          isLoading: false,
          myPatientList: apiResponse.data!,
          errorMessage: apiResponse.message,
          selectedProfile: state.selectedProfile,
        ),
      );
    }
  }

  Future<void> selectProfileImage(BuildContext context) async {
    final appStateController = Get.find<AppStateController>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          padding: const EdgeInsets.symmetric(
            // horizontal: 24,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  appStateController.setPickingImage(true);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                    maxHeight: 700,
                    maxWidth: 700,
                  );
                  if (image != null) {
                    emit(PatientListState(
                      isLoading: false,
                      myPatientList: state.myPatientList,
                      selectedProfile: image,
                    ));
                  }
                  appStateController.setPickingImage(false);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: InterText(
                        title: 'Capture\nImage',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  appStateController.setPickingImage(true);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxHeight: 700,
                    maxWidth: 700,
                  );
                  if (image != null) {
                    emit(PatientListState(
                      isLoading: false,
                      myPatientList: state.myPatientList,
                      selectedProfile: image,
                    ));
                  }
                  appStateController.setPickingImage(false);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image,
                      size: 40,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: InterText(
                        title: 'Select\nImage',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
