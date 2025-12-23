import 'dart:io';

import 'package:eye_buddy/app/api/model/profile_reponse_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_state.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

bool isValidEmail(String email) {
  // Define a regular expression for a basic email validation
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Use the RegExp's hasMatch method to check if the email matches the pattern
  return emailRegex.hasMatch(email);
}

class EditProfileScreen extends StatefulWidget {
  Profile? profile;

  EditProfileScreen({required this.profile, super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController(text: '');

  TextEditingController dobController = TextEditingController(text: '');

  TextEditingController weightController = TextEditingController(text: '');

  TextEditingController genderController = TextEditingController(text: 'Male');

  TextEditingController emailController = TextEditingController(text: '');

  final String _dropDownValue = 'Male';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfileData(widget.profile);
  }

  setProfileData(Profile? profile) {
    nameController.text = profile!.name!;
    dobController.text = formatDateDDMMMMYYYY(profile.dateOfBirth!.toString());
    weightController.text = profile.weight!;
    genderController.text = profile.gender!;
    emailController.text = profile.email!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.editProfile,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(20),
              bottom: getProportionateScreenWidth(12),
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
                          title: l10n.loading,
                          textColor: AppColors.primaryColor,
                        )
                      ],
                    ),
                  )
                : CustomButton(
                    title: l10n.save,
                    callBackFunction: () {
                      if (emailController.text.isEmpty
                          ? true
                          : isValidEmail(emailController.text)) {
                        Map<String, dynamic> parameters =
                            Map<String, dynamic>();
                        parameters["name"] = nameController.text;
                        parameters["dateOfBirth"] = dobController.text;
                        parameters["weight"] = weightController.text;
                        parameters["gender"] = genderController.text;
                        parameters["email"] = emailController.text;

                        context
                            .read<ProfileCubit>()
                            .uploadProfileDataWithImage(parameters);
                      } else {
                        showToast(
                          message: "Invalid email address",
                          context: context,
                        );
                      }
                    },
                  ),
          );
        },
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailed) {
            showToast(
              message: state.errorMessage,
              context: context,
            );
            context.read<ProfileCubit>().resetState();
          } else if (state is ProfileSuccessful) {
            showToast(
              message: state.toastMessage,
              context: context,
            );
            context.read<ProfileCubit>().resetState();
            NavigatorServices().pop(context: context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonSizeBox(
                    height: getProportionateScreenHeight(12),
                  ),
                  SizedBox(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(100),
                          width: getProportionateScreenHeight(100),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: state.selectedProfileImage.path != ''
                                ? state.selectedProfileImage.path == ""
                                    ? SizedBox(
                                        height:
                                            getProportionateScreenHeight(100),
                                        width:
                                            getProportionateScreenHeight(100),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CommonNetworkImageWidget(
                                            imageLink:
                                                '${ApiConstants.imageBaseUrl}${state.profileResponseModel!.profile!.photo}',
                                            boxFit: BoxFit.cover,
                                          ),
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
                                        child: Image.file(
                                          File(state.selectedProfileImage.path
                                              .toString()),
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                : Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        110,
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
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              context.read<ProfileCubit>().selectImage(context);
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
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(16),
                  ),
                  InterText(
                    title: l10n.full_name,
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
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
                    title: l10n.date_of_birth,
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(8),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
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
                    title: l10n.weight,
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
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
                    height: getProportionateScreenHeight(16),
                  ),
                  InterText(
                    title: l10n.gender,
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
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
                    height: getProportionateScreenHeight(16),
                  ),
                  InterText(
                    title: '${l10n.email} (Optional)',
                    fontSize: 14,
                    textColor: AppColors.color888E9D,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(8),
                  ),
                  CustomTextFormField(
                    textEditingController: emailController,
                  ),
                  CommonSizeBox(
                    height: getProportionateScreenHeight(31),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
