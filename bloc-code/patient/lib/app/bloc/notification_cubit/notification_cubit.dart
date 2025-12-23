import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/model/notification_response_model.dart';
import '../../api/repo/api_repo.dart';
import '../../utils/keys/token_keys.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationListState> {
  NotificationCubit()
      : super(
          NotificationListState(isLoading: false, notificationResponseModel: null, notificationList: []),
        );

  void resetState() {
    emit(
      NotificationListState(
          isLoading: false, notificationResponseModel: state.notificationResponseModel, notificationList: state.notificationList),
    );
  }

  Future<void> refreshScreen() async {
    getNotificationList();
  }

  Future<void> getNotificationList() async {
    log("user toke ${patientToken}");

    Map<String, String> parameters = Map<String, String>();
    // parameters["patient"] = "${state.patient.id}";

    emit(
        NotificationListState(isLoading: true, notificationResponseModel: state.notificationResponseModel, notificationList: []));
    final promosApiResponse = await ApiRepo().getNotificationList(parameters);
    if (promosApiResponse.status == 'success') {
      emit(
        NotificationListSuccessful(
            isLoading: false,
            toastMessage: promosApiResponse.message!,
            notificationResponseModel: promosApiResponse,
            notificationList: promosApiResponse.notificationData!.notificationList),
      );
    } else {
      emit(
        NotificationListFailed(
            isLoading: false,
            errorMessage: promosApiResponse.message!,
            notificationResponseModel: state.notificationResponseModel,
            notificationList: state.notificationList),
      );
    }
  }
}
