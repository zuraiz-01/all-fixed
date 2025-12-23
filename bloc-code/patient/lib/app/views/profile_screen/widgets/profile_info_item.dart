import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class ProfileInfoItem extends StatelessWidget {
  const ProfileInfoItem({
    required this.title,
    required this.titleDetails,
    super.key,
  });
  final String title;
  final String titleDetails;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: SizeConfig.screenWidth,
      color: Colors.transparent,
      child: titleDetails == "" || titleDetails.toString() == "null"
          ? SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: InterText(
                    title: title,
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
                  ),
                ),
                CommonSizeBox(
                  height: getProportionateScreenHeight(4),
                ),
                SizedBox(
                  child: InterText(
                    title: titleDetails,
                    fontSize: 14,
                    textColor: AppColors.color030330,
                  ),
                ),
              ],
            ),
    );
  }
}
