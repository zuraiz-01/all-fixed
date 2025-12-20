import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/dimentions.dart';
import 'package:eye_buddy/features/global_widgets/filled_button.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/medication_tracker/widgets/medication_time_and_day_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationTimeListWidget extends StatelessWidget {
  const MedicationTimeListWidget({
    super.key,
    required this.timeList,
    required this.addNewTimeCallBackFunction,
    this.isEditOrUpdate = false,
  });

  final List<String> timeList;
  final Function addNewTimeCallBackFunction;
  final bool isEditOrUpdate;

  String _convertTimeFormat(String timeString) {
    final time = DateFormat.Hm().parse(timeString);
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context: context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InterText(
            title: 'Time',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10),
          Container(
            width: getWidth(context: context),
            height: 41,
            alignment: timeList.isEmpty
                ? Alignment.center
                : Alignment.centerLeft,
            child: timeList.isEmpty
                ? const InterText(
                    title: 'Add medication time schedule',
                    textColor: AppColors.color888E9D,
                    fontSize: 12,
                  )
                : ListView.builder(
                    itemCount: timeList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MedicationTimeAndDayChip(
                        text: _convertTimeFormat(timeList[index]),
                      );
                    },
                  ),
          ),
          if (isEditOrUpdate) ...[
            const SizedBox(height: 25),
            GetFilledButton(
              title: 'Add New Time',
              callBackFunction: () {
                addNewTimeCallBackFunction();
              },
              titleColor: AppColors.primaryColor,
              buttonColor: AppColors.colorCCE7D9,
              buttonRadius: 5,
              buttonHeight: 40,
            ),
          ],
        ],
      ),
    );
  }
}
