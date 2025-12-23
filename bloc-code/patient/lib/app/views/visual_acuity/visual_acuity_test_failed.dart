import 'package:eye_buddy/app/bloc/visual_acity_eye_test_cubit/visual_acuity_cubit.dart';
import 'package:eye_buddy/app/models/visual_acuity_test_model.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile/profile_cubit.dart';

class VisualAcuityTestFailedScreen extends StatefulWidget {
  VisualAcuityTestFailedScreen({
    super.key,
    required this.currentPage,
  });

  int currentPage;

  @override
  State<VisualAcuityTestFailedScreen> createState() => _VisualAcuityTestFailedScreenState();
}

class _VisualAcuityTestFailedScreenState extends State<VisualAcuityTestFailedScreen> {
  @override
  void initState() {
    context.read<VisualAcuityCubit>().updateScore(
          "${visualAcuityEyeTestList[widget.currentPage].myRange}/${visualAcuityEyeTestList[widget.currentPage].averageHumansRange}",
        );
    VisualAcuityState visualAcuityState = context.read<VisualAcuityCubit>().state;
    // if (!visualAcuityState.isLefteye) {
    //   context.read<VisualAcuityCubit>().updateVisualAcuityTestResult(
    //         context.read<ProfileCubit>().state.profileResponseModel?.profile?.sId ?? "",
    //       );
    // }

    context.read<VisualAcuityCubit>().updateVisualAcuityTestResult(context,
          context.read<ProfileCubit>().state.profileResponseModel?.profile?.sId ?? "",
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var visualAcuityModel = visualAcuityEyeTestList[widget.currentPage];
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.zero,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 33),
        width: getWidth(context: context),
        height: getHeight(context: context),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InterText(
                    title: visualAcuityModel.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InterText(
                    title: visualAcuityModel.message,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  title: "Start Again",
                  callBackFunction: () {
                    context.read<VisualAcuityCubit>().resetScore();
                    NavigatorServices().toReplacement(
                      context: context,
                      widget: VisualAcuitySelectEyeScreen(),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<VisualAcuityCubit, VisualAcuityState>(
                  builder: (context, state) {
                    return state.isLefteye
                        ? Column(
                            children: [
                              CustomButton(
                                title: "Continue for right eye",
                                showBorder: true,
                                callBackFunction: () {
                                  context.read<VisualAcuityCubit>().updateCurrentEye(
                                        false,
                                      );
                                  NavigatorServices().toReplacement(
                                    context: context,
                                    widget: VisualAcuitySelectEyeScreen(),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink();
                  },
                ),
                CustomButton(
                  title: "Back to Home",
                  showBorder: true,
                  callBackFunction: () {
                    NavigatorServices().pop(context: context);
                    NavigatorServices().pop(context: context);
                  },
                ),
                SizedBox(
                  height: 30,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
