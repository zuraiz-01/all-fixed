import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_singleton.dart';
import '../../../../core/services/utils/handlers/agora_call_socket_handler.dart';

class AgoraCallController extends GetxController {
  static AgoraCallController get to => Get.find();

  static const String _flowTag = 'CALLFLOW';
  int _flowSeq = 0;

  void _flow(String step, {Object? data}) {
    _flowSeq++;
    log(
      '$_flowTag[${_flowSeq.toString().padLeft(3, '0')}] $step${data == null ? '' : ' | $data'}',
    );
  }

  // final AgoraCallService _agoraService = AgoraCallService.to; // Removed - using AgoraSingleton only
  AgoraSingleton get _agoraSingleton => Get.find<AgoraSingleton>();

  // Reactive variables
  final RxBool isInCall = false.obs;
  final RxBool isConnecting = false.obs;
  final RxBool isLocalMicActive = true.obs;
  final RxBool isLocalCameraActive = true.obs;
  final RxBool isRemoteAudioActive = true.obs;
  final RxBool isRemoteVideoActive = false.obs;
  final RxBool isSpeakerOn = true.obs;
  final RxString currentAppointmentId = ''.obs;
  final RxInt remoteUserId = 0.obs;
  // Local Agora UID for this patient
  final RxInt localUid = 0.obs;

  // Agora state variables
  final RxString appId = ''.obs;
  final RxString patientToken = ''.obs;
  final RxString channelId = ''.obs;

  // Call state
  final RxString callStatus = 'idle'.obs; // idle, connecting, in_call, ended
  final RxString errorMessage = ''.obs;

  final RxBool isDoctor = false.obs;

  bool _isEnding = false;

  @override
  void onInit() {
    super.onInit();
    log('CONTROLLER: AgoraCallController initialized');
    _flow('A: controller.onInit');
    _setupEventCallbacks();
    _syncWithSingleton();
  }

  void _setupEventCallbacks() {
    log('[CONTROLLER] Setting up event callbacks');
    _flow('B: setupEventCallbacks');
    // Set up callbacks that won't be lost on controller rebuild
    _agoraSingleton.onJoinChannelSuccess = (connection, elapsed) {
      try {
        log('[CONTROLLER] onJoinChannelSuccess callback received');
        _flow(
          'H: onJoinChannelSuccess',
          data: {
            'uid': connection.localUid ?? 0,
            'channel': connection.channelId,
            'elapsed': elapsed,
          },
        );
        handleJoinChannelSuccess(connection.localUid ?? 0);
      } catch (e, st) {
        _flow('H: onJoinChannelSuccess ERROR', data: '$e\n$st');
      }
    };

    _agoraSingleton.onUserJoined = (connection, remoteUid, elapsed) {
      try {
        log('[CONTROLLER] onUserJoined callback received');
        _flow(
          'I: onUserJoined',
          data: {
            'remoteUid': remoteUid,
            'channel': connection.channelId,
            'elapsed': elapsed,
          },
        );
        handleUserJoined(remoteUid);
      } catch (e, st) {
        _flow('I: onUserJoined ERROR', data: '$e\n$st');
      }
    };

    _agoraSingleton.onUserOffline = (connection, remoteUid, reason) {
      try {
        log('[CONTROLLER] onUserOffline callback received');
        _flow(
          'J: onUserOffline',
          data: {
            'remoteUid': remoteUid,
            'channel': connection.channelId,
            'reason': reason.toString(),
          },
        );
        handleUserOffline(remoteUid);
      } catch (e, st) {
        _flow('J: onUserOffline ERROR', data: '$e\n$st');
      }
    };

    _agoraSingleton.onConnectionStateChanged = (connection, state, reason) {
      try {
        _flow(
          'Y: onConnectionStateChanged',
          data: {
            'state': state.toString(),
            'reason': reason.toString(),
            'channel': connection.channelId,
          },
        );

        // If connection drops while in an active call, end the call to avoid being stuck.
        final stateString = state.toString().toLowerCase();
        if (!isDoctor.value && (isInCall.value || isConnecting.value)) {
          if (stateString.contains('disconnected') ||
              stateString.contains('failed')) {
            _endCallInternal(reason: 'connection_lost', emitSocket: false);
          }
        }
      } catch (e, st) {
        _flow('Y: onConnectionStateChanged ERROR', data: '$e\n$st');
      }
    };

    _agoraSingleton.onRemoteVideoStateChanged =
        (
          RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed,
        ) {
          try {
            log('[CONTROLLER] onRemoteVideoStateChanged callback received');
            _flow(
              'K: onRemoteVideoStateChanged',
              data: {
                'remoteUid': remoteUid,
                'channel': connection.channelId,
                'state': state.toString(),
                'reason': reason.toString(),
                'elapsed': elapsed,
              },
            );
            handleRemoteVideoStateChanged(remoteUid, state, reason);
          } catch (e, st) {
            _flow('K: onRemoteVideoStateChanged ERROR', data: '$e\n$st');
          }
        };

    _agoraSingleton.onError = (err, msg) {
      try {
        log('[CONTROLLER] onError callback received');
        _flow('Z: onError', data: {'err': err.toString(), 'msg': msg});
        handleError('$err: $msg');
      } catch (e, st) {
        _flow('Z: onError ERROR', data: '$e\n$st');
      }
    };
    log('[CONTROLLER] Event callbacks set up complete');
  }

