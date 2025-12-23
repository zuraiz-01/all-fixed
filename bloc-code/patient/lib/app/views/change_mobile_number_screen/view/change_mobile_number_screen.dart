import 'package:eye_buddy/app/bloc/change_phone_number_cubit/change_phone_number_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/services/navigator_services.dart';
import '../../login_flow/otp_screen.dart';

class ChangeMobileNumberScreen extends StatelessWidget {
  const ChangeMobileNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePhoneNumberCubit(),
      child: _ChangeMobileNumberView(),
    );
  }
}

class _ChangeMobileNumberView extends StatefulWidget {
  _ChangeMobileNumberView();

  @override
  State<_ChangeMobileNumberView> createState() =>
      _ChangeMobileNumberViewState();
}

class _ChangeMobileNumberViewState extends State<_ChangeMobileNumberView> {
  TextEditingController currentMobileNumberController = TextEditingController();

  TextEditingController newMobileNumberController = TextEditingController();

  TextEditingController confirmMobileNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    var profileCubit = context.read<ProfileCubit>().state;
    currentMobileNumberController.text =
        profileCubit.profileResponseModel!.profile!.phone!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    var profileCubit = context.read<ProfileCubit>().state;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.change_mobile_number,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocListener<ChangePhoneNumberCubit, ChangePhoneNumberState>(
        listener: (context, state) {
          if (state.isSuccess != "") {
            showToast(
              message: state.message,
              context: context,
            );
            if (state.isSuccess == "success") {
              NavigatorServices().toReplacement(
                context: context,
                widget: OtpScreen(
                  phoneNumber:
                      profileCubit.profileResponseModel!.profile!.dialCode! +
                          confirmMobileNumberController.text,
                  isForChangePhoneNumber: true,
                ),
              );
            }
            context.read<ChangePhoneNumberCubit>().resetState();
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(12),
                    ),
                    InterText(
                      title: l10n.current_mobile_number,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    CustomTextFormField(
                      textEditingController: currentMobileNumberController,
                      isEnabled: false,
                      textInputType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(16),
                    ),
                    InterText(
                      title: l10n.new_mobile_number,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    CustomTextFormField(
                      textEditingController: newMobileNumberController,
                      hint: l10n.enter_new_mobile_number,
                      maxLength: 11,
                      textInputType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(16),
                    ),
                    InterText(
                      title: l10n.confirm_mobile_number,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    CustomTextFormField(
                      textEditingController: confirmMobileNumberController,
                      hint: l10n.confirm_new_mobile_number,
                      maxLength: 11,
                      textInputType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(22),
                    ),
                    CustomButton(
                      title: l10n.change_mobile_number,
                      callBackFunction: () {
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => const BottomNavBarScreen(),
                        //   ),
                        // );
                        if (newMobileNumberController.text.isEmpty ||
                            currentMobileNumberController.text.isEmpty ||
                            confirmMobileNumberController.text.isEmpty) {
                          showToast(
                            message: "Please complete the form and try again!",
                            context: context,
                          );
                        } else if (newMobileNumberController.text !=
                            confirmMobileNumberController.text) {
                          showToast(
                            message: "Given phone numbers are not same.",
                            context: context,
                          );
                        } else if (!isPhoneNoValid(confirmMobileNumberController
                            .text
                            .trim()
                            .toString())) {
                          showToast(
                            message: "Given phone numbers is not valid.",
                            context: context,
                          );
                        } else {
                          Map<String, dynamic> param = {
                            "currentDialCode": profileCubit
                                .profileResponseModel!.profile!.dialCode,
                            "dialCode": profileCubit
                                .profileResponseModel!.profile!.dialCode,
                            "currentPhone": currentMobileNumberController.text,
                            "phone": confirmMobileNumberController.text,
                          };
                          context
                              .read<ChangePhoneNumberCubit>()
                              .changePhoneNumber(param);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<ChangePhoneNumberCubit, ChangePhoneNumberState>(
              builder: (context, state) {
                return state.isLoading
                    ? CustomLoadingScreen()
                    : SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNo);
  }
}
