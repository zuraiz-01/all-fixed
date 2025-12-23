import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfileFilter extends StatelessWidget {
  const DoctorProfileFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.color80C2A0,
        ),
      ),
      padding: const EdgeInsets.all(
        5,
      ),
      child: BlocBuilder<DoctorProfileCubit, DoctorProfileFilterState>(
        builder: (context, state) {
          return Row(
            children: [
              DoctorProfileFilterChip(
                isActive: state.doctorProfileFilterType == DoctorProfileFilterType.info,
                title: 'Info',
                filterType: DoctorProfileFilterType.info,
              ),
              DoctorProfileFilterChip(
                isActive: state.doctorProfileFilterType == DoctorProfileFilterType.experience,
                filterType: DoctorProfileFilterType.experience,
                title: 'Experience',
              ),
              DoctorProfileFilterChip(
                isActive: state.doctorProfileFilterType == DoctorProfileFilterType.feedback,
                title: 'Feedback',
                filterType: DoctorProfileFilterType.feedback,
              ),
            ],
          );
        },
      ),
    );
  }
}

class DoctorProfileFilterChip extends StatelessWidget {
  DoctorProfileFilterChip({
    required this.title,
    required this.isActive,
    required this.filterType,
    super.key,
  });

  String title;
  bool isActive;
  DoctorProfileFilterType filterType;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          context.read<DoctorProfileCubit>().changeFilterType(
                filterType,
              );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: InterText(
            title: title,
            textColor: isActive ? Colors.white : Colors.black.withOpacity(.7),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
