import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/app_test_result_response_model.dart';
import 'package:eye_buddy/app/api/model/test_result_response_model.dart';

class TestResultState extends Equatable {
  bool isLoading;
  TestResultResponseModel? testResultResponseModel;
  AppTestResultResponseModel? appTestResult;
  List<TestResult>? clinicalResultList;

  TestResultState({
    required this.isLoading,
    required this.testResultResponseModel,
    required this.appTestResult,
    required this.clinicalResultList,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];
}

class TestResultInitial extends TestResultState {
  TestResultInitial({
    required super.isLoading,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });
}

class TestResultSuccessful extends TestResultState {
  TestResultSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String toastMessage;
}

class TestResultFailed extends TestResultState {
  TestResultFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String errorMessage;
}

class DeleteTestResultSuccessful extends TestResultState {
  DeleteTestResultSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String toastMessage;
}

class DeleteTestResultFailed extends TestResultState {
  DeleteTestResultFailed({
    required this.errorMessage,
    required super.isLoading,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String errorMessage;
}

class AppTestResultSuccessful extends TestResultState {
  AppTestResultSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String toastMessage;
}

class AppTestResultFailed extends TestResultState {
  AppTestResultFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.testResultResponseModel,
    required super.appTestResult,
    required super.clinicalResultList,
  });

  String errorMessage;
}
