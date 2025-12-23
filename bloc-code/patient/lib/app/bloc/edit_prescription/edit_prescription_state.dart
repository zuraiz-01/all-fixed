import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/models/common_api_response_model.dart';

class EditPrescriptionState extends Equatable {
  bool isLoading;
  CommonResponseModel? commonApiResponse;
  String title;

  EditPrescriptionState({
    required this.isLoading,
    required this.commonApiResponse,
    required this.title,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];

  EditPrescriptionState copyWith({
    bool? isLoading,
    CommonResponseModel? commonApiResponse,
    String? title,
  }) {
    return EditPrescriptionState(
      isLoading: isLoading ?? this.isLoading,
      commonApiResponse: commonApiResponse ?? this.commonApiResponse,
      title: title ?? this.title,
    );
  }
}

class UploadPrescriptionOrClinicalImageInitial extends EditPrescriptionState {
  UploadPrescriptionOrClinicalImageInitial({
    required super.isLoading,
    required super.commonApiResponse,
    required super.title,
  });
}

class UpdatePrescriptionSuccessful extends EditPrescriptionState {
  UpdatePrescriptionSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.commonApiResponse,
    required super.title,
  });

  String toastMessage;
}

class UpdatePrescriptionFailed extends EditPrescriptionState {
  UpdatePrescriptionFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.commonApiResponse,
    required super.title,
  });

  String errorMessage;
}
