// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

class LoginState extends Equatable {
  bool isLoading;
  LoginApiResponseDataModel? loginApiResponseDataModel;
  String traceId;
  LoginState({
    required this.isLoading,
    required this.loginApiResponseDataModel,
    required this.traceId,
  });

  @override
  List<Object> get props => [
        isLoading,
        loginApiResponseDataModel.hashCode,
        traceId,
      ];

  LoginState copyWith({
    bool? isLoading,
    LoginApiResponseDataModel? loginApiResponseDataModel,
    String? traceId,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      loginApiResponseDataModel: loginApiResponseDataModel ?? this.loginApiResponseDataModel,
      traceId: traceId ?? this.traceId,
    );
  }
}

class LoginSuccessful extends LoginState {
  LoginSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.loginApiResponseDataModel,
    required super.traceId,
  });
  String toastMessage;
}

class LoginFailed extends LoginState {
  LoginFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.loginApiResponseDataModel,
    required super.traceId,
  });

  String errorMessage;
}
