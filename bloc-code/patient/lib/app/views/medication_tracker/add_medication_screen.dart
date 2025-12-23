import 'package:eye_buddy/app/api/model/medication_tracker_model.dart';
import 'package:eye_buddy/app/bloc/add_medication_cubit/add_medication_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/filled_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/medication_tracker/add_medication_add_schedule_days.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_day_list_widget.dart';
import 'package:eye_buddy/app/views/medication_tracker/widgets/medication_time_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../global_widgets/custom_loader.dart';

class AddOrEditMedicationScreen extends StatefulWidget {
  AddOrEditMedicationScreen({
    super.key,
    this.isEdit = false,
    this.medication = null,
  });

  bool isEdit;
  Medication? medication;

  @override
  State<AddOrEditMedicationScreen> createState() =>
      _AddOrEditMedicationScreenState();
}

class _AddOrEditMedicationScreenState extends State<AddOrEditMedicationScreen> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  List<String> time = [];
  List<String> getDayList(Medication medication) {
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
  void initState() {
    super.initState();
    if (widget.isEdit) {
      titleController.text = widget.medication!.title!;
      descriptionController.text = widget.medication!.description ?? "";
      context
          .read<AddMedicationCubit>()
          .updateFullTimeList(widget.medication!.time);
      context
          .read<AddMedicationCubit>()
          .updateFullDayList(getDayList(widget.medication!));
    } else {
      context.read<AddMedicationCubit>().resetEverythingState();
    }
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final time = DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
    final formattedTime = DateFormat.Hm().format(time);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    // context.read<AddMedicationCubit>().resetState();
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
          title: widget.isEdit ? "Editing Medication" : 'Create Medication',
        ),
      ),
      body: BlocConsumer<AddMedicationCubit, AddMedicationState>(
        listener: (context, state) {
          if (state is MedicationUpdateErrorState) {
            showToast(message: state.errorMessage, context: context);
            context.read<AddMedicationCubit>().resetState();
          }
          if (state is MedicationUpdateSuccessState) {
            showToast(message: state.toastMessage, context: context);
            NavigatorServices().pop(context: context);
            context.read<AddMedicationCubit>().resetState();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Container(
              height: getHeight(context: context),
              width: getWidth(context: context),
              color: Colors.white,
              child: const CustomLoader(),
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
                        title: 'Medication Title',
                        textColor: AppColors.color888E9D,
                        fontSize: 11,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Medication Title',
                        textEditingController: titleController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9\s]*$'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InterText(
                        title: 'Medication Description',
                        textColor: AppColors.color888E9D,
                        fontSize: 11,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Medication Description',
                        textEditingController: descriptionController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9\s]*$'),
                          ),
                        ],
                        maxLines: 5,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GetMedicationTimeListWidget(
                        timeList: state.timeList,
                        isEditOrUpdate: true,
                        addNewTimeCallBackFunction: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            context
                                .read<AddMedicationCubit>()
                                .addNewTime(formatTimeOfDay(time));
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GetMedicationDayListWidget(
                        dayList: state.dayList,
                        showAddDayButton: true,
                        addNewDayCallBackFunction: () {
                          NavigatorServices().to(
                            context: context,
                            widget: AddMedicationAddDayScheduleScreen(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: kToolbarHeight * 2,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: GetFilledButton(
                    title: widget.isEdit
                        ? "Update Medication"
                        : 'Create Medication',
                    callBackFunction: () {
                      if (widget.isEdit) {
                        Medication updatedMedication = widget.medication!;
                        updatedMedication.time = state.timeList;
                        updatedMedication.sun =
                            state.dayList.contains("Sunday");
                        updatedMedication.mon =
                            state.dayList.contains("Monday");
                        updatedMedication.tue =
                            state.dayList.contains("Tuesday");
                        updatedMedication.wed =
                            state.dayList.contains("Wednesday");
                        updatedMedication.thu =
                            state.dayList.contains("Thursday");
                        updatedMedication.fri =
                            state.dayList.contains("Friday");
                        updatedMedication.sat =
                            state.dayList.contains("Saturday");
                        updatedMedication.title = titleController.text;
                        updatedMedication.description =
                            descriptionController.text;
                        context.read<AddMedicationCubit>().updateMedication(
                              updatedMedication,
                              context,
                            );
                      } else {
                        Medication updatedMedication = Medication(
                          time: [],
                        );
                        updatedMedication.time = state.timeList;
                        updatedMedication.sun =
                            state.dayList.contains("Sunday");
                        updatedMedication.mon =
                            state.dayList.contains("Monday");
                        updatedMedication.tue =
                            state.dayList.contains("Tuesday");
                        updatedMedication.wed =
                            state.dayList.contains("Wednesday");
                        updatedMedication.thu =
                            state.dayList.contains("Thursday");
                        updatedMedication.fri =
                            state.dayList.contains("Friday");
                        updatedMedication.sat =
                            state.dayList.contains("Saturday");
                        updatedMedication.title = titleController.text;
                        updatedMedication.description =
                            descriptionController.text;
                        if (updatedMedication.time.isNotEmpty &&
                            (updatedMedication.title ?? "").trim().isNotEmpty &&
                            (updatedMedication.description ?? "")
                                .trim()
                                .isNotEmpty &&
                            ((updatedMedication.sun ?? false) ||
                                (updatedMedication.mon ?? false) ||
                                (updatedMedication.tue ?? false) ||
                                (updatedMedication.wed ?? false) ||
                                (updatedMedication.thu ?? false) ||
                                (updatedMedication.fri ?? false) ||
                                (updatedMedication.sat ?? false))) {
                          context.read<AddMedicationCubit>().addMedication(
                                updatedMedication,
                                context,
                              );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
