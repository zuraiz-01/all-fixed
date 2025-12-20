import 'package:eye_buddy/core/services/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/more/controller/edit_prescription_controller.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:eye_buddy/features/more/view/edit_prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionOptionBottomSheet extends StatelessWidget {
  const PrescriptionOptionBottomSheet({
    super.key,
    required this.prescription,
  });

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    final moreController = Get.find<MoreController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonSizeBox(height: getProportionateScreenHeight(7)),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(
                () => EditPrescriptionScreen(
                  screenName: 'Edit Prescription',
                  isFromPrescriptionScreen: true,
                  prescriptionId: prescription.sId ?? '',
                  title: prescription.title ?? '',
                ),
              );
            },
            child: InterText(
              title: 'Edit',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          CommonSizeBox(height: getProportionateScreenWidth(5)),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.colorEDEDED,
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          InkWell(
            onTap: () async {
              final id = prescription.sId;
              if (id != null && id.isNotEmpty) {
                await moreController.deletePrescription(id);
              }
              Get.back();
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

