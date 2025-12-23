import 'dart:io';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/assets/app_assets.dart';
import '../../../utils/config/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../global_widgets/common_size_box.dart';

class SupportSection extends StatefulWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSizeBox(
            height: 18,
          ),
          // InterText(
          //   title: "Support",
          //   fontWeight: FontWeight.w600,
          //   fontSize: 14,
          //   textColor: AppColors.black,
          // ),
          CommonSizeBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.colorEFEFEF,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 34,
                  width: 34,
                  child: SvgPicture.asset(
                    AppAssets.help_center_support,
                    colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  ),
                ),
                CommonSizeBox(
                  width: 16,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InterText(
                        title: "BEH Support (7 am to 10 pm)",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        textColor: AppColors.primaryColor,
                      ),
                      CommonSizeBox(
                        height: 8,
                      ),
                      InterText(
                        title: "Bangladesh Eye Hospital & Institute Ltd. has now become the trendsetter for the eye care sector in the country. Our aim is to serve the community with outstanding patient care and the latest in medical advancements. We have always felt a responsibility to offer healthcare consumers the latest in advanced eye care at an affordable cost with a focus on superior customer service.",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // maxLines: 10,
                        textAlign: TextAlign.justify,
                        textColor: AppColors.color181D3D,
                      ),
                      CommonSizeBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              whatsapp();
                            },
                            child: Container(
                              width: getProportionateScreenWidth(110),
                              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: SvgPicture.asset(
                                      AppAssets.whatsapp,
                                      // colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                                    ),
                                  ),
                                  CommonSizeBox(
                                    width: 5,
                                  ),
                                  InterText(
                                    title: "Whatsapp",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    textColor: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CommonSizeBox(
                            width: 13,
                          ),
                          InkWell(
                            onTap: () {
                              makePhoneCall();
                            },
                            child: Container(
                              width: getProportionateScreenWidth(110),
                              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: SvgPicture.asset(
                                      AppAssets.support_call,
                                      // colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                                    ),
                                  ),
                                  CommonSizeBox(
                                    width: 14,
                                  ),
                                  InterText(
                                    title: "Call",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    textColor: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+88010620",
    );

    try{
      await launchUrl(launchUri);
    }catch(x){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Cant make a call now"),
      ));
    }

  }

  whatsapp() async {
    var contact = "09666787878";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("WhatsApp is not installed on the device"),
      ));
    }
  }
}
