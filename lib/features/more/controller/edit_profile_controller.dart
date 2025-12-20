import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eye_buddy/core/services/api/model/profile_reponse_model.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:eye_buddy/core/services//api/repo/api_repo.dart'; // tumhara repo

class EditProfileController extends GetxController {
  // ===== Controllers =====
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final genderController = TextEditingController(text: "Male");
  final emailController = TextEditingController();

  // ===== Variables =====
  RxBool isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  late Profile profile;

  final ApiRepo _repo = ApiRepo(); // API repository

  void setProfile(Profile data) {
    profile = data;
    nameController.text = data.name ?? "";
    dobController.text = data.dateOfBirth ?? "";
    weightController.text = data.weight ?? "";
    genderController.text = data.gender ?? "Male";
    emailController.text = data.email ?? "";
  }

  /// ===== Pick Image from gallery =====
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  /// ===== Save Profile with API =====
  Future<void> saveProfile() async {
    isLoading.value = true;

    try {
      // 1️⃣ Upload image if selected
      String? uploadedImagePath;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final imageResponse = await _repo.uploadProfileImageInBase64(
          base64Image,
        );
        if (imageResponse.status == 'success') {
          uploadedImagePath = imageResponse.profile?.photo ?? '';
        } else {
          Get.snackbar(
            "Error",
            imageResponse.message ?? "Failed to upload image",
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading.value = false;
          return;
        }
      }

      // 2️⃣ Prepare profile update parameters
      final Map<String, dynamic> parameters = {
        "name": nameController.text,
        "dateOfBirth": dobController.text,
        "weight": weightController.text,
        "gender": genderController.text,
        "email": emailController.text,
      };
      if (uploadedImagePath != null) {
        parameters["photo"] = uploadedImagePath;
      }

      // 3️⃣ Call update profile API
      final response = await _repo.updateProfileData(parameters);

      if (response.status == 'success') {
        // Update local profile object
        profile.name = nameController.text;
        profile.dateOfBirth = dobController.text;
        profile.weight = weightController.text;
        profile.gender = genderController.text;
        profile.email = emailController.text;
        if (uploadedImagePath != null) {
          profile.photo = uploadedImagePath;
        }

        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        try {
          final profileCtrl = Get.isRegistered<ProfileController>()
              ? Get.find<ProfileController>()
              : Get.put(ProfileController());
          await profileCtrl.getProfileData();
        } catch (_) {
          // ignore
        }

        Get.back(result: profile); // Return updated profile to previous screen
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
