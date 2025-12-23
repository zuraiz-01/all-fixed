import 'dart:developer';

import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_state.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../utils/config/app_colors.dart';
import '../../utils/dimentions.dart';
import '../global_widgets/common_app_bar.dart';

class RatingScreen extends StatelessWidget {
  RatingScreen({
    super.key,
    required this.appointmentId,
  });

  String appointmentId;

  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.rating,
        elevation: 0,
        icon: Icons.close,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Container(
        height: getHeight(
          context: context,
        ),
        width: getWidth(
          context: context,
        ),
        child: BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, state) {
            return state.isLoading
                ? CustomLoadingScreen()
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          // Container(
                          //   width: getWidth(context: context),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     border: Border.all(color: AppColors.colorEFEFEF),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 17,
                          //     vertical: 20,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 16,
                          // ),
                          Container(
                            width: getWidth(context: context),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.colorEFEFEF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 6,
                                ),
                                InterText(
                                  title: l10n.how_was_the_doctor,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RatingBar.builder(
                                  initialRating: 0,
                                  itemSize: 45,
                                  maxRating: 5,
                                  ignoreGestures: false,
                                  allowHalfRating: true,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.5),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (val) {
                                    rating = val;
                                    log("Rating: $val");
                                  },
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          InterText(
                            title: l10n.leave_a_comment,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          CustomTextFormField(
                            textEditingController: reviewController,
                            maxLines: 5,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomButton(
                            title: l10n.submit,
                            callBackFunction: () {
                              if (reviewController.text.isNotEmpty) {
                                context.read<AppointmentCubit>().submitRating(
                                  {
                                    "appointment": appointmentId,
                                    "rating": rating,
                                    "review": reviewController.text,
                                  },
                                  context,
                                );
                              } else {
                                showToast(
                                  message: "Review cannot be empty",
                                  context: context,
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
