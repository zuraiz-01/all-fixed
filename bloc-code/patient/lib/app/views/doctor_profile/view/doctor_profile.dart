// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/bloc/doctor_profile_cubit/doctor_profile_filter_cubit.dart';
import 'package:eye_buddy/app/bloc/doctor_rating_cubit/doctor_rating_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/extensions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/filter_pages.dart/experience_page.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/filter_pages.dart/feedback_page.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/filter_pages.dart/info_page.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_profile_bottom_bar.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_profile_filter.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctor_statistics_tile.dart';
import 'package:eye_buddy/app/views/doctor_profile/widgets/get_doctors_profile_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfileScreen extends StatelessWidget {
  Doctor? doctorProfile;
  bool isFromFavoriteList;
  DoctorProfileScreen({
    super.key,
    this.doctorProfile,
    this.isFromFavoriteList = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorProfileCubit(),
      child: _DoctorProfileView(
        doctorProfile: doctorProfile,
        isFromFavoriteList: isFromFavoriteList,
      ),
    );
  }
}

class _DoctorProfileView extends StatefulWidget {
  Doctor? doctorProfile;
  bool isFromFavoriteList;
  _DoctorProfileView({
    Key? key,
    this.doctorProfile,
    required this.isFromFavoriteList,
  }) : super(key: key);

  @override
  State<_DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<_DoctorProfileView> {
  List<Widget> doctorsProfileFilterTabs = [];

  @override
  void initState() {
    super.initState();
    if (widget.doctorProfile != null) {
      context
          .read<DoctorProfileCubit>()
          .updateSelectedDoctor(widget.doctorProfile!);
    }
    doctorsProfileFilterTabs = [
      DoctorProfileInfoPage(),
      DoctorProfileExperiencePage(),
      DoctorProfileFeedbackPage(),
    ];
    context
        .read<DoctorRatingCubit>()
        .setDoctorId(widget.doctorProfile?.id ?? "");
    context.read<DoctorRatingCubit>().getDoctorRating();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DoctorProfileCubit, DoctorProfileFilterState>(
      builder: (context, state) {
        Doctor currentDoctor = state.doctor!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: InterText(
              title: l10n.profile,
            ),
            actions: [
              Align(
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: AppColors.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  alignment: Alignment.center,
                  child: InterText(
                    title:
                        capitalizeFirstWord(currentDoctor.availabilityStatus!),
                    fontSize: 14,
                    textColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          bottomNavigationBar: GetDoctorProfileBottomBar(
            doctorProfile: widget.doctorProfile,
          ),
          body: SizedBox(
            // height: getHeight(context: context),
            width: getWidth(context: context),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      GetDoctorsProfile(
                        isFromFavoriteList: widget.isFromFavoriteList,
                        doctor: widget.doctorProfile,
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),
                      const GetDoctorsStatisticsTile(),
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),
                      const DoctorProfileFilter(),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: PageView.builder(
                    controller: state.filterPageController,
                    itemCount: doctorsProfileFilterTabs.length,
                    onPageChanged: (value) {
                      final type = value == 0
                          ? DoctorProfileFilterType.info
                          : value == 1
                              ? DoctorProfileFilterType.experience
                              : DoctorProfileFilterType.feedback;
                      context.read<DoctorProfileCubit>().updateFilterType(type);
                    },
                    itemBuilder: (context, index) =>
                        doctorsProfileFilterTabs[index],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
