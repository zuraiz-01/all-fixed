// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';

import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/create_patient_profile/view/create_appointment_overview_screen.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/add_eye_photo_button.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/attach_reports_and_prescription_tile_button.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/eye_image_widget.dart';
import 'package:eye_buddy/app/views/create_patient_profile/widgets/patient_tile.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../utils/functions.dart';
import '../../global_widgets/custom_button.dart';
import '../../shemmer/card_skelton_screen.dart';

class ReasonForVisitScreen extends StatelessWidget {
  ReasonForVisitScreen({
    super.key,
    required this.patientData,
    required this.selectedDoctor,
  });

  MyPatient patientData;
  Doctor selectedDoctor;

  @override
  Widget build(BuildContext context) {
    return _ReasonForVisitView(
      patientData: patientData,
      selectedDoctor: selectedDoctor,
    );
  }
}

class _ReasonForVisitView extends StatefulWidget {
  _ReasonForVisitView(
      {Key? key, required this.patientData, required this.selectedDoctor})
      : super(key: key);
  MyPatient patientData;
  Doctor selectedDoctor;

  @override
  State<_ReasonForVisitView> createState() => _ReasonForVisitViewState();
}

class _ReasonForVisitViewState extends State<_ReasonForVisitView> {
  TextEditingController ageController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController reasonController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ageController.text = widget.patientData.dateOfBirth == null
        ? ""
        : getYearsOld(widget.patientData.dateOfBirth!);
    weightController.text =
        widget.patientData.weight == null ? "" : widget.patientData.weight!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.black,
          onPressed: () {
            context.read<ReasonForVisitCubit>().clearState();
            Navigator.pop(context);
          },
        ),
        title: InterText(
          title: l10n.reason_for_visit,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: CustomButton(
          title: l10n.proceedNext,
          callBackFunction: () async {
            var resonForVisitAssetCubit = context.read<ReasonForVisitCubit>();
            if (ageController.text.isEmpty) {
              showToast(
                message: "Please enter the age and try again!",
                context: context,
              );
              return;
            }
            if (weightController.text.isEmpty) {
              showToast(
                message: "Please enter the weight and try again!",
                context: context,
              );
              return;
            }
            if (descriptionController.text.isEmpty
                // ||
                // resonForVisitAssetCubit.state.eyePhotoList.isEmpty
                ) {
              showToast(
                message: "Please enter the problem description and try again!",
                context: context,
              );
              return;
            }
            context.read<ReasonForVisitCubit>().saveAppointment({
              "appointmentType": "regular",
              "patient": widget.patientData.id,
              "doctor": widget.selectedDoctor.id,
              "age": ageController.text,
              "weight": weightController.text,
              "reason": reasonController.text,
              "description": descriptionController.text,
              "locationGenre":
                  await getCountryID() == "Bangladesh" ? "local" : "foreigner",
            });
            // List<Map<String, dynamic>> eyePhotos = [];
            // for(int i=0; i<resonForVisitAssetCubit.state.eyePhotoList.length; i++){
            //   eyePhotos.add(
            //     {
            //       "base64String" : conert
            //     }
            //   )
            // }

            // NavigatorServices().to(
            //   context: context,
            //   widget: const ReasonForVisitOverviewScreen(),
            // );
          },
        ),
      ),
      body: BlocListener<ReasonForVisitCubit, ReasonForVisitState>(
        listener: (context, state) {
          if (state is ReasonForVisitSuccessState) {
            // showToast(message: state.toastMessage, context: context);
            // context.read<ReasonForVisitCubit>().resetState();
            context.read<AppointmentCubit>().getAppointments();
            NavigatorServices().toReplacement(
              context: context,
              widget: CreateAppointmentOverviewScreen(
                patientData: widget.patientData,
                selectedDoctor: widget.selectedDoctor,
                appointment: state.selectedAppointment!,
              ),
            );
          } else if (state is ReasonForVisitErrorState) {
            context.read<ReasonForVisitCubit>().resetState();
            showToast(message: state.errorMessage, context: context);
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: getHeight(context: context),
              width: getWidth(context: context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          PatientTile(
                            patientData: widget.patientData,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InterText(
                                      title: 'Age',
                                      fontSize: 11,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      textEditingController: ageController,
                                      textInputType: TextInputType.number,
                                      containsSuffix: true,
                                      sufffixOnTapFunction: () {},
                                      suffixSvgPath: AppAssets.years,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InterText(
                                      title: 'Weight',
                                      fontSize: 11,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      textEditingController: weightController,
                                      textInputType: TextInputType.number,
                                      containsSuffix: true,
                                      sufffixOnTapFunction: () {},
                                      suffixSvgPath: AppAssets.kgSmall,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InterText(
                            title: 'Appointment Reason (Optional)',
                            fontSize: 11,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            textEditingController: reasonController,
                          ),
                          // PopupMenuButton(
                          //   offset: const Offset(
                          //     1,
                          //     0,
                          //   ),
                          //   position: PopupMenuPosition.under,
                          //   itemBuilder: (context) => [
                          //     PopupMenuItem(
                          //       value: 1,
                          //       onTap: () {},
                          //       child: InterText(
                          //         title: 'Male',
                          //         textColor: Colors.black,
                          //         fontSize: 11,
                          //       ),
                          //     ),
                          //     PopupMenuItem(
                          //       value: 1,
                          //       onTap: () {},
                          //       child: InterText(
                          //         title: 'Female',
                          //         textColor: Colors.black,
                          //         fontSize: 11,
                          //       ),
                          //     ),
                          //   ],
                          //   child: CustomTextFormField(
                          //     textEditingController: TextEditingController()..text = 'Select your reason',
                          //     sufffixOnTapFunction: () {},
                          //     suffixSvgPath: AppAssets.arrowDown,
                          //     isEnabled: false,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InterText(
                                title: 'Attach your eye photo',
                                fontSize: 11,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Gap(4),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InterText(
                                                      title: "Example Images",
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: AppColors.black,
                                                      ))
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Image.asset(
                                                      AppAssets.eye_example_one,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Image.asset(
                                                      AppAssets.eye_example_two,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Image.asset(
                                                      AppAssets
                                                          .eye_example_three,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CustomButton(
                                                title: "Close",
                                                callBackFunction: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: InterText(
                                  title: 'See example',
                                  fontSize: 11,
                                  textColor: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const _GetAttachYourEyePhotoList(),
                          AddEyePhotoButton(
                            callBackFunction: () async {
                              context
                                  .read<ReasonForVisitCubit>()
                                  .selectImage(context);
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          InterText(
                            title: 'Describe the problem',
                            fontSize: 11,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            textEditingController: descriptionController,
                            hint: "Describe the problem you're facing...",
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InterText(
                            title:
                                'Attach reports & previous Prescriptions (Optional)',
                            fontSize: 11,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const AttachReportsAndPreviousPrescriptionsDottedBorderTileButton(),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          // EyeImageWidget(
                          //   position: 1,
                          //   onDeleteButtonPressed: () {},
                          // ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
                            builder: (context, state) {
                              return SizedBox(
                                height: 90,
                                child: Row(
                                  children: [
                                    ListView.builder(
                                      itemCount: state
                                          .reportAndPrescriptionList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Align(
                                            child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                ),
                                                color: Colors.black,
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Container(
                                                      height: 110,
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          110,
                                                        ),
                                                      ),
                                                      child: state
                                                              .reportAndPrescriptionList[
                                                                  index]
                                                              .path
                                                              .endsWith("pdf")
                                                          ? Icon(
                                                              Icons.description,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Image.file(
                                                              File(state
                                                                  .reportAndPrescriptionList[
                                                                      index]
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 6,
                                                    right: 6,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<
                                                                ReasonForVisitCubit>()
                                                            .deletePatientPrescriptionFile(
                                                              position: index,
                                                            );
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: Colors.white,
                                                        ),
                                                        child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                        // EyeImageWidget(
                                        //   image: state.eyePhotoList[index],
                                        //   position: index,
                                        //   onDeleteButtonPressed: (int position) {
                                        //     context.read<ReasonForVisitCubit>().deleteEyePhoto(
                                        //           position: position,
                                        //         );
                                        //   },
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     context.read<ReasonForVisitCubit>().selectPrescriptionFile();
                          //   },
                          //   child: Align(
                          //     child: Container(
                          //       height: 90,
                          //       width: 90,
                          //       decoration: BoxDecoration(
                          //         color: AppColors.colorEFEFEF,
                          //         borderRadius: BorderRadius.circular(8),
                          //         border: Border.all(
                          //           color: AppColors.colorBBBBBB,
                          //         ),
                          //       ),
                          //       child: Align(
                          //         child: SizedBox(
                          //           height: 45,
                          //           width: 45,
                          //           child: SvgPicture.asset(
                          //             AppAssets.addMoreWithEye,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
              builder: (context, state) {
                return state.isLoading ? NewsCardSkelton() : SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _GetAttachYourEyePhotoList extends StatelessWidget {
  const _GetAttachYourEyePhotoList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: Row(
            children: [
              ListView.builder(
                itemCount: state.eyePhotoList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return EyeImageWidget(
                    image: state.eyePhotoList[index],
                    position: index,
                    onDeleteButtonPressed: (int position) {
                      context.read<ReasonForVisitCubit>().deleteEyePhoto(
                            position: position,
                          );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
