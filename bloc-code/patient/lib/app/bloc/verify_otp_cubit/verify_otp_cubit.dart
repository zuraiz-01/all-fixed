import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/data/api_data.dart';
import 'package:eye_buddy/app/api/model/verifyOtpModel.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

import '../../utils/keys/token_keys.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit()
      : super(
          VerifyOtpState(
            isLoading: false,
            verifyOtpApiResponseData: null,
          ),
        );

  void resetState() {
    emit(
      VerifyOtpState(
        isLoading: false,
        verifyOtpApiResponseData: null,
      ),
    );
  }

  Future<void> verifyOtp({
    required String otpCode,
    bool isForChangePhoneNumber = false,
  }) async {
    emit(
      state.copyWith(isLoading: true),
    );
    final verifyOtpApiResponse = await ApiRepo().verifyOtp(
      traceId: traceId,
      otpCode: otpCode,
      isForChangePhoneNumber: isForChangePhoneNumber,
    );

    if (verifyOtpApiResponse.status == 'success') {
      print("Patient Data: ${verifyOtpApiResponse.data}");
      emit(
        VerifyOtpSuccessful(
          toastMessage: verifyOtpApiResponse.message!,
          isLoading: false,
          verifyOtpApiResponseData: verifyOtpApiResponse.data,
          isNewUser: isForChangePhoneNumber
              ? false
              : verifyOtpApiResponse.data!.isNewUser!,
        ),
      );
      await saveToken(token: verifyOtpApiResponse.data!.token!);
    } else {
      emit(
        VerifyOtpFailed(
          errorMessage: verifyOtpApiResponse.message!,
          isLoading: false,
          verifyOtpApiResponseData: verifyOtpApiResponse.data,
        ),
      );
    }
  }
}
