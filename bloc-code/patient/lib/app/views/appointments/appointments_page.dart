import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_state.dart';
import 'package:eye_buddy/app/bloc/appointment_filter_cubit/appointment_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/appointments/widgets/appointment_filter.dart';
import 'package:eye_buddy/app/views/appointments/widgets/appointment_tile_widget.dart';
import 'package:eye_buddy/app/views/appointments/widgets/appointment_user_menu.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shemmer/card_skelton_screen.dart';

class AppointmentsPage extends StatefulWidget {
  AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var state = context.read<AppointmentFilterCubit>().state;

    // switch (state.appointmentType) {
    //   case AppointmentFilterType.past:
    //     state.appointmentPageController.jumpToPage(0);
    //     break;
    //   case AppointmentFilterType.upcoming:
    //     state.appointmentPageController.jumpToPage(1);

    //     break;
    //   case AppointmentFilterType.followup:
    //     state.appointmentPageController.jumpToPage(2);

    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;

    List<Widget> appointmentPages = [
      BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state.getPastAppointmentApiResponse == null ||
              state.getPastAppointmentApiResponse!.appointmentList!
                      .appointmentData!.length ==
                  0) {
            return NoDataFoundWidget(
              title: localLanguage.you_dont_have_any_past_appointments,
            );
          }
          return ListView.builder(
            itemCount: state.getPastAppointmentApiResponse!.appointmentList!
                .appointmentData!.length,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AppointmentTileWidget(
                appointmentType: AppointmentFilterType.past,
                appointmentData: state.getPastAppointmentApiResponse!
                    .appointmentList!.appointmentData![index],
              );
            },
          );
        },
      ),
      BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state.getUpcomingAppointmentApiResponse == null ||
              state.getUpcomingAppointmentApiResponse!.appointmentList!
                      .appointmentData!.length ==
                  0) {
            return NoDataFoundWidget(
              title: localLanguage.you_dont_have_any_upcoming_appointments,
            );
          }
          return ListView.builder(
            itemCount: state.getUpcomingAppointmentApiResponse!.appointmentList!
                .appointmentData!.length,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AppointmentTileWidget(
                appointmentType: AppointmentFilterType.upcoming,
                appointmentData: state.getUpcomingAppointmentApiResponse!
                    .appointmentList!.appointmentData![index],
              );
            },
          );
        },
      ),
      BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state.getFollowupAppointmentApiResponse == null ||
              state.getFollowupAppointmentApiResponse!.appointmentList!
                      .appointmentData!.length ==
                  0) {
            return NoDataFoundWidget(
              title: localLanguage.you_dont_have_any_follow_up_appointments,
            );
          }
          return ListView.builder(
            itemCount: state.getFollowupAppointmentApiResponse!.appointmentList!
                .appointmentData!.length,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return AppointmentTileWidget(
                appointmentType: AppointmentFilterType.followup,
                appointmentData: state.getFollowupAppointmentApiResponse!
                    .appointmentList!.appointmentData![index],
              );
            },
          );
        },
      ),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      backgroundColor: AppColors.appBackground,
      body: RefreshIndicator(
        onRefresh: context.read<AppointmentCubit>().refreshScreen,
        child: SizedBox(
          child: Stack(
            children: [
              SizedBox(
                height: getHeight(context: context),
                width: getWidth(context: context),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: kToolbarHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InterText(
                                  fontSize: 20,
                                  title: localLanguage.appointments,
                                  fontWeight: FontWeight.bold,
                                ),
                                const AppointmentUserMenu(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          const AppointmentsFilter(),
                          SizedBox(
                            height: getProportionateScreenHeight(12),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AppointmentFilterCubit, AppointmentFilterState>(
                      builder: (context, state) {
                        return Expanded(
                            child: state.appointmentType ==
                                    AppointmentFilterType.past
                                ? appointmentPages[0]
                                : state.appointmentType ==
                                        AppointmentFilterType.upcoming
                                    ? appointmentPages[1]
                                    : appointmentPages[2]);
                      },
                    )
                  ],
                ),
              ),
              BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  return state.isLoading
                      ? NewsCardSkelton()
                      : SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
