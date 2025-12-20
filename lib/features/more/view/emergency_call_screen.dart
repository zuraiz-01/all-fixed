import 'dart:io';

import 'package:eye_buddy/core/services/utils/assets/app_assets.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';

class EmergencyCallScreen extends StatelessWidget {
  const EmergencyCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.emergency_call,
        elevation: 1.0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: true,
        context: context,
      ),
      body: Column(children: const [SupportSection(), SizedBox(height: 10)]),
    );
  }
}

class SupportSection extends StatefulWidget {
  const SupportSection({super.key});

  @override
  State<SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<SupportSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSizeBox(height: 18),
          const CommonSizeBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const CommonSizeBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InterText(
                        title: 'BEH Support (7 am to 10 pm)',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        textColor: AppColors.primaryColor,
                      ),
                      const CommonSizeBox(height: 8),
                      const InterText(
                        title:
                            'Bangladesh Eye Hospital & Institute Ltd. has now become the trendsetter for the eye care sector in the country. Our aim is to serve the community with outstanding patient care and the latest in medical advancements. We have always felt a responsibility to offer healthcare consumers the latest in advanced eye care at an affordable cost with a focus on superior customer service.',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        textAlign: TextAlign.justify,
                        textColor: AppColors.color181D3D,
                      ),
                      const CommonSizeBox(height: 14),
                      Row(
                        children: [
                          InkWell(
                            onTap: whatsapp,
                            child: Container(
                              width: getProportionateScreenWidth(110),
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 7,
                              ),
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
                                    child: SvgPicture.asset(AppAssets.whatsapp),
                                  ),
                                  const CommonSizeBox(width: 5),
                                  const InterText(
                                    title: 'Whatsapp',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    textColor: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const CommonSizeBox(width: 13),
                          InkWell(
                            onTap: makePhoneCall,
                            child: Container(
                              width: getProportionateScreenWidth(110),
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 7,
                              ),
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
                                    ),
                                  ),
                                  const CommonSizeBox(width: 14),
                                  const InterText(
                                    title: 'Call',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    textColor: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
    final Uri launchUri = Uri(scheme: 'tel', path: '+88010620');

    try {
      await launchUrl(launchUri);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cant make a call now')));
    }
  }

  Future<void> whatsapp() async {
    const contact = '09666787878';
    const androidUrl =
        'whatsapp://send?phone=$contact&text=Hi, I need some help';
    final iosUrl =
        'https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}';

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp is not installed on the device'),
        ),
      );
    }
  }
}
