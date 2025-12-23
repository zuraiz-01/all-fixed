import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/widgets/support_bottom_nav_bar.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/assets/app_assets.dart';
import '../global_widgets/custom_button.dart';

class WaitingForPrescriptionScreen extends StatefulWidget {
  WaitingForPrescriptionScreen({
    super.key,
  });

  @override
  State<WaitingForPrescriptionScreen> createState() => _WaitingForDoctorScreenState();
}

class _WaitingForDoctorScreenState extends State<WaitingForPrescriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: InterText(
          title: "Waiting for Prescription",
        ),
      ),
      body: SizedBox(
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          child: LottieBuilder.asset(
                            AppAssets.onlineDoctor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InterText(
                          title: "Please wait! Doctor will send the prescription very soon",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InterText(
                          title:
                              "You can leave from this screen. Prescription will show Under All Prescriptions. Thanks for being with us. We wish for your good health.",
                          fontSize: 14,
                          textColor: AppColors.color888E9D,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          title: "Go Back",
                          callBackFunction: () {
                            NavigatorServices().pop(context: context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SupportBottomNavBar()
          ],
        ),
      ),
    );
  }
}
