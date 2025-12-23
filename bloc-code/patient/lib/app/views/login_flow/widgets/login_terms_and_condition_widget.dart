import 'dart:developer';

import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginTermsAndConditionsWidget extends StatelessWidget {
  LoginTermsAndConditionsWidget({super.key});

  final _termsConditionRecognizer = TapGestureRecognizer()
    ..onTap = () {
      log('Terms and condition tapped');
    };
  final _privacyPolicyRecognizer = TapGestureRecognizer()
    ..onTap = () {
      log('Provacy Policy tapped');
    };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RichText(
      text: TextSpan(
        style: interTextStyle.copyWith(
          color: AppColors.color888E9D,
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text: l10n.byTappingContinueYouAgreeTo,
          ),
          TextSpan(
            text: l10n.termsAndConditions,
            style: interTextStyle.copyWith(
              color: AppColors.color008541,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            recognizer: _termsConditionRecognizer,
          ),
          TextSpan(
            text: l10n.and,
          ),
          TextSpan(
            recognizer: _privacyPolicyRecognizer,
            text: l10n.privacyPolicy,
            style: interTextStyle.copyWith(
              color: AppColors.color008541,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: l10n.ofBangladeshEyeHospital,
          )
        ],
      ),
    );
  }
}
