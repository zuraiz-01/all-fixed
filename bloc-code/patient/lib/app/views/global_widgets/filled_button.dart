import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class GetFilledButton extends StatelessWidget {
  GetFilledButton({
    required this.title,
    required this.callBackFunction,
    super.key,
    this.transparentBackground = false,
    this.buttonHeight = 55,
    this.buttonColor = AppColors.color008541,
    this.buttonRadius = 8,
    this.buttonWidth,
    this.titleColor = Colors.white,
  });

  String title;
  Color titleColor;
  Function callBackFunction;
  bool transparentBackground;
  double buttonHeight;
  double? buttonWidth;
  Color buttonColor;
  double buttonRadius;

  @override
  Widget build(BuildContext context) {
    buttonWidth ??= getWidth(context: context);
    return Align(
      child: GestureDetector(
        onTap: () {
          callBackFunction();
        },
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              buttonRadius,
            ),
            color: transparentBackground ? Colors.transparent : buttonColor,
          ),
          alignment: Alignment.center,
          child: InterText(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textColor: transparentBackground ? AppColors.color888E9D : titleColor,
            title: title,
          ),
        ),
      ),
    );
  }
}
