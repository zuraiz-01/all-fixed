import 'dart:convert';

import 'package:eye_buddy/app/bloc/edit_prescription/edit_prescription_cubit.dart';
import 'package:eye_buddy/app/bloc/edit_prescription/edit_prescription_state.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/upload_prescription_or_clinical_image_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPrescriptionScreen extends StatelessWidget {
  String screenName;
  bool isFromTestResultScreen;
  bool isFromPrescriptionScreen;
  String? prescriptionId;
  String? title;

  EditPrescriptionScreen(
      {required this.screenName,
      this.isFromTestResultScreen = false,
      this.isFromPrescriptionScreen = false,
      required this.prescriptionId,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadPrescriptionOrClinicalImageCubit(),
      child: _EditPrescriptionScreen(
        screenName: screenName,
        isFromTestResultScreen: isFromTestResultScreen,
        isFromPrescriptionScreen: isFromPrescriptionScreen,
        prescriptionId: prescriptionId,
        title: title,
      ),
    );
  }
}

class _EditPrescriptionScreen extends StatefulWidget {
  String screenName;
  bool isFromTestResultScreen;
  bool isFromPrescriptionScreen;
  String? prescriptionId;
  String? title;

  _EditPrescriptionScreen(
      {required this.screenName,
      required this.isFromTestResultScreen,
      required this.isFromPrescriptionScreen,
      required this.prescriptionId,
      required this.title});

  @override
  State<_EditPrescriptionScreen> createState() => _EditPrescriptionScreenState();
}

class _EditPrescriptionScreenState extends State<_EditPrescriptionScreen> {
  TextEditingController titleController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title!;
  }

  @override
  Widget build(BuildContext buildContext) {
    SizeConfig().init(buildContext);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      bottomNavigationBar: BlocBuilder<EditPrescriptionCubit, EditPrescriptionState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              bottom: getProportionateScreenWidth(20),
            ),
            child: state.isLoading
                ? SizedBox(
                    height: kToolbarHeight * 1.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 1.5,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        InterText(
                          title: localLanguage.loading,
                          textColor: AppColors.primaryColor,
                        )
                      ],
                    ),
                  )
                : CustomButton(
                    title: localLanguage.save,
                    callBackFunction: () async {
                      if (titleController.text.trim().isEmpty) {
                        showToast(message: "Please give title", context: context, backgroundColor: AppColors.colorF14F4A);
                      } else {
                        var json = {
                          "id": "${widget.prescriptionId}",
                          "title": "${titleController.text}",
                        };

                        if (widget.isFromTestResultScreen) {
                          context.read<EditPrescriptionCubit>().updateClinicalPrescription(jsonEncode(json), context);
                        } else if (widget.isFromPrescriptionScreen) {
                          context.read<EditPrescriptionCubit>().updatePatientPrescriptionUpdate(jsonEncode(json), context);
                        }
                      }
                    },
                  ),
          );
        },
      ),
      appBar: CommonAppBar(
        title: widget.screenName,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocConsumer<EditPrescriptionCubit, EditPrescriptionState>(
        listener: (context, state) {
          if (state is UpdatePrescriptionSuccessful) {
            showToast(message: state.toastMessage, context: context);
            titleController.text = "";
            Navigator.pop(context);
          } else if (state is UpdatePrescriptionFailed) {
            showToast(message: state.errorMessage, context: context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(8),
                ),
                InterText(
                  title: widget.isFromTestResultScreen ? localLanguage.title : localLanguage.prescription_title,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.color001B0D,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(8),
                ),
                CustomTextFormField(
                  textEditingController: titleController,
                  hint: localLanguage.title,
                  sufffixOnTapFunction: () {},
                  suffixSvgPath: "",
                  textInputType: TextInputType.text,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
