import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/widgets/bottom_navbar_icon.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.bottomNavBarPageController,
  });

  final PageController bottomNavBarPageController;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: kToolbarHeight * 1.5,
      width: getWidth(context: context),
      decoration: BoxDecoration(
        color: AppColors.colorFFFFFF,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 15,
            offset: const Offset(0, 0.75),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavBarIconWidget(
            title: l10n.home,
            iconPath: AppAssets.navbarHome,
            navbarPosition: 0,
            bottomNavBarPageController: bottomNavBarPageController,
          ),
          BottomNavBarIconWidget(
            title: l10n.appointments,
            iconPath: AppAssets.navbarAppointments,
            navbarPosition: 1,
            bottomNavBarPageController: bottomNavBarPageController,
          ),
          BottomNavBarIconWidget(
            title: l10n.more,
            iconPath: AppAssets.navbarMore,
            navbarPosition: 2,
            bottomNavBarPageController: bottomNavBarPageController,
          ),
        ],
      ),
    );
  }
}
