import 'package:eye_buddy/app/bloc/appointment_filter_cubit/appointment_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsFilter extends StatelessWidget {
  const AppointmentsFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(context)!;
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
      child: BlocBuilder<AppointmentFilterCubit, AppointmentFilterState>(
        builder: (context, state) {
          return Row(
            children: [
              AppointmentsFilterChip(
                isActive: state.appointmentType == AppointmentFilterType.past,
                title: localLanguage.past,
                appointmentType: AppointmentFilterType.past,
              ),
              AppointmentsFilterChip(
                isActive: state.appointmentType == AppointmentFilterType.upcoming,
                appointmentType: AppointmentFilterType.upcoming,
                title: localLanguage.upcoming,
              ),
              AppointmentsFilterChip(
                isActive: state.appointmentType == AppointmentFilterType.followup,
                title: localLanguage.followup,
                appointmentType: AppointmentFilterType.followup,
              ),
            ],
          );
        },
      ),
    );
  }
}

class AppointmentsFilterChip extends StatelessWidget {
  AppointmentsFilterChip({
    required this.title,
    required this.isActive,
    required this.appointmentType,
    super.key,
  });

  String title;
  bool isActive;
  AppointmentFilterType appointmentType;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          context.read<AppointmentFilterCubit>().changeAppointmentType(appointmentType);
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
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
