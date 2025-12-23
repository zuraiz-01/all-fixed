import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsItem extends StatelessWidget {
  TermsAndConditionsItem({
    required this.title,
    required this.index,
    required this.selectedIndexIndex,
    required this.callBackFunction,
    super.key,
  });

  final String title;
  final int index;
  int selectedIndexIndex;
  Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: const BoxDecoration(
        color: AppColors.colorCCE7D9,
        borderRadius: BorderRadius.all(Radius.circular(17)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 18,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: AppColors.primaryColor),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  Visibility(
                    visible: selectedIndexIndex == index ? true : false,
                    child: Container(
                      child: const Text(
                        'Experienced Mobile Application Developer with a demonstrated history of working in the computer software industry. Skilled in Flutter, Android, Java.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                callBackFunction();
              },
              child: selectedIndexIndex == index
                  ? Container(
                      child: const Icon(
                        Icons.arrow_drop_up_sharp,
                        color: AppColors.primaryColor,
                      ),
                    )
                  : Container(
                      child: const Icon(
                        Icons.add,
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
