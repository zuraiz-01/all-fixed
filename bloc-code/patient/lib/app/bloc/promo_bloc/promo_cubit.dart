import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/apply_promo_response_model.dart';
import 'package:eye_buddy/app/api/model/promo_list_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/keys/shared_pref_keys.dart';

part 'promo_state.dart';

class PromoCubit extends Cubit<PromoState> {
  PromoCubit()
      : super(
          PromoState(
            isLoading: false,
            promoResponseModel: null,
          ),
        );

  void resetState() {
    emit(
      PromoState(
        isLoading: false,
        promoResponseModel: state.promoResponseModel,
      ),
    );
  }

  Future<void> refreshData() async {
    log('refreshing data...');
    getPromoList();
  }

  Future<void> getPromoList() async {
    emit(PromoState(isLoading: true, promoResponseModel: null));

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? promoListString = await preferences.getString(getPromoKey);

    if (promoListString != null) {
      try {
        PromoResponseModel promoResponseModel = PromoResponseModel.fromJson(jsonDecode(promoListString));
        emitPromoList(promoResponseModel);
      } catch (e) {}
    }

    PromoResponseModel promosApiResponse = await ApiRepo().getPromos();
    preferences.setString(getPromoKey, jsonEncode(promosApiResponse.toJson()));

    emitPromoList(promosApiResponse);
  }

  Future<void> applyPromoCode(
    Map<String, String> parameters,
    BuildContext context,
  ) async {
    emit(PromoState(isLoading: true, promoResponseModel: state.promoResponseModel));
    ApplyPromo promosApiResponse = await ApiRepo().applyPromoCode(parameters);
    if (promosApiResponse.status == 'success') {
      context.read<ReasonForVisitCubit>().updateAppointmentWithPromoData(
            vat: (promosApiResponse.data?.vat ?? 0).toString(),
            grandTotal: (promosApiResponse.data?.grandTotal ?? 0).toString(),
            totalAmount: (promosApiResponse.data?.totalAmount ?? 0).toString(),
          );

      log("Pushing");
      showToast(message: "Promo applied", context: context);
      emit(
        ApplyPromoSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          promoResponseModel: state.promoResponseModel,
        ),
      );
    } else {
      showToast(message: "Invalid promo", context: context);
      emit(
        PromoFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          promoResponseModel: state.promoResponseModel,
        ),
      );
    }
  }

  emitPromoList(PromoResponseModel promosApiResponse) {
    if (promosApiResponse.status == 'success') {
      emit(
        PromoSuccessful(
          isLoading: false,
          toastMessage: promosApiResponse.message!,
          promoResponseModel: promosApiResponse.promoResponseData,
        ),
      );
    } else {
      emit(
        PromoFailed(
          isLoading: false,
          errorMessage: promosApiResponse.message!,
          promoResponseModel: promosApiResponse.promoResponseData,
        ),
      );
    }
  }
}
