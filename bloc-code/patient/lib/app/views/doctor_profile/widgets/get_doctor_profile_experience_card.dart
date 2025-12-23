import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class GetDoctorProfileExperienceCard extends StatelessWidget {
  Experience docExperience;
  GetDoctorProfileExperienceCard({
    super.key,
    required this.docExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(
          15,
        ),
        width: getWidth(context: context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.colorEFEFEF,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InterText(
              title: docExperience.hospitalName!,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              children: [
                Flexible(
                  child: _ExperienceWidget(
                    title: 'Designation',
                    subtitleOne: docExperience.designation!,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: _ExperienceWidget(
                    title: 'Department',
                    subtitleOne: docExperience.department!,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _ExperienceWidget(
                    title: 'Start Date',
                    subtitleOne: (docExperience.startDate ?? DateTime.now()).toString(),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: _ExperienceWidget(
                    title: 'End Date',
                    subtitleOne: 'Present',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceWidget extends StatelessWidget {
  _ExperienceWidget({
    required this.title,
    required this.subtitleOne,
  });

  String title;
  String subtitleOne;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterText(
            title: title,
            fontSize: 12,
            textColor: AppColors.color888E9D,
          ),
          const SizedBox(
            height: 4,
          ),
          InterText(
            title: subtitleOne,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}
