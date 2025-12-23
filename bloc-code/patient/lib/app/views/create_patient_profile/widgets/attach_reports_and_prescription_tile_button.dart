import 'package:dotted_border/dotted_border.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';

class AttachReportsAndPreviousPrescriptionsDottedBorderTileButton
    extends StatelessWidget {
  const AttachReportsAndPreviousPrescriptionsDottedBorderTileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ReasonForVisitCubit>().selectPrescriptionFile();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: AppColors.color888E9D,
        radius: const Radius.circular(5),
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(18),
              vertical: getProportionateScreenWidth(13),
            ),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InterText(
                        title: 'Upload reports & previous prescriptions',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.black,
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      InterText(
                        title: 'Format will be JPG, PNG, PDF',
                        fontSize: 12,
                        textColor: AppColors.color777777,
                      ),
                      CommonSizeBox(
                        height: getProportionateScreenHeight(3),
                      ),
                      InterText(
                        title: '* Max Attachments 10',
                        fontSize: 12,
                        textColor: AppColors.color777777,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: getProportionateScreenWidth(45),
                  width: getProportionateScreenWidth(45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      AppAssets.upload,
                      color: AppColors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
