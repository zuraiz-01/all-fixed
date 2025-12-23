import 'package:eye_buddy/app/bloc/favorites_doctor/favorites_doctor_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/doctor_profile.dart';
import 'package:eye_buddy/app/views/favourite_doctors_screen/widgets/favourite_doctors_list_item.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shemmer/card_skelton_screen.dart';


class FavouriteDoctorsScreen extends StatelessWidget {
  FavouriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FavouriteDoctorsScreen();
  }
}

class _FavouriteDoctorsScreen extends StatefulWidget {
  _FavouriteDoctorsScreen();

  @override
  State<_FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<_FavouriteDoctorsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext mainContext) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.favourite_doctors,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocConsumer<FavoritesDoctorCubit, FavoritesDoctorState>(
        listener: (context, state) {
          if (state is FavoritesDoctorFailed) {
            showToast(message: state.errorMessage, context: context);
          } else if (state is RemoveDoctorFromFavoritesDoctorSuccessful) {
            showToast(message: state.toastMessage, context: context);
            context.read<FavoritesDoctorCubit>().resetState();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: context.read<FavoritesDoctorCubit>().refreshData,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: state.isLoading
                  ? Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.white,
                      // child: const CustomLoader(),
                      child: const NewsCardSkelton(),
                    )
                  : state.doctorListResponseData!.doctorList!.isNotEmpty && state is FavoritesDoctorSuccessful ||
                          state is RemoveDoctorFromFavoritesDoctorSuccessful
                      ? SizedBox(
                          child: ListView.builder(
                            itemCount: state.doctorListResponseData!.doctorList!.length,
                            // controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 50, top: 10),
                            // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  NavigatorServices().to(
                                    context: context,
                                    widget: DoctorProfileScreen(
                                      isFromFavoriteList: true,
                                      doctorProfile: state.doctorListResponseData!.doctorList![index],
                                    ),
                                  );
                                },
                                child: FavouriteDoctorsListItem(
                                  doctor: state.doctorListResponseData!.doctorList![index],
                                  index: index,
                                ),
                              );
                            },
                          ),
                        )
                      : NoDataFoundWidget(
                          title: "You don't have any favourite doctor",
                        ),
            ),
          );
        },
      ),
    );
  }
}
