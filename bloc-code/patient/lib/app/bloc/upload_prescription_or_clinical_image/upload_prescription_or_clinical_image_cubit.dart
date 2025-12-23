import 'dart:convert';

import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/upload_prescription_or_clinical_image_state.dart';
import 'package:eye_buddy/app/controller/app_state_controller.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadPrescriptionOrClinicalImageCubit
    extends Cubit<UploadPrescriptionOrClinicalImageState> {
  UploadPrescriptionOrClinicalImageCubit()
      : super(
          UploadPrescriptionOrClinicalImageState(
            isLoading: false,
            commonApiResponse: null,
            selectedProfileImage: XFile(''),
            title: "",
            selectedPatient: null,
          ),
        );

  void resetState() {
    emit(
      UploadPrescriptionOrClinicalImageState(
        isLoading: false,
        commonApiResponse: state.commonApiResponse,
        selectedProfileImage: XFile(''),
        title: "",
        selectedPatient: state.selectedPatient,
      ),
    );
  }

  void updateSelectedPatient(MyPatient selectedPatient) {
    emit(
      state.copyWith(
        selectedPatient: selectedPatient,
      ),
    );
  }

  Future<void> selectImage(BuildContext context) async {
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
                    maxWidth: 700,
                    maxHeight: 700,
                  );
                  if (image != null) {
                    emit(
                      UploadPrescriptionOrClinicalImageState(
                        isLoading: state.isLoading,
                        commonApiResponse: state.commonApiResponse,
                        selectedProfileImage: image,
                        title: state.title,
                        selectedPatient: state.selectedPatient,
                      ),
                    );
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
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxWidth: 700,
                    maxHeight: 700,
                  );
                  if (image != null) {
                    emit(
                      UploadPrescriptionOrClinicalImageState(
                        isLoading: state.isLoading,
                        commonApiResponse: state.commonApiResponse,
                        selectedProfileImage: image,
                        title: state.title,
                        selectedPatient: state.selectedPatient,
                      ),
                    );
                  }
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

  Future<String> xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    return base64Image;
  }

  Future<void> uploadPatientPrescription(
      var parameters, BuildContext context) async {
    emit(UploadPrescriptionOrClinicalImageState(
      isLoading: true,
      commonApiResponse: state.commonApiResponse,
      selectedProfileImage: state.selectedProfileImage,
      title: state.title,
      selectedPatient: state.selectedPatient,
    ));
    final promosApiResponse =
        await ApiRepo().uploadPatientPrescription(parameters);
    if (promosApiResponse.status == 'success') {
      await context.read<PrescriptionListCubit>().getPrescriptionList(
            loadFromStorage: false,
          );
      emit(
        UploadPrescriptionOrClinicalImageSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          selectedProfileImage: state.selectedProfileImage,
          title: state.title,
          selectedPatient: state.selectedPatient,
        ),
      );
    } else {
      emit(
        UploadPrescriptionOrClinicalImageFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          selectedProfileImage: state.selectedProfileImage,
          title: state.title,
          selectedPatient: state.selectedPatient,
        ),
      );
    }
  }

  Future<void> uploadPatientClinicalResult(
      var parameters, BuildContext context) async {
    emit(UploadPrescriptionOrClinicalImageState(
      isLoading: true,
      commonApiResponse: state.commonApiResponse,
      selectedProfileImage: state.selectedProfileImage,
      title: state.title,
      selectedPatient: state.selectedPatient,
    ));
    final promosApiResponse =
        await ApiRepo().uploadPatientClinicalResult(parameters);
    if (promosApiResponse.status == 'success') {
      await context.read<TestResultCubit>().getClinicalTestResultData();
      emit(
        UploadPrescriptionOrClinicalImageSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          selectedProfileImage: state.selectedProfileImage,
          title: state.title,
          selectedPatient: state.selectedPatient,
        ),
      );
    } else {
      emit(
        UploadPrescriptionOrClinicalImageFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          selectedProfileImage: state.selectedProfileImage,
          title: state.title,
          selectedPatient: state.selectedPatient,
        ),
      );
    }
  }
}
