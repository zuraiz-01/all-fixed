import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/services/api/model/appointment_doctor_model.dart';
import '../../../core/services/api/model/init_payment_response_model.dart';
import '../../../core/services/api/repo/api_repo.dart';
import '../../../core/controler/app_state_controller.dart';
import '../../appointments/controller/appointment_controller.dart';

class ReasonForVisitController extends GetxController {
  final ApiRepo _apiRepo = ApiRepo();

  final isLoading = false.obs;
  final eyePhotoList = <XFile>[].obs;
  final reportAndPrescriptionList = <File>[].obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final selectedAppointment = Rx<Appointment?>(null);
  final gatewayUrl = ''.obs;

  void resetState() {
    eyePhotoList.clear();
    reportAndPrescriptionList.clear();
    errorMessage.value = '';
    successMessage.value = '';
    selectedAppointment.value = null;
    gatewayUrl.value = '';
  }

  void clearState() {
    eyePhotoList.clear();
    reportAndPrescriptionList.clear();
    errorMessage.value = '';
    successMessage.value = '';
    selectedAppointment.value = null;
    gatewayUrl.value = '';
  }

  void addEyePhoto({required XFile eyePhoto}) {
    eyePhotoList.add(eyePhoto);
  }

  void deleteEyePhoto({required int position}) {
    if (position >= 0 && position < eyePhotoList.length) {
      eyePhotoList.removeAt(position);
    }
  }

  void addPatientPrescriptionFile({required File file}) {
    reportAndPrescriptionList.add(file);
  }

  void deletePatientPrescriptionFile({required int position}) {
    if (position >= 0 && position < reportAndPrescriptionList.length) {
      reportAndPrescriptionList.removeAt(position);
    }
  }