  void _syncWithSingleton() {
    // Sync reactive variables with singleton
    ever(_agoraSingleton.isInCall, (bool value) => isInCall.value = value);
    ever(
      _agoraSingleton.isConnecting,
      (bool value) => isConnecting.value = value,
    );
    ever(
      _agoraSingleton.remoteUserId,
      (int value) => remoteUserId.value = value,
    );
  }

  @override
  void onClose() {
    log('CONTROLLER: AgoraCallController closing');
    _cleanup();
    super.onClose();
  }

  /// Fetch and save Agora tokens from appointment API
  Future<void> fetchAndSaveTokensFromAppointments() async {
    try {
      // This would typically be called when appointments are loaded
      // For now, we'll assume the appointment data is already available
      // and tokens are saved by the appointment loading logic
      log(
        'CONTROLLER: Tokens should be fetched and saved by appointment loading logic',
      );
    } catch (e) {
      log('CONTROLLER ERROR: Failed to fetch tokens from appointments - $e');
    }
  }

  /// Start Agora call
  Future<void> startCall({
    required String appointmentId,
    String? token,
    String? appId,
    bool asDoctor = false,
  }) async {
    try {
      log('CONTROLLER: Starting call for appointment: $appointmentId');
      _flow('C: startCall.enter', data: {'appointmentId': appointmentId});

      if (currentAppointmentId.value == appointmentId &&
          (isConnecting.value || isInCall.value)) {
        log(
          'CONTROLLER: startCall ignored (already connecting/in-call for same appointment)',
        );
        return;
      }

      // Update state
      isConnecting.value = true;
      callStatus.value = 'connecting';
      currentAppointmentId.value = appointmentId;
      errorMessage.value = '';
      isDoctor.value = asDoctor;
      _flow('D: state.connecting');

      // Set Agora configuration
      if (appId != null) {
        this.appId.value = appId;
        _agoraSingleton.appId.value = appId;
      }

      // Load token and channel from SharedPreferences directly
      try {
        _flow('E: loadTokenFromPrefs.begin');
        final prefs = await SharedPreferences.getInstance();
        final tokenKey = asDoctor
            ? 'doctor_agora_token_$appointmentId'
            : 'patient_agora_token_$appointmentId';
        final defaultTokenKey = asDoctor
            ? 'doctor_agora_token'
            : 'patient_agora_token';

        final storedToken = prefs.getString(tokenKey) ?? '';
        final storedChannelId =
            prefs.getString('agora_channel_id_$appointmentId') ?? '';

        if (storedToken.isNotEmpty) {
          log(
            'CONTROLLER: Loaded Agora token from SharedPreferences for appointment $appointmentId',
          );
          patientToken.value = storedToken;
          // IMPORTANT: channelId fallback (if not provided, use appointmentId)
          final resolvedChannelId = storedChannelId.isNotEmpty
              ? storedChannelId
              : appointmentId;
          channelId.value = resolvedChannelId;
          _agoraSingleton.channelId.value = resolvedChannelId;
          _flow(
            'E: loadTokenFromPrefs.done',
            data: {
              'tokenLen': storedToken.length,
              'channelId': resolvedChannelId,
            },
          );
        } else {
          // Try to get default token (from first appointment)
          final defaultToken = prefs.getString(defaultTokenKey) ?? '';
          final defaultChannelId = prefs.getString('agora_channel_id') ?? '';
          if (defaultToken.isNotEmpty) {
            log('CONTROLLER: Using default token from first appointment');
            patientToken.value = defaultToken;
            final resolvedChannelId = defaultChannelId.isNotEmpty
                ? defaultChannelId
                : appointmentId;
            channelId.value = resolvedChannelId;
            _agoraSingleton.channelId.value = resolvedChannelId;
            _flow(
              'E: loadDefaultToken.done',
              data: {
                'tokenLen': defaultToken.length,
                'channelId': resolvedChannelId,
              },
            );
          } else {
            log(
              'CONTROLLER ERROR: No token found in SharedPreferences, cannot join call',
            );
            _handleCallError(
              'No Agora token found. Please refresh appointment / try again.',
            );
            return;
          }
        }
      } catch (e) {
        log(
          'CONTROLLER ERROR: Failed to load patient Agora token from SharedPreferences - $e',
        );
        _handleCallError('Failed to load Agora credentials: $e');
        return;
      }

      log('CONTROLLER DEBUG: Using patientToken → ${patientToken.value}');
      log('CONTROLLER DEBUG: Using channelId → ${channelId.value}');

      // Validate token and channel before joining
      if (patientToken.value.isEmpty) {
        log('CONTROLLER ERROR: Token is empty, cannot join call');
        _handleCallError('Agora token is empty. Cannot join call.');
        return;
      }
      if (channelId.value.isEmpty) {
        log('CONTROLLER ERROR: Channel ID is empty, cannot join call');
        _handleCallError('Agora channel is empty. Cannot join call.');
        return;
      }

      // Join channel using singleton
      _flow('F: joinChannel.begin', data: {'channelId': channelId.value});
      await _agoraSingleton.joinChannel(
        //token static for testing
        // token:
        //    "007eJxTYDhpv7Vgp6njhpxQ83VWzNtirR8WdC946Bf5ZYqEq19TyFUFBoO0JMNEw9TkNNNEY5OUJKMkU8MUSwtLs2RLSxMzU6PEhSa2mRudbDObTn1jYIRCEJBgMLM0TjE2TjU3STZJNjBPNbVITklLNrEwYGAAAOoxJF4=",
        token: patientToken.value,
        channelId: channelId.value,
        uid: 0,
        isDoctor: asDoctor,
      );
      _flow('F: joinChannel.called');

      // Initialize socket connection
      _flow('G: socket.init.begin');
      await _initializeSocket(appointmentId);
      _flow('G: socket.init.done');
    } catch (e) {
      log('CONTROLLER ERROR: Failed to start call - $e');
      _flow('C: startCall.ERROR', data: e);
      _handleCallError('Failed to start call: $e');
    }
  }

