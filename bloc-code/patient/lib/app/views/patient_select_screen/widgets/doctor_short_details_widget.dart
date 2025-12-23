import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../api/model/doctor_list_response_model.dart';

class DoctorShortDetails extends StatelessWidget {
  DoctorShortDetails({
    super.key,
    required this.doctorProfile,
  });
  Doctor? doctorProfile;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(100),
            width: getProportionateScreenHeight(100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CommonNetworkImageWidget(
                imageLink:
                    '${ApiConstants.imageBaseUrl}${doctorProfile?.photo}',
              ),
            ),
          ),
          CommonSizeBox(
            width: getProportionateScreenWidth(12),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth / 2,
                child: InterText(
                  title: doctorProfile?.name ?? "",
                  textColor: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              doctorProfile!.specialty.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: InterText(
                            title:
                                "${doctorProfile!.specialty.map((e) => e.title).toList().join(", ")}",
                            fontSize: 12,
                            textColor: AppColors.color888E9D,
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(5),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              doctorProfile?.hospital != null
                  ? Column(
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: InterText(
                            title:
                                "${doctorProfile!.hospital.map((e) => e.name).toList().join(", ")}",
                            fontSize: 12,
                            textColor: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(6),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  InterText(
                    title:
                        '${doctorProfile?.averageRating} (${doctorProfile?.ratingCount})',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
