import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import '../view/agora_call_room_screen.dart';
import 'agora_call_controller.dart';
import '../../../core/services/utils/handlers/agora_call_socket_handler.dart';
import '../../../core/services/utils/assets/app_assets.dart';
import '../../../core/services/utils/config/app_colors.dart';
import '../../../core/services/utils/size_config.dart';
import '../../global_widgets/inter_text.dart';
import '../../global_widgets/common_network_image_widget.dart';

class CallController extends GetxController {
  static CallController get to => Get.find();

  final RxString appointmentId = ''.obs;
  final RxString doctorName = ''.obs;
  final RxString doctorPhoto = ''.obs;
  final RxBool isIncomingVisible = false.obs;

  Timer? _autoDeclineTimer;
  static const int _autoDeclineSeconds = 30;

  Timer? _remoteWatchdogTimer;
  static const int _remoteWatchdogSeconds = 30;

  StreamSubscription? _callKitSub;

  void _cancelAutoDeclineTimer() {
    _autoDeclineTimer?.cancel();
    _autoDeclineTimer = null;
  }

  void _cancelRemoteWatchdogTimer() {
    _remoteWatchdogTimer?.cancel();
    _remoteWatchdogTimer = null;
  }

  void _startRemoteWatchdogTimer({required String forAppointmentId}) {
    _cancelRemoteWatchdogTimer();
    _remoteWatchdogTimer = Timer(Duration(seconds: _remoteWatchdogSeconds), () {
      if (!isIncomingVisible.value) return;
      if (appointmentId.value != forAppointmentId) return;
      log(
        'CALLCONTROLLER: Remote watchdog fired after ${_remoteWatchdogSeconds}s. Dismissing stuck ringing. appointmentId=$forAppointmentId',
      );
      _dismissIncomingCall(reason: 'remote_watchdog');
    });
  }

  void _startAutoDeclineTimer({required String forAppointmentId}) {
    _cancelAutoDeclineTimer();
    _autoDeclineTimer = Timer(Duration(seconds: _autoDeclineSeconds), () {
      if (!isIncomingVisible.value) return;
      if (appointmentId.value != forAppointmentId) return;
      log(
        'CALLCONTROLLER: Auto-declining incoming call after ${_autoDeclineSeconds}s. appointmentId=$forAppointmentId',
      );
      declineIncomingCall();
    });
  }

  void markIncomingAccepted() {
    _cancelAutoDeclineTimer();
    _cancelRemoteWatchdogTimer();
    isIncomingVisible.value = false;
  }

  Future<void> declineIncomingCall() async {
    _cancelAutoDeclineTimer();
    _cancelRemoteWatchdogTimer();
    try {
      await AgoraCallController.to.rejectCall();
    } catch (_) {
      // ignore
    }
    _dismissIncomingCall(reason: 'local_reject');
  }

  void _dismissIncomingCall({required String reason}) {
    log('CALLCONTROLLER: Dismissing incoming call. reason=$reason');
    _cancelAutoDeclineTimer();
    _cancelRemoteWatchdogTimer();
    isIncomingVisible.value = false;
    final activeAppointmentId = appointmentId.value;
    appointmentId.value = '';
    doctorName.value = '';
    doctorPhoto.value = '';

    try {
      if (activeAppointmentId.isNotEmpty) {
        FlutterCallkitIncoming.endCall(activeAppointmentId);
      }
      FlutterCallkitIncoming.endAllCalls();
    } catch (_) {
      // ignore
    }

    // Stop listening to call events for this appointment
    try {
      AgoraCallSocketHandler().disposeSocket(disconnect: true);
    } catch (_) {
      // ignore
    }

    try {
      AgoraCallSocketHandler().preconnect();
    } catch (_) {
      // ignore
    }

    // Close UI only if we are currently on top of IncomingCallScreen
    try {
      if ((Get.key.currentState?.canPop() ?? false) &&
          (Get.currentRoute.contains('IncomingCallScreen') ||
              Get.currentRoute.contains('IncomingCall'))) {
        Get.back();
      }
    } catch (_) {
      // ignore
    }
  }

