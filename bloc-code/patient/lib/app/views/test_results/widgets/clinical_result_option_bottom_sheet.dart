import 'package:eye_buddy/app/api/model/test_result_response_model.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/edit_prescription_screen/view/edit_prescription_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicalResultOptionBottomSheet extends StatelessWidget {
  TestResult testResult;
  ClinicalResultOptionBottomSheet({
    required this.testResult,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonSizeBox(
            height: getProportionateScreenHeight(7),
          ),
          GestureDetector(
            onTap: () {
              NavigatorServices().to(
                  context: context,
                  widget: EditPrescriptionScreen(
                    screenName: "Edit Prescription",
                    isFromTestResultScreen: true,
                    prescriptionId: testResult.sId,
                    title: testResult.title,
                  ));
            },
            child: InterText(
              title: 'Edit',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          CommonSizeBox(
            height: getProportionateScreenWidth(5),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.colorEDEDED,
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          GestureDetector(
            onTap: () {
              context.read<TestResultCubit>().deleteTestResult(testResult.sId.toString());
            },
            child: InterText(
              title: 'Delete',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
