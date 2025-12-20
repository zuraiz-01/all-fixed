import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class DummyPrivacyPolicyScreen extends StatelessWidget {
  const DummyPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: 'Privacy Policy',
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
                title: 'Privacy Policy',
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
                '1. Information We Collect',
                '• Personal information (name, email, phone number)\n• Medical information and health records\n• Device information and usage data\n• Location data (with your consent)\n• Payment information',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '2. How We Use Your Information',
                '• Provide and improve our services\n• Schedule appointments and consultations\n• Process payments and insurance claims\n• Send important notifications\n• Conduct research and analytics',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '3. Information Sharing',
                'We only share your information with:\n• Healthcare providers involved in your care\n• Payment processors for transactions\n• Legal authorities when required by law\n• Third-party service providers with your consent',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '4. Data Security',
                'We implement industry-standard security measures including:\n• Encryption of sensitive data\n• Secure servers and databases\n• Regular security audits\n• Employee training on privacy practices',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '5. Your Rights',
                'You have the right to:\n• Access your personal information\n• Correct inaccurate information\n• Delete your account and data\n• Opt-out of marketing communications\n• Request a copy of your data',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '6. Cookies and Tracking',
                'We use cookies and similar technologies to:\n• Remember your preferences\n• Analyze app usage\n• Provide personalized experiences\n• Improve our services',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '7. Children\'s Privacy',
                'Our services are not intended for children under 18. We do not knowingly collect personal information from children under 18.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '8. Changes to This Policy',
                'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '9. Contact Information',
                'For privacy-related questions, please contact us at:\nEmail: privacy@eyebuddy.app\nPhone: +1-800-EYEBUDDY\nAddress: 123 Medical Plaza, Suite 100, Health City, HC 12345',
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
