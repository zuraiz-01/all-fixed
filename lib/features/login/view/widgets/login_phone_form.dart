import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/dimentions.dart';
import 'package:eye_buddy/features/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';

class LoginPhoneTextField extends StatefulWidget {
  const LoginPhoneTextField({
    super.key,
    required this.phoneNumberController,
    required this.countryCodeController,
  });

  final TextEditingController phoneNumberController;
  final TextEditingController countryCodeController;

  @override
  State<LoginPhoneTextField> createState() => _LoginPhoneTextFieldState();
}

class _LoginPhoneTextFieldState extends State<LoginPhoneTextField> {
  @override
  void initState() {
    super.initState();
    widget.countryCodeController.text = "+880";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: getWidth(context: context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.colorBBBBBB, width: 1.5),
      ),
      padding: EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: AppColors.colorEFEFEF,
            ),
            alignment: Alignment.center,
            height: double.maxFinite,
            // child: InterText(
            //   title: "🇧🇩 +880",
            // ),
            child: CountryCodePicker(
              onChanged: (value) {
                widget.countryCodeController.text = value.dialCode!;
              },
              initialSelection: '+880',
              favorite: ['+880'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              showDropDownButton: true,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(right: 5),
              flagWidth: 16,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.dialCodeColor,
              ),
            ),
          ),
          Expanded(
            child: CustomTextFormField(
              textEditingController: widget.phoneNumberController,
              showBorders: false,
              textInputType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );

    // CustomTextFormField(
    //   textEditingController: phoneNumberController,
    // );

    //  IntlPhoneField(
    //   // initialValue: countryCode,
    //   // initialCountryCode: countryCode,
    //   controller: phoneNumberController,
    //   cursorColor: AppColors.primaryColor,
    //   dropdownTextStyle: interTextStyle,
    //   style: interTextStyle,
    //   dropdownIcon: const Icon(
    //     Icons.keyboard_arrow_down_rounded,
    //     color: AppColors.primaryColor,
    //     size: 20,
    //   ),
    //   validator: (p0) {
    //     return null;

    //     // return InputValidation(p0!.number.toString()).isCorrectPhoneNumber();
    //   },

    //   flagsButtonMargin: const EdgeInsets.only(left: 15),
    //   dropdownIconPosition: IconPosition.trailing,
    //   disableLengthCheck: true,
    //   keyboardType: TextInputType.number,
    //   pickerDialogStyle: PickerDialogStyle(
    //     listTileDivider: const SizedBox(height: 1),
    //     countryCodeStyle: interTextStyle,
    //     countryNameStyle: interTextStyle,
    //     backgroundColor: AppColors.appBackground,
    //     searchFieldCursorColor: AppColors.primaryColor,
    //     searchFieldInputDecoration: InputDecoration(
    //       filled: true,
    //       fillColor: Colors.white,
    //       hintText: 'Search',
    //       hintStyle: interTextStyle.copyWith(
    //         color: AppColors.colorBBBBBB,
    //       ),
    //       contentPadding: const EdgeInsets.symmetric(
    //         horizontal: 10,
    //         // vertical: vPadding,
    //       ),
    //       border: OutlineInputBorder(
    //         borderSide: Divider.createBorderSide(
    //           context,
    //           color: AppColors.colorBBBBBB,
    //           width: 1,
    //         ),
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       enabledBorder: OutlineInputBorder(
    //         borderSide: Divider.createBorderSide(
    //           context,
    //           color: AppColors.colorBBBBBB,
    //           width: 1,
    //         ),
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderSide: Divider.createBorderSide(
    //           context,
    //           color: AppColors.primaryColor,
    //           width: 2,
    //         ),
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //     ),
    //   ),
    //   decoration: InputDecoration(
    //     hintText: 'XXXXXXXXXX',
    //     hintStyle: interTextStyle.copyWith(
    //       color: AppColors.colorBBBBBB,
    //     ),
    //     contentPadding: const EdgeInsets.symmetric(
    //       horizontal: 10,
    //       // vertical: vPadding,
    //     ),
    //     filled: true,
    //     fillColor: Colors.white,
    //     border: OutlineInputBorder(
    //       borderSide: Divider.createBorderSide(
    //         context,
    //         color: AppColors.colorBBBBBB,
    //         width: 1,
    //       ),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderSide: Divider.createBorderSide(
    //         context,
    //         color: AppColors.colorBBBBBB,
    //         width: 1,
    //       ),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderSide: Divider.createBorderSide(
    //         context,
    //         color: AppColors.primaryColor,
    //         width: 2,
    //       ),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   onCountryChanged: (value) {
    //     countryCodeController.text = value.dialCode;
    //   },
    // );
  }
}
