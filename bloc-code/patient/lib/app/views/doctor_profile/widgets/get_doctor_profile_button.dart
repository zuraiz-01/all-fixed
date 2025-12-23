import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class GetDoctorsProfileButton extends StatelessWidget {
  GetDoctorsProfileButton({
    required this.icon,
    required this.isFilled,
    required this.title,
    this.width = 12,
    required this.callBackFunction,
    this.height = 30,
    super.key,
    this.fontSize = 12,
  });

  IconData icon;
  bool isFilled;
  String title;
  double width;
  double height;
  Function callBackFunction;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            5,
          ),
          color: isFilled ? AppColors.color008541 : Colors.transparent,
          border: Border.all(
            color: !isFilled ? AppColors.color008541 : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: !isFilled ? AppColors.color008541 : Colors.white,
              size: fontSize + 3,
            ),
            const SizedBox(
              width: 6,
            ),
            InterText(
              fontSize: fontSize,
              textColor: !isFilled ? AppColors.color008541 : Colors.white,
              title: title,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
