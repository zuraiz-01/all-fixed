import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/test_results/widgets/app_test_item.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shemmer/card_skelton_screen.dart';

class AppTestResultScreen extends StatelessWidget {
  const AppTestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SingleChildScrollView(
        child: BlocConsumer<TestResultCubit, TestResultState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return state.isLoading
                ? Container(
                    height: getHeight(context: context) - kToolbarHeight * 3,
                    width: getWidth(context: context),
                    color: Colors.white,
                    child: const NewsCardSkelton(),
                    // child: const CustomLoader(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: state.appTestResult != null
                        ? Column(
                            children: [
                              CommonSizeBox(
                                height: getProportionateScreenWidth(20),
                              ),
                              state.appTestResult!.appTestData!.visualAcuity != null
                                  ? AppTestItem(
                                      leftEye: [
                                        // 'OD   ${state.appTestResult!.appTestData!.visualAcuity!.left!.od}',
                                        'OS   ${state.appTestResult!.appTestData!.visualAcuity!.left!.os}'
                                      ],
                                      rightEye: [
                                        'OD   ${state.appTestResult!.appTestData!.visualAcuity!.right!.od}',
                                        // 'OS   ${state.appTestResult!.appTestData!.visualAcuity!.right!.os}'
                                      ],
                                      title: localLanguage.visual_acuity,
                                      context: context,
                                    )
                                  : SizedBox(),
                              state.appTestResult!.appTestData!.nearVision != null
                                  ? AppTestItem(
                                      leftEye: [
                                        // 'OD   ${state.appTestResult!.appTestData!.nearVision!.left!.od}',
                                        'OS   ${state.appTestResult!.appTestData!.nearVision!.left!.os}'
                                      ],
                                      rightEye: [
                                        'OD   ${state.appTestResult!.appTestData!.nearVision!.right!.od}',
                                        // 'OS   ${state.appTestResult!.appTestData!.nearVision!.right!.os}'
                                      ],
                                      title: localLanguage.near_vision,
                                      context: context,
                                    )
                                  : SizedBox(),
                              state.appTestResult!.appTestData!.colorVision != null
                                  ? AppTestItem(
                                      leftEye: ['${state.appTestResult!.appTestData!.colorVision!.left}'],
                                      rightEye: ['${state.appTestResult!.appTestData!.colorVision!.right}'],
                                      title: localLanguage.color_vision,
                                      context: context)
                                  : SizedBox(),
                              state.appTestResult!.appTestData!.amdVision != null
                                  ? AppTestItem(
                                      leftEye: ['${state.appTestResult!.appTestData!.amdVision!.left}'],
                                      rightEye: ['${state.appTestResult!.appTestData!.amdVision!.right}'],
                                      title: localLanguage.amd,
                                      context: context)
                                  : SizedBox(),
                            ],
                          )
                        : Container(
                            height: MediaQuery.sizeOf(context).height,
                            child: NoDataFoundWidget(
                              title: "You don't have any app test",
                            ),
                          ),
                  );
          },
        ),
      ),
    );
  }
}
