import 'package:eye_buddy/core/services/api/model/prescription_list_response_model.dart';
import 'package:eye_buddy/core/services/api/service/api_constants.dart';
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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PrescriptionOptionBottomSheet extends StatelessWidget {
  const PrescriptionOptionBottomSheet({super.key, required this.prescription});

  final Prescription prescription;

  String _resolveS3Url(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    return '${ApiConstants.imageBaseUrl}$v';
  }

  Future<String> _extractTextFromPdfUrl(String url) async {
    final dio = Dio();
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) return '';
    final document = PdfDocument(inputBytes: bytes);
    try {
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText();
      return (text).trim();
    } finally {
      document.dispose();
    }
  }

  bool _looksLikeInstructionLine(String value) {
    final v = value.toLowerCase();
    if (v.isEmpty) return false;
    final tokens = <String>[
      'take',
      'after',
      'before',
      'daily',
      'times',
      'morning',
      'noon',
      'night',
      'advised',
      'directed',
      'once',
      'twice',
      'thrice',
    ];
    if (tokens.any(v.contains)) return true;
    if (RegExp(r'\b\d+\s*[xX]\s*\d+\b').hasMatch(value)) return true;
    if (RegExp(r'\b\d+\+\d+\+\d+\b').hasMatch(value)) return true;
    return false;
  }

  bool _looksLikeMedicineLine(String value) {
    final v = value.toLowerCase();
    if (v.isEmpty) return false;
    final tokens = <String>[
      'mg',
      'ml',
      '%',
      'sterile',
      'tablet',
      'tab',
      'capsule',
      'cap',
      'drop',
      'drops',
      'ointment',
      'syrup',
      'suspension',
      'solution',
      'eye',
      'gel',
      'cream',
    ];
    final hasToken = tokens.any(v.contains);
    final hasAdviceWord = _looksLikeInstructionLine(value);
    return hasToken && !hasAdviceWord;
  }

  String? _findGenericInstruction(List<String> lines) {
    for (final line in lines) {
      final l = line.toLowerCase();
      if (l.contains('take as advised') ||
          l.contains('as advised') ||
          l.contains('take as directed') ||
          l.contains('as directed')) {
        return line.trim();
      }
    }
    return null;
  }

  List<(String name, String instructions)> _parseRxItems(String text) {
    final cleaned = text.replaceAll('\r', '\n');
    final lower = cleaned.toLowerCase();
    var start = lower.indexOf('\nrx');
    if (start < 0) start = lower.indexOf(' rx');
    if (start < 0) start = lower.indexOf('rx\n');
    if (start < 0) start = lower.indexOf('rx');

    var body = cleaned;
    if (start >= 0) {
      body = cleaned.substring(start);
    }

    final stopTokens = <String>[
      'advice',
      'diagnosis',
      'follow',
      'signature',
      'dr.',
      'doctor',
    ];
    final bodyLower = body.toLowerCase();
    var end = body.length;
    for (final token in stopTokens) {
      final idx = bodyLower.indexOf(token);
      if (idx > 0 && idx < end) {
        end = idx;
      }
    }
    body = body.substring(0, end);

    final rawLines = body
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final genericInstruction = _findGenericInstruction(rawLines);

    final items = <(String name, String instructions)>[];

    // Remove header-like lines.
    final lines = rawLines.where((l) {
      final lower = l.toLowerCase();
      if (lower == 'rx' || lower == 'r x' || lower == 'r.x') return false;
      if (lower.startsWith('medicine') && lower.contains('instruction')) {
        return false;
      }
      if (lower == 'medicine' || lower == 'medicines') return false;
      if (lower == 'instruction' || lower == 'instructions') return false;
      return true;
    }).toList();

    int i = 0;
    while (i < lines.length) {
      final line = lines[i];

      // Pattern: "Name - instruction"
      if (line.contains(' - ') ||
          line.contains(' – ') ||
          line.contains(' — ')) {
        for (final sep in [' - ', ' – ', ' — ']) {
          final idx = line.indexOf(sep);
          if (idx > 0 && idx + sep.length < line.length) {
            final name = line.substring(0, idx).trim();
            final ins = line.substring(idx + sep.length).trim();
            if (name.isNotEmpty) {
              items.add((name, ins));
            }
            break;
          }
        }
        i++;
        continue;
      }

      // Pattern: medicine line followed by instruction line
      if (_looksLikeMedicineLine(line) ||
          (!_looksLikeInstructionLine(line) && line.length > 2)) {
        final name = line.trim();
        String ins = '';
        if (i + 1 < lines.length) {
          final next = lines[i + 1].trim();
          if (_looksLikeInstructionLine(next) &&
              !_looksLikeMedicineLine(next)) {
            ins = next;
            i += 2;
          } else {
            i += 1;
          }
        } else {
          i += 1;
        }

        if (name.isNotEmpty) {
          items.add((name, ins));
        }
        continue;
      }

      i++;
    }

    // Cleanup: move medicine-like instruction into name if needed + apply generic instruction.
    final cleanedItems = <(String name, String instructions)>[];
    for (final it in items) {
      var name = it.$1.trim();
      var ins = it.$2.trim();
      if (ins.isNotEmpty && _looksLikeMedicineLine(ins)) {
        if (name.isEmpty) name = ins;
        ins = '';
      }
      if (genericInstruction != null && genericInstruction.isNotEmpty) {
        if (ins.isEmpty) {
          ins = genericInstruction;
        } else if (!ins.toLowerCase().contains(
          genericInstruction.toLowerCase(),
        )) {
          ins = '$ins\n$genericInstruction';
        }
      }
      if (name.isNotEmpty) {
        cleanedItems.add((name, ins));
      }
    }

    // De-dup
    final seen = <String>{};
    final unique = <(String name, String instructions)>[];
    for (final it in cleanedItems) {
      final key = '${it.$1.toLowerCase()}|${it.$2.toLowerCase()}';
      if (seen.add(key)) unique.add(it);
    }
    return unique;
  }

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
            onTap: () async {
              final rootContext = Get.overlayContext ?? Get.context;
              Get.back();

              if (!Get.isRegistered<MedicationTrackerController>()) {
                Get.put(MedicationTrackerController());
              }

              final rawTitle = (prescription.title ?? '').toString();
              final fileUrl = _resolveS3Url(prescription.file);
              final lower = fileUrl.toLowerCase();
              final isPdf = lower.endsWith('.pdf');

              Future<void> openDialogWithPrefill({
                required String name,
                required String desc,
              }) async {
                final ctx = rootContext;
                if (ctx == null) return;
                final nameController = TextEditingController(text: name);
                final descController = TextEditingController(text: desc);

                await showDialog(
                  context: ctx,
                  builder: (_) => AlertDialog(
                    title: const Text('Add to My Medicine'),
                    content: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                          final nameValue = nameController.text.trim();
                          final descValue = descController.text.trim();
                          Get.back();

                          Get.to(
                            () => AddOrEditMedicationScreen(
                              isEdit: false,
                              medication: Medication(
                                title: nameValue.isEmpty
                                    ? 'Medicine'
                                    : nameValue,
                                description: descValue,
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
              }

              if (isPdf && fileUrl.isNotEmpty) {
                final ctx = rootContext;
                if (ctx == null) return;
                bool loaderShown = false;
                try {
                  loaderShown = true;
                  showDialog(
                    context: ctx,
                    useRootNavigator: true,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final text = await _extractTextFromPdfUrl(fileUrl);
                  final items = _parseRxItems(text);

                  if (loaderShown) {
                    Navigator.of(ctx, rootNavigator: true).pop();
                    loaderShown = false;
                  }

                  final one = items.isNotEmpty ? items.first : ('', '');
                  await openDialogWithPrefill(name: one.$1, desc: one.$2);
                  return;
                } catch (_) {
                  if (loaderShown) {
                    Navigator.of(ctx, rootNavigator: true).pop();
                    loaderShown = false;
                  }

                  await openDialogWithPrefill(name: '', desc: '');
                  return;
                }
              }

              final suggestedName = _suggestedMedicineName(rawTitle);
              final suggestedDesc = _suggestedInstructions(rawTitle);

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

              openDialogWithPrefill(
                name: suggestedName.isEmpty ? '' : suggestedName,
                desc: suggestedDesc.isEmpty ? '' : suggestedDesc,
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
