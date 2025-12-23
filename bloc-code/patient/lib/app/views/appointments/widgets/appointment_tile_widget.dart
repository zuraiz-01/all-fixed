import 'package:eye_buddy/app/api/model/appointment_doctor_model.dart';
import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_state.dart';
import 'package:eye_buddy/app/bloc/appointment_filter_cubit/appointment_filter_cubit.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/live_support/view/live_support_screen.dart';
import 'package:eye_buddy/app/views/rating_screen/rating_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../utils/functions.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/services/navigator_services.dart';
import '../../doctor_profile/view/doctor_profile.dart';
import '../../waiting_for_doctor/view/waiting_for_doctor_screen.dart';

class AppointmentTileWidget extends StatelessWidget {
  AppointmentTileWidget({
    super.key,
    required this.appointmentType,
    required this.appointmentData,
  });

  AppointmentFilterType appointmentType;
  AppointmentData appointmentData;

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    var formatter = DateFormat('dd MMMM yyyy hh:mm a');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(10),
      ),
      child: Container(
        width: getWidth(context: context),
        height: getProportionateScreenWidth(170),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InterText(
                        title:
                            formatDate((appointmentData.date ?? "").toString()),
                        textColor: AppColors.color888E9D,
                        fontSize: 14,
                      ),
                      Row(
                        children: [
                          InterText(
                            title: appointmentData.totalAmount.toString() +
                                " $getCurrencySymbol",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(40),
                        width: getProportionateScreenHeight(40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: CommonNetworkImageWidget(
                            imageLink:
                                '${ApiConstants.imageBaseUrl}${appointmentData.doctor!.photo}',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: InterText(
                                title: appointmentData.doctor!.name!,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(4),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(
                                            text:
                                                "${appointmentData.id!.trim().toString()}"));
                                        showToast(
                                            message:
                                                "Copied to Clipboard ${appointmentData.id!.trim().toString()}",
                                            context: context);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InterText(
                                            title: l10n.appointment_id,
                                            fontSize: 12,
                                            textColor: AppColors.color888E9D,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          InterText(
                                            title: (getShortAppointmentId(
                                                      appointmentId:
                                                          appointmentData.id,
                                                      wantedLength: 5,
                                                    ) ??
                                                    "NO_ID")
                                                .toUpperCase(),
                                            fontSize: 12,
                                            textColor: Colors.black,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InterText(
                                          title: l10n.duration,
                                          fontSize: 12,
                                          textColor: AppColors.color888E9D,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        InterText(
                                          title:
                                              '${(appointmentData.callDurationInSec ?? 1 / 60).ceilToDouble()} min',
                                          fontSize: 12,
                                          textColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: getWidth(context: context),
              color: AppColors.colorEDEDED,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<AppointmentCubit, AppointmentState>(
                      builder: (context, state) {
                        return state.isAppointmentButtonLoading &&
                                state.appointmentId == appointmentData.id
                            ? SizedBox(
                                width: 100,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  Widget? widget;
                                  switch (appointmentType) {
                                    case AppointmentFilterType.past:
                                      Doctor? doc = await context
                                          .read<AppointmentCubit>()
                                          .getDoctorById(
                                            appointmentId:
                                                appointmentData.id ?? "",
                                            docId: appointmentData.doctor?.id ??
                                                "",
                                          );
                                      if (doc != null) {
                                        NavigatorServices().to(
                                          context: context,
                                          widget: DoctorProfileScreen(
                                            doctorProfile: doc,
                                          ),
                                        );
                                      } else {
                                        showToast(
                                          message:
                                              "404 - Appointment doctor profile not found!",
                                          context: context,
                                        );
                                      }
                                      break;
                                    case AppointmentFilterType.upcoming:
                                      // widget = CreatePatientProfileScreen();
                                      // widget = ReasonForVisitScreen();
                                      // log(appointmentData.doctor!.id!);
                                      // log(context.read<DoctorListCubit>().state.doctorListResponseData!.doctorList![0].id!);
                                      Doctor doctor = Doctor(
                                        name:
                                            appointmentData.doctor?.name ?? "",
                                        photo:
                                            appointmentData.doctor?.photo ?? "",
                                        phone:
                                            appointmentData.doctor?.phone ?? "",
                                      );
                                      widget = WaitingForDoctorScreen(
                                        selectedDoctor: doctor,
                                        patientData: null,
                                        appointmentData: appointmentData,
                                        queueStatus: QueueStatus(
                                          totalQueueCount: appointmentData
                                              .queueStatus?.totalQueueCount,
                                          waitingTimeInMin: appointmentData
                                                  .queueStatus
                                                  ?.waitingTimeInMin ??
                                              0,
                                        ),
                                      );
                                      NavigatorServices()
                                          .to(context: context, widget: widget);
                                      break;
                                    case AppointmentFilterType.followup:
                                      Doctor? doc = await context
                                          .read<AppointmentCubit>()
                                          .getDoctorById(
                                            appointmentId:
                                                appointmentData.id ?? "",
                                            docId: appointmentData.doctor?.id ??
                                                "",
                                          );
                                      if (doc != null) {
                                        NavigatorServices().to(
                                          context: context,
                                          widget: DoctorProfileScreen(
                                            doctorProfile: doc,
                                          ),
                                        );
                                      } else {
                                        showToast(
                                          message:
                                              "404 - Appointment doctor profile not found!",
                                          context: context,
                                        );
                                      }
                                      break;
                                      break;
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: InterText(
                                    title: appointmentType ==
                                            AppointmentFilterType.upcoming
                                        ? l10n.go_to_appointment.toUpperCase()
                                        : l10n.book_again.toUpperCase(),
                                    textColor: AppColors.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                      },
                    ),
                    if (appointmentType == AppointmentFilterType.past)
                      appointmentData.hasRating!
                          ? RatingBar.builder(
                              initialRating:
                                  appointmentData.rating?.rating ?? 0.0,
                              minRating: 1,
                              itemSize: 20,
                              ignoreGestures: true,
                              allowHalfRating: true,
                              updateOnDrag: false,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: print,
                            )
                          : GestureDetector(
                              onTap: () {
                                NavigatorServices().to(
                                  context: context,
                                  widget: RatingScreen(
                                    appointmentId: appointmentData.id ?? "",
                                  ),
                                );
                              },
                              child: InterText(
                                title: l10n.rate_now.toUpperCase(),
                                textColor: AppColors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    if (appointmentType == AppointmentFilterType.upcoming)
                      GestureDetector(
                        onTap: () {
                          NavigatorServices().to(
                              context: context, widget: LiveSupportScreen());
                        },
                        child: InterText(
                          title: l10n.help.toUpperCase(),
                          textColor: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    // if (appointmentType == AppointmentFilterType.followup)
                    //   Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.notifications,
                    //         size: 18,
                    //         color: AppColors.color888E9D,
                    //       ),
                    //       const SizedBox(
                    //         width: 2,
                    //       ),
                    //       InterText(
                    //         title: l10n.notify_me.toUpperCase(),
                    //         textColor: AppColors.color888E9D,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
