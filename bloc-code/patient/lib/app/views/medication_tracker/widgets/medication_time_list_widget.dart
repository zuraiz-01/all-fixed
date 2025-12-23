import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/global_widgets/filled_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_tima_and_day_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';

class GetMedicationTimeListWidget extends StatelessWidget {
  GetMedicationTimeListWidget({
    super.key,
    required this.timeList,
    required this.addNewTimeCallBackFunction,
    this.isEditOrUpdate = false,
  });

  List<String> timeList;
  Function addNewTimeCallBackFunction;
  bool isEditOrUpdate;

  String convertTimeFormat(String timeString) {
    final time = DateFormat.Hm().parse(timeString);
    final formattedTime = DateFormat('h:mm a').format(time);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: getWidth(context: context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterText(
            title: 'Time',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: getWidth(context: context),
            height: 41,
            alignment: timeList.isEmpty ? Alignment.center : Alignment.centerLeft,
            child: timeList.isEmpty
                ? InterText(
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
                        text: convertTimeFormat(
                          timeList[index],
                        ),
                      );
                    },
                  ),
          ),
          isEditOrUpdate
              ? Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
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
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
