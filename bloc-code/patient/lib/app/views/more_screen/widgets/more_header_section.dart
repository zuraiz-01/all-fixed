import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_state.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreHeaderSection extends StatelessWidget {
  const MoreHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.profileScreen);
      },
      child: Column(
        children: [
          Container(
            color: AppColors.colorCCE7D9,
            padding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 22,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state.profileResponseModel == null) {
                      return NoDataFoundWidget(
                        title: "You don't have any data",
                      );
                    }
                    return SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenHeight(60),
                            ),
                            child: state.profileResponseModel?.profile?.photo ==
                                        '' ||
                                    state.profileResponseModel?.profile
                                            ?.photo ==
                                        null
                                ? Container(
                                    height: getProportionateScreenHeight(64),
                                    width: getProportionateScreenHeight(64),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        110,
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            AppAssets.beh_app_icon_with_bg),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: getProportionateScreenHeight(64),
                                    width: getProportionateScreenHeight(64),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        60,
                                      ),
                                    ),
                                    child: CommonNetworkImageWidget(
                                      imageLink:
                                          '${ApiConstants.imageBaseUrl}${state.profileResponseModel!.profile!.photo}',
                                      key: key,
                                    ),
                                  ),
                          ),
                          CommonSizeBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: InterText(
                                    title: state.profileResponseModel?.profile
                                            ?.name ??
                                        "",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CommonSizeBox(
                                  height: getProportionateScreenWidth(2),
                                ),
                                InterText(
                                  title: state.profileResponseModel?.profile
                                          ?.phone ??
                                      "",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColors.color888E9D,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.color008541,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: 1,
            color: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
