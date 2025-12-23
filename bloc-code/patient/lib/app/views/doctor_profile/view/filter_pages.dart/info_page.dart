import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/model/doctor_list_response_model.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/global_variables.dart';

class DoctorProfileInfoPage extends StatelessWidget {
  DoctorProfileInfoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileCubit, DoctorProfileFilterState>(
      builder: (context, state) {
        Doctor currentDoctor = state.doctor!;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: getWidth(context: context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    FutureBuilder(
                      builder: (ctx, snapshot) {
                        // Displaying LoadingSpinner to indicate waiting state
                        return Flexible(
                          child: _InfoWidget(
                            title: 'Consultation Fee',
                            subtitleOne: '$getCurrencySymbol ${snapshot.data}',
                            subtitleTwo: '(Incl 5% vat)',
                          ),
                        );
                      },
                      initialData: "",
                      future: getDoctorConsultationFee(doctor: currentDoctor),
                    ),
                    FutureBuilder(
                      builder: (ctx, snapshot) {
                        // Displaying LoadingSpinner to indicate waiting state
                        return Flexible(
                          child: _InfoWidget(
                            title: 'Followup Fee',
                            subtitleOne: '$getCurrencySymbol ${snapshot.data}',
                            subtitleTwo: '(Incl 5% vat)',
                          ),
                        );
                      },
                      initialData: "",
                      future: getDoctorFollowUpFeeUsd(doctor: currentDoctor),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Flexible(
                    //   child: _InfoWidget(
                    //     title: 'Total Patients',
                    //     subtitleOne: '${currentDoctor.totalConsultationCount ?? 0}',
                    //     subtitleTwo: '',
                    //   ),
                    // ),
                    Flexible(
                      child: _InfoWidget(
                        title: 'Average consultancy time',
                        subtitleOne:
                            '${currentDoctor.averageConsultancyTime} min.',
                        subtitleTwo: '',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                InterText(
                  title: 'About Doctor',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.color008541,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(6),
                ),
                InterText(
                  title: currentDoctor.about!,
                  fontSize: 14,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoWidget extends StatelessWidget {
  _InfoWidget({
    required this.title,
    required this.subtitleOne,
    required this.subtitleTwo,
  });

  String title;
  String subtitleOne;
  String subtitleTwo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InterText(
          title: title,
          fontSize: 12,
          textColor: AppColors.color888E9D,
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            InterText(
              title: subtitleOne,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(
              width: 4,
            ),
            InterText(
              title: subtitleTwo,
              fontSize: 14,
              textColor: AppColors.color888E9D,
            ),
          ],
        ),
      ],
    );
  }
}