  void showIncomingCall({
    required String appointmentId,
    required String doctorName,
    required String? doctorPhoto,
  }) {
    // If a call is already being shown for the same appointment, do nothing
    if (isIncomingVisible.value && this.appointmentId.value == appointmentId) {
      return;
    }

    this.appointmentId.value = appointmentId;
    this.doctorName.value = doctorName;
    this.doctorPhoto.value = doctorPhoto ?? '';
    isIncomingVisible.value = true;

    // Defensive: clear any stale CallKit sessions before showing a new incoming call.
    try {
      if (appointmentId.trim().isNotEmpty) {
        FlutterCallkitIncoming.endCall(appointmentId);
      }
      FlutterCallkitIncoming.endAllCalls();
    } catch (_) {
      // ignore
    }

    _startAutoDeclineTimer(forAppointmentId: appointmentId);
    _startRemoteWatchdogTimer(forAppointmentId: appointmentId);

    // Keep AgoraCallController in sync with the current appointment
    try {
      AgoraCallController.to.currentAppointmentId.value = appointmentId;
    } catch (_) {
      // If AgoraCallController is not registered yet, we just skip syncing
    }

    // Listen for doctor cancel/end so patient UI dismisses immediately
    try {
      AgoraCallSocketHandler().initSocket(
        appointmentId: appointmentId,
        onJoinedEvent: () {
          // doctor is in room; stop watchdog so we don't dismiss a valid ring
          _cancelRemoteWatchdogTimer();
        },
        onRejectedEvent: () {
          _cancelRemoteWatchdogTimer();
          _dismissIncomingCall(reason: 'remote_reject');
        },
        onEndedEvent: () {
          _cancelRemoteWatchdogTimer();
          _dismissIncomingCall(reason: 'remote_end');
        },
      );
    } catch (e) {
      log('CALLCONTROLLER: Failed to init socket for incoming call: $e');
    }

    // Navigate to incoming call screen
    Get.to(() => IncomingCallScreen());
  }

  @override
  void onInit() {
    super.onInit();
    try {
      _callKitSub = FlutterCallkitIncoming.onEvent.listen((event) {
        try {
          if (event == null) return;
          final eventName = (event.event.toString());
          log('CALLCONTROLLER: CallKit event=$eventName body=${event.body}');

          // When doctor ends/cancels, CallKit may emit ended/timeout.
          // Ensure we dismiss incoming UI + stop ringing.
          if (eventName.contains('actionCallEnded') ||
              eventName.contains('actionCallTimeout')) {
            if (isIncomingVisible.value) {
              _dismissIncomingCall(reason: 'callkit_end');
            }
          }

          if (eventName.contains('actionCallDecline')) {
            if (isIncomingVisible.value) {
              _dismissIncomingCall(reason: 'callkit_decline');
            }
          }
        } catch (_) {
          // ignore
        }
      });
    } catch (e) {
      log('CALLCONTROLLER: Failed to attach CallKit listener: $e');
    }
  }

  @override
  void onClose() {
    try {
      _callKitSub?.cancel();
    } catch (_) {
      // ignore
    }
    _cancelAutoDeclineTimer();
    _cancelRemoteWatchdogTimer();
    super.onClose();
  }

  /// Handle call acceptance - called when user accepts incoming call
  void joinCall({required int patientAgoraId}) async {
    try {
      log(
        'CALLCONTROLLER: Joining call with patient Agora ID: $patientAgoraId',
      );

      // Delegate to AgoraCallController for actual join logic
      await AgoraCallController.to.joinCall(patientAgoraId: patientAgoraId);
    } catch (e) {
      log('CALLCONTROLLER ERROR: Failed to join call - $e');
    }
  }

  /// Handle call rejection - called when user rejects incoming call
  void rejectCall() async {
    try {
      log(
        'CALLCONTROLLER: Rejecting call for appointment: ${appointmentId.value}',
      );

      // Delegate to AgoraCallController for actual reject logic
      await AgoraCallController.to.rejectCall();
    } catch (e) {
      log('CALLCONTROLLER ERROR: Failed to reject call - $e');
    }
  }
}

class IncomingCallScreen extends StatelessWidget {
  IncomingCallScreen({super.key});

  final CallController controller = CallController.to;

