// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eye_buddy/app/bloc/timer_cubit/timer_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/device_utils.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_select_answer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/visual_acuity_test_model.dart';
import '../../utils/assets/app_assets.dart';
import '../../utils/services/navigator_services.dart';
import '../global_widgets/inter_text.dart';

class VisualAcuityTestScreen extends StatefulWidget {
  int currentPage;
  VisualAcuityTestScreen({
    required this.currentPage,
  });

  @override
  State<VisualAcuityTestScreen> createState() => VisualAcuityTestScreenState(
        currentPage: currentPage,
      );
}

class VisualAcuityTestScreenState extends State<VisualAcuityTestScreen> {
  int currentPage;

  VisualAcuityTestScreenState({
    required this.currentPage,
  });

  @override
  void initState() {
    super.initState();
    context.read<TimerCubit>().startStopwatch();
  }

  @override
  void dispose() {
    // context.read<TimerCubit>().resetStopwatch();
    super.dispose();
  }

  double calculatePixels(double cm, double devicePpi) {
    return (cm * devicePpi) / 2.54;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.zero,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 22),
        width: getWidth(context: context),
        height: getHeight(context: context),
        child: Column(
          children: [
            GetVisualAcuityTestScreenAppbar(currentPage: currentPage),
            // InterText(
            //   title: devicePpi.toString(),
            // ),
            // InterText(
            //   title: screenResolutionHeight.toString(),
            // ),
            // InterText(
            //   title: screenResolutionHeight.toString(),
            // ),
            // Expanded(
            //   child: Container(
            //     height: getHeight(context: context),
            //     width: getWidth(context: context),
            //     child: SizedBox(
            //       height: getHeight(context: context) / 2,
            //       width: getWidth(context: context) / 2,
            //       child: Align(
            //         child: RotatedBox(
            //           quarterTurns: visualAcuityEyeTestList[currentPage].numberOfturns,
            //           child: SvgPicture.asset(
            //             AppAssets.visualAcuityTestE,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Center(
                child: Align(
                  child: MillimeterBox(
                    mmVal: visualAcuityEyeTestList[currentPage].sizeInMM,
                    numberOfturns:
                        visualAcuityEyeTestList[currentPage].numberOfturns,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GetVisualAcuityTestScreenAppbar extends StatelessWidget {
  const GetVisualAcuityTestScreenAppbar({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InterText(
            title: visualAcuityEyeTestList[currentPage].myRange +
                "/" +
                visualAcuityEyeTestList[currentPage].averageHumansRange,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          BlocConsumer<TimerCubit, int>(
            listener: (context, state) {
              if (state == 0) {
                context.read<TimerCubit>().resetStopwatch();
                NavigatorServices().toReplacement(
                  context: context,
                  widget: VisualAcuitySelectAnswerScreen(
                    currentPage: currentPage,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 1,
                    color: AppColors.primaryColor,
                  ),
                ),
                alignment: Alignment.center,
                child: InterText(
                  title: "$state",
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class MillimeterBox extends StatefulWidget {
  double mmVal;
  int numberOfturns;
  MillimeterBox({
    Key? key,
    required this.mmVal,
    required this.numberOfturns,
  }) : super(key: key);
  @override
  _MillimeterBoxState createState() => _MillimeterBoxState();
}

class _MillimeterBoxState extends State<MillimeterBox> {
  late double screenWidth;
  late double screenHeight;
  double boxSizeInPixels = 0.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateScreenSize();
    });
  }

  void _updateScreenSize() {
    setState(() {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;

      // Assuming 1 inch = 25.4 millimeters
      final screenInches =
          screenWidth / MediaQuery.of(context).devicePixelRatio;
      final millimetersPerPixel = 25.4 / screenInches;
      boxSizeInPixels = millimetersPerPixel * 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ppi = DeviceUtils.getDevicePPI(context);
    double letterHeightMm = 0.582;
    double letterHeightPx = DeviceUtils.mmToPixels(letterHeightMm, ppi);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: letterHeightPx + widget.mmVal,
          height: letterHeightPx + widget.mmVal,
          color: Colors.transparent,
          child: RotatedBox(
            quarterTurns: widget.numberOfturns,
            child: SvgPicture.asset(
              AppAssets.visualAcuityTestE,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