  Future<void> _initializeSocket(String appointmentId) async {
    try {
      log('CONTROLLER: Initializing socket for appointment: $appointmentId');
      await AgoraCallSocketHandler().initSocket(
        appointmentId: appointmentId,
        onJoinedEvent: () {
          log('CONTROLLER: Socket onJoinedEvent received');
        },
        onRejectedEvent: () {
          log('CONTROLLER: Socket onRejectedEvent received');
          _endCallInternal(reason: 'remote_reject', emitSocket: false);
        },
        onEndedEvent: () {
          log('CONTROLLER: Socket onEndedEvent received');
          _endCallInternal(reason: 'remote_end', emitSocket: false);
        },
      );
    } catch (e) {
      log('CONTROLLER ERROR: Failed to initialize socket - $e');
      _handleCallError('Failed to connect: $e');
    }
  }

  Future<void> joinCall({required int patientAgoraId}) async {
    try {
      log('CONTROLLER: Joining call with patient Agora ID: $patientAgoraId');

      // Socket emit handled by singleton
      log('CONTROLLER: Join call emitted via singleton');

      // Track local UID and move call into connecting/active state
      localUid.value = patientAgoraId;
      isInCall.value = true;
      isConnecting.value = false;
      callStatus.value = 'in_call';
    } catch (e) {
      log('CONTROLLER ERROR: Failed to join call - $e');
      _handleCallError('Failed to join call: $e');
    }
  }

