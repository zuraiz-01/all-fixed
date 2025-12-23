import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class MedicationTimeAndDayChip extends StatelessWidget {
  MedicationTimeAndDayChip({
    super.key,
    required this.text,
  });

  String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1.5,
              color: AppColors.primaryColor,
            ),
          ),
          alignment: Alignment.center,
          child: InterText(
            title: text,
            fontSize: 12,
            textColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
