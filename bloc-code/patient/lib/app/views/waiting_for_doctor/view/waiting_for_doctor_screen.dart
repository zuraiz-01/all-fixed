import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:eye_buddy/app/api/model/doctor_list_response_model.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/waiting_for_doctor/view/widgets/doctor_tile.dart';
import 'package:eye_buddy/app/widgets/support_bottom_nav_bar.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../api/model/appointment_doctor_model.dart';
import '../../../api/model/patient_list_model.dart';
import '../../../api/service/api_constants.dart';
import '../../../bloc/agora_call_cubit/agora_call_cubit.dart';
import '../../../bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import '../../../utils/services/navigator_services.dart';
import '../../waiting_for_prescription/prescription_screen.dart';

class WaitingForDoctorScreen extends StatefulWidget {
  WaitingForDoctorScreen({
    super.key,
    required this.patientData,
    required this.selectedDoctor,
    required this.appointmentData,
    required this.queueStatus,
  });
  MyPatient? patientData;
  Doctor selectedDoctor;
  AppointmentData? appointmentData;
  QueueStatus? queueStatus;

  @override
  State<WaitingForDoctorScreen> createState() => _WaitingForDoctorScreenState();
}

class _WaitingForDoctorScreenState extends State<WaitingForDoctorScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ReasonForVisitCubit>().clearState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    // context.read<AgoraCallCubit>().setAgoraChannelIdAndToken(
    //       channelId: widget.appointmentData?.id ?? "",
    //       token: widget.appointmentData?.patientAgoraToken ?? "",
    //     );
    var agoraCubitState = context.read<AgoraCallCubit>().state;
    log(widget.appointmentData.toString());
    log("app id: ${agoraCubitState.appId}");
    log("channel id: ${agoraCubitState.channelId}");
    log("patientToken: ${agoraCubitState.patientToken}");

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
          title: l10n.waiting_for_doctor,
        ),
      ),
      body: SizedBox(
        height: getHeight(context: context),
        width: getWidth(context: context),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        WaitingForDoctorDoctorTile(
                          selectedDoctor: widget.selectedDoctor,
                          patientData: widget.patientData,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: getWidth(context: context),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AppAssets.checkbox,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InterText(
                                title: l10n.congrats,
                                textAlign: TextAlign.center,
                              ),
                              InterText(
                                title: l10n.appointment_booked_successfully,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.selectedDoctor.name,
                                style: interTextStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: l10n.will_call_you_soon,
                                style: interTextStyle.copyWith(
                                  fontSize: 14,
                                  // color: AppColors.primaryColor,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InterText(
                          title:
                              l10n.dont_turn_off_your_internet_doctor_will_call,
                          fontSize: 14,
                          textColor: AppColors.color888E9D,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          width: getWidth(context: context),
                          color: AppColors.color888E9D.withOpacity(.2),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                InterText(
                                  title: l10n.estimated_wait_time,
                                  textColor: AppColors.color888E9D,
                                  fontSize: 14,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                InterText(
                                  title:
                                      '${widget.queueStatus?.waitingTimeInMin ?? 0} Mins',
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                InterText(
                                  title: l10n.patients_before_you,
                                  textColor: AppColors.color888E9D,
                                  fontSize: 14,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 14,
                                  ),
                                  alignment: Alignment.center,
                                  child: InterText(
                                    title:
                                        '${widget.queueStatus?.totalQueueCount ?? 0}',
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: kToolbarHeight,
                        ),
                        // BlocListener<AgoraCallEventsCubit, AgoraCallEventsState>(
                        //   listener: (context, state) {
                        //     if (state is AgoraCallJoinedEvent) {
                        //       showToast(
                        //         message: "User joined",
                        //         context: context,
                        //       );
                        //     } else if (state is AgoraCallRejectedEvent) {
                        //       showToast(
                        //         message: "Call rejected",
                        //         context: context,
                        //       );
                        //     } else if (state is AgoraCallEndedEvent) {
                        //       showToast(
                        //         message: "Call ended",
                        //         context: context,
                        //       );
                        //     }
                        //   },
                        //   child: Column(
                        //     children: [
                        //       CustomButton(
                        //         title: "InitSocket",
                        //         callBackFunction: () {
                        //           AgoraCallSocketHandler().initSocket(
                        //             appintId: widget.appointmentData?.id ?? "NO_APPINT_ID",
                        //             onJoinedEvent: () {
                        //               context.read<AgoraCallEventsCubit>().emitJoinedEvent();
                        //             },
                        //             onRejectedEvent: () {
                        //               context.read<AgoraCallEventsCubit>().emitRejectedEvent();
                        //             },
                        //             onEndedEvent: () {
                        //               context.read<AgoraCallEventsCubit>().emitEndedEvent();
                        //             },
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "EmitRejectCall",
                        //         callBackFunction: () {
                        //           AgoraCallSocketHandler().emitRejectCall(
                        //             appintId: widget.appointmentData?.id ?? "NO_APPINT_ID",
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "EmitJoinCall",
                        //         callBackFunction: () {
                        //           AgoraCallSocketHandler().emitJoinCall(
                        //             appintId: widget.appointmentData?.id ?? "NO_APPINT_ID",
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "EmitEndCall",
                        //         callBackFunction: () {
                        //           AgoraCallSocketHandler().emitEndCall(
                        //             appintId: widget.appointmentData?.id ?? "NO_APPINT_ID",
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "DisposeSocket",
                        //         callBackFunction: () {
                        //           AgoraCallSocketHandler().disposeSocket();
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "WaitingForPrescription",
                        //         callBackFunction: () {
                        //           NavigatorServices().to(
                        //             context: context,
                        //             widget: WaitingForPrescriptionScreen(),
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "Rating Screen",
                        //         callBackFunction: () {
                        //           NavigatorServices().to(
                        //             context: context,
                        //             widget: RatingScreen(),
                        //           );
                        //         },
                        //       ),
                        //       SizedBox(
                        //         height: 6,
                        //       ),
                        //       CustomButton(
                        //         title: "Prescription Screen",
                        //         callBackFunction: () {
                        //           NavigatorServices().to(
                        //             context: context,
                        //             widget: PrescriptionScreen(
                        //               payload: {
                        //                 "id": widget.appointmentData?.id ?? "",
                        //                 "diagnosis": [
                        //                   "Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus."
                        //                 ],
                        //                 "note": [
                        //                   "Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus."
                        //                 ],
                        //                 "investigations": [
                        //                   "Praesent dapibus neque id cursus faucibus tortor neque egestas auguae eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi tincidunt quis accumsan porttitor facilisis luctus metus."
                        //                 ],
                        //                 "medicines": [
                        //                   {
                        //                     "name": "Med 1",
                        //                     "note": "Med notes",
                        //                   }
                        //                 ],
                        //                 "surgery": [
                        //                   "EL",
                        //                 ],
                        //                 "followUpDate": formatDate(DateTime.now().toString()),
                        //                 "referredTo": "Mr Brian",
                        //                 // "note": "This is note"
                        //               },
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SupportBottomNavBar()
          ],
        ),
      ),
    );
  }
}
