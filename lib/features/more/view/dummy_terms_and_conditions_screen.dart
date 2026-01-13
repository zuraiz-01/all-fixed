import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/core/services/utils/assets/app_assets.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DummyTermsAndConditionsScreen extends StatelessWidget {
  const DummyTermsAndConditionsScreen({super.key});

  static const double _cardRadius = 14;

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
              _buildHeader(),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                'Terms & Conditions - BEH Teleophthalmology',
                'Effective Date: 17 August 2025\n\nThese Terms & Conditions ("Terms") govern your use of the BEH Teleophthalmology mobile applications, including the BEH Patient App and BEH Doctor App (together, the "Apps"). By accessing or using our Apps, you agree to these Terms. If you do not agree, please do not use the Apps.',
                icon: Icons.description_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '1. Definitions',
                'Patient - a registered user of the BEH Patient App who books consultations.\nDoctor - a registered and licensed medical professional using the BEH Doctor App to provide consultations.\nServices - tele-consultations, prescription generation, and related features offered through the Apps.\nBEH - Bangladesh Eye Hospital & Institute, operator of the BEH Teleophthalmology platform.',
                icon: Icons.menu_book_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '2. Eligibility',
                'Patients must be at least 18 years old or have parental/guardian supervision.\nDoctors must be licensed ophthalmologists or qualified specialists with verified credentials.\nBy using the Apps, you confirm that you meet these eligibility criteria.',
                icon: Icons.verified_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '3. Use of Services',
                'For Patients:\n- You may select a doctor, upload eye images and medical details, pay consultation fees, and receive prescriptions.\n- You are responsible for ensuring the accuracy of medical information provided.\n\nFor Doctors:\n- You may review patient data, conduct consultations, and issue prescriptions.\n- You are responsible for the accuracy of diagnoses, treatment advice, and prescriptions provided.\n- You may add bank account details to receive earnings securely.',
                icon: Icons.medical_services_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '4. Payments',
                'Patients agree to pay consultation fees as displayed in the App.\nPayments are processed via secure third-party payment providers.\nBEH deducts applicable platform/processing fees before disbursing payments to doctors.\nDoctors are responsible for any tax obligations arising from earnings.',
                icon: Icons.payments_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '5. Medical Disclaimer',
                'BEH Teleophthalmology provides a digital platform only and is not a medical provider itself.\nDoctors are independent professionals responsible for the advice and prescriptions they provide.\nTele-consultations may not replace physical examinations. Patients should seek in-person care if symptoms worsen or in case of emergencies.',
                icon: Icons.local_hospital_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '6. User Responsibilities',
                'Users must keep login credentials secure and confidential.\nUsers must not misuse the Apps for unlawful or fraudulent activity.\nDoctors must provide care consistent with professional medical standards.\nPatients must follow prescribed treatments responsibly and inform doctors of all relevant health history.',
                icon: Icons.rule_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '7. Data Privacy',
                'All data use is governed by our Privacy Policy (last updated 17 August 2025).\nPatients consent to share medical data with selected doctors for consultation purposes.\nDoctors consent to provide professional details for verification and payment.',
                icon: Icons.privacy_tip_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '8. Limitations of Liability',
                'BEH is not liable for medical outcomes, treatment errors, or misdiagnosis by doctors.\nBEH is not liable for payment disputes between patients and doctors beyond transaction facilitation.\nBEH is not responsible for technical failures caused by internet providers, mobile devices, or external services.',
                icon: Icons.warning_amber_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '9. Termination of Accounts',
                'BEH may suspend or terminate accounts that violate these Terms, including fraudulent activity, misuse, or unprofessional conduct.\nUsers may request account closure at any time (subject to legal/medical record retention requirements).',
                icon: Icons.block_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '10. Modifications to Services',
                'BEH reserves the right to update, suspend, or discontinue features or services without prior notice.',
                icon: Icons.update_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '11. Governing Law & Disputes',
                'These Terms are governed by the laws of Bangladesh.\nAny disputes shall be subject to the jurisdiction of courts in Dhaka, Bangladesh.',
                icon: Icons.gavel_outlined,
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '12. Contact Us',
                'For questions about these Terms, please contact:\nBEH Teleophthalmology - Legal Office\n78, Satmasjid Road (West of Road 27), Dhanmondi, Dhaka-1209\nPhone: 10620, 09666787878\nEmail: info@bdeyehospital.com\nWeb: dhanmondi.bdeyehospital.com',
                icon: Icons.contact_phone_outlined,
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
                  AppAssets.termsAndConditions,
                  color: AppColors.primaryColor,
                ),
              ),
              CommonSizeBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InterText(
                      title: 'Terms & Conditions',
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
