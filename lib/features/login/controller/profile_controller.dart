import 'dart:developer';

import 'package:eye_buddy/core/services/api/model/profile_reponse_model.dart';
import 'package:eye_buddy/core/services/api/service/api_constants.dart';
import 'package:eye_buddy/core/services/api/service/api_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Observables
  var profileData = ProfileResponseModel().obs;
  var isLoading = false.obs;
  var selectedProfileImagePath = ''.obs;

  /// -----------------------------
  /// GET PROFILE DATA
  /// -----------------------------
  Future<void> getProfileData() async {
    try {
      isLoading.value = true;

      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getGetResponse(ApiConstants.profileMe)
            as Map<String, dynamic>,
      );

      profileData.value = apiResponse;
    } catch (err) {
      log("Get Profile Data Error: $err");
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------------
  /// UPDATE PROFILE DATA
  /// -----------------------------
  Future<void> updateProfileData(Map<String, dynamic> parameters) async {
    try {
      isLoading.value = true;

      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getPatchResponse(
              ApiConstants.profileUpdate,
              parameters,
            )
            as Map<String, dynamic>,
      );

      profileData.value = apiResponse;
    } catch (err) {
      log("Update Profile Data Error: $err");
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------------
  /// UPLOAD PROFILE IMAGE
  /// -----------------------------
  Future<void> uploadProfileImageInBase64(String imageAsBase64) async {
    try {
      isLoading.value = true;

      final apiResponse = ProfileResponseModel.fromJson(
        await _apiService.getPostResponse(
              '${ApiConstants.baseUrl}/api/patient/profile/uploadProfilePhoto',
              {"base64String": imageAsBase64, "fileExtension": "jpg"},
            )
            as Map<String, dynamic>,
      );

      profileData.value = apiResponse;
    } catch (err) {
      log("Upload Profile Image Error: $err");
    } finally {
      isLoading.value = false;
    }
  }

  /// -----------------------------
  /// PICK IMAGE FUNCTION
  /// -----------------------------
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      selectedProfileImagePath.value = file.path;
    }
  }
}
