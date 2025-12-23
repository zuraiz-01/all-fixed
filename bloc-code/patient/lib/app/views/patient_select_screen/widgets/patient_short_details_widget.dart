import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/extensions.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class PatientShortDetailsWidget extends StatelessWidget {
  PatientShortDetailsWidget({
    super.key,
    required this.relationsWithPatient,
    required this.patientModel,
  });

  String relationsWithPatient;
  MyPatient patientModel;

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
        vertical: 14,
      ),
      child: Row(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(50),
            width: getProportionateScreenHeight(50),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CommonNetworkImageWidget(
                imageLink: '${ApiConstants.imageBaseUrl}${patientModel.photo}',
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InterText(
                    title: patientModel.name!,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  CommonSizeBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  if (relationsWithPatient.trim().isEmpty)
                    const SizedBox()
                  else
                    Container(
                      // height: getProportionateScreenHeight(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        color: AppColors.colorEFEFEF,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      alignment: Alignment.center,
                      child: InterText(
                        title: capitalizeFirstWord(relationsWithPatient),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  InterText(
                    title: patientModel.gender!,
                    fontSize: 14,
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
                    title: getYearsOld(patientModel.dateOfBirth!) + " Years",
                    fontSize: 14,
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
                    title: '${patientModel.weight} KG',
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
