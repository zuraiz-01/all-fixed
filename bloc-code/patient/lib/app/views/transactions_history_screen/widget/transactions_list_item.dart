import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/global_variables.dart';

class TransactionsListItem extends StatelessWidget {
  AppointmentData appointmentData;
  TransactionsListItem({required this.appointmentData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(23)),
      child: Row(
        children: [
          Container(
            height: getProportionateScreenHeight(40),
            width: getProportionateScreenHeight(40),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.colorE6F2EE),
            child: SvgPicture.asset(
              AppAssets.transactions,
              height: getProportionateScreenWidth(21),
              width: getProportionateScreenWidth(21),
            ),
          ),
          CommonSizeBox(
            width: getProportionateScreenWidth(14),
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Paid to ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${appointmentData.doctor!.name}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                InterText(
                  title: '${formatDate(appointmentData.date!)}',
                  fontSize: 9,
                  textColor: AppColors.color888E9D,
                ),
              ],
            ),
          ),
          const Spacer(),
          InterText(
            title: '$getCurrencySymbol ${appointmentData.grandTotal}',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
