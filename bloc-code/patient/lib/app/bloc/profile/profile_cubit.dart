import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/controller/app_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/model/profile_reponse_model.dart';
import '../../views/global_widgets/inter_text.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(
          ProfileState(
            isLoading: false,
            profileResponseModel: null,
            selectedProfileImage: XFile(''),
          ),
        );

  Future<void> resetState() async {
    emit(
      ProfileState(
        isLoading: false,
        profileResponseModel: state.profileResponseModel,
        selectedProfileImage: XFile(''),
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
                    imageQuality: 50,
                    maxHeight: 700,
                    maxWidth: 700,
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    emit(
                      ProfileState(
                        isLoading: state.isLoading,
                        profileResponseModel: state.profileResponseModel,
                        selectedProfileImage: image,
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
                  appStateController.setPickingImage(true);
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxHeight: 700,
                    maxWidth: 700,
                  );
                  if (image != null) {
                    emit(
                      ProfileState(
                        isLoading: state.isLoading,
                        profileResponseModel: state.profileResponseModel,
                        selectedProfileImage: image,
                      ),
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
        ));
      },
    );
  }

  Future<void> getProfileData({
    bool loadFromCache = true,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(
      ProfileState(
        isLoading: true,
        profileResponseModel: state.profileResponseModel,
        selectedProfileImage: state.selectedProfileImage,
      ),
    );
    String? profileDataFromStorage = prefs.getString(
      "getProfileData",
    );
    if (profileDataFromStorage != null && loadFromCache) {
      try {
        emitPatientProfile(
          ProfileResponseModel.fromJson(
            jsonDecode(
              profileDataFromStorage,
            ),
          ),
        );
      } catch (err) {}
    }
    ProfileResponseModel apiResponse = await ApiRepo().getProfileData();
    prefs.setString(
      "getProfileData",
      jsonEncode(
        apiResponse.toJson(),
      ),
    );
    emitPatientProfile(apiResponse);
  }

  emitPatientProfile(ProfileResponseModel apiResponse) {
    if (apiResponse.status == 'success') {
      emit(
        ProfileSuccessful(
          isLoading: false,
          toastMessage: apiResponse.message!,
          profileResponseModel: apiResponse,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    } else {
      emit(
        ProfileFailed(
          isLoading: false,
          errorMessage: apiResponse.message!,
          profileResponseModel: apiResponse,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    }
  }

  Future<void> updateProfileData(
    Map<String, dynamic> parameters,
  ) async {
    emit(
      ProfileState(
        isLoading: true,
        profileResponseModel: state.profileResponseModel,
        selectedProfileImage: state.selectedProfileImage,
      ),
    );
    final apiResponse = await ApiRepo().updateProfileData(parameters);
    if (apiResponse.status == 'success') {
      await getProfileData();
      emit(
        ProfileSuccessful(
          isLoading: false,
          toastMessage: apiResponse.message!,
          profileResponseModel: state.profileResponseModel,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    } else {
      emit(
        ProfileFailed(
          isLoading: false,
          errorMessage: apiResponse.message!,
          profileResponseModel: apiResponse,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    }
  }

  Future<String> xFileToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    return base64Image;
  }

  Future<void> uploadProfileImage() async {
    emit(
      ProfileState(
        isLoading: true,
        profileResponseModel: state.profileResponseModel,
        selectedProfileImage: state.selectedProfileImage,
      ),
    );
    final apiResponse =
        await ApiRepo().uploadProfileImageInBase64(await xFileToBase64(
      state.selectedProfileImage,
    ));
    if (apiResponse.status == 'success') {
      await getProfileData();
      emit(
        ProfileSuccessful(
          isLoading: false,
          toastMessage: apiResponse.message!,
          profileResponseModel: state.profileResponseModel,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    } else {
      emit(
        ProfileFailed(
          isLoading: false,
          errorMessage: apiResponse.message!,
          profileResponseModel: apiResponse,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    }
  }

  Future<void> uploadProfileDataWithImage(
      Map<String, dynamic> parameters) async {
    emit(
      ProfileState(
        isLoading: true,
        profileResponseModel: state.profileResponseModel,
        selectedProfileImage: state.selectedProfileImage,
      ),
    );
    final apiResponse = await ApiRepo().updateProfileData(parameters);
    if (apiResponse.status == 'success') {
      // emit(
      //   ProfileState(
      //     isLoading: true,
      //     profileResponseModel: state.profileResponseModel,
      //     selectedProfileImage: state.selectedProfileImage,
      //   ),
      // );

      if (state.selectedProfileImage.path == "") {
        emit(
          ProfileSuccessful(
            isLoading: false,
            toastMessage: apiResponse.message!,
            profileResponseModel: state.profileResponseModel,
            selectedProfileImage: state.selectedProfileImage,
          ),
        );
      } else {
        log("image path ${path.extension(state.selectedProfileImage.path.toString())}");

        final apiResponse =
            await ApiRepo().uploadProfileImageInBase64(await xFileToBase64(
          state.selectedProfileImage,
        ));
        if (apiResponse.status == 'success') {
          emit(
            ProfileSuccessful(
              isLoading: false,
              toastMessage: apiResponse.message!,
              profileResponseModel: state.profileResponseModel,
              selectedProfileImage: state.selectedProfileImage,
            ),
          );
        } else {
          emit(
            ProfileFailed(
              isLoading: false,
              errorMessage: apiResponse.message!,
              profileResponseModel: apiResponse,
              selectedProfileImage: state.selectedProfileImage,
            ),
          );
        }
      }
      await getProfileData(
        loadFromCache: false,
      );
    } else {
      emit(
        ProfileFailed(
          isLoading: false,
          errorMessage: apiResponse.message!,
          profileResponseModel: apiResponse,
          selectedProfileImage: state.selectedProfileImage,
        ),
      );
    }
  }
}
