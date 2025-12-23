// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verify_otp_cubit.dart';

class VerifyOtpState extends Equatable {
  bool isLoading;
  VerifyOtpApiResponseData? verifyOtpApiResponseData;
  VerifyOtpState({
    required this.isLoading,
    required this.verifyOtpApiResponseData,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];

  VerifyOtpState copyWith({
    bool? isLoading,
    VerifyOtpApiResponseData? verifyOtpApiResponseData,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      verifyOtpApiResponseData: verifyOtpApiResponseData ?? this.verifyOtpApiResponseData,
    );
  }
}

class VerifyOtpFailed extends VerifyOtpState {
  String errorMessage;
  VerifyOtpFailed({
    required this.errorMessage,
    required super.isLoading,
    required super.verifyOtpApiResponseData,
  });
}

class VerifyOtpSuccessful extends VerifyOtpState {
  String toastMessage;
  bool isNewUser;
  VerifyOtpSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.verifyOtpApiResponseData,
    required this.isNewUser,
  });
}
