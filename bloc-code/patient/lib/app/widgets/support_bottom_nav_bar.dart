import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../l10n/app_localizations.dart';
import '../utils/services/navigator_services.dart';
import '../views/live_support/view/live_support_screen.dart';

class SupportBottomNavBar extends StatelessWidget {
  const SupportBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          height: 1.5,
          width: getWidth(context: context),
          color: AppColors.primaryColor,
        ),
        Container(
          height: kToolbarHeight * 1.5,
          color: AppColors.colorCCE7D9,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {

                    _makePhoneCall("09666787878");

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      FittedBox(
                        child: InterText(
                          title: '09666787878',
                          fontSize: 12,
                          textColor: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    NavigatorServices().to(context: context, widget: LiveSupportScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.chatHelp,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InterText(
                        title: l10n.live_chat,
                        fontSize: 12,
                        textColor: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
