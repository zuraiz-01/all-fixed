

import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';

class TransactionsHistoryState extends Equatable {
  bool isLoading;
  GetAppointmentApiResponse? getAppointmentApiResponse;

  TransactionsHistoryState({
    required this.isLoading,
    required this.getAppointmentApiResponse,
  });

  @override
  List<Object> get props => [
    isLoading,
  ];
}

class TransactionsHistoryInitial extends TransactionsHistoryState {
  TransactionsHistoryInitial({required super.isLoading, required super.getAppointmentApiResponse});
}

class TransactionsHistorySuccessful extends TransactionsHistoryState {
  TransactionsHistorySuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.getAppointmentApiResponse,
  });

  String toastMessage;
}

class TransactionsHistoryFailed extends TransactionsHistoryState {
  TransactionsHistoryFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.getAppointmentApiResponse,
  });

  String errorMessage;
}
