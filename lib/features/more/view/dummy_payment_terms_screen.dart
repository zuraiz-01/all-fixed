import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class DummyPaymentTermsScreen extends StatelessWidget {
  const DummyPaymentTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: 'Payment Terms',
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
                title: 'Payment Terms & Conditions',
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
                '1. Payment Methods',
                '• Credit/Debit Cards (Visa, MasterCard, American Express)\n• Digital Wallets (Apple Pay, Google Pay)\n• Bank Transfers\n• Insurance Payments\n• Payment Plans',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '2. Consultation Fees',
                '• Initial Consultation: \$50-\$150\n• Follow-up Consultation: \$30-\$100\n• Emergency Consultation: \$100-\$300\n• Video Consultation: \$40-\$120\n• In-Person Consultation: \$60-\$200',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '3. Payment Timing',
                '• Payment required before consultation start\n• Pre-authorization for estimated costs\n• Final settlement within 24 hours\n• Automatic billing for completed services',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '4. Refund Policy',
                '• Full refund for cancellations 24+ hours before\n• 50% refund for cancellations 2-24 hours before\n• No refund for cancellations less than 2 hours before\n• Full refund for service provider cancellations',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '5. Insurance Coverage',
                '• We accept most major insurance plans\n• Pre-authorization available\n• Co-pays and deductibles apply\n• Direct billing to insurance companies\n• Out-of-network options available',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '6. Payment Security',
                '• PCI-DSS compliant payment processing\n• Encrypted transactions\n• Secure data storage\n• Fraud detection systems\n• Regular security audits',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '7. Disputed Charges',
                '• Contact support within 30 days\n• Provide detailed dispute information\n• Investigation within 5-7 business days\n• Resolution within 14 days\n• Temporary credit during investigation',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '8. Late Payment Fees',
                '• 2% monthly interest on overdue amounts\n• \$25 late payment fee after 30 days\n• Service suspension for accounts 60+ days overdue\n• Collection agency referral after 90 days',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '9. Currency and Taxes',
                '• All prices in USD\n• Applicable taxes added at checkout\n• Currency conversion fees may apply\n• Local tax regulations followed',
              ),
              CommonSizeBox(height: getProportionateScreenHeight(20)),
              _buildSection(
                '10. Contact Information',
                'For payment-related questions:\nEmail: billing@eyebuddy.app\nPhone: +1-800-BILL-EYE\nHours: Monday-Friday, 9AM-6PM EST',
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
