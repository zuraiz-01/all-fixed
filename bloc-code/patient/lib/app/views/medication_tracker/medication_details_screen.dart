import 'package:eye_buddy/app/bloc/add_medication_cubit/add_medication_cubit.dart';
import 'package:eye_buddy/app/bloc/medication_tracker_cubit/medication_tracker_cubit.dart';
import 'package:eye_buddy/app/utils/app_fonts.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_day_list_widget.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_time_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../api/model/medication_tracker_model.dart';
import '../shemmer/card_skelton_screen.dart';

class MedicationDetailsScreen extends StatelessWidget {
  Medication medication;
  MedicationDetailsScreen({
    super.key,
    required this.medication,
  });
  List<String> getDayList() {
    List<String> days = [];
    if (medication.sun == true) {
      days.add("Sunday");
    }
    if (medication.mon == true) {
      days.add("Monday");
    }
    if (medication.tue == true) {
      days.add("Tuesday");
    }
    if (medication.wed == true) {
      days.add("Wednesday");
    }
    if (medication.thu == true) {
      days.add("Thursday");
    }
    if (medication.fri == true) {
      days.add("Friday");
    }
    if (medication.sat == true) {
      days.add("Saturday");
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          title: 'Medication Details',
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //     },
        //     icon: Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //     ),
        //   )
        // ],
      ),
      body: BlocConsumer<MedicationTrackerCubit, MedicationTrackerState>(
        listener: (context, trackerCubit) {
          if (trackerCubit is MedicationTrackerSuccess) {
            NavigatorServices().pop(context: context);
            showToast(
              message: trackerCubit.toastMessage,
              context: context,
            );
          }
        },
        builder: (context, trackerCubit) {
          return BlocConsumer<AddMedicationCubit, AddMedicationState>(
            listener: (context, state) {
              if (state is MedicationUpdateErrorState) {
                showToast(
                  message: state.errorMessage,
                  context: context,
                );
              } else if (state is MedicationUpdateSuccessState) {
                NavigatorServices().pop(context: context);
                showToast(
                  message: state.toastMessage,
                  context: context,
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading || trackerCubit.isLoading) {
                return Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  child: const NewsCardSkelton(),
                  // child: const CustomLoader(),
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
                          const SizedBox(
                            height: 10,
                          ),
                          InterText(
                            title: l10n.medication_title,
                            textColor: AppColors.color888E9D,
                            fontSize: 12,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          InterText(
                            title: medication.title!,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InterText(
                            title: l10n.medication_description,
                            textColor: AppColors.color888E9D,
                            fontSize: 12,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          InterText(
                            title: medication.description ?? "",
                            fontSize: 14,
                          ),
                          const SizedBox(
                            height: kToolbarHeight / 2,
                          ),
                          GetMedicationTimeListWidget(
                            timeList: medication.time,
                            addNewTimeCallBackFunction: () {},
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          GetMedicationDayListWidget(
                            dayList: getDayList(),
                            addNewDayCallBackFunction: () {},
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Container(
                        width: getWidth(context: context),
                        height: 40,
                        child: TextButton(
                          child: Text('Delete', style: TextStyle(
                            color: AppColors.color777777,
                            fontFamily: AppFonts.INTER, fontWeight: FontWeight.bold
                          ),),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.colorEDEDED,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontStyle: FontStyle.normal
                            ),
                          ),
                          onPressed: () {
                            context.read<MedicationTrackerCubit>().deleteMedication(medication.title ?? "");
                          },
                        ),
                      ),
                    )
                    // Positioned(
                    //   bottom: 20,
                    //   left: 0,
                    //   right: 0,
                    //   child: SizedBox(
                    //     width: getWidth(context: context),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         GetFilledButton(
                    //           callBackFunction: () {
                    //             context.read<AddMedicationCubit>().deleteMedication(medication, context);
                    //           },
                    //           title: 'Delete',
                    //           buttonHeight: 40,
                    //           buttonWidth: 100,
                    //           transparentBackground: true,
                    //         ),
                    //         const SizedBox(
                    //           width: 8,
                    //         ),
                    //         GetFilledButton(
                    //           callBackFunction: () {
                    //             NavigatorServices().toReplacement(
                    //               context: context,
                    //               widget: AddOrEditMedicationScreen(
                    //                 isEdit: true,
                    //                 medication: medication,
                    //               ),
                    //             );
                    //           },
                    //           buttonHeight: 40,
                    //           buttonWidth: 100,
                    //           title: 'Edit',
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
