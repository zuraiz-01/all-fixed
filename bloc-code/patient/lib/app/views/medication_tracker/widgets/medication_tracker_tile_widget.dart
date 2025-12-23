import 'package:eye_buddy/app/api/model/medication_tracker_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/medication_tracker/medication_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationTrackerTileWidget extends StatelessWidget {
  Medication medication;
  MedicationTrackerTileWidget({
    super.key,
    required this.isActive,
    required this.medication,
  });

  String getNextTime(List<String> times) {
    print("Medication Times: $times");
    final currentTime = DateTime.now();

    // Get the allowed days
    final allowedDays = getDayList();
    print("Allowed Days: $allowedDays");

    // Map day names to DateTime weekdays
    final dayMapping = {
      "Sun": DateTime.sunday,
      "Mon": DateTime.monday,
      "Tue": DateTime.tuesday,
      "Wed": DateTime.wednesday,
      "Thu": DateTime.thursday,
      "Fri": DateTime.friday,
      "Sat": DateTime.saturday,
    };

    // Parse allowed days into a list of integers representing weekdays
    final allowedWeekdays = allowedDays
        .split(", ")
        .map((day) => dayMapping[day])
        .where((day) => day != null)
        .toList();

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final currentDay = currentTime.add(Duration(days: dayOffset));
      if (allowedWeekdays.contains(currentDay.weekday)) {
        for (final timeString in times) {
          final time = DateFormat.Hm().parse(timeString);

          // Create the next potential time
          final nextTime = DateTime(
            currentDay.year,
            currentDay.month,
            currentDay.day,
            time.hour,
            time.minute,
          );

          if (nextTime.isAfter(currentTime)) {
            final formattedNextTime = DateFormat.jm().format(nextTime);

            if (dayOffset == 0) {
              return "Today - $formattedNextTime";
            } else if (dayOffset == 1) {
              return "Tomorrow - $formattedNextTime";
            } else {
              final dayOfWeek = DateFormat.EEEE().format(nextTime);
              return "$dayOfWeek - $formattedNextTime";
            }
          }
        }
      }
    }

    return "No upcoming medication times found.";
  }

  getDayList() {
    String days = "";
    if (medication.sun == true) {
      days += "Sun";
    }
    if (medication.mon == true) {
      if (days.isEmpty) {
        days += "Mon";
      } else {
        days += ", Mon";
      }
    }
    if (medication.tue == true) {
      if (days.isEmpty) {
        days += "Tue";
      } else {
        days += ", Tue";
      }
    }
    if (medication.wed == true) {
      if (days.isEmpty) {
        days += "Wed";
      } else {
        days += ", Wed";
      }
    }
    if (medication.thu == true) {
      if (days.isEmpty) {
        days += "Thu";
      } else {
        days += ", Thu";
      }
    }
    if (medication.fri == true) {
      if (days.isEmpty) {
        days += "Fri";
      } else {
        days += ", Fri";
      }
    }
    if (medication.sat == true) {
      if (days.isEmpty) {
        days += "Sat";
      } else {
        days += ", Sat";
      }
    }
    return days;
  }

  bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          NavigatorServices().to(
            context: context,
            widget: MedicationDetailsScreen(
              medication: medication,
            ),
          );
        },
        child: Material(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shadowColor: AppColors.black.withOpacity(.25),
          child: Container(
            padding: const EdgeInsets.all(15),
            height: 120,
            width: getWidth(context: context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InterText(
                        title: medication.title!,
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InterText(
                        title: medication.description ?? "",
                        maxLines: 2,
                        fontSize: 12,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          InterText(
                            title: getNextTime(medication.time),
                            textColor: AppColors.primaryColor,
                            fontSize: 12,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          getDayList() == ""
                              ? SizedBox.shrink()
                              : Container(
                                  height: 10,
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: InterText(
                              maxLines: 1,
                              title: getDayList(),
                              textColor: AppColors.primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                // GestureDetector(
                //   onTap: () {
                //     context.read<MedicationTrackerCubit>().toogleNotification(medication, context);
                //   },
                //   child: Container(
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(30),
                //       color: isActive ? AppColors.primaryColor.withOpacity(.2) : AppColors.colorBBBBBB.withOpacity(.2),
                //     ),
                //     child: Icon(
                //       Icons.notifications,
                //       size: 20,
                //       color: isActive ? AppColors.primaryColor : Colors.black,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
