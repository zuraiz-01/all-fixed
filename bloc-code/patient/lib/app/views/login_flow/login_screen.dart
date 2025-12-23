// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:eye_buddy/app/bloc/login_cubit/login_cubit.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/filled_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/language_chip.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/login_flow/otp_screen.dart';
import 'package:eye_buddy/app/views/login_flow/widgets/login_phone_form.dart';
import 'package:eye_buddy/app/views/login_flow/widgets/login_terms_and_condition_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
    required this.showBackButton,
  });
  bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return _LoginView(showBackButton: showBackButton);
  }
}

class _LoginView extends StatelessWidget {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  bool showBackButton;
  _LoginView({
    Key? key,
    required this.showBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SizeConfig().init(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          showToast(
            message: state.errorMessage,
            context: context,
          );
          context.read<LoginCubit>().resetState();
        } else if (state is LoginSuccessful) {
          showToast(
            message: state.toastMessage,
            context: context,
          );
          NavigatorServices().to(
            context: context,
            widget: OtpScreen(
              phoneNumber: countryCodeController.text + phoneNumberController.text,
            ),
          );
          context.read<LoginCubit>().resetState();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : SizedBox.shrink(),
            actions: const [
              LanguageChip(),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: getHeight(context: context),
                width: getWidth(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InterText(
                      title: l10n.enterYourMobileNumber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    LoginPhoneTextField(
                      phoneNumberController: phoneNumberController,
                      countryCodeController: countryCodeController,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    GetFilledButton(
                      title: l10n.continueNext.toUpperCase(),
                      callBackFunction: () {
                        if (phoneNumberController.text.isEmpty) {
                          showToast(
                            message: l10n.please_enter_a_phone_number_and_try_again,
                            context: context,
                          );
                        } else {
                          log(phoneNumberController.text);
                          log(countryCodeController.text);
                          context.read<LoginCubit>().loginUser(
                                phone: phoneNumberController.text,
                                dialCode: '${countryCodeController.text}',
                                context: context,
                              );
                        }
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    LoginTermsAndConditionsWidget(),
                  ],
                ),
              ),
              if (state.isLoading) CustomLoadingScreen()
            ],
          ),
        );
      },
    );
  }
}
