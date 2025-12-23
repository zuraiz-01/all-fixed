// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:eye_buddy/app/api/repo/api_repo.dart';
import 'package:eye_buddy/app/bloc/login_cubit/login_cubit.dart';
import 'package:eye_buddy/app/bloc/verify_otp_cubit/verify_otp_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/login_flow/save_user_data_screen.dart';
import 'package:eye_buddy/app/views/login_flow/widgets/login_otp_pin_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({
    super.key,
    required this.phoneNumber,
    this.isForChangePhoneNumber = false,
  });

  String phoneNumber;
  bool isForChangePhoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpCubit(),
      child: _OtpView(
        phoneNumber: phoneNumber,
        isForChangePhoneNumber: isForChangePhoneNumber,
      ),
    );
  }
}

class _OtpView extends StatefulWidget {
  String phoneNumber;
  bool isForChangePhoneNumber;
  _OtpView({
    Key? key,
    required this.phoneNumber,
    required this.isForChangePhoneNumber,
  }) : super(key: key);

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  TextEditingController otpCodeController = TextEditingController();

  late Timer _timer;

  int _start = 300;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 1) {
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final _resendOTPRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        if (_start == 0) {
          await ApiRepo().resendOtp(
            traceId: context.read<LoginCubit>().state.traceId,
          );
          showToast(
            message: l10n.an_SMS_with_OTP_has_been_sent_to,
            context: context,
          );
        } else {
          showToast(
            message: "Please wait for ${formattedTime(timeInSecond: _start)} sec",
            context: context,
          );
        }
      };

    SizeConfig().init(context);
    return BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpFailed) {
          showToast(
            message: state.errorMessage,
            context: context,
          );
          context.read<VerifyOtpCubit>().resetState();
        } else if (state is VerifyOtpSuccessful) {
          showToast(
            message: widget.isForChangePhoneNumber ? "Phone number successfully changed" : state.toastMessage,
            context: context,
          );
          NavigatorServices().toPushAndRemoveUntil(
            context: context,
            widget: state.isNewUser ? SaveUserDataScreen() : BottomNavBarScreen(),
          );
          context.read<VerifyOtpCubit>().resetState();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.colorFFFFFF,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: InterText(
              title: l10n.verify_it_s_you,
            ),
          ),
          backgroundColor: AppColors.appBackground,
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
                  children: [
                    SvgPicture.asset(
                      AppAssets.otpLock,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    InterText(
                      title: l10n.an_SMS_with_OTP_has_been_sent_to,
                      textColor: AppColors.color888E9D,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    InterText(
                      title: widget.phoneNumber,
                      textColor: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                    LoginOtpPinCodeWidget(otpCodeController: otpCodeController),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.resend_OTP,
                            style: interTextStyle.copyWith(
                              color: AppColors.color888E9D,
                            ),
                          ),
                          TextSpan(
                            text: ' ${l10n.resend} (${formattedTime(timeInSecond: _start)})',
                            recognizer: _resendOTPRecognizer,
                            style: interTextStyle.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    CustomButton(
                      title: l10n.verify,
                      callBackFunction: () {
                        
                        if(otpCodeController.text.toString().trim().isEmpty){
                          showToast(message: l10n.please_give_your_otp, context: context);
                        } else{
                          if (widget.isForChangePhoneNumber) {}
                          context.read<VerifyOtpCubit>().verifyOtp(
                            otpCode: otpCodeController.text,
                            isForChangePhoneNumber: widget.isForChangePhoneNumber,
                          );
                        }
                        
                       
                      },
                    )
                  ],
                ),
              ),
              if (state.isLoading)
                Container(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  color: Colors.white,
                  child: const CustomLoader(),
                )
            ],
          ),
        );
      },
    );
  }
}
