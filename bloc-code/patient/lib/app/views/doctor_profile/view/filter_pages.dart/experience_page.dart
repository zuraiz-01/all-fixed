import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/size_config.dart';
import '../../widgets/get_doctor_profile_experience_card.dart';

class DoctorProfileExperiencePage extends StatelessWidget {
  DoctorProfileExperiencePage({
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
                currentDoctor.experiences!.length == 0
                    ? SizedBox(
                        height: getHeight(context: context) / 3,
                        child: NoDataFoundWidget(
                          title: "Don't have any experience",
                        ),
                      )
                    : SizedBox.shrink(),
                ListView.builder(
                  itemCount: currentDoctor.experiences!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GetDoctorProfileExperienceCard(
                        docExperience: currentDoctor.experiences![index]);
                  },
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
