import 'package:eye_buddy/app/api/model/get_doctor_rating_model.dart';
import 'package:eye_buddy/app/bloc/doctor_rating_cubit/doctor_rating_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_profile_feedback_comment_widget.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_profile_rating_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfileFeedbackPage extends StatelessWidget {
  DoctorProfileFeedbackPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<DoctorRatingCubit, DoctorRatingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return CupertinoActivityIndicator(
            color: AppColors.primaryColor,
          );
        }
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
                  height: getProportionateScreenHeight(16),
                ),
                const GetDoctorProfileFeedbackRatingBar(),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     InterText(
                //       title: 'Sorted By',
                //       fontSize: 12,
                //     ),
                //     InterText(
                //       title: 'Most Relevant',
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //       textColor: AppColors.color008541,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: getProportionateScreenHeight(16),
                // ),
                ListView.builder(
                  itemCount:
                      state.getDoctorRatingModel?.data?.docs?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Doc? commentDocument =
                        state.getDoctorRatingModel?.data?.docs![index];
                    if (commentDocument != null) {
                      return GetDoctorProfileFeedbackCommentWidget(
                        commentDocument: commentDocument,
                      );
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
