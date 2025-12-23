import 'package:eye_buddy/app/bloc/doctor_list/doctor_list_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/widgets/doctor_fee_slider.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/widgets/specialties_dropdown_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/global_variables.dart';

class DoctorFilterBottomSheet extends StatelessWidget {
  DoctorFilterBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              16,
            ),
            topRight: Radius.circular(
              16,
            ),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InterText(
                title: "Filter",
                fontWeight: FontWeight.bold,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 20,
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          InterText(
            title: "Speciality",
            fontSize: 14,
          ),
          SizedBox(
            height: 8,
          ),
          SpecialtiesDropdownWidget(),
          SizedBox(
            height: 12,
          ),
          InterText(
            title: "Rating",
            fontSize: 14,
          ),
          SizedBox(
            height: 8,
          ),
          BlocBuilder<DoctorListCubit, DoctorListState>(
            builder: (context, state) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<DoctorListCubit>().updateCurrentRating(state.currentRating == "4" ? "" : "4");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: state.currentRating == "4" ? AppColors.primaryColor : AppColors.appBackground,
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(
                            .2,
                          ),
                        ),
                      ),
                      child: InterText(
                        title: "Up to 4",
                        fontSize: 12,
                        textColor: state.currentRating == "4" ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<DoctorListCubit>().updateCurrentRating(state.currentRating == "4.5" ? "":"4.5");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: state.currentRating == "4.5" ? AppColors.primaryColor : AppColors.appBackground,
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(
                              .2,
                            ),
                          )),
                      child: InterText(
                        title: "Up to 4.5",
                        fontSize: 12,
                        textColor: state.currentRating == "4.5" ? AppColors.white : AppColors.black,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          SizedBox(
            height: 12,
          ),
          // InterText(
          //   title: "Consultation Fee",
          //   fontSize: 14,
          // ),
          // SizedBox(
          //   height: 8,
          // ),
          // // CustomTextFormField(
          // //   textEditingController: TextEditingController(),
          // //   hint: "To be replaced with slider",
          // // ),
          // DoctorFeeSlider(),
          // SizedBox(
          //   height: 8,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         InterText(
          //           title: "Min ",
          //           fontSize: 10,
          //         ),
          //         InterText(
          //           title: "$getCurrencySymbol 0",
          //           fontSize: 10,
          //           textColor: AppColors.primaryColor,
          //         ),
          //       ],
          //     ),
          //     Row(
          //       children: [
          //         InterText(
          //           title: "Max ",
          //           fontSize: 10,
          //         ),
          //         InterText(
          //           title: "$getCurrencySymbol 1000",
          //           fontSize: 10,
          //           textColor: AppColors.primaryColor,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 12,
          // ),
          CustomButton(
            title: "Clear Filters",
            callBackFunction: () {
              context.read<DoctorListCubit>().resetState();
              Navigator.pop(context);
            },
            backGroundColor: Colors.white,
            textColor: Colors.black,
          ),
          CustomButton(
            title: "Apply",
            callBackFunction: () {
              Map<String, String> parameters = Map<String, String>();
              if (context.read<DoctorListCubit>().state.selectedSpecialty != null) {
                parameters["specialty"] = "${context.read<DoctorListCubit>().state.selectedSpecialty!.id ?? 0}";
              }
              parameters["minConsultationFee"] = "${context.read<DoctorListCubit>().state.minConsultationFee}";
              parameters["maxConsultationFee"] = "${context.read<DoctorListCubit>().state.maxConsultationFee}";
              parameters["minRating"] = "${context.read<DoctorListCubit>().state.currentRating}";
              context.read<DoctorListCubit>().getSearchDoctorList(parameters);

              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
