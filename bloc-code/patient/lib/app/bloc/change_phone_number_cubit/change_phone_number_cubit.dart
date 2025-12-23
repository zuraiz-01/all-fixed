import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

import '../../api/model/loginModels.dart';
import '../../utils/keys/token_keys.dart';

part 'change_phone_number_state.dart';

class ChangePhoneNumberCubit extends Cubit<ChangePhoneNumberState> {
  ChangePhoneNumberCubit()
      : super(
          ChangePhoneNumberState(
            isLoading: false,
            isSuccess: "",
            message: "",
            traceId: "",
          ),
        );

  void resetState() {
    emit(
      state.copyWith(
        isSuccess: "",
        message: "",
      ),
    );
  }

  Future<void> changePhoneNumber(Map<String, dynamic> params) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    LoginApiResponseModel apiRes = await ApiRepo().changePhoneNumber(
      params: params,
    );
    if (apiRes.status == "success") {
      traceId = apiRes.data!.traceId!;
    }
    emit(
      state.copyWith(
        isLoading: false,
        isSuccess: apiRes.status,
        message: apiRes.message,
      ),
    );
  }
}
