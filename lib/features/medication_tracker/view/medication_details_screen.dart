import 'package:eye_buddy/core/services/api/model/medication_tracker_model.dart';
import 'package:eye_buddy/core/services/utils/app_fonts.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/dimentions.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/global_widgets/toast.dart';
import 'package:eye_buddy/features/medication_tracker/controller/medication_tracker_controller.dart';
import 'package:eye_buddy/features/medication_tracker/widgets/medication_day_list_widget.dart';
import 'package:eye_buddy/features/medication_tracker/widgets/medication_time_list_widget.dart';
import 'package:eye_buddy/features/more/view/card_skelton_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';

class MedicationDetailsScreen extends StatelessWidget {
  const MedicationDetailsScreen({super.key, required this.medication});

  final Medication medication;

  List<String> _getDayList() {
    final days = <String>[];
    if (medication.sun == true) days.add('Sunday');
    if (medication.mon == true) days.add('Monday');
    if (medication.tue == true) days.add('Tuesday');
    if (medication.wed == true) days.add('Wednesday');
    if (medication.thu == true) days.add('Thursday');
    if (medication.fri == true) days.add('Friday');
    if (medication.sat == true) days.add('Saturday');
    return days;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    final controller = Get.find<MedicationTrackerController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const InterText(title: 'Medication Details'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            height: getHeight(context: context),
            width: getWidth(context: context),
            color: Colors.white,
            child: const NewsCardSkelton(),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: getHeight(context: context),
          width: getWidth(context: context),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    InterText(
                      title: l10n.medication_title,
                      textColor: AppColors.color888E9D,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 4),
                    InterText(
                      title: medication.title ?? '',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    InterText(
                      title: l10n.medication_description,
                      textColor: AppColors.color888E9D,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 4),
                    InterText(
                      title: medication.description ?? '',
                      fontSize: 14,
                    ),
                    const SizedBox(height: kToolbarHeight / 2),
                    MedicationTimeListWidget(
                      timeList: medication.time,
                      addNewTimeCallBackFunction: () {},
                    ),
                    const SizedBox(height: 22),
                    MedicationDayListWidget(
                      dayList: _getDayList(),
                      addNewDayCallBackFunction: () {},
                    ),
                    const SizedBox(height: kToolbarHeight * 2),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: getWidth(context: context),
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.colorEDEDED,
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed: () async {
                      final ok = await controller.deleteMedicationGroupByTitle(
                        medication.title ?? '',
                      );
                      if (ok) {
                        showToast(
                          message: 'Medication deleted successfully',
                          context: context,
                        );
                        Get.back();
                      } else {
                        showToast(
                          message: controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : 'Failed to delete',
                          context: context,
                        );
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: AppColors.color777777,
                        fontFamily: AppFonts.INTER,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
