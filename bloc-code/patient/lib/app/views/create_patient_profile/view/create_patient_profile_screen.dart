import 'dart:io';

import 'package:eye_buddy/app/api/model/patient_list_model.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreatePatientProfileScreen extends StatelessWidget {
  CreatePatientProfileScreen({
    super.key,
    required this.isCreateNewPatientProfile,
  });
  bool isCreateNewPatientProfile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReasonForVisitCubit(),
      child: _CreatePatientProfileScreen(
        isCreateNewPatientProfile: isCreateNewPatientProfile,
      ),
    );
  }
}

class _CreatePatientProfileScreen extends StatefulWidget {
  _CreatePatientProfileScreen({
    required this.isCreateNewPatientProfile,
  });
  bool isCreateNewPatientProfile;

  @override
  State<_CreatePatientProfileScreen> createState() => _CreatePatientProfileScreenState();
}

class _CreatePatientProfileScreenState extends State<_CreatePatientProfileScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController relationWithYouController = TextEditingController();

  final String _dropDownValue = 'Male';

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    var formatter = DateFormat('dd MMMM yyyy hh:mm a');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PatientListCubit>().state.selectedProfile = XFile("");
    if (!widget.isCreateNewPatientProfile) {
      var profileCubit = context.read<ProfileCubit>().state;
      nameController.text = profileCubit.profileResponseModel!.profile!.name!;
      dobController.text = DateFormat('MM/dd/yyyy').format(DateTime.parse(profileCubit.profileResponseModel!.profile!.dateOfBirth!)).toString();

      weightController.text = profileCubit.profileResponseModel!.profile!.weight!;
      genderController.text = profileCubit.profileResponseModel!.profile!.gender!;
      genderController.text = profileCubit.profileResponseModel!.profile!.gender!;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.createPatientProfile,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: CustomButton(
          title: l10n.proceedNext,
          callBackFunction: () {
            String name = nameController.text;
            String dob = dobController.text;
            String weight = weightController.text;
            String gender = genderController.text.toString();
            String relation = relationWithYouController.text;
            if (name.isEmpty || dob.isEmpty || weight.isEmpty || gender.isEmpty || relation.isEmpty) {
              showToast(
                message: "Please fill up the form and try again",
                context: context,
              );
              return;
            }
            MyPatient myPatient = MyPatient(
              name: name,
              dateOfBirth: dob,
              weight: weight,
              gender: gender.toLowerCase(),
              relation: relation,
            );
            context.read<PatientListCubit>().saveMyPatient(
                  myPatient: myPatient,
                );
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(
            //     builder: (context) => const ReasonForVisitScreen(),
            //   ),
            // );
          },
        ),
      ),
      body: BlocListener<PatientListCubit, PatientListState>(
        listener: (context, state) {
          if (widget.isCreateNewPatientProfile && state is PatientListFetchedSuccessfully) {
            showToast(
              message: "Patient added!",
              context: context,
            );
            NavigatorServices().pop(context: context);
          } else if (state is PatientListFetchFailed) {
            showToast(
              message: state.errorMessage,
              context: context,
            );
            context.read<PatientListCubit>().resetState();
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonSizeBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    BlocBuilder<PatientListCubit, PatientListState>(
                      builder: (context, state) {
                        return SizedBox(
                          child: Stack(
                            children: [
                              state.selectedProfile.path == ""
                                  ? Container(
                                      height: getProportionateScreenHeight(100),
                                      width: getProportionateScreenHeight(100),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : Container(
                                      height: 110,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          110,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          110,
                                        ),
                                        child: Image.file(
                                          File(state.selectedProfile.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<PatientListCubit>().selectProfileImage(context);
                                  },
                                  child: Container(
                                    height: getProportionateScreenHeight(30),
                                    width: getProportionateScreenWidth(30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.colorCCE7D9,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: SvgPicture.asset(
                                        AppAssets.upload,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenHeight(23),
                    ),
                    InterText(
                      title: 'Full name',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    CustomTextFormField(
                      textEditingController: nameController,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(16),
                    ),
                    InterText(
                      title: 'Date of Birth',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final currentDate = DateTime.now();
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: currentDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          dobController.text = DateFormat('MM/dd/yyyy').format(selectedDate).toString();
                        } else {
                          dobController.text = DateFormat('MM/dd/yyyy').format(currentDate).toString();
                        }
                      },
                      child: CustomTextFormField(
                        textEditingController: dobController,
                        sufffixOnTapFunction: () {},
                        suffixSvgPath: AppAssets.calender,
                        isEnabled: false,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(16),
                    ),
                    InterText(
                      title: 'Weight',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    CustomTextFormField(
                      textEditingController: weightController,
                      sufffixOnTapFunction: () {},
                      suffixSvgPath: AppAssets.kg,
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                    InterText(
                      title: 'Gender',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    PopupMenuButton(
                      offset: const Offset(
                        1,
                        0,
                      ),
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            genderController.text = "Male";
                          },
                          child: InterText(
                            title: 'Male',
                            textColor: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            genderController.text = "Female";
                          },
                          child: InterText(
                            title: 'Female',
                            textColor: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      child: CustomTextFormField(
                        textEditingController: genderController,
                        sufffixOnTapFunction: () {},
                        suffixSvgPath: AppAssets.arrowDown,
                        isEnabled: false,
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    InterText(
                      title: 'Relation with you',
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    PopupMenuButton(
                      offset: const Offset(
                        1,
                        0,
                      ),
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            relationWithYouController.text = "Mother";
                          },
                          child: InterText(
                            title: 'Mother',
                            textColor: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            relationWithYouController.text = "Father";
                          },
                          child: InterText(
                            title: 'Father',
                            textColor: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            relationWithYouController.text = "Brother";
                          },
                          child: InterText(
                            title: 'Brother',
                            textColor: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            relationWithYouController.text = "Sister";
                          },
                          child: InterText(
                            title: 'Sister',
                            textColor: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          onTap: () {
                            relationWithYouController.text = "Other";
                          },
                          child: InterText(
                            title: 'Other',
                            textColor: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      child: CustomTextFormField(
                        textEditingController: relationWithYouController,
                        sufffixOnTapFunction: () {},
                        suffixSvgPath: AppAssets.arrowDown,
                        isEnabled: false,
                      ),
                    ),
                    // CommonSizeBox(
                    //   height: getProportionateScreenHeight(20),
                    // ),
                    // InterText(
                    //   title: 'Attach reports & previous Prescriptions (optional)',
                    //   fontSize: 12,
                    // ),
                    // SizedBox(
                    //   height: getProportionateScreenHeight(8),
                    // ),
                    // const AttachReportsAndPreviousPrescriptionsDottedBorderTileButton(),
                    // CommonSizeBox(
                    //   height: getProportionateScreenHeight(20),
                    // ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       const _GetPatientPrescriptionPhotoList(),
                    //       AddEyePhotoButton(
                    //         callBackFunction: () async {
                    //           context.read<ReasonForVisitCubit>().selectImage(context);
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    CommonSizeBox(
                      height: getProportionateScreenHeight(60),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<PatientListCubit, PatientListState>(
              builder: (context, state) {
                return state.isLoading ? CustomLoadingScreen() : SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}

class _GetPatientPrescriptionPhotoList extends StatelessWidget {
  const _GetPatientPrescriptionPhotoList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReasonForVisitCubit, ReasonForVisitState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: Row(
            children: [
              // ListView.builder(
              //   itemCount: state.reportAndPrescriptionList.length,
              //   scrollDirection: Axis.horizontal,
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return EyeImageWidget(
              //       image: state.reportAndPrescriptionList[index],
              //       position: index,
              //       onDeleteButtonPressed: (int position) {
              //         // context.read<ReasonForVisitCubit>().deletePatientPrescriptionPhoto(
              //         //       position: position,
              //         //     );
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
