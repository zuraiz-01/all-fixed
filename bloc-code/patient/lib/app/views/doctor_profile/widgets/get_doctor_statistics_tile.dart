import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/model/doctor_list_response_model.dart';
import '../../global_widgets/toast.dart';

class GetDoctorsStatisticsTile extends StatelessWidget {
  const GetDoctorsStatisticsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorProfileCubit, DoctorProfileFilterState>(
      builder: (context, state) {
        Doctor currentDoctor = state.doctor!;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              5,
            ),
            color: Colors.white,
          ),
          height: getProportionateScreenHeight(70),
          width: getWidth(context: context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InterText(
                    title: 'Total Ratings',
                    fontSize: 12,
                    textColor: AppColors.color888E9D,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      InterText(
                        title: currentDoctor.averageRating.toString(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InterText(
                    title: 'Experience in',
                    fontSize: 12,
                    textColor: AppColors.color888E9D,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  InterText(
                    title: currentDoctor.experienceInYear.toString(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  // await Clipboard.setData(ClipboardData(text: "${currentDoctor.bmdcCode!.trim().toString()}"));
                  // showToast(message: "Copied to Clipboard ${currentDoctor.bmdcCode!.trim().toString()}", context: context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InterText(
                      title: 'BMDC No.',
                      fontSize: 12,
                      textColor: AppColors.color888E9D,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InterText(
                      title: currentDoctor.bmdcCode!.length > 6 ? currentDoctor.bmdcCode!.substring(0, 6) + "..." : currentDoctor.bmdcCode!,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