  Future<void> rejectCall() async {
    try {
      log(
        'CONTROLLER: Rejecting call for appointment: ${currentAppointmentId.value}',
      );

      // Socket reject handled by singleton

      isConnecting.value = false;
      isInCall.value = false;
      callStatus.value = 'ended';
    } catch (e) {
      log('CONTROLLER ERROR: Failed to reject call - $e');
    }
  }

  Future<void> endCall() async {
    try {
      log(
        'CONTROLLER: Ending call for appointment: ${currentAppointmentId.value}',
      );
      log('CONTROLLER: endCall() invoked from:\n${StackTrace.current}');

      _endCallInternal(reason: 'local_end', emitSocket: true);
    } catch (e) {
      log('CONTROLLER ERROR: Failed to end call - $e');
    }
  }

  void _endCallInternal({required String reason, required bool emitSocket}) {
    if (_isEnding) {
      return;
    }
    _isEnding = true;
    log('CONTROLLER: Call ended - cleaning up. reason=$reason');

    // Emit socket event to notify other party only when this is a local hangup.
    if (emitSocket && currentAppointmentId.value.isNotEmpty) {
      try {
        AgoraCallSocketHandler().emitEndCall(
          appointmentId: currentAppointmentId.value,
        );
      } catch (_) {
        // ignore
      }
    }

    isConnecting.value = false;
    isInCall.value = false;
    callStatus.value = 'ended';
    remoteUserId.value = 0;
    isRemoteVideoActive.value = false;
    isRemoteAudioActive.value = false;

    // IMPORTANT: Leave the Agora channel to allow reconnection
    _agoraSingleton.leaveChannel(reason: 'controller_end_call');

    _cleanup();

    _isEnding = false;
  }

