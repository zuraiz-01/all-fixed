import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/all_prescriptions_screen/view/all_prescriptions_screen.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/views/doctor_list_screen.dart';
import 'package:eye_buddy/app/views/eye_test_list_screen/view/eye_test_list_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/medication_tracker/medication_tracker_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeFeatureSection extends StatelessWidget {
  const HomeFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: getProportionateScreenWidth(20),
        right: getProportionateScreenWidth(20),
        bottom: getProportionateScreenWidth(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quick_access,
            style: TextStyle(
              color: Color(0xFF001B0D),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(10),
          Row(
            children: [
              Expanded(
                child: homeFeaturedSectionItem(
                  context: context,
                  imageAssets: AppAssets.doctor,
                  title: l10n.video_consultation,
                  titleDetails: l10n.doctors_are_online,
                  isOnline: true,
                  onPressed: () {
                    NavigatorServices().to(
                      context: context,
                      widget: DoctorListScreen(),
                    );
                  },
                ),
              ),
              CommonSizeBox(
                width: 16,
              ),
              Expanded(
                child: homeFeaturedSectionItem(
                  context: context,
                  imageAssets: AppAssets.eye_test,
                  title: l10n.eye_test,
                  onPressed: () {
                    NavigatorServices().to(
                      context: context,
                      widget: EyeTestListScreen(),
                    );
                  },
                  titleDetails: l10n.check_your_vision_now,
                ),
              ),
            ],
          ),
          CommonSizeBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: homeFeaturedSectionItem(
                  context: context,
                  imageAssets: AppAssets.eye_test_home,
                  onPressed: () {
                    NavigatorServices().to(
                      context: context,
                      widget: MedicationTrackerScreen(),
                    );
                  },
                  title: l10n.medication_tracker,
                  titleDetails:
                      "${l10n.never_miss_a_dose}\n${l10n.set_reminders}",
                ),
              ),
              CommonSizeBox(
                width: 16,
              ),
              Expanded(
                child: homeFeaturedSectionItem(
                  context: context,
                  imageAssets: AppAssets.all_prescriptions_home,
                  onPressed: () {
                    NavigatorServices().to(
                      context: context,
                      widget: AllPrescriptionsScreen(),
                    );
                  },
                  title: l10n.all_prescriptions,
                  titleDetails: l10n.your_prescriptions_all_in_one_place,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  homeFeaturedSectionItem({
    required onPressed,
    required BuildContext context,
    required String imageAssets,
    required String title,
    required String titleDetails,
    bool isOnline = false,
  }) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            border: Border.all(color: AppColors.colorEDEDED, width: 2)),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                padding: imageAssets == AppAssets.eye_test ||
                        imageAssets == AppAssets.doctor
                    ? EdgeInsets.only(top: 10)
                    : EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.primaryColor),
                alignment: imageAssets == AppAssets.eye_test
                    ? Alignment.centerRight
                    : Alignment.center,
                child: Image.asset(
                  imageAssets,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InterText(
                      title: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(6),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isOnline,
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 3, top: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InterText(
                            title: titleDetails,
                            fontSize: 10.5,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            textColor: AppColors.black.withOpacity(.7),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     // Column(
                    //     //   children: [
                    //     //     SizedBox(
                    //     //       height: 2,
                    //     //     ),
                    //     //     Container(
                    //     //       height: getProportionateScreenHeight(10),
                    //     //       width: getProportionateScreenHeight(10),
                    //     //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor),
                    //     //     ),
                    //     //   ],
                    //     // ),
                    //     // CommonSizeBox(
                    //     //   width: getProportionateScreenWidth(4),
                    //     // ),
                    //
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
