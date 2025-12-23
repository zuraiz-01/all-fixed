import 'dart:convert';
import 'dart:io';
import 'package:eye_buddy/core/services/api/repo/api_repo.dart';
import 'package:eye_buddy/core/services/utils/services/navigator_services.dart';
import 'package:eye_buddy/features/bootom_navbar_screen/views/bottom_navbar_screen.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SaveUserDataController extends GetxController {
  // Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final genderController = TextEditingController(text: "Male");

  // Profile Image
  final selectedProfileImage = Rx<File?>(null);

  // Loading state
  final isLoading = false.obs;

  final ApiRepo _apiRepo = ApiRepo();

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    weightController.dispose();
    genderController.dispose();
    super.onClose();
  }

  /// Pick Image
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedProfileImage.value = File(pickedFile.path);
    }
  }

  /// Save User Data
  Future<void> saveUserData() async {
    if (nameController.text.isEmpty ||
        dobController.text.isEmpty ||
        weightController.text.isEmpty ||
        genderController.text.isEmpty) {
      final ctx = Get.context;
      if (ctx != null) {
        final l10n = AppLocalizations.of(ctx)!;
        Get.snackbar(l10n.error, l10n.enter_all_fields_and_try_again);
      }
      return;
    }

    isLoading.value = true;

    Map<String, dynamic> parameters = {
      "name": nameController.text,
      "dateOfBirth": dobController.text,
      "weight": weightController.text,
      "gender": genderController.text,
    };

    try {
      if (selectedProfileImage.value != null) {
        final bytes = await selectedProfileImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final imageResponse = await _apiRepo.uploadProfileImageInBase64(
          base64Image,
        );

        final imageSuccess =
            (imageResponse.status ?? '').toLowerCase() == 'success';
        final uploadedPhoto = imageResponse.profile?.photo;
        final hasPhoto =
            uploadedPhoto != null && uploadedPhoto.trim().isNotEmpty;

        if (!imageSuccess || !hasPhoto) {
          final ctx = Get.context;
          if (ctx != null) {
            final l10n = AppLocalizations.of(ctx)!;
            Get.snackbar(
              l10n.error,
              imageResponse.message ?? l10n.failed_to_save_profile_data,
            );
          }
          isLoading.value = false;
          return;
        }

        parameters['photo'] = uploadedPhoto;
      }

      final updateResponse = await _apiRepo.updateProfileData(parameters);
      final isSuccess =
          (updateResponse.status ?? '').toLowerCase() == 'success';
      if (!isSuccess) {
        final ctx = Get.context;
        if (ctx != null) {
          final l10n = AppLocalizations.of(ctx)!;
          Get.snackbar(
            l10n.error,
            updateResponse.message ?? l10n.failed_to_save_profile_data,
          );
        }
        isLoading.value = false;
        return;
      }

      try {
        final profileCtrl = Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());
        await profileCtrl.getProfileData();
      } catch (_) {
        // ignore
      }
      isLoading.value = false;

      // Navigate to bottom nav
      final ctx = Get.context;
      if (ctx != null) {
        NavigatorServices().toPushAndRemoveUntil(
          context: ctx,
          widget: const BottomNavBarScreen(),
        );
      } else {
        Get.offAll(() => const BottomNavBarScreen());
      }
    } catch (e) {
      isLoading.value = false;
      final ctx = Get.context;
      if (ctx != null) {
        final l10n = AppLocalizations.of(ctx)!;
        Get.snackbar(l10n.error, l10n.failed_to_save_profile_data);
      }
    }
  }

  /// Select DOB
  Future<void> pickDate(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    dobController.text = selectedDate != null
        ? "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}"
        : "${currentDate.month}/${currentDate.day}/${currentDate.year}";
  }
}
