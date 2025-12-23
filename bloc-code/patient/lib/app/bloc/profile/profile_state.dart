import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/profile_reponse_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileState extends Equatable {
  bool isLoading;
  ProfileResponseModel? profileResponseModel;
  XFile selectedProfileImage = XFile('');

  ProfileState({
    required this.isLoading,
    required this.profileResponseModel,
    required this.selectedProfileImage,
  });

  @override
  List<Object> get props => [
        isLoading,
        selectedProfileImage.path,
        selectedProfileImage.path.hashCode,
        selectedProfileImage.hashCode,
      ];
}

class ProfileInitial extends ProfileState {
  ProfileInitial({
    required super.isLoading,
    required super.profileResponseModel,
    required super.selectedProfileImage,
  });
}

class ProfileSuccessful extends ProfileState {
  ProfileSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.profileResponseModel,
    required super.selectedProfileImage,
  });

  String toastMessage;
}

class ProfileFailed extends ProfileState {
  ProfileFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.profileResponseModel,
    required super.selectedProfileImage,
  });

  String errorMessage;
}
