import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/extensions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/doctor_profile.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/functions.dart';
import '../../../utils/global_variables.dart';

class DoctorListItem extends StatelessWidget {
  Doctor doctor;

  DoctorListItem({
    required this.doctor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        NavigatorServices().to(
          context: context,
          widget: DoctorProfileScreen(
            doctorProfile: doctor,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: 15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenWidth(75),
                            width: getProportionateScreenWidth(75),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: CommonNetworkImageWidget(
                                imageLink:
                                    '${ApiConstants.imageBaseUrl}${doctor.photo}',
                              ),
                            ),
                          ),
                          CommonSizeBox(
                            height: getProportionateScreenWidth(5),
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
                                title:
                                    '${doctor.averageRating} (${doctor.ratingCount})',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          )
                        ],
                      ),
                      CommonSizeBox(
                        width: getProportionateScreenWidth(16),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: InterText(
                                    title: '${doctor.name}',
                                    textColor: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CommonSizeBox(
                                  width: getProportionateScreenWidth(8),
                                ),
                                Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    color: AppColors.primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  alignment: Alignment.center,
                                  child: InterText(
                                    title: capitalizeFirstWord(
                                        '${doctor.availabilityStatus}'),
                                    fontSize: 12,
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            InterText(
                              title: '${doctor.about}',
                              fontSize: 12,
                              maxLines: 2,
                              textColor: AppColors.color888E9D,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(5),
                            ),
                            doctor.hospital != null
                                ? SizedBox(
                                    width: SizeConfig.screenWidth / 2,
                                    child: InterText(
                                      title:
                                          '${doctor.hospital.map((e) => e.name).toList().join(", ")}',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.black,
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: InterText(
                                        title: l10n.experience_in,
                                        fontSize: 12,
                                        textColor: AppColors.color888E9D,
                                      ),
                                    ),
                                    Gap(2),
                                    SizedBox(
                                      child: InterText(
                                        title:
                                            '${doctor.experienceInYear} ${l10n.years}',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        textColor: AppColors.color030330,
                                      ),
                                    ),
                                  ],
                                ),
                                CommonSizeBox(
                                  width: getProportionateScreenWidth(50),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // await Clipboard.setData(ClipboardData(text: "${doctor.bmdcCode!.trim().toString()}"));
                                    // showToast(message: "Copied to Clipboard ${doctor.bmdcCode!.trim().toString()}", context: context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: InterText(
                                          title: 'BMDC No',
                                          fontSize: 12,
                                          textColor: AppColors.color888E9D,
                                        ),
                                      ),
                                      Gap(2),
                                      SizedBox(
                                        child: InterText(
                                          title: getShortAppointmentId(
                                                  appointmentId:
                                                      doctor.bmdcCode,
                                                  wantedLength: 5) ??
                                              "NO_ID",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          textColor: AppColors.color030330,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: AppColors.colorEDEDED,
                  height: getProportionateScreenHeight(1),
                  width: double.maxFinite,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    top: getProportionateScreenWidth(10),
                    bottom: getProportionateScreenWidth(10),
                  ),
                  child: Row(
                    children: [
                      FutureBuilder(
                        builder: (ctx, snapshot) {
                          // Displaying LoadingSpinner to indicate waiting state
                          return InterText(
                            title: '$getCurrencySymbol ${snapshot.data}',
                          );
                        },
                        initialData: "",
                        future: getDoctorConsultationFee(doctor: doctor),
                      ),
                      InterText(
                        title: '  (incl vat) per consultation',
                        fontSize: 12,
                        textColor: AppColors.color888E9D,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.color888E9D,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.5,
            width: double.maxFinite,
            color: AppColors.color008541,
          ),
          Gap(12)
        ],
      ),
    );
  }
}
