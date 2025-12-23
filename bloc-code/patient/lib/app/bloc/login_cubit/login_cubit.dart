import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/loginModels.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:flutter/material.dart';

import '../../utils/keys/token_keys.dart';
import '../../views/global_widgets/toast.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : super(
          LoginState(
            isLoading: false,
            loginApiResponseDataModel: null,
            traceId: "",
          ),
        );

  void resetState() {
    emit(
      LoginState(
        isLoading: false,
        loginApiResponseDataModel: null,
        traceId: state.traceId,
      ),
    );
  }

  String? checkPhoneNumberFormat({required String phoneNumber}) {
    log(phoneNumber.length.toString());
    if (phoneNumber.length == 10) {
      return phoneNumber;
    }
    if (phoneNumber.length > 10 && phoneNumber.startsWith("0")) {
      return phoneNumber.substring(1, phoneNumber.length);
    } else if (phoneNumber.length > 10 || phoneNumber.length < 10) {
      return null;
    }
    return null;
  }

  Future<void> loginUser({
    required String phone,
    required String dialCode,
    required BuildContext context,
  }) async {
    // dialCode = "+880";
    // dialCode = "+91";
    String? verifiedPhoneNumber = checkPhoneNumberFormat(phoneNumber: phone);

    log("User phone:" + (verifiedPhoneNumber ?? ""));
    log("User dialcode:" + dialCode);

    if (verifiedPhoneNumber != null) {
      phone = verifiedPhoneNumber;
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
      final loginApiResponseModel = await ApiRepo().loginUser(
        phone: phone,
        dialCode: dialCode,
      );
      if (loginApiResponseModel.status == 'success') {
        traceId = loginApiResponseModel.data!.traceId!;
        emit(
          LoginSuccessful(
            isLoading: false,
            loginApiResponseDataModel: loginApiResponseModel.data,
            toastMessage: loginApiResponseModel.message!,
            traceId: traceId,
          ),
        );
      } else {
        emit(
          LoginFailed(
            isLoading: false,
            errorMessage: loginApiResponseModel.message!,
            loginApiResponseDataModel: loginApiResponseModel.data,
            traceId: state.traceId,
          ),
        );
      }
    } else {
      showToast(message: "Invalid phone number", context: context);
    }
  }
}
