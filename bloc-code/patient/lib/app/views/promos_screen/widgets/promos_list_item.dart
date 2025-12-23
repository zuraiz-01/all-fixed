import 'package:eye_buddy/app/api/model/promo_list_response_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

class PromosListItem extends StatelessWidget {
  PromosListItem({
    required this.promo,
    // required this.titleDetails,
    super.key,
  });
  Promo promo;
  // final String titleDetails;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: SizeConfig.screenWidth,
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(20),
        getProportionateScreenHeight(13),
        getProportionateScreenWidth(20),
        getProportionateScreenHeight(13),
      ),
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: InterText(
                  title: promo.code!,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.color008541,
                ),
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(14),
              ),
              RichText(
                text: TextSpan(
                  text: '* Minimum Amount ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color888E9D,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${promo.minimumPurchase} Tk.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color001B0D,
                      ),
                    ),
                  ],
                ),
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(6),
              ),
              RichText(
                text: TextSpan(
                  text: '* Valid Till ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color888E9D,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '${DateFormat('dd MMM, yyyy').format(DateTime.parse(promo.validTill!))}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color001B0D,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: InterText(
                  title: '${promo.discount}% OFF',
                  textColor: AppColors.color008541,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CommonSizeBox(
                height: getProportionateScreenHeight(4),
              ),
              SizedBox(
                child: InterText(
                  title: 'Up to ${promo.maximumDiscount} Tk.',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