  Future<String> xFileToBase64(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      log('xFileToBase64 error: $e');
      rethrow;
    }
  }

  Future<String> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      log('fileToBase64 error: $e');
      rethrow;
    }
  }

  String getFileExtension(String filePath) {
    try {
      final extensionIndex = filePath.lastIndexOf('.');
      if (extensionIndex != -1 && extensionIndex < filePath.length - 1) {
        return "." + filePath.substring(extensionIndex + 1);
      } else {
        return '.jpg';
      }
    } catch (e) {
      log('getFileExtension error: $e');
      return '.jpg';
    }
  }

  Future<void> saveAppointment(Map<String, dynamic> params) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    var didNavigate = false;

    try {
      List<Map<String, dynamic>> eyePhotos = [];
      for (int i = 0; i < eyePhotoList.length; i++) {
        eyePhotos.add({
          "base64String": await xFileToBase64(eyePhotoList[i]),
          "fileExtension": getFileExtension(eyePhotoList[i].path),
        });
      }
      params.addAll({"eyePhotos": eyePhotos});

      List<Map<String, dynamic>> reports = [];
      for (int i = 0; i < reportAndPrescriptionList.length; i++) {
        reports.add({
          "base64String": await fileToBase64(reportAndPrescriptionList[i]),
          "fileExtension": getFileExtension(reportAndPrescriptionList[i].path),
        });
      }
      params.addAll({"prescriptions": reports});

      // Match BLoC: do not send Flutter objects in API body
      final apiParams = Map<String, dynamic>.from(params)
        ..remove('patientData')
        ..remove('selectedDoctor');

      SaveAppointmentApiResponse apiResponse = await _apiRepo.saveAppointments(
        apiParams,
      );

      if (apiResponse.status == "success") {
        selectedAppointment.value = apiResponse.appointment;
        successMessage.value = "Appointment created.";

        // Navigate to appointment overview screen
        // Turn off loader before navigating, otherwise the next screen may
        // show its own loader and the user sees a "double loader" effect.
        isLoading.value = false;
        didNavigate = true;
        Get.toNamed(
          '/appointment-overview',
          arguments: {
            'patientData': params['patientData'],
            'selectedDoctor': params['selectedDoctor'],
            'appointment': apiResponse.appointment,
          },
        );
      } else {
        errorMessage.value = apiResponse.message;
      }
    } catch (e, s) {
      log('saveAppointment error: $e', stackTrace: s);
      errorMessage.value = 'Failed to save appointment';
    } finally {
      if (!didNavigate) {
        isLoading.value = false;
      }
    }
  }

  Future<void> initiatePayment(Map<String, dynamic> params) async {
    isLoading.value = true;
    errorMessage.value = '';
    var didNavigate = false;

    try {
      // Match BLoC: only send appointment + paymentGateway to API
      final apiParams = Map<String, dynamic>.from(params)
        ..remove('patientData')
        ..remove('selectedDoctor');

      InitPaymentApiResponseModel apiResponse = await _apiRepo.initiatePayment(
        apiParams,
      );
      log("Appointment ID: ${selectedAppointment.value?.id ?? "NO-ID"}");

      if (apiResponse.status == "success") {
        gatewayUrl.value = apiResponse.url ?? '';
        successMessage.value = "Payment initiated.";

        // Navigate to in-app payment gateway screen when URL is available
        if (gatewayUrl.value.isNotEmpty) {
          log('Payment URL: ${gatewayUrl.value}');
          // Turn off loader before navigating, otherwise the payment screen's
          // webview loader can appear together with this screen's overlay.
          isLoading.value = false;
          didNavigate = true;
          Get.toNamed(
            '/payment-gateway',
            arguments: {
              'url': gatewayUrl.value,
              'appointmentId': params['appointment'],
              'patientData': params['patientData'],
              'selectedDoctor': params['selectedDoctor'],
            },
          );
        }
      } else {
        errorMessage.value = apiResponse.message ?? "Payment initiation failed";
      }
    } catch (e, s) {
      log('initiatePayment error: $e', stackTrace: s);
      errorMessage.value = 'Failed to initiate payment';
    } finally {
      if (!didNavigate) {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateAppointmentWithPromoData({
    required String vat,
    required String grandTotal,
    required String totalAmount,
  }) async {
    try {
      if (selectedAppointment.value != null) {
        final appointment = selectedAppointment.value!;
        appointment.vat = double.parse(vat);
        appointment.grandTotal = double.parse(grandTotal);
        appointment.totalAmount = double.parse(totalAmount);

        selectedAppointment.value = appointment;
        successMessage.value = "Appointment updated with promo data.";
      }
    } catch (e, s) {
      log('updateAppointmentWithPromoData error: $e', stackTrace: s);
      errorMessage.value = 'Failed to update appointment';
    }
  }

  Future<void> selectPrescriptionFile() async {
    try {
      final appStateController = Get.find<AppStateController>();
      appStateController.setPickingImage(true);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["pdf", "jpg", "png"],
        type: FileType.custom,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        log('Selected file: ${file.name}');

        final fileObj = File(result.paths.first!);
        addPatientPrescriptionFile(file: fileObj);
      }
    } catch (e, s) {
      log('selectPrescriptionFile error: $e', stackTrace: s);
      errorMessage.value = 'Failed to select prescription file';
    } finally {
      final appStateController = Get.find<AppStateController>();
      appStateController.setPickingImage(false);
    }
  }

  Future<void> selectImage(BuildContext context) async {
    try {
      final appStateController = Get.find<AppStateController>();

      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
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
                      await _pickImage(ImageSource.camera);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 12),
                        Text('Capture\nImage', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.gallery);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 40),
                        SizedBox(height: 12),
                        Text('Select\nImage', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e, s) {
      log('selectImage error: $e', stackTrace: s);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final appStateController = Get.find<AppStateController>();
      appStateController.setPickingImage(true);

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 700,
        maxHeight: 700,
      );

      if (image != null) {
        addEyePhoto(eyePhoto: image);
      }
    } catch (e, s) {
      log('_pickImage error: $e', stackTrace: s);
    } finally {
      final appStateController = Get.find<AppStateController>();
      appStateController.setPickingImage(false);
    }
  }

  Future<void> refreshAppointments() async {
    // Refresh appointments after payment success like BLoC's AppointmentCubit.getAppointments
    // This will update the appointment list with latest status using AppointmentController
    try {
      final appointmentController = Get.isRegistered<AppointmentController>()
          ? Get.find<AppointmentController>()
          : Get.put(AppointmentController());

      // Force a fresh fetch from API (no storage cache) similar to BLoC refresh
      await appointmentController.refreshScreen();
    } catch (e) {
      log('refreshAppointments error: $e');
    }
  }
}
