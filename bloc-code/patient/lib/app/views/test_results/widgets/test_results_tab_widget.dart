import 'package:eye_buddy/app/bloc/test_result_bloc/test_result_tab_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result_bloc/test_results_tab_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestResultTabWidget extends StatelessWidget {
  const TestResultTabWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localLanguage = AppLocalizations.of(context)!;
    return Container(
      height: getProportionateScreenHeight(45),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.color80C2A0,
        ),
      ),
      padding: const EdgeInsets.all(
        5,
      ),
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: BlocBuilder<TestResultTabCubit, TestResultTabState>(
        builder: (context, state) {
          return Row(
            children: [
              TestResultTabWidgetChip(
                isActive: state.testResultTabType == TestResultTabType.appTest,
                title: localLanguage.app_test,
                appointmentType: TestResultTabType.appTest,
              ),
              TestResultTabWidgetChip(
                isActive: state.testResultTabType == TestResultTabType.clinicalResult,
                appointmentType: TestResultTabType.clinicalResult,
                title: localLanguage.clinical_results,
              ),
            ],
          );
        },
      ),
    );
  }
}

class TestResultTabWidgetChip extends StatelessWidget {
  TestResultTabWidgetChip({
    required this.title,
    required this.isActive,
    required this.appointmentType,
    super.key,
  });

  String title;
  bool isActive;
  TestResultTabType appointmentType;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          context.read<TestResultTabCubit>().changeAppointmentType(appointmentType);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: InterText(
            title: title,
            textColor: isActive ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
