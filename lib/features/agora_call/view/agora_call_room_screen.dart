import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../controller/agora_call_controller.dart';
import '../controller/agora_singleton.dart';
import '../services/agora_call_service.dart';
import '../../../core/services/api/service/api_constants.dart';
import '../../waiting_for_prescription/view/waiting_for_prescription_screen.dart';

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
  final AgoraCallController _callController = AgoraCallController.to;
  final AgoraCallService _agoraService = AgoraCallService.to;
  final AgoraSingleton _agoraSingleton = AgoraSingleton.to;
  int? _localUid;
  bool _localUserJoined = false;
  bool _hasLeftChannel = false;
  late final RtcEngine _engine;
  final stopWatchTimer = StopWatchTimer();
  Timer? _joinTimeoutTimer;
  Worker? _callStateWorker;
  bool _wasInCall = false;

  @override
  void initState() {
    super.initState();
    // Ensure engine is initialized before the first build.
    // The UI (Obx) can call _remoteVideo() which uses _engine.
    _engine = _agoraSingleton.engine;
    // Initialize call with appointment ID
    _callController.startCall(appointmentId: widget.appointmentId);
    _wasInCall = _callController.isInCall.value;
    _callStateWorker = ever<bool>(_callController.isInCall, (value) {
      if (!value && _wasInCall) {
        if (mounted) {
          _handleCallEnded();
        }
      }
      _wasInCall = value;
    });
    _initializeAgoraClient();
    _startJoinTimeout();
  }

  @override
  void dispose() {
    _joinTimeoutTimer?.cancel();
    _callStateWorker?.dispose();
    WakelockPlus.disable();
    _agoraService.disposeSocket();
    _leaveChannelOnce();
    super.dispose();
  }

  Future<void> _leaveChannelOnce() async {
    if (_hasLeftChannel) return;
    _hasLeftChannel = true;
    try {
      await _agoraSingleton.leaveChannel(reason: 'call_room_leave_once');
    } catch (e) {
      log('Error leaving channel (leave once): $e');
    }
  }

  void _startJoinTimeout() {
    // If doctor/local join does not lead to an active call within 30 seconds,
    // automatically end the call to avoid the user being stuck.
    _joinTimeoutTimer?.cancel();
    _joinTimeoutTimer = Timer(const Duration(seconds: 30), () async {
      if (!_callController.isInCall.value) {
        log(
          'CALL FLOW: Join timeout reached (30s). Ending call automatically.',
        );
        try {
          await _callController.endCall();
        } catch (e) {
          log('CALL FLOW: Error while ending call on timeout - $e');
        }
        if (mounted) {
          _handleCallEnded();
        }
      }
    });
  }

  Widget _remoteVideo({required int uid}) {
    log("Remote Id: ${_callController.remoteUserId.value}");
    final resolvedChannelId = _callController.channelId.value.isNotEmpty
        ? _callController.channelId.value
        : widget.appointmentId;
    final int remoteUid = _callController.remoteUserId.value;
    print('zuraiz: ${uid}');
    if (remoteUid != 0) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Stack(
          children: [
            AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: remoteUid),
                connection: RtcConnection(channelId: resolvedChannelId),
              ),
            ),
            if (!_callController.isRemoteVideoActive.value)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, color: Colors.white, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Video is off',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.grey[200],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text(
              'Waiting for doctor to join...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _initializeAgoraClient() async {
    WakelockPlus.enable();

    // Request permissions
    await [Permission.microphone, Permission.camera].request();

    try {
      // Engine/channel join is handled by AgoraCallController.startCall -> AgoraSingleton.joinChannel
      log('CALL FLOW: Using singleton engine (join handled by controller)');

      // Keep local preview state in sync
      _localUid = 0;
      stopWatchTimer.onStartTimer();
      setState(() {
        _localUserJoined = true;
      });
    } catch (e) {
      log('CALL FLOW: Error while joining channel - $e');
      _showErrorAndExit("Failed to join channel: $e");
      return;
    }
  }

  void _showErrorAndExit(String error) {
    log("CALL FLOW ERROR: $error");
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Call Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Exit call screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handleCallEnded() {
    // Use singleton to leave channel instead of direct engine call
    _leaveChannelOnce().whenComplete(() {
      WakelockPlus.disable();
      Get.offAll(() => const WaitingForPrescriptionScreen());
    });
  }

  String formatStopwatchTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Obx(
        () => Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(color: Colors.white),
                          alignment: Alignment.center,
                          child: const Text(
                            "Joining...",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Stack(
                            children: [
                              Center(
                                child: _remoteVideo(
                                  uid: _callController.remoteUserId.value,
                                ),
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
                                                canvas: const VideoCanvas(
                                                  uid: 0,
                                                ),
                                              ),
                                            )
                                          : const CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 22,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.6),
                                borderRadius: BorderRadius.circular(46),
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
                                            color: const Color(0xFF008541),
                                            width: 5,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            45,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            45,
                                          ),
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                            ),
                                            child: widget.image != null
                                                ? Image.network(
                                                    '${ApiConstants.imageBaseUrl}${widget.image}',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          StreamBuilder<int>(
                                            stream: stopWatchTimer.secondTime,
                                            initialData: 0,
                                            builder: (context, snap) {
                                              final value = snap.data;
                                              return Text(
                                                formatStopwatchTime(
                                                  int.parse(value.toString()),
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF008541),
                                      borderRadius: BorderRadius.circular(55),
                                    ),
                                    child: const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Align(
                                        child: Icon(
                                          Icons.volume_up,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * .15) < 120
                        ? 120
                        : MediaQuery.of(context).size.height * .15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AgoraCallButton(
                              buttonColor: const Color(0xFFCCE7D9),
                              icon: _callController.isRemoteAudioActive.value
                                  ? Icons.volume_up_outlined
                                  : Icons.volume_off_outlined,
                              iconColor: const Color(0xFF008541),
                              callBackFunction: () {
                                final isActive =
                                    _callController.isRemoteAudioActive.value;
                                if (isActive) {
                                  _engine.muteAllRemoteAudioStreams(true);
                                  _callController.isRemoteAudioActive.value =
                                      false;
                                } else {
                                  _engine.muteAllRemoteAudioStreams(false);
                                  _callController.isRemoteAudioActive.value =
                                      true;
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                            AgoraCallButton(
                              buttonColor: const Color(0xFFEFEFEF),
                              icon: _callController.isLocalMicActive.value
                                  ? Icons.mic_none_outlined
                                  : Icons.mic_off_outlined,
                              iconColor: Colors.black,
                              callBackFunction: () {
                                final isActive =
                                    _callController.isLocalMicActive.value;
                                if (isActive) {
                                  _engine.muteLocalAudioStream(true);
                                  _callController.isLocalMicActive.value =
                                      false;
                                } else {
                                  _engine.muteLocalAudioStream(false);
                                  _callController.isLocalMicActive.value = true;
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                            AgoraCallButton(
                              buttonColor: const Color(0xFFF14F4A),
                              icon: Icons.phone,
                              iconColor: Colors.white,
                              callBackFunction: () {
                                _callController.endCall();
                                _handleCallEnded();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgoraCallButton extends StatelessWidget {
  const AgoraCallButton({
    required this.buttonColor,
    required this.icon,
    required this.iconColor,
    required this.callBackFunction,
    super.key,
  });

  final Color buttonColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback callBackFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBackFunction,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(55),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
