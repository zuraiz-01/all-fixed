import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

import '../../../api/model/patient_list_model.dart';
import '../../../api/service/api_constants.dart';

class PatientTile extends StatelessWidget {
  PatientTile({
    super.key,
    this.forOverviewScreen = false,
    this.patientData,
  });
  MyPatient? patientData;

  bool forOverviewScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context: context),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.colorEFEFEF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InterText(
            title: forOverviewScreen ? 'Patient info' : 'Patient',
            fontSize: 14,
            textColor: AppColors.color888E9D,
          ),
          const SizedBox(
            height: 9,
          ),
          Row(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(50),
                width: getProportionateScreenHeight(50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CommonNetworkImageWidget(
                    imageLink: ApiConstants.imageBaseUrl + (patientData?.photo ?? ""),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InterText(
                      title: patientData!.name!,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        InterText(
                          title: patientData!.gender!,
                          fontSize: 12,
                          textColor: AppColors.color888E9D,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 10,
                          width: 1,
                          color: AppColors.color888E9D,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InterText(
                          title: '${getYearsOld(patientData!.dateOfBirth!)} Years',
                          fontSize: 12,
                          textColor: AppColors.color888E9D,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 10,
                          width: 1,
                          color: AppColors.color888E9D,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InterText(
                          title: '${patientData!.weight!} KG',
                          fontSize: 12,
                          textColor: AppColors.color888E9D,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // if (forOverviewScreen)
              //   Row(
              //     children: [
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 10,
              //           vertical: 5,
              //         ),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(25),
              //           color: AppColors.colorCCE7D9,
              //         ),
              //         alignment: Alignment.center,
              //         child: InterText(
              //           title: 'Someone else',
              //           fontSize: 10,
              //           textColor: AppColors.primaryColor,
              //         ),
              //       )
              //     ],
              //   )
              // else
              //   const SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }
}
