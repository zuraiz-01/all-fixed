import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eye_buddy/app/bloc/network_block/network_bloc.dart';
import 'package:eye_buddy/app/bloc/network_block/network_state.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/upload_prescription_or_clinical_image_cubit.dart';
import 'package:eye_buddy/app/bloc/upload_prescription_or_clinical_image/upload_prescription_or_clinical_image_state.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_internet_connection_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/upload_prescription_or_clinical_data/widget/type_dropdown_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UploadPrescriptionOrClinicalDataScreen extends StatelessWidget {
  String screenName;
  bool isFromTestResultScreen;
  bool isFromPrescriptionScreen;

  UploadPrescriptionOrClinicalDataScreen(
      {required this.screenName,
      this.isFromTestResultScreen = false,
      this.isFromPrescriptionScreen = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadPrescriptionOrClinicalImageCubit(),
      child: _UploadPrescriptionOrClinicalDataScreen(
        screenName: screenName,
        isFromTestResultScreen: isFromTestResultScreen,
        isFromPrescriptionScreen: isFromPrescriptionScreen,
      ),
    );
  }
}

class _UploadPrescriptionOrClinicalDataScreen extends StatefulWidget {
  String screenName;
  bool isFromTestResultScreen;
  bool isFromPrescriptionScreen;

  _UploadPrescriptionOrClinicalDataScreen(
      {required this.screenName,
      required this.isFromTestResultScreen,
      required this.isFromPrescriptionScreen});

  @override
  State<_UploadPrescriptionOrClinicalDataScreen> createState() =>
      _UploadPrescriptionOrClinicalDataScreenState();
}

class _UploadPrescriptionOrClinicalDataScreenState
    extends State<_UploadPrescriptionOrClinicalDataScreen> {
  TextEditingController titleController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    SizeConfig().init(buildContext);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      bottomNavigationBar: BlocBuilder<UploadPrescriptionOrClinicalImageCubit,
          UploadPrescriptionOrClinicalImageState>(
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
                        showToast(
                            message: localLanguage.please_give_title,
                            context: context,
                            backgroundColor: AppColors.colorF14F4A);
                      } else if (state.selectedProfileImage.path.isEmpty) {
                        showToast(
                            message: localLanguage.please_select_a_prescription,
                            context: context,
                            backgroundColor: AppColors.colorF14F4A);
                      } else if (state.selectedPatient == null) {
                        showToast(
                            message: localLanguage.please_select_your_patient,
                            context: context,
                            backgroundColor: AppColors.colorF14F4A);
                      } else {
                        if (widget.isFromTestResultScreen) {
                          var json = {
                            "patient": "${state.selectedPatient!.id}",
                            "title": "${titleController.text}",
                            // "type": "clinical",
                            "attachment": {
                              "base64String":
                                  "${await context.read<UploadPrescriptionOrClinicalImageCubit>().xFileToBase64(
                                        state.selectedProfileImage,
                                      )}",
                              "fileExtension": ".jpg",
                            },
                          };
                          context
                              .read<UploadPrescriptionOrClinicalImageCubit>()
                              .uploadPatientClinicalResult(
                                  jsonEncode(json), context);
                        } else if (widget.isFromPrescriptionScreen) {
                          var json = {
                            "patient": "${state.selectedPatient!.id}",
                            "title": "${titleController.text}",
                            "attachment": {
                              "base64String":
                                  "${await context.read<UploadPrescriptionOrClinicalImageCubit>().xFileToBase64(
                                        state.selectedProfileImage,
                                      )}",
                              "fileExtension": ".jpg",
                            },
                          };
                          context
                              .read<UploadPrescriptionOrClinicalImageCubit>()
                              .uploadPatientPrescription(
                                  jsonEncode(json), context);
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
      body: Builder(builder: (context) {
        var networkState = context.watch<NetworkBloc>().state;

        if (networkState is NetworkFailure) {
          return const NoInterConnectionWidget();
        } else if (networkState is NetworkSuccess) {
          return BlocConsumer<UploadPrescriptionOrClinicalImageCubit,
              UploadPrescriptionOrClinicalImageState>(
            listener: (context, state) {
              if (state is UploadPrescriptionOrClinicalImageSuccessful) {
                showToast(message: state.toastMessage, context: context);
                titleController.text = "";
                Navigator.pop(context);
              } else if (state is UploadPrescriptionOrClinicalImageFailed) {
                showToast(message: state.errorMessage, context: context);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserTypeDropdownWidget(),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    InterText(
                      title: widget.isFromTestResultScreen
                          ? localLanguage.title
                          : localLanguage.prescription_title,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9\s]*$'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(18),
                    ),
                    InterText(
                      title: widget.isFromPrescriptionScreen
                          ? localLanguage.prescription
                          : localLanguage.clinical_results,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.color001B0D,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    state.selectedProfileImage.path != ""
                        ? Container(
                            margin: EdgeInsets.only(bottom: 8),
                            height: getProportionateScreenHeight(150),
                            width: getProportionateScreenHeight(150),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(state.selectedProfileImage.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () {
                        context
                            .read<UploadPrescriptionOrClinicalImageCubit>()
                            .selectImage(context);
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: AppColors.color888E9D,
                        radius: const Radius.circular(5),
                        padding: const EdgeInsets.all(1),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenHeight(18),
                              vertical: getProportionateScreenWidth(13),
                            ),
                            color: AppColors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InterText(
                                        title: localLanguage
                                            .upload_reports_and_previous_prescriptions,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.black,
                                      ),
                                      CommonSizeBox(
                                        height: getProportionateScreenHeight(5),
                                      ),
                                      InterText(
                                        title: localLanguage
                                            .format_will_be_jpg_png_pdf,
                                        fontSize: 12,
                                        textColor: AppColors.color777777,
                                      ),
                                      CommonSizeBox(
                                        height: getProportionateScreenHeight(3),
                                      ),
                                      InterText(
                                        title:
                                            '* ${localLanguage.max_attachments} 10',
                                        fontSize: 12,
                                        textColor: AppColors.color777777,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: getProportionateScreenWidth(45),
                                  width: getProportionateScreenWidth(45),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      AppAssets.upload,
                                      color: AppColors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
