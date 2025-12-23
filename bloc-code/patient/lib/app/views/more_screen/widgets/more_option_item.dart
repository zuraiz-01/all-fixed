import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/config/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../global_widgets/common_size_box.dart';
import '../../global_widgets/inter_text.dart';

class MoreOptionItem extends StatelessWidget {
  MoreOptionItem({
    required this.iconName,
    required this.title,
    required this.callBackFunction,
    super.key,
  });
  final String title;
  final String iconName;
  Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Container(
        width: SizeConfig.screenWidth,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: getProportionateScreenWidth(10), top: getProportionateScreenWidth(10)),
          child: Row(
            children: [
              SizedBox(
                width: 15,
                child: SvgPicture.asset(
                  iconName,
                  height: 18,
                  width: 18,
                ),
              ),
              CommonSizeBox(
                width: 12,
              ),
              SizedBox(
                child: InterText(
                  title: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const SizedBox(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.color008541,
                  size: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
