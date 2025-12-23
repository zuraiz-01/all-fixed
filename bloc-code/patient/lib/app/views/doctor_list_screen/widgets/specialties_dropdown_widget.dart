import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/bloc/doctor_list/doctor_list_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialtiesDropdownWidget extends StatelessWidget {
  const SpecialtiesDropdownWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: BlocBuilder<DoctorListCubit, DoctorListState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Specialty>(
                    isExpanded: true,
                    alignment: Alignment.center,
                    value: context.read<DoctorListCubit>().state.selectedSpecialty,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                    elevation: 16,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    onChanged: (Specialty? newValue) {
                      context.read<DoctorListCubit>().updateSelectedSpecialty(newValue!);
                    },
                    hint: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Select a type",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                    items: context.read<DoctorListCubit>().state.specialtyList!.map((e) {
                      return DropdownMenuItem<Specialty>(
                        value: e,
                        child: Text(e.title!),
                      );
                    }).toList()),
              ),
            ),
          );
        },
      ),
    );
  }
}
