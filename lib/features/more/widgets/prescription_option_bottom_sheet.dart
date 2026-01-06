import 'package:eye_buddy/core/services/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/more/controller/edit_prescription_controller.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:eye_buddy/features/more/view/edit_prescription_screen.dart';
import 'package:eye_buddy/features/medication_tracker/controller/medication_tracker_controller.dart';
import 'package:eye_buddy/features/medication_tracker/view/add_or_edit_medication_screen.dart';
import 'package:eye_buddy/core/services/api/model/medication_tracker_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionOptionBottomSheet extends StatelessWidget {
  const PrescriptionOptionBottomSheet({super.key, required this.prescription});

  final Prescription prescription;

  String _suggestedMedicineName(String rawTitle) {
    final t = rawTitle.trim();
    if (t.isEmpty) return '';
    final lines = t
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) return '';
    final first = lines.first;

    // If title is like "Napa 500mg - 1+1+1 after meal", treat left as name.
    for (final sep in [' - ', ' – ', ' — ', ': ']) {
      final idx = first.indexOf(sep);
      if (idx > 0) {
        return first.substring(0, idx).trim();
      }
    }
    return first;
  }

  String _suggestedInstructions(String rawTitle) {
    final t = rawTitle.trim();
    if (t.isEmpty) return '';
    final lines = t
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.length >= 2) {
      return lines.skip(1).join('\n').trim();
    }

    // If title is like "Napa 500mg - 1+1+1 after meal", treat right as instructions.
    final first = lines.isEmpty ? '' : lines.first;
    for (final sep in [' - ', ' – ', ' — ', ': ']) {
      final idx = first.indexOf(sep);
      if (idx > 0 && idx + sep.length < first.length) {
        return first.substring(idx + sep.length).trim();
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final moreController = Get.find<MoreController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonSizeBox(height: getProportionateScreenHeight(7)),
          InkWell(
            onTap: () {
              Get.back();

              if (!Get.isRegistered<MedicationTrackerController>()) {
                Get.put(MedicationTrackerController());
              }

              final rawTitle = (prescription.title ?? '').toString();
              final suggestedName = _suggestedMedicineName(rawTitle);
              final suggestedDesc = _suggestedInstructions(rawTitle);

              // If we can infer both name + instructions, go directly to Add Medicine.
              if (suggestedName.isNotEmpty && suggestedDesc.isNotEmpty) {
                Get.to(
                  () => AddOrEditMedicationScreen(
                    isEdit: false,
                    medication: Medication(
                      title: suggestedName,
                      description: suggestedDesc,
                      time: const [],
                    ),
                  ),
                );
                return;
              }

              final nameController = TextEditingController(
                text: suggestedName.isEmpty ? '' : suggestedName,
              );
              final descController = TextEditingController(
                text: suggestedDesc.isEmpty ? '' : suggestedDesc,
              );

              Get.dialog(
                AlertDialog(
                  title: const Text('Add to My Medicine'),
                  content: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Medicine name',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Doctor instructions',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final desc = descController.text.trim();
                        Get.back();

                        Get.to(
                          () => AddOrEditMedicationScreen(
                            isEdit: false,
                            medication: Medication(
                              title: name.isEmpty ? 'Medicine' : name,
                              description: desc,
                              time: const [],
                            ),
                          ),
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              );
            },
            child: InterText(
              title: 'Add to My Medicine',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          CommonSizeBox(height: getProportionateScreenWidth(5)),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.colorEDEDED,
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(
                () => EditPrescriptionScreen(
                  screenName: 'Edit Prescription',
                  isFromPrescriptionScreen: true,
                  prescriptionId: prescription.sId ?? '',
                  title: prescription.title ?? '',
                ),
              );
            },
            child: InterText(
              title: 'Edit',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          CommonSizeBox(height: getProportionateScreenWidth(5)),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.colorEDEDED,
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          InkWell(
            onTap: () async {
              final id = prescription.sId;
              if (id != null && id.isNotEmpty) {
                await moreController.deletePrescription(id);
              }
              Get.back();
            },
            child: InterText(
              title: 'Delete',
              fontSize: 14,
              textColor: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
