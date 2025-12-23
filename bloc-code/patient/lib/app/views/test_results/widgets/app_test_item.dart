import 'dart:math';

import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppTestItem extends StatelessWidget {
  AppTestItem(
      {super.key,
      required this.context,
      required this.title,
      required this.leftEye,
      required this.rightEye});
  BuildContext context;
  String title;
  List<String> leftEye;
  List<String> rightEye;

  @override
  Widget build(BuildContext context) {
    var localLanguage = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        border: Border.all(color: AppColors.colorEFEFEF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(18),
              top: getProportionateScreenWidth(10),
              bottom: getProportionateScreenWidth(10),
            ),
            child: InterText(
              title: title,
              textColor: AppColors.black,
              fontSize: 14,
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 1,
            color: AppColors.colorEFEFEF,
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(18),
                        getProportionateScreenWidth(7),
                        0,
                        0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InterText(
                          title: localLanguage.left_eye,
                          textColor: AppColors.color888E9D,
                          fontSize: 12,
                        ),
                        CommonSizeBox(
                          height: getProportionateScreenWidth(10),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          child: ListView.builder(
                            itemCount: leftEye.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: getProportionateScreenWidth(10)),
                                child: InterText(
                                  title: leftEye[index],
                                  textColor: AppColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: getProportionateScreenWidth(80),
                  color: AppColors.colorEFEFEF,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        getProportionateScreenWidth(18),
                        getProportionateScreenWidth(7),
                        0,
                        0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InterText(
                          title: localLanguage.right_eye,
                          textColor: AppColors.color888E9D,
                          fontSize: 12,
                        ),
                        CommonSizeBox(
                          height: getProportionateScreenWidth(10),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          child: ListView.builder(
                            itemCount: rightEye.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: getProportionateScreenWidth(10)),
                                child: InterText(
                                  title: rightEye[index],
                                  textColor: AppColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
