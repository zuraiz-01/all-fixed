import 'dart:io';

import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_state.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_text_field.dart';
import 'package:eye_buddy/app/views/global_widgets/filled_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../bottom_nav_bar_screen/bottom_nav_bar_screen.dart';

class SaveUserDataScreen extends StatefulWidget {
  SaveUserDataScreen({super.key});

  @override
  State<SaveUserDataScreen> createState() => _SaveUserDataScreenState();
}

class _SaveUserDataScreenState extends State<SaveUserDataScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController weightController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  final String _dropDownValue = 'Male';

  @override
  void initState() {
    super.initState();
    genderController.text = "Male";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      backgroundColor: AppColors.appBackground,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailed) {
            showToast(
              message: state.errorMessage,
              context: context,
            );
            context.read<ProfileCubit>().resetState();
          } else if (state is ProfileSuccessful) {
            context.read<ProfileCubit>().resetState();
            NavigatorServices().toReplacement(
              context: context,
              widget: BottomNavBarScreen(),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: getHeight(context: context),
                width: getWidth(context: context),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: kToolbarHeight,
                      ),
                      InterText(
                        title: 'Please enter\nyour information',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(110),
                        width: getProportionateScreenHeight(110),
                        child: Stack(
                          children: [
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenHeight(110),
                                  ),
                                  child: state.selectedProfileImage.path == ''
                                      ? Container(
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
                                            File(state
                                                .selectedProfileImage.path),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProfileCubit>()
                                      .selectImage(context);
                                },
                                child: Container(
                                  height: getProportionateScreenHeight(35),
                                  width: getProportionateScreenHeight(35),
                                  decoration: BoxDecoration(
                                    color: AppColors.colorCCE7D9,
                                    borderRadius: BorderRadius.circular(
                                      getProportionateScreenHeight(35),
                                    ),
                                  ),
                                  child: Align(
                                    child: SizedBox(
                                      height: getProportionateScreenHeight(20),
                                      width: getProportionateScreenHeight(20),
                                      child: SvgPicture.asset(
                                        AppAssets.upload,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      InterText(
                        title: 'Full name',
                        fontSize: 11,
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
                        fontSize: 11,
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
                            dobController.text = DateFormat('MM/dd/yyyy')
                                .format(selectedDate)
                                .toString();
                          } else {
                            dobController.text = DateFormat('MM/dd/yyyy')
                                .format(currentDate)
                                .toString();
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
                        fontSize: 11,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(8),
                      ),
                      CustomTextFormField(
                        textEditingController: weightController,
                        sufffixOnTapFunction: () {},
                        suffixSvgPath: AppAssets.kg,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),
                      InterText(
                        title: 'Gender',
                        fontSize: 11,
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
                        height: getProportionateScreenHeight(40),
                      ),
                      GetFilledButton(
                        title: 'Save & Continue'.toUpperCase(),
                        callBackFunction: () async {
                          if (nameController.text.isEmpty ||
                                  dobController.text.isEmpty ||
                                  weightController.text.isEmpty ||
                                  genderController.text.isEmpty
                              // || state.selectedProfileImage.path == ""
                              ) {
                            showToast(
                              message: "Enter the fields and try again!",
                              context: context,
                            );
                            return;
                          } else {
                            Map<String, dynamic> parameters =
                                Map<String, dynamic>();
                            parameters["name"] = nameController.text;
                            parameters["dateOfBirth"] = dobController.text;
                            parameters["weight"] = weightController.text;
                            parameters["gender"] = genderController.text;

                            await context
                                .read<ProfileCubit>()
                                .uploadProfileDataWithImage(parameters);
                            // context.read<ProfileCubit>().resetState();
                          }
                        },
                      ),
                      // SizedBox(
                      //   height: getProportionateScreenHeight(10),
                      // ),
                      // GetFilledButton(
                      //   title: 'Skip'.toUpperCase(),
                      //   callBackFunction: () {},
                      //   transparentBackground: true,
                      // ),
                    ],
                  ),
                ),
              ),
              state.isLoading ? CustomLoadingScreen() : SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
