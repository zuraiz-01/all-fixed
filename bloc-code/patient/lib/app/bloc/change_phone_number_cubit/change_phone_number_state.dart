// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'change_phone_number_cubit.dart';

class ChangePhoneNumberState extends Equatable {
  bool isLoading;
  String isSuccess;
  String message;
  String traceId;
  ChangePhoneNumberState({
    required this.isLoading,
    required this.isSuccess,
    required this.message,
    required this.traceId,
  });

  @override
  List<Object> get props => [
        isLoading,
        isSuccess,
        message,
        traceId,
      ];

  ChangePhoneNumberState copyWith({
    bool? isLoading,
    String? isSuccess,
    String? message,
    String? traceId,
  }) {
    return ChangePhoneNumberState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      traceId: traceId ?? this.traceId,
    );
  }
}
