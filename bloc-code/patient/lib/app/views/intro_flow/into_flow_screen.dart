import 'package:eye_buddy/app/bloc/intro_cubit/intro_cubit.dart';
import 'package:eye_buddy/app/models/intro_widget_model.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/intro_flow/widgets/intro_background_image_widget.dart';
import 'package:eye_buddy/app/views/intro_flow/widgets/intro_page_indexer.dart';
import 'package:eye_buddy/app/views/login_flow/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class IntroFlowScreen extends StatelessWidget {
  const IntroFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IntroCubit(),
      child: _IntroFlowView(),
    );
  }
}

class _IntroFlowView extends StatelessWidget {
  _IntroFlowView();

  final List<IntroWidgetModel> introPageImages = [
    IntroWidgetModel(
      imagePath: AppAssets.introOneImage,
      title: 'Get top eye doctors\nconsultation from home',
    ),
    IntroWidgetModel(
      imagePath: AppAssets.introTwoImage,
      title: 'Best eye doctors\nin one place',
    ),
    IntroWidgetModel(
      imagePath: AppAssets.introThreeImage,
      title: 'Test you eye\nfrom home',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        // color: AppColors.primaryColor,
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [

            Image.asset(
              AppAssets.onboarding_bg,
              fit: BoxFit.fill,
              width: getWidth(context: context),
              height: getHeight(context: context),
            ),

            IntroBackgoundImageWidget(
              introPageImages: introPageImages,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              height: getHeight(context: context) / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gap(5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: BlocBuilder<IntroCubit, IntroState>(
                      builder: (context, state) {
                        return InterText(
                          title: introPageImages[state.currentPageIndex].title,
                          fontSize: 20,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        );
                      },
                    ),
                  ),
                  IntroPageIndexer(
                    introPageImages: introPageImages,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: CustomButton(
                          title: 'Get Started',
                          callBackFunction: () {
                            NavigatorServices().toReplacement(
                              context: context,
                              widget: LoginScreen(
                                showBackButton: false,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
