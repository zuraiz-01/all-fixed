import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/upload_prescription_or_clinical_image_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTypeDropdownWidget extends StatelessWidget {
  const UserTypeDropdownWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var localLanguage = AppLocalizations.of(context)!;
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MyPatient>(
                isExpanded: true,
                alignment: Alignment.center,
                value: context
                    .read<UploadPrescriptionOrClinicalImageCubit>()
                    .state
                    .selectedPatient,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                elevation: 16,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                onChanged: (MyPatient? newValue) {
                  context
                      .read<UploadPrescriptionOrClinicalImageCubit>()
                      .updateSelectedPatient(newValue!);
                },
                hint: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    localLanguage.select_your_patient,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
                items: context
                    .read<PatientListCubit>()
                    .state
                    .myPatientList
                    .map((e) {
                  return DropdownMenuItem<MyPatient>(
                    value: e,
                    child: Text(e.name!),
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
}
