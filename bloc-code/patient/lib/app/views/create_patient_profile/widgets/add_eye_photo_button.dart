import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddEyePhotoButton extends StatelessWidget {
  AddEyePhotoButton({
    super.key,
    required this.callBackFunction,
  });

  Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Align(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: AppColors.colorEFEFEF,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.colorBBBBBB,
            ),
          ),
          child: Align(
            child: SizedBox(
              height: 45,
              width: 45,
              child: SvgPicture.asset(
                AppAssets.addMoreWithEye,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
