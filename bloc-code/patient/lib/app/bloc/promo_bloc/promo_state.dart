part of 'promo_cubit.dart';

class PromoState extends Equatable {
  bool isLoading;
  PromoResponseData? promoResponseModel;

  PromoState({
    required this.isLoading,
    required this.promoResponseModel,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];
}

class PromoInitial extends PromoState {
  PromoInitial({required super.isLoading, required super.promoResponseModel});
}

class PromoSuccessful extends PromoState {
  PromoSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.promoResponseModel,
  });

  String toastMessage;
}

class PromoFailed extends PromoState {
  PromoFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.promoResponseModel,
  });

  String errorMessage;
}

class ApplyPromoSuccessful extends PromoState {
  ApplyPromoSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.promoResponseModel,
  });

  String toastMessage;
}
