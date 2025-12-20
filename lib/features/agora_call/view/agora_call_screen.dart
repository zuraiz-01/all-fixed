import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/agora_call_controller.dart';
import '../controller/agora_singleton.dart';

class AgoraCallScreen extends StatelessWidget {
  const AgoraCallScreen({
    super.key,
    required this.name,
    required this.image,
    required this.callId,
    this.asDoctor = false,
  });

  final String name;
  final String? image;
  final String callId;
  final bool asDoctor;

  @override
  Widget build(BuildContext context) {
    return _AgoraCallRoomView(
      name: name,
      image: image,
      callId: callId,
      asDoctor: asDoctor,
    );
  }
}

class _AgoraCallRoomView extends StatefulWidget {
  const _AgoraCallRoomView({
    required this.name,
    required this.image,
    required this.callId,
    required this.asDoctor,
  });

  final String name;
  final String? image;
  final String callId;
  final bool asDoctor;

  @override
  State<_AgoraCallRoomView> createState() => _AgoraCallRoomViewState();
}

class _AgoraCallRoomViewState extends State<_AgoraCallRoomView> {
  late AgoraCallController _controller;
  late AgoraSingleton _agoraSingleton;

  @override
  void initState() {
    super.initState();
    log("CALL FLOW: initState started for callId: ${widget.callId}");

    // Initialize controllers
    _controller = Get.find<AgoraCallController>();
    _agoraSingleton = Get.find<AgoraSingleton>();

    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      log("CALL FLOW: Starting call with singleton");

      final permissionStatuses = await [
        Permission.microphone,
        Permission.camera,
      ].request();
      final micOk =
          permissionStatuses[Permission.microphone]?.isGranted ??
          permissionStatuses[Permission.microphone]?.isLimited ??
          false;
      final camOk =
          permissionStatuses[Permission.camera]?.isGranted ??
          permissionStatuses[Permission.camera]?.isLimited ??
          false;
      if (!micOk || !camOk) {
        _showErrorAndExit('Camera/Microphone permission denied');
        return;
      }

      // Validate callId
      if (widget.callId.isEmpty) {
        log("CALL FLOW ERROR: callId is empty");
        _showErrorAndExit("Invalid call ID");
        return;
      }

      // Start call using controller (which uses singleton)
      await _controller.startCall(
        appointmentId: widget.callId,
        appId: "0fb1a1ecf5a34db2b51d9896c994652a",
        asDoctor: widget.asDoctor,
      );

      log("CALL FLOW: Call started successfully");
    } catch (e) {
      log("CALL FLOW ERROR: Initialization failed - $e");
      _showErrorAndExit("Failed to initialize call: $e");
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = _controller;
      final resolvedChannelId = controller.channelId.value.isNotEmpty
          ? controller.channelId.value
          : widget.callId;

      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Call status bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      controller.isConnecting.value
                          ? Icons.phone_in_talk
                          : controller.isInCall.value
                          ? Icons.phone
                          : Icons.phone_disabled,
                      color: controller.isConnecting.value
                          ? Colors.yellow
                          : controller.isInCall.value
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.isConnecting.value
                          ? 'Connecting...'
                          : controller.isInCall.value
                          ? 'Connected'
                          : 'Disconnected',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Video area
              Expanded(
                child: Stack(
                  children: [
                    // Remote video
                    if (controller.remoteUserId.value != 0 &&
                        controller.isRemoteVideoActive.value) ...[
                      () {
                        log(
                          '[UI] Showing remote video - remoteUserId: ${controller.remoteUserId.value}, isRemoteVideoActive: ${controller.isRemoteVideoActive.value}',
                        );
                        return AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: _agoraSingleton.engine,
                            connection: RtcConnection(
                              channelId: resolvedChannelId,
                            ),
                            canvas: VideoCanvas(
                              uid: controller.remoteUserId.value,
                            ),
                          ),
                        );
                      }(),
                    ],

                    // Doctor camera off state
                    if (controller.remoteUserId.value != 0 &&
                        !controller.isRemoteVideoActive.value) ...[
                      () {
                        log(
                          '[UI] Doctor camera off - remoteUserId: ${controller.remoteUserId.value}, isRemoteVideoActive: ${controller.isRemoteVideoActive.value}',
                        );
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_off,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Doctor camera is off',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }(),
                    ],

                    // Waiting for doctor state
                    if (controller.remoteUserId.value == 0) ...[
                      () {
                        log(
                          '[UI] Waiting for doctor - remoteUserId: ${controller.remoteUserId.value}, isRemoteVideoActive: ${controller.isRemoteVideoActive.value}',
                        );
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, size: 80, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Waiting for doctor to join...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }(),
                    ],

                    // Local video (picture-in-picture)
                    Positioned(
                      top: 16,
                      right: 16,
                      width: 120,
                      height: 160,
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _agoraSingleton.engine,
                          canvas: VideoCanvas(
                            uid: controller.localUid.value,
                            sourceType: VideoSourceType.videoSourceCamera,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Controls
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute/Unmute
                    IconButton(
                      onPressed: () async => controller.toggleMicrophone(),
                      icon: Icon(
                        controller.isLocalMicActive.value
                            ? Icons.mic
                            : Icons.mic_off,
                        color: controller.isLocalMicActive.value
                            ? Colors.white
                            : Colors.red,
                        size: 32,
                      ),
                    ),

                    // Camera toggle
                    IconButton(
                      onPressed: () async => controller.toggleCamera(),
                      icon: Icon(
                        controller.isLocalCameraActive.value
                            ? Icons.videocam
                            : Icons.videocam_off,
                        color: controller.isLocalCameraActive.value
                            ? Colors.white
                            : Colors.red,
                        size: 32,
                      ),
                    ),

                    // Speaker toggle
                    IconButton(
                      onPressed: () async => controller.toggleSpeaker(),
                      icon: Icon(
                        controller.isSpeakerOn.value
                            ? Icons.volume_up
                            : Icons.volume_off,
                        color: controller.isSpeakerOn.value
                            ? Colors.white
                            : Colors.red,
                        size: 32,
                      ),
                    ),

                    // End call
                    IconButton(
                      onPressed: () => controller.endCall(),
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
