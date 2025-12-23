import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_state.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/extensions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointment_user_popup.dart';

class AppointmentUserMenu extends StatelessWidget {
  const AppointmentUserMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(
        1,
        0,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        var userPatientsCubitState = context.read<PatientListCubit>().state;
        List<PopupMenuItem> items = [];
        userPatientsCubitState.myPatientList.forEach((element) {
          items.add(
            PopupMenuItem(
              value: element.id,
              onTap: () {
                context.read<AppointmentCubit>().updatePatient(element);
              },
              child: SizedBox(
                width: getProportionateScreenWidth(180),
                child: AppointmentUserPopUpWIdget(userName: "${element.name}", image: '${ApiConstants.imageBaseUrl}${element.photo}'),
              ),
            ),
          );
        });
        return items;
      },
      // itemBuilder: (context) => [
      //   PopupMenuItem(
      //     value: 1,
      //     onTap: () {},
      //     child: AppointmentUserPopUpWIdget(
      //       userName: 'Myself',
      //     ),
      //   ),
      //   PopupMenuItem(
      //     value: 1,
      //     onTap: () {},
      //     child: SizedBox(
      //       height: getProportionateScreenHeight(35),
      //       width: getProportionateScreenWidth(120),
      //       child: AppointmentUserPopUpWIdget(
      //         userName: 'Brother',
      //       ),
      //     ),
      //   ),
      // ],
      child: Container(
        height: getProportionateScreenHeight(45),
        width: getProportionateScreenWidth(150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.colorBBBBBB,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return Container(
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenHeight(30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CommonNetworkImageWidget(
                          imageLink: "${ApiConstants.imageBaseUrl}${state.patient.photo}",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  builder: (context, state) {
                    return InterText(
                      title: capitalizeFirstWord(state.patient.relation ?? ""),
                      fontSize: 14,
                    );
                  },
                )
              ],
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
