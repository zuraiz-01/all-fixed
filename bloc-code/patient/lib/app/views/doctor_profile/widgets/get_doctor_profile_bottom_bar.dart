import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_profile_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/patient_select_screen/view/patient_select_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/functions.dart';
import '../../../utils/global_variables.dart';

class GetDoctorProfileBottomBar extends StatelessWidget {
  GetDoctorProfileBottomBar({
    super.key,
    required this.doctorProfile,
  });
  Doctor? doctorProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DoctorProfileCubit, DoctorProfileFilterState>(
      builder: (context, state) {
        Doctor currentDoctor = state.doctor!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: getProportionateScreenHeight(90),
          width: getWidth(context: context),
          decoration: BoxDecoration(
            color: AppColors.colorFFFFFF,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 15,
                offset: const Offset(0, 0.75),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InterText(
                    title: l10n.consultationFee,
                    fontSize: 14,
                  ),
                  FutureBuilder(
                    builder: (ctx, snapshot) {
                      // Displaying LoadingSpinner to indicate waiting state
                      return InterText(
                        title: '$getCurrencySymbol ${snapshot.data}',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        textColor: AppColors.color008541,
                      );
                    },
                    initialData: "",
                    future: getDoctorConsultationFee(doctor: doctorProfile!),
                  ),

                ],
              ),
              GetDoctorsProfileButton(
                icon: Icons.videocam,
                isFilled: true,
                title: l10n.seeDoctorNow,
                height: 45,
                fontSize: 14,
                width: getProportionateScreenWidth(190),
                callBackFunction: () {
                  if (doctorProfile!.availabilityStatus != "offline") {
                    NavigatorServices().to(
                      context: context,
                      widget: PatientSelectScreen(
                        doctorProfile: doctorProfile,
                      ),
                    );
                  } else {
                    showToast(
                      message: l10n.doctor_is_offline_try_again_later,
                      context: context,
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
