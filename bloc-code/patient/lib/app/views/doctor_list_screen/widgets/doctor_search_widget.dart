import 'package:eye_buddy/app/bloc/doctor_list/doctor_list_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/widgets/doctor_filter_bottom_sheet.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class DoctorSearchWidget extends StatelessWidget {
  DoctorSearchWidget({
    super.key,
  });

  void openBottomSheet(BuildContext context) {
    String enteredText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DoctorFilterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    // TextEditingController doctorSearchController = TextEditingController(text: '');

    return Container(
      color: AppColors.white,
      height: kToolbarHeight + 20,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    child: SvgPicture.asset(
                      AppAssets.search,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        //focusNode: focus,
                        onChanged: (searchText) {
                          if (searchText.length > 2) {
                            Map<String, String> parameters = Map<String, String>();
                            parameters["query"] = "${searchText}";
                            // parameters["page"] = "${context.read<DoctorListCubit>().state.pageNo}";
                            context.read<DoctorListCubit>().resetState();
                            context.read<DoctorListCubit>().getSearchDoctorList(parameters, isFromSearch: true);
                          } else {
                            context.read<DoctorListCubit>().resetState();
                            context.read<DoctorListCubit>().getSearchDoctorList({}, isFromSearch: true);
                          }
                        },
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        // controller: doctorSearchController,
                        style: interTextStyle,
                        maxLines: 1,
                        cursorColor: AppColors.primaryColor,
                        enabled: true,
                        decoration: InputDecoration(
                          hintText: l10n.search_doctor,
                          hintStyle: interTextStyle.copyWith(
                            color: AppColors.colorBBBBBB,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            // vertical: vPadding,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(
                              context,
                              color: Colors.transparent,
                              width: 0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context, color: Colors.transparent, width: 10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(
                              context,
                              color: Colors.transparent,
                              width: 0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: AppColors.colorEDEDED,
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  GestureDetector(
                    onTap: () {
                      openBottomSheet(context);
                    },
                    child: SvgPicture.asset(
                      AppAssets.filter,
                      height: getProportionateScreenWidth(20),
                      width: getProportionateScreenWidth(20),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }
}
