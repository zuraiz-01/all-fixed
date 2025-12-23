import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/edit_prescription/edit_prescription_state.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPrescriptionCubit extends Cubit<EditPrescriptionState> {
  EditPrescriptionCubit()
      : super(
          EditPrescriptionState(
            isLoading: false,
            commonApiResponse: null,
            title: "",
          ),
        );

  void resetState() {
    emit(
      EditPrescriptionState(
        isLoading: false,
        commonApiResponse: state.commonApiResponse,
        title: "",
      ),
    );
  }

  Future<void> updatePatientPrescriptionUpdate(var parameters, BuildContext context) async {
    emit(EditPrescriptionState(
      isLoading: true,
      commonApiResponse: state.commonApiResponse,
      title: state.title,
    ));
    final promosApiResponse = await ApiRepo().updatePatientPrescriptionUpdate(parameters);
    if (promosApiResponse.status == 'success') {
      context.read<PrescriptionListCubit>().getPrescriptionList();
      emit(
        UpdatePrescriptionSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          title: state.title,
        ),
      );
    } else {
      emit(
        UpdatePrescriptionFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          title: state.title,
        ),
      );
    }
  }

  Future<void> updateClinicalPrescription(var parameters, BuildContext context) async {
    emit(EditPrescriptionState(
      isLoading: true,
      commonApiResponse: state.commonApiResponse,
      title: state.title,
    ));
    final promosApiResponse = await ApiRepo().updateClinicalPrescription(parameters);
    if (promosApiResponse.status == 'success') {
      context.read<TestResultCubit>().getClinicalTestResultData();
      emit(
        UpdatePrescriptionSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          title: state.title,
        ),
      );
    } else {
      emit(
        UpdatePrescriptionFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          commonApiResponse: state.commonApiResponse,
          title: state.title,
        ),
      );
    }
  }
}