  Future<void> toggleMicrophone() async {
    final bool nextEnabled = !isLocalMicActive.value;
    isLocalMicActive.value = nextEnabled;
    try {
      await _agoraSingleton.engine.muteLocalAudioStream(!nextEnabled);
      log('CONTROLLER: Microphone ${nextEnabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      // Revert UI state if engine call fails
      isLocalMicActive.value = !nextEnabled;
      log('CONTROLLER ERROR: Failed to toggle microphone - $e');
    }
  }

  Future<void> toggleCamera() async {
    final bool nextEnabled = !isLocalCameraActive.value;
    isLocalCameraActive.value = nextEnabled;
    try {
      await _agoraSingleton.engine.muteLocalVideoStream(!nextEnabled);
      // Some devices need local video enable/disable toggled too
      await _agoraSingleton.engine.enableLocalVideo(nextEnabled);
      if (nextEnabled) {
        await _agoraSingleton.engine.startPreview();
      }
      log('CONTROLLER: Camera ${nextEnabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      // Revert UI state if engine call fails
      isLocalCameraActive.value = !nextEnabled;
      log('CONTROLLER ERROR: Failed to toggle camera - $e');
    }
  }

  Future<void> toggleSpeaker() async {
    final bool nextEnabled = !isSpeakerOn.value;
    isSpeakerOn.value = nextEnabled;
    try {
      await _agoraSingleton.engine.setEnableSpeakerphone(nextEnabled);
      log('CONTROLLER: Speaker ${nextEnabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      // Revert UI state if engine call fails
      isSpeakerOn.value = !nextEnabled;
      log('CONTROLLER ERROR: Failed to toggle speaker - $e');
    }
  }

  void setRemoteUserId(int userId) {
    remoteUserId.value = userId;
    log('CONTROLLER: Remote user ID set to: $userId');
  }

  void _handleCallError(String error) {
    log('CONTROLLER ERROR: $error');
    errorMessage.value = error;
    isConnecting.value = false;
    isInCall.value = false;
    callStatus.value = 'ended';
  }

  void _cleanup() {
    log('CONTROLLER: Cleaning up resources');

    // Reset reactive variables
    isConnecting.value = false;
    isInCall.value = false;
    remoteUserId.value = 0;
    isRemoteVideoActive.value = false;
    isRemoteAudioActive.value = false;
    errorMessage.value = '';
    currentAppointmentId.value = '';

    // Dispose socket connection
    // Socket disposal handled by singleton
  }

  // Getters for convenience
  bool get isCallActive => isInCall.value;
  bool get isCallConnecting => isConnecting.value;
  String get currentCallStatus => callStatus.value;
  String get currentError => errorMessage.value;
  bool get hasError => errorMessage.value.isNotEmpty;

  // Event handler methods
  void handleJoinChannelSuccess(int uid) {
    log('[CONTROLLER] Joined channel successfully with uid: $uid');
    localUid.value = uid;
    isConnecting.value = false;
    isInCall.value = true;
    callStatus.value = 'connected';

    // IMPORTANT: Notify doctor via socket that patient joined with Agora uid
    try {
      if (!isDoctor.value &&
          currentAppointmentId.value.isNotEmpty &&
          uid != 0) {
        AgoraCallSocketHandler().emitJoinCall(
          appointmentId: currentAppointmentId.value,
          patientAgoraId: uid,
        );
      }
    } catch (e) {
      log('[CONTROLLER] Failed to emitJoinCall: $e');
    }
  }

  void handleUserJoined(int uid) {
    log('[CONTROLLER] Remote user joined: $uid');
    remoteUserId.value = uid;
    isRemoteAudioActive.value = true;
    // Some devices/SDK versions don't reliably emit onRemoteVideoStateChanged
    // for the first remote frame. Mark as active on join to avoid the UI
    // overlay hiding the remote view.
    isRemoteVideoActive.value = true;

    // If remote joined, we can consider the call active.
    if (!isInCall.value) {
      isInCall.value = true;
      callStatus.value = 'in_call';
    }
  }

  void handleUserOffline(int uid) {
    log('[CONTROLLER] Remote user left: $uid');

    // Always clear remote media state if we were in a call.
    if (remoteUserId.value == uid || remoteUserId.value == 0) {
      remoteUserId.value = 0;
    }
    isRemoteAudioActive.value = false;
    isRemoteVideoActive.value = false;

    // If doctor disconnects at any stage, end call so patient doesn't get stuck.
    if (!isDoctor.value && (isInCall.value || isConnecting.value)) {
      _endCallInternal(reason: 'agora_user_offline', emitSocket: false);
    }
  }

  void handleRemoteVideoStateChanged(
    int remoteUid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
  ) {
    log(
      '[CONTROLLER] Remote video state changed: uid=$remoteUid, state=$state, reason=$reason',
    );

    // Fallback: on some SDK/device combinations, if the remote user was already
    // present in the channel when we joined, onUserJoined may not be emitted.
    // In that case, onRemoteVideoStateChanged is the earliest reliable signal.
    if (remoteUserId.value == 0 && remoteUid != 0) {
      remoteUserId.value = remoteUid;
      isRemoteAudioActive.value = true;
    }

    if (remoteUserId.value == remoteUid) {
      // Update remote video active state based on video state
      // Using string comparison to avoid enum dependency issues
      final stateString = state.toString();
      if (stateString.contains('Playing') || stateString.contains('Decoding')) {
        isRemoteVideoActive.value = true;
        log('[CONTROLLER] Remote video is now active');
      } else if (stateString.contains('Stopped') ||
          stateString.contains('Frozen') ||
          stateString.contains('Failed')) {
        isRemoteVideoActive.value = false;
        log('[CONTROLLER] Remote video is now inactive');
      } else {
        log('[CONTROLLER] Unknown remote video state: $stateString');
      }
    }
  }

  void handleError(String error) {
    log('[CONTROLLER] Error: $error');
    errorMessage.value = error;
    if (!isDoctor.value && (isInCall.value || isConnecting.value)) {
      _endCallInternal(reason: 'agora_error', emitSocket: false);
    } else {
      isConnecting.value = false;
      isInCall.value = false;
      callStatus.value = 'error';
    }
  }
}
