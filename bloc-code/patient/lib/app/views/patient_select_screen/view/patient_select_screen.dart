import 'package:dotted_border/dotted_border.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/create_patient_profile/view/create_patient_profile_screen.dart';
import 'package:eye_buddy/app/views/create_patient_profile/view/reason_for_visit_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/patient_select_screen/widgets/doctor_short_details_widget.dart';
import 'package:eye_buddy/app/views/patient_select_screen/widgets/patient_short_details_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../api/model/doctor_list_response_model.dart';

class PatientSelectScreen extends StatelessWidget {
  PatientSelectScreen({
    super.key,
    required this.doctorProfile,
  });
  Doctor? doctorProfile;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: localLanguage.profile,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(24),
              ),
              DoctorShortDetails(
                doctorProfile: doctorProfile,
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(10),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: InterText(
                  title: localLanguage.selectPatient,
                  textColor: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(12),
              ),
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeTop: true,
                child: BlocBuilder<PatientListCubit, PatientListState>(
                  builder: (context, state) {
                    if (state is PatientListFetchedSuccessfully || state is PatientListState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.myPatientList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                NavigatorServices().toReplacement(
                                  context: context,
                                  widget: ReasonForVisitScreen(
                                    patientData: state.myPatientList[index],
                                    selectedDoctor: doctorProfile!,
                                  ),
                                );
                              },
                              child: PatientShortDetailsWidget(
                                relationsWithPatient: state.myPatientList[index].relation!,
                                patientModel: state.myPatientList[index],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return InterText(title: "No patient found");
                    }
                  },
                ),
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(6),
              ),
              InterText(
                title: localLanguage.or,
                textColor: AppColors.color888E9D,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(16),
              ),
              GestureDetector(
                onTap: () {
                  NavigatorServices().to(
                    context: context,
                    widget: CreatePatientProfileScreen(
                      isCreateNewPatientProfile: true,
                    ),
                  );
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: AppColors.color888E9D,
                  radius: const Radius.circular(5),
                  padding: const EdgeInsets.all(1),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(18),
                        vertical: getProportionateScreenWidth(13),
                      ),
                      color: AppColors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getProportionateScreenWidth(22),
                            width: getProportionateScreenWidth(22),
                            child: SvgPicture.asset(
                              AppAssets.createPatient,
                            ),
                          ),
                          CommonSizeBox(
                            width: getProportionateScreenWidth(16),
                          ),
                          InterText(
                            title: localLanguage.createPatientProfile,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.color888E9D,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: kToolbarHeight * 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
