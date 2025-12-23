import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../bloc/doctor_rating_cubit/doctor_rating_cubit.dart';

class GetDoctorProfileFeedbackRatingBar extends StatelessWidget {
  const GetDoctorProfileFeedbackRatingBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorRatingCubit, DoctorRatingState>(
      builder: (context, state) {
        return Row(
          children: [
            Column(
              children: [
                InterText(
                  title: (state.getDoctorRatingModel?.averageRating ?? 0.0).toString(),
                  fontSize: 24,
                  textColor: AppColors.color008541,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 3,
                ),
                Column(
                  children: [
                    RatingBar.builder(
                      initialRating: state.getDoctorRatingModel?.averageRating ?? 0.0,
                      minRating: 0,
                      itemSize: 12,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: print,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    InterText(
                      title:
                          '${(state.getDoctorRatingModel?.statistics?.length ?? 0.0).toString()} ${state.getDoctorRatingModel?.statistics?.length == 1 ? "Rating" : "Ratings"}',
                      fontSize: 12,
                      textColor: AppColors.color888E9D,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: getProportionateScreenWidth(16),
            ),
            Expanded(
              child: Column(
                children: [
                  _DoctorProfileRatingBar(
                    totalRatings: state.getDoctorRatingModel?.totalRatings ?? 0,
                    outOf: double.parse((state.getDoctorRatingModel?.statistics?.where((element) => element.id == 5).toList().length ?? 0).toString()),
                    rating: 5,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  _DoctorProfileRatingBar(
                    totalRatings: state.getDoctorRatingModel?.totalRatings ?? 0,
                    outOf: double.parse((state.getDoctorRatingModel?.statistics?.where((element) => element.id == 4).toList().length ?? 0).toString()),
                    rating: 4,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  _DoctorProfileRatingBar(
                    totalRatings: state.getDoctorRatingModel?.totalRatings ?? 0,
                    outOf: double.parse((state.getDoctorRatingModel?.statistics?.where((element) => element.id == 3).toList().length ?? 0).toString()),
                    rating: 3,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  _DoctorProfileRatingBar(
                    totalRatings: state.getDoctorRatingModel?.totalRatings ?? 0,
                    outOf: double.parse((state.getDoctorRatingModel?.statistics?.where((element) => element.id == 2).toList().length ?? 0).toString()),
                    rating: 2,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(3),
                  ),
                  _DoctorProfileRatingBar(
                    totalRatings: state.getDoctorRatingModel?.totalRatings ?? 0,
                    outOf: double.parse((state.getDoctorRatingModel?.statistics?.where((element) => element.id == 1).toList().length ?? 0).toString()),
                    rating: 1,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _DoctorProfileRatingBar extends StatelessWidget {
  _DoctorProfileRatingBar({
    required this.outOf,
    required this.totalRatings,
    required this.rating,
  });

  double outOf;
  int totalRatings;
  int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey[200],
            ),
            alignment: Alignment.centerLeft,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var percentageCovered = constraints.maxWidth * (outOf / totalRatings);
                if (totalRatings == 0) {
                  percentageCovered = 0;
                }
                return Container(
                  height: 5,
                  width: percentageCovered,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        SizedBox(
          width: getProportionateScreenWidth(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBar.builder(
                initialRating: rating.toDouble(),
                itemSize: 12,
                maxRating: 5,
                allowHalfRating: true,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                ),
                onRatingUpdate: print,
              ),
              InterText(
                title: outOf.toString(),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        )
      ],
    );
  }
}
