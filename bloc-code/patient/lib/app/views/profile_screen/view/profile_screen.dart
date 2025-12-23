import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/edit_profile_screen/view/edit_profile_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/profile_screen/widgets/profile_info_item.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shemmer/card_skelton_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.my_profile,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state.isLoading
              ? Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  child: const NewsCardSkelton(),
                  // child: const CustomLoader(),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      SizedBox(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(100),
                              width: getProportionateScreenHeight(100),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CommonNetworkImageWidget(
                                  imageLink: state.profileResponseModel!
                                              .profile!.photo !=
                                          null
                                      ? '${ApiConstants.imageBaseUrl}${state.profileResponseModel!.profile!.photo}'
                                      : '',
                                ),
                              ),
                            ),
                            // Positioned(
                            //   right: 0,
                            //   bottom: 0,
                            //   child: Container(
                            //     height: getProportionateScreenHeight(30),
                            //     width: getProportionateScreenWidth(30),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(15),
                            //       color: AppColors.colorCCE7D9,
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(4),
                            //       child: SvgPicture.asset(
                            //         AppAssets.upload,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      ProfileInfoItem(
                        title: l10n.full_name,
                        titleDetails:
                            '${state.profileResponseModel!.profile!.name}',
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      ProfileInfoItem(
                        title: l10n.date_of_birth,
                        titleDetails:
                            '${formatDateDDMMMMYYYY(state.profileResponseModel!.profile!.dateOfBirth.toString())}',
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      ProfileInfoItem(
                        title: l10n.gender,
                        titleDetails:
                            '${state.profileResponseModel!.profile!.gender}',
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      ProfileInfoItem(
                        title: l10n.weight,
                        titleDetails:
                            '${state.profileResponseModel!.profile!.weight} KG',
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(16),
                      ),
                      ProfileInfoItem(
                        title: l10n.email,
                        titleDetails:
                            '${state.profileResponseModel!.profile!.email}',
                      ),
                      const Spacer(),
                      CustomButton(
                        title: l10n.edit_profile,
                        callBackFunction: () {
                          NavigatorServices().to(
                              context: context,
                              widget: EditProfileScreen(
                                profile: state.profileResponseModel!.profile,
                              ));
                        },
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(12),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
