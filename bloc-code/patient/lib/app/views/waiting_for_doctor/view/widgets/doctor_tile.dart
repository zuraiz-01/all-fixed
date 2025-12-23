import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

import '../../../../api/model/doctor_list_response_model.dart';
import '../../../../api/model/patient_list_model.dart';

class WaitingForDoctorDoctorTile extends StatelessWidget {
  WaitingForDoctorDoctorTile({
    super.key,
    required this.patientData,
    required this.selectedDoctor,
  });
  MyPatient? patientData;
  Doctor selectedDoctor;

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
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(60),
                width: getProportionateScreenHeight(60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: CommonNetworkImageWidget(
                    imageLink:
                        '${ApiConstants.imageBaseUrl}${selectedDoctor.photo}',
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
                      title: selectedDoctor.name ?? "",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InterText(
                      title:
                          "${selectedDoctor.specialty.map((e) => e.title).toList().join(", ")}",
                      fontSize: 10,
                      textColor: AppColors.color888E9D,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: AppColors.colorCCE7D9,
                    ),
                    alignment: Alignment.center,
                    child: InterText(
                      title: 'PAID',
                      fontSize: 10,
                      textColor: AppColors.primaryColor,
                    ),
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
