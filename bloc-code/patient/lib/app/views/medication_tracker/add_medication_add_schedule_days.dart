import 'dart:developer';

import 'package:eye_buddy/app/bloc/add_medication_cubit/add_medication_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/global_widgets/filled_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';

class AddMedicationAddDayScheduleScreen extends StatelessWidget {
  AddMedicationAddDayScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // List<String> listOfWeekDays = [
    //   l10n.sunday,
    //   l10n.monday,
    //   l10n.tuesday,
    //   l10n.wednesday,
    //   l10n.thursday,
    //   l10n.friday,
    //   l10n.saturday,
    // ];

    List<String> listOfWeekDays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: InterText(
          title: 'Choose Day',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<AddMedicationCubit, AddMedicationState>(
                builder: (context, state) {
                  log("Rebuilding state");
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listOfWeekDays.length,
                          itemBuilder: (context, index) {
                            final day = listOfWeekDays[index];
                            return GestureDetector(
                              onTap: () {
                                context.read<AddMedicationCubit>().toogleDay(day);
                              },
                              child: Container(
                                color: Colors.transparent,
                                height: kToolbarHeight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InterText(
                                      title: day,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Checkbox(
                                      activeColor: AppColors.primaryColor,
                                      value: state.dayList.contains(day),
                                      onChanged: (selected) {
                                        if (selected != null) {
                                          if (selected) {
                                            context.read<AddMedicationCubit>().addNewDay(day);
                                          } else {
                                            context.read<AddMedicationCubit>().removeDay(day);
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GetFilledButton(
                          title: 'SAVE',
                          callBackFunction: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
