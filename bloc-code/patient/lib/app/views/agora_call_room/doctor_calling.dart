import 'dart:developer';

import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/bloc/agora_call_cubit/agora_call_events/agora_call_events_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/handlers/agora_call_socket_handler.dart';
import 'package:eye_buddy/app/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/agora_call_room/agora_call_room_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorCallingView extends StatefulWidget {
  DoctorCallingView({
    super.key,
    required this.name,
    required this.image,
    required this.appointmentId,
  });

  final String name;
  final String? image;
  final String appointmentId;
  @override
  State<DoctorCallingView> createState() => _DoctorCallingViewState();
}

class _DoctorCallingViewState extends State<DoctorCallingView> {
  AudioPlayer? audioPlayer;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSocket();
      audioPlayer?.setAsset(AppAssets.ringtone);
      audioPlayer?.play();
    });
  }

  void initSocket() async {
    AgoraCallSocketHandler().initSocket(
      appintId: widget.appointmentId,
      onJoinedEvent: () {
        if (!mounted) return;
        context.read<AgoraCallEventsCubit>().emitJoinedEvent();
      },
      onRejectedEvent: () {
        if (!mounted) return;
        log("Doctor Rejected Call");
        context.read<AgoraCallEventsCubit>().emitRejectedEvent();
        Navigator.pop(context);
      },
      onEndedEvent: () {
        if (!mounted) return;
        log("Doctor Ending Call");
        showToast(
          message: "Doctor has ended the call.",
          context: context,
        );
        context.read<AgoraCallEventsCubit>().emitEndedEvent();
        AgoraCallSocketHandler().disposeSocket();
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: Colors.white, // Background color of phone screen
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InterText(
                        title: "samee...",
                        fontSize: 16,
                        textColor: Colors.black,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InterText(
                        title: widget.name ?? "BEH - DOCTOR",
                        fontSize: 25,
                        textColor: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(
                      getWidth(context: context) / 2,
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getWidth(context: context) / 2,
                    ),
                    child: Container(
                      height: getWidth(context: context) / 2,
                      width: getWidth(context: context) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          getWidth(context: context) / 2,
                        ),
                      ),
                      child: CommonNetworkImageWidget(
                        imageLink: widget.image != null
                            ? '${ApiConstants.imageBaseUrl}${widget.image}'
                            : '',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.call_end, size: 40, color: Colors.red),
                    //   onPressed: () {
                    //     AgoraCallSocketHandler().emitEndCall(
                    //       appintId: context.read<AgoraCallCubit>().state.channelId,
                    //     );

                    //     AgoraCallSocketHandler().disposeSocket();
                    //     NavigatorServices().pop(context: context);
                    //   },
                    // ),
                    // SizedBox(width: 40),

                    // IconButton(
                    //   icon: Icon(Icons.call, size: 40, color: Colors.green),
                    //   onPressed: () async {
                    //     NavigatorServices().toReplacement(
                    //       context: context,
                    //       widget: AgoraCallScreen(
                    //         prefs: await SharedPreferences.getInstance(),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 25,
              bottom: 23,
              child: InkWell(
                onTap: () {
                  log("CustomTag declined");
                  AgoraCallSocketHandler()
                      .emitRejectCall(appintId: widget.appointmentId);
                  // widget.prefs.setString(criteria, "");
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AppAssets.endCall,
                  width: 100,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  log("widget.appointmentId samee ${widget.appointmentId}");
                  NavigatorServices().toReplacement(
                    context: context,
                    widget: AgoraCallScreen(
                      // prefs: await SharedPreferences.getInstance(),
                      name: widget.name,
                      image: widget.image,
                      appointmentId: widget.appointmentId,
                    ),
                  );
                },
                child: SizedBox(
                  height: 140,
                  child: Align(
                    child: LottieBuilder.asset(
                      AppAssets.acceptCall,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
