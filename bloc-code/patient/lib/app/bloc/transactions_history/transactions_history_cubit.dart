import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/transactions_history/transactions_history_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/model/appointment_doctor_model.dart';
import '../../utils/keys/shared_pref_keys.dart';

class TransactionsHistoryCubit extends Cubit<TransactionsHistoryState> {
  TransactionsHistoryCubit()
      : super(
          TransactionsHistoryState(
            isLoading: false,
            getAppointmentApiResponse: null,
          ),
        );

  void resetState() {
    emit(
      TransactionsHistoryState(
        isLoading: false,
        getAppointmentApiResponse: state.getAppointmentApiResponse,
      ),
    );
  }

  Future<void> getTransactionsHistory(String patientId) async {
    emit(TransactionsHistoryState(
        isLoading: true, getAppointmentApiResponse: null));

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? transactionsHistoryListString =
        await preferences.getString(getTransactionListKey);

    if (transactionsHistoryListString != null) {
      try {
        GetAppointmentApiResponse getAppointmentApiResponse =
            GetAppointmentApiResponse.fromJson(
                jsonDecode(transactionsHistoryListString));
        emitTransactionList(getAppointmentApiResponse);
      } catch (e) {}
    }

    final getAppointmentApiResponse =
        await ApiRepo().getAppointments("", patientId);
    preferences.setString(
        getTransactionListKey, jsonEncode(getAppointmentApiResponse.toJson()));

    emitTransactionList(getAppointmentApiResponse);
  }

  emitTransactionList(GetAppointmentApiResponse getAppointmentApiResponse) {
    ///past/upcoming/followup
    if (getAppointmentApiResponse.status == 'success') {
      emit(
        TransactionsHistorySuccessful(
            isLoading: false,
            toastMessage: getAppointmentApiResponse.message ?? "",
            getAppointmentApiResponse: getAppointmentApiResponse),
      );
    } else {
      emit(
        TransactionsHistoryFailed(
          isLoading: false,
          errorMessage: getAppointmentApiResponse.message ?? "",
          getAppointmentApiResponse: getAppointmentApiResponse,
        ),
      );
    }
  }
}
