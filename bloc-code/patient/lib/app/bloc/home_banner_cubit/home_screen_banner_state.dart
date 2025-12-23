part of 'home_screen_banner_cubit.dart';

class HomeScreenBannerState extends Equatable {
  bool isLoading;
  List<Banner>? homeScreenBannerList;

  HomeScreenBannerState({
    required this.isLoading,
    required this.homeScreenBannerList,
  });

  @override
  List<Object> get props => [
        isLoading,
      ];
}

class HomeScreenBannerInitial extends HomeScreenBannerState {
  HomeScreenBannerInitial({required super.isLoading, required super.homeScreenBannerList});
}

class HomeScreenBannerSuccessful extends HomeScreenBannerState {
  HomeScreenBannerSuccessful({
    required this.toastMessage,
    required super.isLoading,
    required super.homeScreenBannerList,
  });

  String toastMessage;
}

class HomeScreenBannerFailed extends HomeScreenBannerState {
  HomeScreenBannerFailed({
    required super.isLoading,
    required this.errorMessage,
    required super.homeScreenBannerList,
  });

  String errorMessage;
}
