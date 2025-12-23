import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/api/model/banner_response_model.dart';
import 'package:eye_buddy/app/api/repo/api_repo.dart';

part 'home_screen_banner_state.dart';

class HomeScreenBannerCubit extends Cubit<HomeScreenBannerState> {
  HomeScreenBannerCubit()
      : super(
          HomeScreenBannerState(
            isLoading: false,
            homeScreenBannerList: [],
          ),
        );

  void resetState() {
    emit(
      HomeScreenBannerState(
        isLoading: false,
        homeScreenBannerList: state.homeScreenBannerList,
      ),
    );
  }

  Future<void> getHomeBannersList() async {
    emit(HomeScreenBannerState(isLoading: true, homeScreenBannerList: []));
    final bannerList = await ApiRepo().getHomeBanners();
    if (bannerList.status == 'success') {
      emit(
        HomeScreenBannerSuccessful(
          isLoading: false,
          toastMessage: bannerList.message!,
          homeScreenBannerList: bannerList.bannerList,
        ),
      );
    } else {
      emit(
        HomeScreenBannerFailed(
          isLoading: false,
          errorMessage: bannerList.message!,
          homeScreenBannerList: [],
        ),
      );
    }
  }
}
