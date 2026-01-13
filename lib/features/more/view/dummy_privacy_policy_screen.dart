import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/core/services/utils/assets/app_assets.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DummyPrivacyPolicyScreen extends StatelessWidget {
  const DummyPrivacyPolicyScreen({super.key});

  static const double _cardRadius = 14;

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
              _buildHeader(),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                'Privacy Policy - BEH Teleophthalmology',
                'Effective Date: 17 August 2025\nLast Updated: 17 August 2025\n\nBEH Teleophthalmology ("BEH", "we," "our," or "us") operates two applications:\nBEH Patient App - for patients to book tele-consultations, upload eye images, share health information, and receive prescriptions.\nBEH Doctor App - for licensed ophthalmologists to provide tele-consultations, review patient information, and receive payments for services.\n\nWe are committed to protecting the privacy and security of your personal, medical, and financial information. This Privacy Policy explains how we collect, use, disclose, and safeguard your data when you use our services.',
                icon: Icons.policy_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '1. Information We Collect',
                'From Patients (via BEH Patient App):\n- Personal Identification: Name, phone number, email, gender, age, and contact details.\n- Medical Information: Eye images, diagnostic results, consultation history, prescriptions, and symptoms you provide.\n- Payment Information: Transaction details when you pay for tele-consultations (processed by secure third-party payment providers).\n\nFrom Doctors (via BEH Doctor App):\n- Professional Information: Name, registration number, specialty, qualifications, and contact details.\n- Consultation Data: Prescriptions created, consultation notes, and reviews of patient information.\n- Financial Information: Bank account details for secure withdrawal of consultation earnings.\n\nAutomatically Collected Data:\n- Device type, operating system, IP address.\n- App usage logs, crash reports, session activity.\n- Cookies or tracking tools (for performance and security).',
                icon: Icons.inventory_2_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '2. How We Use Your Information',
                'We use information for:\n- Enabling patients to choose doctors, upload images, and receive tele-consultations.\n- Allowing doctors to review patient data, provide consultations, and issue prescriptions.\n- Processing payments and withdrawals securely.\n- Maintaining medical records for continuity of care.\n- Meeting legal, ethical, and regulatory obligations.\n- Improving our apps\' functionality, safety, and user experience.',
                icon: Icons.assignment_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '3. How We Store and Protect Data',
                'All sensitive data is encrypted in transit and at rest.\nMedical records are securely stored in compliance with healthcare data standards.\nPayment processing is handled by trusted third-party providers; BEH never stores full payment card details.\nDoctor bank account details are encrypted and used only for payouts.\nAccess to sensitive data is strictly limited to authorized personnel.',
                icon: Icons.lock_outline,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '4. Sharing of Information',
                'We never sell or rent your data. Information may only be shared:\n- With your consent (e.g., when patients choose to share data with a doctor).\n- With secure service providers (e.g., cloud hosting, payment gateways) under confidentiality agreements.\n- To comply with laws, court orders, or government requests.\n- To protect safety, prevent fraud, or ensure secure operation of the Apps.',
                icon: Icons.share_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '5. Data Retention',
                'Patient records are retained for as long as required by medical regulations.\nDoctor payout and transaction records are retained for financial compliance.\nUsers may request deletion of accounts (subject to retention laws).',
                icon: Icons.storage_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '6. Your Rights',
                'You may have rights under applicable data protection laws, including:\n- Accessing your data.\n- Correcting inaccurate information.\n- Requesting deletion of personal data.\n- Withdrawing consent to processing (where applicable).\n- Filing a complaint with your local data authority.',
                icon: Icons.fact_check_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '7. Children\'s Privacy',
                'BEH Patient is intended for adults (18+) or minors under parental/guardian supervision. We do not knowingly collect data from children without consent.',
                icon: Icons.family_restroom_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '8. Security Commitment',
                'We apply strict technical, administrative, and physical safeguards to protect your data. However, no system is completely secure. Users are advised to keep login credentials confidential.',
                icon: Icons.shield_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '9. Updates to this Privacy Policy',
                'We may update this Privacy Policy from time to time. Updates will be reflected in the Apps with the revised date. Continued use of the Apps after updates means you accept the new terms.',
                icon: Icons.update_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '10. Contact Us',
                'For questions, concerns, or data requests, please contact:\nBEH Teleophthalmology - Privacy Office\n78, Satmasjid Road (West of Road 27), Dhanmondi, Dhaka-1209\nPhone: 10620, 09666787878\nEmail: info@bdeyehospital.com\nWeb: dhanmondi.bdeyehospital.com',
                icon: Icons.contact_mail_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenHeight(16),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white,
            AppColors.appBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.color888E9D.withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.appBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  AppAssets.privacyAndPolicy,
                  color: AppColors.primaryColor,
                ),
              ),
              CommonSizeBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InterText(
                      title: 'Privacy Policy',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.primaryColor,
                    ),
                    CommonSizeBox(height: getProportionateScreenHeight(6)),
                    InterText(
                      title: 'BEH Teleophthalmology',
                      fontSize: 14,
                      textColor: AppColors.color888E9D,
                    ),
                  ],
                ),
              ),
            ],
          ),
          CommonSizeBox(height: getProportionateScreenHeight(12)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
                CommonSizeBox(width: getProportionateScreenWidth(6)),
                InterText(
                  title: 'Effective Date: 17 August 2025',
                  fontSize: 12,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
          CommonSizeBox(height: getProportionateScreenHeight(6)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update_outlined,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
                CommonSizeBox(width: getProportionateScreenWidth(6)),
                InterText(
                  title: 'Last Updated: 17 August 2025',
                  fontSize: 12,
                  textColor: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String content, {
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.color888E9D.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.45),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_cardRadius),
                  bottomLeft: Radius.circular(_cardRadius),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(16),
                  vertical: getProportionateScreenHeight(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.appBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            size: 16,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        CommonSizeBox(width: getProportionateScreenWidth(10)),
                        Expanded(
                          child: InterText(
                            title: title,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CommonSizeBox(height: getProportionateScreenHeight(8)),
                    InterText(
                      title: content,
                      fontSize: 14,
                      textColor: AppColors.color888E9D,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
