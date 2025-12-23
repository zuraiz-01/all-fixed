// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eye_buddy/app/bloc/timer_cubit/timer_cubit.dart';
import 'package:eye_buddy/app/bloc/visual_acity_eye_test_cubit/visual_acuity_cubit.dart';
import 'package:eye_buddy/app/models/visual_acuity_test_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_test_failed.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../utils/assets/app_assets.dart';

class VisualAcutyTestAssetModel {
  String title;
  String description;
  String imagePath;
  int index;
  VisualAcutyTestAssetModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.index,
  });
}

class VisualAcuitySelectEyeScreen extends StatefulWidget {
  VisualAcuitySelectEyeScreen({
    super.key,
  });

  @override
  State<VisualAcuitySelectEyeScreen> createState() => _VisualAcuitySelectEyeScreenState();
}

class _VisualAcuitySelectEyeScreenState extends State<VisualAcuitySelectEyeScreen> {
  List<VisualAcutyTestAssetModel> rightInstructions = [
    VisualAcutyTestAssetModel(
      title: "Cover your Right eye",
      description: "Cover your left eye and test your right eye",
      imagePath: AppAssets.va21,
      index: 0,
    ),
  ];

  List<VisualAcutyTestAssetModel> leftInstructions = [
    VisualAcutyTestAssetModel(
      title: "Visual Acuity Test",
      description: "Welcome to the Visual Acuity Test. This quick test helps assess your vision",
      imagePath: AppAssets.va1,
      index: 0,
    ),
    VisualAcutyTestAssetModel(
      title: "Test preparation and Device Positioning",
      description:
          "Find a quiet, well-lit area to take the test.Position your device at eye level, about arm's length away. Ensure the screen is unobstructed.",
      imagePath: AppAssets.va2,
      index: 1,
    ),
    VisualAcutyTestAssetModel(
      title: "Cover One Eye Instruction",
      description: "Cover one eye with your hand or use an eye patch.",
      imagePath: AppAssets.va3,
      index: 2,
    ),
    VisualAcutyTestAssetModel(
      title: "Focus on the direction of the “E” and Select the Correct  Response",
      description: "Focus on the 'E' chart displayed on the screen. Select the correct direction the 'E' is facing.",
      imagePath: AppAssets.va4,
      index: 3,
    ),
    VisualAcutyTestAssetModel(
      title: "Repeat for the Other Eye ",
      description: "Uncover the covered eye and repeat the test for the other eye.",
      imagePath: AppAssets.va5,
      index: 4,
    ),
    VisualAcutyTestAssetModel(
      title: "Interpreting Results",
      description: "Results will show as 'Normal,' 'Mild Vision Loss,' 'Moderate Vision Loss,' or 'Severe Vision Loss.' Take note of each eye's result.",
      imagePath: AppAssets.va6,
      index: 5,
    ),
    VisualAcutyTestAssetModel(
      title: "Cover your left eye",
      description: "Cover your left eye and test your right eye",
      imagePath: AppAssets.va7,
      index: 6,
    ),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        elevation: 0.0,
        title: "Visual Acuity Instructions",
        context: context,
        finishScreen: true,
        isTitleCenter: false,
        icon: Icons.arrow_back,
      ),
      backgroundColor: AppColors.appBackground,
      body: Container(
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: BlocBuilder<VisualAcuityCubit, VisualAcuityState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: state.isLefteye ? leftInstructions.length : rightInstructions.length,
                    onPageChanged: (value) {
                      setState(() {
                        currentPageIndex = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: Image.asset(
                                state.isLefteye ? leftInstructions[index].imagePath : rightInstructions[index].imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.isLefteye ? leftInstructions[index].title : rightInstructions[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          state.isLefteye ? leftInstructions[index].description : rightInstructions[index].description,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.isLefteye ? leftInstructions.length : rightInstructions.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: Align(
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: index == currentPageIndex ? Colors.green : Colors.green.withOpacity(.4),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Gap(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: CustomButton(
                    title: "Start Test",
                    callBackFunction: () {
                      context.read<TimerCubit>().startStopwatch();
                      NavigatorServices().toReplacement(
                        context: context,
                        widget: VisualAcuityTestScreen(
                          currentPage: 0,
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
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
