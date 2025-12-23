import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/api/model/test_result_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

import 'test_result_state.dart';

class TestResultCubit extends Cubit<TestResultState> {
  TestResultCubit()
      : super(
          TestResultState(
            isLoading: false,
            testResultResponseModel: null,
            appTestResult: null,
            clinicalResultList: [],
          ),
        );

  void resetState() {
    emit(
      TestResultState(
        isLoading: false,
        testResultResponseModel: state.testResultResponseModel,
        appTestResult: state.appTestResult,
        clinicalResultList: state.clinicalResultList,
      ),
    );
  }

  Future<void> getClinicalTestResultData() async {
    emit(TestResultState(
        isLoading: true, testResultResponseModel: null, appTestResult: state.appTestResult, clinicalResultList: []));
    final testResultApiResponse = await ApiRepo().getClinicalTestResultData();
    if (testResultApiResponse.status == 'success') {
      state.clinicalResultList!.clear();
      state.clinicalResultList!.addAll(testResultApiResponse.testResultResponseData!.docs as Iterable<TestResult>);
      // for (var result in testResultApiResponse.testResultResponseData!.docs!) {
      //   if (result.type == "clinical") {
      //     state.clinicalResultList!.add(result);
      //   } else if (result.type == "app") {
      //     state.appTestResultList!.add(result);
      //   }
      // }

      emit(
        TestResultSuccessful(
          isLoading: false,
          toastMessage: testResultApiResponse.message!,
          testResultResponseModel: testResultApiResponse,
          appTestResult: state.appTestResult,
          clinicalResultList: state.clinicalResultList,
        ),
      );
    } else {
      emit(
        TestResultFailed(
          isLoading: false,
          errorMessage: testResultApiResponse.message!,
          testResultResponseModel: testResultApiResponse,
          appTestResult: state.appTestResult,
          clinicalResultList: [],
        ),
      );
    }
  }

  Future<void> getAppTestResultData() async {
    emit(TestResultState(
        isLoading: true, testResultResponseModel: null, appTestResult: null, clinicalResultList: state.clinicalResultList));
    final testResultApiResponse = await ApiRepo().getAppTestResultData();
    if (testResultApiResponse.status == 'success') {
      emit(
        AppTestResultSuccessful(
          isLoading: false,
          toastMessage: testResultApiResponse.message!,
          testResultResponseModel: state.testResultResponseModel,
          appTestResult: testResultApiResponse,
          clinicalResultList: state.clinicalResultList,
        ),
      );
    } else {
      emit(
        AppTestResultFailed(
          isLoading: false,
          errorMessage: testResultApiResponse.message!,
          testResultResponseModel: state.testResultResponseModel,
          appTestResult: state.appTestResult,
          clinicalResultList: state.clinicalResultList,
        ),
      );
    }
  }

  Future<void> deleteTestResult(String testResultId) async {
    emit(TestResultState(
        isLoading: true,
        testResultResponseModel: state.testResultResponseModel,
        appTestResult: state.appTestResult,
        clinicalResultList: state.clinicalResultList));
    final testResultApiResponse = await ApiRepo().deleteTestResult(resultId: testResultId);
    if (testResultApiResponse.status == 'success') {
      getClinicalTestResultData();
      emit(
        DeleteTestResultSuccessful(
          isLoading: false,
          toastMessage: testResultApiResponse.message!,
          testResultResponseModel: state.testResultResponseModel,
          appTestResult: state.appTestResult,
          clinicalResultList: state.clinicalResultList,
        ),
      );
    } else {
      emit(
        DeleteTestResultFailed(
          isLoading: false,
          errorMessage: testResultApiResponse.message!,
          testResultResponseModel: state.testResultResponseModel,
          appTestResult: state.appTestResult,
          clinicalResultList: state.clinicalResultList,
        ),
      );
    }
  }
}
