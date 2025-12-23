import 'package:eye_buddy/app/models/visual_acuity_test_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_test_failed.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/assets/app_assets.dart';

class VisualAcuitySelectAnswerScreen extends StatelessWidget {
  VisualAcuitySelectAnswerScreen({
    super.key,
    required this.currentPage,
  });

  int currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.zero,
      ),
      backgroundColor: AppColors.appBackground,
      body: Container(
        height: getHeight(context: context),
        width: getWidth(context: context),
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                InterText(
                  title: "Which direction was the letter facing?",
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetVisualAcuitySelectAnswerEWidget(
                        currentPage: currentPage,
                        numberOfTurns: 0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GetVisualAcuitySelectAnswerEWidget(
                        currentPage: currentPage,
                        numberOfTurns: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetVisualAcuitySelectAnswerEWidget(
                        currentPage: currentPage,
                        numberOfTurns: 2,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GetVisualAcuitySelectAnswerEWidget(
                        currentPage: currentPage,
                        numberOfTurns: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetVisualAcuitySelectAnswerEWidget extends StatelessWidget {
  GetVisualAcuitySelectAnswerEWidget({
    super.key,
    required this.currentPage,
    required this.numberOfTurns,
  });

  final int currentPage;
  int numberOfTurns;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (visualAcuityEyeTestList[currentPage].numberOfturns == numberOfTurns) {
          if (currentPage != 6) {
            NavigatorServices().toReplacement(
              context: context,
              widget: VisualAcuityTestScreen(
                currentPage: currentPage + 1,
              ),
            );
          } else {
            NavigatorServices().toReplacement(
              context: context,
              widget: VisualAcuityTestFailedScreen(
                currentPage: currentPage,
              ),
            );
          }
        } else {
          NavigatorServices().toReplacement(
            context: context,
            widget: VisualAcuityTestFailedScreen(
              currentPage: currentPage,
            ),
          );
        }
      },
      child: Material(
        elevation: 60,
        shadowColor: Colors.black.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          height: getWidth(context: context) / 2.5,
          width: getWidth(context: context) / 2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: SizedBox(
            height: getHeight(context: context) / 3,
            width: getWidth(context: context) / 3,
            child: Align(
              child: RotatedBox(
                quarterTurns: numberOfTurns,
                child: SvgPicture.asset(
                  AppAssets.visualAcuityTestE,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
