import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/api/model/init_payment_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/controller/app_state_controller.dart';
import 'package:eye_buddy/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/app_state_controller.dart';
import '../../views/global_widgets/inter_text.dart';

part 'reason_for_visit_state.dart';

class ReasonForVisitCubit extends Cubit<ReasonForVisitState> {
  ReasonForVisitCubit()
      : super(
          ReasonForVisitState(
            eyePhotoList: const [],
            reportAndPrescriptionList: const [],
            isLoading: false,
          ),
        );

  void resetState() {
    emit(
      ReasonForVisitState(
        isLoading: false,
        eyePhotoList: state.eyePhotoList,
        reportAndPrescriptionList: state.reportAndPrescriptionList,
      ),
    );
  }

  void clearState() {
    emit(
      ReasonForVisitState(
        eyePhotoList: const [],
        reportAndPrescriptionList: const [],
        isLoading: false,
      ),
    );
  }

  void addEyePhoto({required XFile eyePhotos}) {
    emit(
      state.copyWith(
        eyePhotoList: [
          ...state.eyePhotoList,
          eyePhotos,
        ],
      ),
    );
  }

  void deleteEyePhoto({required int position}) {
    final eyePhotoList = state.eyePhotoList.toList()..removeAt(position);
    emit(
      state.copyWith(
        eyePhotoList: eyePhotoList,
      ),
    );
  }

  void addPatientPrescriptionFile({required File eyePhotos}) {
    emit(
      state.copyWith(
        reportAndPrescriptionList: [
          ...state.reportAndPrescriptionList,
          eyePhotos,
        ],
      ),
    );
  }

  void deletePatientPrescriptionFile({required int position}) {
    final patientPrescriptionPhoto = state.reportAndPrescriptionList.toList()
      ..removeAt(position);
    emit(
      state.copyWith(
        reportAndPrescriptionList: patientPrescriptionPhoto,
      ),
    );
  }

  Future<String> xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    return base64Image;
  }

  Future<String> FileToBase64(File file) async {
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

  Future<void> saveAppointment(Map<String, dynamic> params) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    List<Map<String, dynamic>> eyePhotos = [];
    List<Map<String, dynamic>> reports = [];
    for (int i = 0; i < state.eyePhotoList.length; i++) {
      eyePhotos.add(
        {
          "base64String": await xFileToBase64(
            state.eyePhotoList[i],
          ),
          "fileExtension": getFileExtension(state.eyePhotoList[i].path)
        },
      );
    }
    params.addAll(
      {
        "eyePhotos": eyePhotos,
      },
    );
    for (int i = 0; i < state.reportAndPrescriptionList.length; i++) {
      reports.add(
        {
          "base64String": await FileToBase64(
            state.reportAndPrescriptionList[i],
          ),
          "fileExtension":
              getFileExtension(state.reportAndPrescriptionList[i].path)
        },
      );
    }
    params.addAll(
      {
        "prescriptions": reports,
      },
    );

    SaveAppointmentApiResponse apiResponse =
        await ApiRepo().saveAppointments(params);

    if (apiResponse.status == "success") {
      emit(
        ReasonForVisitSuccessState(
          eyePhotoList: state.eyePhotoList,
          reportAndPrescriptionList: state.reportAndPrescriptionList,
          isLoading: false,
          gatewayUrl: "",
          toastMessage: "Appointment created.",
          selectedAppointment: apiResponse.appointment!,
          appointmentMarkAsPaidApiResponseModel: null,
        ),
      );
    } else {
      emit(
        ReasonForVisitErrorState(
          eyePhotoList: state.eyePhotoList,
          reportAndPrescriptionList: state.reportAndPrescriptionList,
          isLoading: false,
          errorMessage: apiResponse.message,
          selectedAppointment: state.selectedAppointment,
        ),
      );
    }
  }

  Future<void> inititatePayment(Map<String, dynamic> params) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    InitPaymentApiResponseModel apiResponse =
        await ApiRepo().inititatePayment(params);
    print("Appointment ID: ${state.selectedAppointment?.id ?? "NO-ID"}");

    if (apiResponse.status == "success") {
      emit(
        ReasonForVisitSuccessState(
          eyePhotoList: state.eyePhotoList,
          reportAndPrescriptionList: state.reportAndPrescriptionList,
          isLoading: false,
          gatewayUrl: apiResponse.url ?? '',
          toastMessage: "Appointment created.",
          selectedAppointment: state.selectedAppointment,
          appointmentMarkAsPaidApiResponseModel:
              state.appointmentMarkAsPaidApiResponseModel,
        ),
      );
    } else {
      emit(
        ReasonForVisitErrorState(
          eyePhotoList: state.eyePhotoList,
          reportAndPrescriptionList: state.reportAndPrescriptionList,
          isLoading: false,
          errorMessage: apiResponse.message ?? "",
          selectedAppointment: state.selectedAppointment,
        ),
      );
    }
  }

  Future<void> updateAppointmentWithPromoData({
    required String vat,
    required String grandTotal,
    required String totalAmount,
  }) async {
    Appointment appointment = state.selectedAppointment!;
    appointment.vat = double.parse(vat);
    appointment.grandTotal = double.parse(grandTotal);
    appointment.totalAmount = double.parse(totalAmount);

    emit(
      ReasonForVisitSuccessState(
        eyePhotoList: state.eyePhotoList,
        reportAndPrescriptionList: state.reportAndPrescriptionList,
        isLoading: false,
        toastMessage: "Appointment created.",
        gatewayUrl: "",
        selectedAppointment: appointment,
        appointmentMarkAsPaidApiResponseModel:
            state.appointmentMarkAsPaidApiResponseModel,
      ),
    );
  }

  Future selectPrescriptionFile() async {
    var appStateController = Get.find<AppStateController>();
    appStateController.isPickingImage(true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [
        "pdf",
        "jpg",
        "png",
      ],
      type: FileType.custom,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      addPatientPrescriptionFile(
        eyePhotos: File(
          result.paths.first!,
        ),
      );
      appStateController.isPickingImage(false);
    } else {
      // User canceled the picker
    }
  }

  Future<void> selectImage(BuildContext context) async {
    final appStateController = Get.find<AppStateController>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
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
                      addEyePhoto(
                        eyePhotos: image,
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
                    appStateController.setPickingImage(true);
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                      maxWidth: 700,
                      maxHeight: 700,
                    );
                    if (image != null) {
                      addEyePhoto(
                        eyePhotos: image,
                      );
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
          ),
        );
      },
    );
  }
}
