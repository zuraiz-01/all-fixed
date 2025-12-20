import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class DummyTermsAndConditionsScreen extends StatelessWidget {
  const DummyTermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: 'Terms & Conditions',
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InterText(
                title: 'Terms & Conditions',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              InterText(
                title: 'Last Updated: December 2024',
                fontSize: 14,
                textColor: AppColors.color888E9D,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(30)),
              _buildSection(
                '1. Acceptance of Terms',
                'By downloading and using EyeBuddy, you agree to these terms and conditions. If you do not agree, please do not use our app.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '2. Services Description',
                'EyeBuddy provides telemedicine services including doctor consultations, eye tests, prescription management, and appointment scheduling through our mobile application.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '3. User Responsibilities',
                '• Provide accurate and complete information\n• Keep your account credentials secure\n• Use the service for legitimate medical purposes\n• Respect healthcare professionals and other users',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '4. Privacy Policy',
                'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '5. Medical Disclaimer',
                'EyeBuddy is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of qualified healthcare providers for medical concerns.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '6. Limitation of Liability',
                'EyeBuddy shall not be liable for any direct, indirect, incidental, or consequential damages arising from your use of our services.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '7. Contact Information',
                'For questions about these terms, please contact us at:\nEmail: support@eyebuddy.app\nPhone: +1-800-EYEBUDDY',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InterText(title: title, fontSize: 16, fontWeight: FontWeight.w600),
        CommonSizeBox(height: getProportionateScreenHeight(8)),
        InterText(
          title: content,
          fontSize: 14,
          textColor: AppColors.color888E9D,
        ),
      ],
    );
  }
}
