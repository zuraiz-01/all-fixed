import 'package:eye_buddy/app/bloc/homeframe_cubit/homeframe_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBarIconWidget extends StatelessWidget {
  BottomNavBarIconWidget({
    required this.title,
    required this.iconPath,
    required this.navbarPosition,
    required this.bottomNavBarPageController,
    super.key,
  });

  String title;
  String iconPath;
  int navbarPosition;
  PageController bottomNavBarPageController;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<HomeframeCubit, HomeframeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<HomeframeCubit>().changePage(
                  pageIndex: navbarPosition,
                );
            bottomNavBarPageController.animateToPage(
              navbarPosition,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 100,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: state.currentPageIndex == navbarPosition ? AppColors.color008541 : Colors.transparent,
              borderRadius: BorderRadius.circular(
                130,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(15),
                  width: getProportionateScreenHeight(15),
                  child: SvgPicture.asset(
                    iconPath,
                    theme: SvgTheme(
                      currentColor: state.currentPageIndex == navbarPosition ? Colors.white : AppColors.colorBBBBBB,
                    ),
                    color: state.currentPageIndex == navbarPosition ? Colors.white : AppColors.colorBBBBBB,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                InterText(
                  title: title,
                  textColor: state.currentPageIndex == navbarPosition ? Colors.white : AppColors.colorBBBBBB,
                  fontWeight: state.currentPageIndex == navbarPosition ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
