// import 'package:agora_uikit/agora_uikit.dart';
import 'dart:developer';

import 'package:eye_buddy/app/bloc/agora_call_cubit/agora_call_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/waiting_for_prescription/waiting_for_prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../api/service/api_constants.dart';
import '../../bloc/agora_call_cubit/agora_call_events/agora_call_events_cubit.dart';
import '../../utils/handlers/agora_call_socket_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraCallScreen extends StatelessWidget {
  AgoraCallScreen({
    super.key,
    required this.name,
    required this.image,
    required this.appointmentId,
  });
  final String name;
  final String? image;
  final String appointmentId;

  @override
  Widget build(BuildContext context) {
    return _AgoraCallRoomView(
      name: name,
      image: image,
      appointmentId: appointmentId,
    );
  }
}

class _AgoraCallRoomView extends StatefulWidget {
  _AgoraCallRoomView({
    required this.name,
    required this.image,
    required this.appointmentId,
  });
  final String name;
  final String? image;
  final String appointmentId;
  @override
  State<_AgoraCallRoomView> createState() => _AgoraCallRoomViewState();
}

class _AgoraCallRoomViewState extends State<_AgoraCallRoomView> {
  int? _remoteUid;
  int? _localUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  @override
  void initState() {
    if (AgoraCallSocketHandler().socket == null ||
        (!AgoraCallSocketHandler().socket!.connected)) {
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
    initializeAgoraClient();
    context.read<AgoraCallEventsCubit>().resetEvent();
    context.read<AgoraCallCubit>().emitLoading(
          isLoading: true,
        );

    // AgoraCallSocketHandler()
    //     .initSocket(
    //   appintId: widget.appointmentId,
    //   onJoinedEvent: () {
    //     log("Doctor Joined the call");
    //     context.read<AgoraCallEventsCubit>().emitJoinedEvent();
    //   },
    //   onRejectedEvent: () {
    //     log("Doctor Reject the call");
    //     context.read<AgoraCallEventsCubit>().emitRejectedEvent();
    //   },
    //   onEndedEvent: () {
    //     log("Doctor Ended the call");
    //     context.read<AgoraCallEventsCubit>().emitEndedEvent();
    //   },
    // )
    //     .then((value) {
    //   // Future.delayed(Duration(seconds: 2)).then(
    //   //   (value) {
    //   //     AgoraCallSocketHandler().emitJoinCall(
    //   //         appintId: agoraCubitState!.channelId, patientAgoraId: _localUid!);
    //   //   },
    //   // );
    // });
    super.initState();
  }

  // AgoraClient? agoraClient;
  AgoraCallState? agoraCubitState;

  @override
  void dispose() async {
    WakelockPlus.disable();
    AgoraCallSocketHandler().disposeSocket();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // late SharedPreferences prefs;
  // void initializeAgoraClient() async {
  //   WakelockPlus.enable();
  //   agoraCubitState = context.read<AgoraCallCubit>().state;

  //   // retrieve permissions
  //   await [Permission.microphone, Permission.camera].request();

  //   //create the engine
  //   _engine = createAgoraRtcEngine();

  //   try {
  //     await _engine.initialize(RtcEngineContext(
  //       appId: agoraCubitState!.appId,
  //       channelProfile: ChannelProfileType.channelProfileCommunication,
  //       threadPriority: ThreadPriorityType.high,
  //     ));
  //     log("appid hamy mil gai: ${agoraCubitState!.appId}");
  //     log("channelId hamy mil gai: ${agoraCubitState!.channelId}");
  //     log("token hamy mil gai: ${agoraCubitState!.patientToken}");

  //     _engine.registerEventHandler(
  //       RtcEngineEventHandler(
  //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
  //           debugPrint("local user ${connection.localUid} joined");
  //           _localUid = connection.localUid;
  //           AgoraCallSocketHandler().emitJoinCall(
  //               appintId: agoraCubitState!.channelId,
  //               patientAgoraId: _localUid!);
  //           stopWatchTimer.onStartTimer();
  //           setState(() {
  //             _localUserJoined = true;
  //           });
  //         },
  //         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
  //           log("remote user test samee $remoteUid joined");
  //           setState(() {
  //             _remoteUid = remoteUid;
  //           });
  //         },
  //         onUserOffline: (RtcConnection connection, int remoteUid,
  //             UserOfflineReasonType reason) {
  //           debugPrint("remote user $remoteUid left channel");
  //           setState(() {
  //             _remoteUid = null;
  //           });
  //           context.read<AgoraCallEventsCubit>().emitEndedEvent();
  //         },
  //         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
  //           debugPrint(
  //               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
  //         },
  //       ),
  //     );

  //     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  //     await _engine.setVideoEncoderConfiguration(
  //       const VideoEncoderConfiguration(
  //         dimensions:
  //             VideoDimensions(width: 640, height: 360), // Set resolution
  //         frameRate: 15, // Set frame rate
  //         orientationMode:
  //             OrientationMode.orientationModeAdaptive, // Set orientation mode
  //       ),
  //     );
  //     await _engine.enableVideo();
  //     await _engine.startPreview();

  //     await _engine
  //         .joinChannel(
  //       token: agoraCubitState!.patientToken,
  //       channelId: agoraCubitState!.channelId,
  //       uid: 0,
  //       options: const ChannelMediaOptions(),
  //     )
  //         .then(
  //       (value) {
  //         _engine.muteLocalAudioStream(
  //           false,
  //         );

  //         context.read<AgoraCallCubit>().toggleLocalMic(
  //               isActive: true,
  //             );

  //         _engine.muteAllRemoteAudioStreams(
  //           false,
  //         );

  //         context.read<AgoraCallCubit>().toggleRemoteAudio(isActive: true);
  //       },
  //     );
  //     //   agoraClient = AgoraClient(
  //     //   //   agoraConnectionData: AgoraConnectionData(
  //     //   //     appId: agoraCubitState!.appId,
  //     //   //     channelName: agoraCubitState!.channelId,
  //     //   //     // tempToken: agoraCubitState.patientToken,
  //     //   //   ),
  //     //   // );
  //     //   // agoraClient?.initialize();
  //   } catch (err) {
  //     debugPrint('Failed to initialize RtcEngine: $err');
  //   }
  //   // widget.prefs.setString(criteria, "");
  //   context.read<AgoraCallCubit>().emitLoading(
  //         isLoading: false,
  //       );
  // }
  void initializeAgoraClient() async {
 log("🔵 initializeAgoraClient() STARTED");

  WakelockPlus.enable();
  agoraCubitState = context.read<AgoraCallCubit>().state;

 log("APP ID: ${agoraCubitState!.appId}");
 log("CHANNEL: ${agoraCubitState!.channelId}");
 log("TOKEN: ${agoraCubitState!.patientToken}");

  // retrieve permissions
  await [Permission.microphone, Permission.camera].request();

  //create the engine
  _engine = createAgoraRtcEngine();

  // ---------------- STEP 1: INITIALIZE ENGINE ----------------
  try {
   log("STEP 1 → Initializing engine...");
    await _engine.initialize(
      RtcEngineContext(
        appId: agoraCubitState!.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        threadPriority: ThreadPriorityType.high,
      ),
    );
   log("STEP 1 ✔ Engine Initialized");
  } catch (e, s) {
   log("❌ ERROR @ initialize(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 2: REGISTER HANDLERS ----------------
  try {
   log("STEP 2 → Registering event handler...");
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
         log("🟢 LOCAL JOINED: ${connection.localUid}");
          _localUid = connection.localUid;

          AgoraCallSocketHandler().emitJoinCall(
            appintId: agoraCubitState!.channelId,
            patientAgoraId: _localUid!,
          );

          stopWatchTimer.onStartTimer();

          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
         log("🟣 REMOTE JOINED: $remoteUid");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline:
            (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
         log("🔴 REMOTE LEFT: $remoteUid, reason = $reason");
          setState(() {
            _remoteUid = null;
          });
          context.read<AgoraCallEventsCubit>().emitEndedEvent();
        },
      ),
    );
   log("STEP 2 ✔ Event Handler Registered");
  } catch (e, s) {
   log("❌ ERROR @ registerEventHandler(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 3: CLIENT ROLE ----------------
  try {
   log("STEP 3 → Setting client role...");
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
   log("STEP 3 ✔ Client role set");
  } catch (e, s) {
   log("❌ ERROR @ setClientRole(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 4: VIDEO CONFIG ----------------
  try {
   log("STEP 4 → Setting video encoder config...");
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );
   log("STEP 4 ✔ Video Encoder Config Applied");
  } catch (e, s) {
   log("❌ ERROR @ setVideoEncoderConfiguration(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 5: ENABLE VIDEO ----------------
  try {
   log("STEP 5 → Enabling video...");
    await _engine.enableVideo();
   log("STEP 5 ✔ enableVideo OK");
  } catch (e, s) {
   log("❌ ERROR @ enableVideo(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 6: START PREVIEW ----------------
  try {
   log("STEP 6 → Starting preview...");
    await _engine.startPreview();
   log("STEP 6 ✔ Preview Started");
  } catch (e, s) {
   log("❌ ERROR @ startPreview(): $e");
   print(s);
    return;
  }

  // ---------------- STEP 7: JOIN CHANNEL ----------------
  try {
   log("STEP 7 → Joining channel...");
   log("JOIN TOKEN → ${agoraCubitState!.patientToken}");
   log("JOIN CHANNEL → ${agoraCubitState!.channelId}");

    await _engine.joinChannel(
      token: "007eJxTYCjr6Hf8YjV7QfNU/2CHKNn4rV/4rCJijfp+HvpR5nWoPVCBwSAtyTDRMDU5zTTR2CQlySjJ1DDF0sLSLNnS0sTM1Cixdq5lZu9qy8xpv8+xMDJAIAhIMJhZGltaphiZpaYYWhiZphmbm5gaWxgaJzMwAAAgtySl",
      // token: agoraCubitState!.patientToken,
      //zuriz
      channelId: agoraCubitState!.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

   log("STEP 7 ✔ joinChannel() called");

    // MUTE HANDLING
    _engine.muteLocalAudioStream(false);
    context.read<AgoraCallCubit>().toggleLocalMic(isActive: true);

    _engine.muteAllRemoteAudioStreams(false);
    context.read<AgoraCallCubit>().toggleRemoteAudio(isActive: true);

  } catch (e, s) {
   log("❌ ERROR @ joinChannel(): $e");
   print(s);
    return;
  }

  context.read<AgoraCallCubit>().emitLoading(isLoading: false);

 log("🎉 Agora Initialization COMPLETED");
}

  String formatStopwatchTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  final stopWatchTimer = StopWatchTimer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: BlocListener<AgoraCallEventsCubit, AgoraCallEventsState>(
        listener: (context, state) {
          if (state is AgoraCallEndedEvent) {
            showToast(
              message: "Doctor has ended the call.",
              context: context,
            );
            context.read<AgoraCallEventsCubit>().resetEvent();
            _engine.leaveChannel().then((value) {
              _engine.release();
              WakelockPlus.disable();
              NavigatorServices().toReplacement(
                context: context,
                widget: WaitingForPrescriptionScreen(),
              );
            });
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: getHeight(context: context),
              width: getWidth(context: context),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                                // bottomLeft: Radius.circular(30),
                                // bottomRight: Radius.circular(30),
                                ),
                          ),
                          alignment: Alignment.center,
                          child: InterText(
                            title: "Joining...",
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                                // bottomLeft: Radius.circular(30),
                                // bottomRight: Radius.circular(30),
                                ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: _remoteVideo(),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: 120,
                                    height: 140,
                                    child: Center(
                                      child: _localUserJoined
                                          ? AgoraVideoView(
                                              controller: VideoViewController(
                                                rtcEngine: _engine,
                                                canvas:
                                                    const VideoCanvas(uid: 0),
                                              ),
                                            )
                                          : const CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // child: ClipRRect(
                          //   borderRadius: const BorderRadius.only(
                          //       // bottomLeft: Radius.circular(30),
                          //       // bottomRight: Radius.circular(30),
                          //       ),
                          //   // child: AgoraVideoViewer(
                          //   //   layoutType: Layout.oneToOne,
                          //   //   client: agoraClient!,
                          //   //   showNumberOfUsers: true,
                          //   // ),
                          // ),
                        ),
                        Positioned(
                          bottom: 22,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.6),
                                borderRadius: BorderRadius.circular(
                                  46,
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            45,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            45,
                                          ),
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                45,
                                              ),
                                            ),
                                            child: Image.network(
                                              widget.image != null
                                                  ? '${ApiConstants.imageBaseUrl}${widget.image}'
                                                  : '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InterText(
                                            title: widget.name,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          StreamBuilder<int>(
                                            stream: stopWatchTimer.secondTime,
                                            initialData: 0,
                                            builder: (context, snap) {
                                              final value = snap.data;
                                              return InterText(
                                                title: formatStopwatchTime(
                                                  int.parse(
                                                    value.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: AppColors.color008541,
                                      borderRadius: BorderRadius.circular(55),
                                    ),
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Align(
                                        child: LottieBuilder.asset(
                                          AppAssets.talkingAnimation,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (getHeight(context: context) * .15) < 120
                        ? 120
                        : getHeight(context: context) * .15,
                    child: BlocBuilder<AgoraCallCubit, AgoraCallState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AgoraCallButton(
                                  buttonColor: AppColors.colorCCE7D9,
                                  icon: state.isRemoteAudioActive
                                      ? Icons.volume_up_outlined
                                      : Icons.volume_off_outlined,
                                  iconColor: AppColors.color008541,
                                  callBackFunction: () {
                                    final isActive = state.isRemoteAudioActive;
                                    if (isActive) {
                                      _engine.muteAllRemoteAudioStreams(
                                        true,
                                      );
                                      context
                                          .read<AgoraCallCubit>()
                                          .toggleRemoteAudio(isActive: false);
                                    } else {
                                      _engine.muteAllRemoteAudioStreams(
                                        false,
                                      );

                                      context
                                          .read<AgoraCallCubit>()
                                          .toggleRemoteAudio(isActive: true);
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                AgoraCallButton(
                                  buttonColor: AppColors.colorEFEFEF,
                                  icon: state.isLocalMicActive
                                      ? Icons.mic_none_outlined
                                      : Icons.mic_off_outlined,
                                  iconColor: Colors.black,
                                  callBackFunction: () {
                                    final isActive = state.isLocalMicActive;
                                    if (isActive) {
                                      _engine.muteLocalAudioStream(
                                        true,
                                      );
                                      context
                                          .read<AgoraCallCubit>()
                                          .toggleLocalMic(isActive: false);
                                    } else {
                                      _engine.muteLocalAudioStream(
                                        false,
                                      );
                                      context
                                          .read<AgoraCallCubit>()
                                          .toggleLocalMic(
                                            isActive: true,
                                          );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                AgoraCallButton(
                                  buttonColor: AppColors.colorF14F4A,
                                  icon: Icons.phone,
                                  iconColor: Colors.white,
                                  callBackFunction: () {
                                    AgoraCallSocketHandler().emitEndCall(
                                      appintId: agoraCubitState!.channelId,
                                    );
                                    _engine.leaveChannel().then((_) {
                                      _engine.release();
                                      WakelockPlus.disable();
                                      NavigatorServices().toReplacement(
                                        context: context,
                                        widget: WaitingForPrescriptionScreen(),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<AgoraCallCubit, AgoraCallState>(
              builder: (context, state) {
                return state.isLoading! ? CustomLoadingScreen() : SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _remoteVideo() {
    log("Remote Id: ${_remoteUid}");
    if (_remoteUid != null) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(
                channelId: context.read<AgoraCallCubit>().state.channelId),
          ),
        ),
      );
    } else {
      return const Text(
        'Please wait for doctor to join',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      );
    }
  }
}

class AgoraCallButton extends StatelessWidget {
  AgoraCallButton({
    required this.buttonColor,
    required this.icon,
    required this.iconColor,
    required this.callBackFunction,
    super.key,
  });

  Color buttonColor;
  Color iconColor;
  IconData icon;
  Function callBackFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBackFunction();
      },
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(55),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
