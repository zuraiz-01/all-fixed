import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/extensions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/appointments/widgets/appointment_user_popup.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrescriptionUserMenu extends StatelessWidget {
  const PrescriptionUserMenu({
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
                context
                    .read<PrescriptionListCubit>()
                    .updatePatientForPrescription(element);
              },
              child: SizedBox(
                height: getProportionateScreenHeight(35),
                width: getProportionateScreenWidth(120),
                child: AppointmentUserPopUpWIdget(
                  userName: "${element.name}",
                  image: element.photo != null
                      ? '${ApiConstants.imageBaseUrl}${element.photo}'
                      : '',
                ),
              ),
            ),
          );
        });
        return items;
      },
      child: Container(
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenWidth(130),
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
                BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
                  builder: (context, state) {
                    return Container(
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenHeight(30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CommonNetworkImageWidget(
                          imageLink:
                              "${ApiConstants.imageBaseUrl}${state.patient.photo}",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 6,
                ),
                BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
                  builder: (context, state) {
                    return state.patient.relation != null
                        ? InterText(
                            title: capitalizeFirstWord(state.patient.relation!),
                            fontSize: 12,
                          )
                        : SizedBox();
                  },
                )
              ],
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.color000000,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