  @override
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);
  //   return PopScope(
  //     canPop: false,
  //     onPopInvokedWithResult: (didPop, result) {},
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       body: Stack(
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             // mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Column(
  //                   children: [
  //                     InterText(
  //                       title: 'Incoming call...',
  //                       fontSize: 16,
  //                       textColor: Colors.black,
  //                     ),
  //                     const SizedBox(height: 8),
  //                     InterText(
  //                       title: controller.doctorName.value.isNotEmpty
  //                           ? controller.doctorName.value
  //                           : 'BEH - DOCTOR',
  //                       fontSize: 25,
  //                       textColor: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 25),
  //               Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: AppColors.primaryColor, width: 5),
  //                   borderRadius: BorderRadius.circular(
  //                     SizeConfig.screenWidth / 2,
  //                   ),
  //                 ),
  //                 padding: const EdgeInsets.all(5),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(
  //                     SizeConfig.screenWidth / 2,
  //                   ),
  //                   child: Container(
  //                     height: SizeConfig.screenWidth / 2,
  //                     width: SizeConfig.screenWidth / 2,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(
  //                         SizeConfig.screenWidth / 2,
  //                       ),
  //                     ),
  //                     child: CommonNetworkImageWidget(
  //                       imageLink: controller.doctorPhoto.value.isNotEmpty
  //                           ? '${ApiConstants.imageBaseUrl}${controller.doctorPhoto.value}'
  //                           : '',
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 50),
  //             ],
  //           ),
  //           Positioned(
  //             left: 25,
  //             bottom: 23,
  //             child: InkWell(
  //               onTap: () {
  //                 log('IncomingCallScreen: declined by patient');
  //                 // Notify Agora controller so it can emit rejectCall over socket
  //                 try {
  //                   AgoraCallController.to.rejectCall();
  //                 } catch (_) {
  //                   // Fallback: if controller is not available, just close screen
  //                 }
  //                 Get.back();
  //               },
  //               child: Image.asset(AppAssets.endCall, width: 100),
  //             ),
  //           ),
  //           Positioned(
  //             right: 0,
  //             bottom: 0,
  //             child: InkWell(
  //               onTap: () {
  //                 log('IncomingCallScreen: accepted by patient');
  //                 // Navigate to call room screen with Agora integration
  //                 Get.to(
  //                   () => AgoraCallScreen(
  //                     name: controller.doctorName.value,
  //                     image: controller.doctorPhoto.value,
  //                     appointmentId: controller.appointmentId.value,
  //                   ),
  //                 );
  //               },
  //               child: SizedBox(
  //                 height: 140,
  //                 child: Align(
  //                   child: LottieBuilder.asset(AppAssets.acceptCall),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final double avatarSize = SizeConfig.screenWidth * 0.55;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              /// CENTER CONTENT
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Incoming Text
                    InterText(
                      title: 'Incoming call...',
                      fontSize: 16,
                      textColor: Colors.black54,
                    ),
                    const SizedBox(height: 8),

                    /// Doctor Name
                    InterText(
                      title: controller.doctorName.value.isNotEmpty
                          ? controller.doctorName.value
                          : 'BEH - DOCTOR',
                      fontSize: 26,
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    /// Avatar
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 5,
                        ),
                      ),
                      child: ClipOval(
                        child: SizedBox(
                          height: avatarSize,
                          width: avatarSize,
                          child: CommonNetworkImageWidget(
                            imageLink: controller.doctorPhoto.value.isNotEmpty
                                ? controller.doctorPhoto.value
                                : '',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// DECLINE BUTTON
              Positioned(
                left: 24,
                bottom: 30,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    log('IncomingCallScreen: declined by patient');
                    controller.declineIncomingCall();
                  },
                  child: Image.asset(AppAssets.endCall, width: 90),
                ),
              ),

              /// ACCEPT BUTTON
              Positioned(
                right: 24,
                bottom: 20,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: () {
                    log('IncomingCallScreen: accepted by patient');
                    controller.markIncomingAccepted();
                    Get.to(
                      () => AgoraCallScreen(
                        name: controller.doctorName.value,
                        image: controller.doctorPhoto.value,
                        appointmentId: controller.appointmentId.value,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: LottieBuilder.asset(
                      AppAssets.acceptCall,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
