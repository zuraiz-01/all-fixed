import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/models/common_api_response_model.dart';
import 'package:image_picker/image_picker.dart';

class UploadPrescriptionOrClinicalImageState extends Equatable {
  bool isLoading;
  CommonResponseModel? commonApiResponse;
  String title;
  XFile selectedProfileImage = XFile('');
  MyPatient? selectedPatient;

  UploadPrescriptionOrClinicalImageState({
    required this.isLoading,
    required this.commonApiResponse,
    required this.selectedProfileImage,
    required this.title,
    required this.selectedPatient,
  });

  @override
  List<Object> get props => [
        isLoading,
        selectedProfileImage.path,
        (selectedPatient?.name ?? "").length,
      ];

  UploadPrescriptionOrClinicalImageState copyWith({
    bool? isLoading,
    CommonResponseModel? commonApiResponse,
    String? title,
    XFile? selectedProfileImage,
    MyPatient? selectedPatient,
  }) {
    return UploadPrescriptionOrClinicalImageState(
        isLoading: isLoading ?? this.isLoading,
        commonApiResponse: commonApiResponse ?? this.commonApiResponse,
        title: title ?? this.title,
        selectedProfileImage: selectedProfileImage ?? this.selectedProfileImage,
        selectedPatient: selectedPatient ?? this.selectedPatient);
  }
}

class UploadPrescriptionOrClinicalImageInitial extends UploadPrescriptionOrClinicalImageState {
  UploadPrescriptionOrClinicalImageInitial({
    required super.isLoading,
    required super.commonApiResponse,
    required super.selectedProfileImage,
    required super.title,
    required super.selectedPatient,
  });
}

class UploadPrescriptionOrClinicalImageSuccessful extends UploadPrescriptionOrClinicalImageState {
  UploadPrescriptionOrClinicalImageSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.commonApiResponse,
    required super.selectedProfileImage,
    required super.title,
    required super.selectedPatient,
  });

  String toastMessage;
}

class UploadPrescriptionOrClinicalImageFailed extends UploadPrescriptionOrClinicalImageState {
  UploadPrescriptionOrClinicalImageFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.commonApiResponse,
    required super.selectedProfileImage,
    required super.title,
    required super.selectedPatient,
  });

  String errorMessage;
}
