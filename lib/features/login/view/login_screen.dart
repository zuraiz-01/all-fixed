import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/core/services/utils/services/navigator_services.dart';
import 'package:eye_buddy/features/global_widgets/filled_button.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/global_widgets/language_chip.dart';
import 'package:eye_buddy/features/global_widgets/toast.dart';
import 'package:eye_buddy/features/global_widgets/custom_loader.dart';
import 'package:eye_buddy/features/login/controller/login_controller.dart';
import 'package:eye_buddy/features/login/view/otp_screen.dart';
import 'package:eye_buddy/features/login/view/widgets/login_phone_form.dart';
import 'package:eye_buddy/features/login/view/widgets/login_terms_and_condition_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  final bool showBackButton;
  LoginScreen({super.key, required this.showBackButton});

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [LanguageChip(), const SizedBox(width: 20)],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InterText(
                      title: l10n.enterYourMobileNumber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    LoginPhoneTextField(
                      phoneNumberController: phoneNumberController,
                      countryCodeController: countryCodeController,
                    ),
                    SizedBox(height: getProportionateScreenHeight(15)),

                    // CONTINUE BUTTON — no Obx needed
                    GetFilledButton(
                      title: l10n.continueNext.toUpperCase(),
                      callBackFunction: () async {
                        if (phoneNumberController.text.isEmpty) {
                          showToast(
                            message:
                                l10n.please_enter_a_phone_number_and_try_again,
                            context: context,
                          );
                          return;
                        }

                        await loginController.loginUser(
                          phone: phoneNumberController.text,
                          dialCode: countryCodeController.text,
                          context: context,
                        );

                        final loginData = loginController.loginData.value;
                        if (loginData != null) {
                          final fullPhoneNumber =
                              countryCodeController.text +
                              phoneNumberController.text;
                          final traceId = loginData.traceId;

                          if (traceId == null || traceId.isEmpty) {
                            showToast(
                              message: "TraceId missing",
                              context: context,
                            );
                            return;
                          }

                          NavigatorServices().to(
                            context: context,
                            widget: OtpScreen(
                              phoneNumber: fullPhoneNumber,
                              traceId: traceId,
                            ),
                          );

                          loginController.resetState();
                        }
                      },
                    ),

                    SizedBox(height: getProportionateScreenHeight(15)),
                    LoginTermsAndConditionsWidget(),
                  ],
                ),
              ),
            ),
          ),

          // LOADER — wrap only loader in Obx
          Obx(() {
            return loginController.isLoading.value
                ? const CustomLoadingScreen()
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
