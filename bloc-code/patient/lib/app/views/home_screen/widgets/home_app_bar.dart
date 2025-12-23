import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_state.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/language_chip.dart';
import 'package:eye_buddy/app/views/notifications_screen/notifications_screen.dart';
import 'package:eye_buddy/app_routes/route_name.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.profileScreen);
                },
                child: SizedBox(
                  height: getProportionateScreenHeight(48),
                  width: getProportionateScreenHeight(48),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: CommonNetworkImageWidget(
                      imageLink: state.profileResponseModel?.profile?.photo !=
                              null
                          ? '${ApiConstants.imageBaseUrl}${state.profileResponseModel?.profile?.photo}'
                          : '',
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          const LanguageChip(),
          CommonSizeBox(
            width: getProportionateScreenWidth(20),
          ),
          GestureDetector(
            onTap: () {
              NavigatorServices().to(
                context: context,
                widget: NotificationsScreen(),
              );
            },
            child: SvgPicture.asset(
              AppAssets.bell,
              height: getProportionateScreenWidth(20),
              width: getProportionateScreenWidth(20),
            ),
          )
        ],
      ),
    );
  }
}
