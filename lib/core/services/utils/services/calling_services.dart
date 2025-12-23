// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../features/agora_call/view/agora_call_screen.dart';
import '../handlers/agora_call_socket_handler.dart';
import '../keys/shared_pref_keys.dart';

class CallService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  final AgoraCallSocketHandler _socketHandler = AgoraCallSocketHandler();
  String _currentAppointmentId = '';
  String _currentName = '';
  String? _currentImage = '';

  Future<bool> _canReceiveCallForAppointment(String appointmentId) async {
    try {
      if (appointmentId.trim().isEmpty) return false;
      final prefs = await SharedPreferences.getInstance();
      final pastIds = prefs.getStringList('past_appointment_ids') ?? const [];
      if (pastIds.contains(appointmentId)) return false;

      final prescribedIds =
          prefs.getStringList('prescribed_appointment_ids') ?? const [];
      if (prescribedIds.contains(appointmentId)) return false;

      // Requirement: allow calls as long as appointment is not past.
      // Do not block based on active list because it can be stale.
      return true;
    } catch (e) {
      log('CALL SERVICE: _canReceiveCallForAppointment error: $e');
      return true;
    }
  }

  Future<void> showIncomingCall({
    required String name,
    required String? image,
    required String appointmentId,
    BuildContext? context,
  }) async {
    try {
      final canReceive = await _canReceiveCallForAppointment(appointmentId);
      if (!canReceive) {
        log(
          'CALL SERVICE: Ignoring incoming call because appointment is past/not-active: $appointmentId',
        );
        return;
      }

      log(
        'CALL SERVICE: Showing incoming call for appointment: $appointmentId',
      );

      _currentAppointmentId = appointmentId;
      _currentName = name;
      _currentImage = image;

      // Store call data in shared preferences
      await _storeCallData(
        name: name,
        image: image,
        appointmentId: appointmentId,
      );

      // Show CallKit incoming call
      await _showCallKitIncoming(name: name, appointmentId: appointmentId);

      // Initialize socket connection
      await _initializeSocket(appointmentId);
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to show incoming call - $e');
    }
  }

  Future<void> _storeCallData({
    required String name,
    required String? image,
    required String appointmentId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKeys.incomingCallName, name);
      await prefs.setString(
        SharedPrefKeys.incomingCallAppointmentId,
        appointmentId,
      );
      if (image != null) {
        await prefs.setString(SharedPrefKeys.incomingCallImage, image);
      }
      log('CALL SERVICE: Call data stored in preferences');
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to store call data - $e');
    }
  }

  Future<void> _showCallKitIncoming({
    required String name,
    required String appointmentId,
  }) async {
    try {
      log('CALL SERVICE: Showing CallKit incoming call');

      final callKitParams = CallKitParams(
        id: appointmentId,
        nameCaller: name,
        appName: 'Eye Buddy',
        avatar: _currentImage,
        handle: appointmentId,
        type: 0,
        duration: 30000,
        textAccept: 'Accept',
        textDecline: 'Decline',
        missedCallNotification: NotificationParams(
          showNotification: true,
          isShowCallback: false,
          subtitle: 'Missed call from $name',
          callbackText: 'Call back',
        ),
        extra: <String, dynamic>{'appointmentId': appointmentId},
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: 'Incoming Call',
          missedCallNotificationChannelName: 'Missed Call',
        ),
        ios: const IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          ringtonePath: 'system_ringtone_default',
        ),
      );

      await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
      log('CALL SERVICE: CallKit incoming call shown');
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to show CallKit - $e');
    }
  }

  Future<void> _initializeSocket(String appointmentId) async {
    try {
      log('CALL SERVICE: Initializing socket for incoming call');

      await _socketHandler.initSocket(
        appointmentId: appointmentId,
        onJoinedEvent: () {
          log('CALL SERVICE: Doctor joined the call');
        },
        onRejectedEvent: () {
          log('CALL SERVICE: Call was rejected');
          _handleCallRejected();
        },
        onEndedEvent: () {
          log('CALL SERVICE: Call ended');
          _handleCallEnded();
        },
      );
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to initialize socket - $e');
    }
  }

  Future<void> acceptCall(BuildContext context) async {
    try {
      log(
        'CALL SERVICE: Accepting call for appointment: $_currentAppointmentId',
      );

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Navigate to call screen
      if (context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgoraCallScreen(
              name: _currentName,
              image: _currentImage,
              callId: _currentAppointmentId,
            ),
          ),
        );
      }
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to accept call - $e');
    }
  }

  Future<void> rejectCall() async {
    try {
      log(
        'CALL SERVICE: Rejecting call for appointment: $_currentAppointmentId',
      );

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Notify socket
      _socketHandler.emitRejectCall(appointmentId: _currentAppointmentId);

      // Clear call data
      await _clearCallData();
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to reject call - $e');
    }
  }

  Future<void> endCall() async {
    try {
      log('CALL SERVICE: Ending call for appointment: $_currentAppointmentId');

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Notify socket
      _socketHandler.emitEndCall(appointmentId: _currentAppointmentId);

      // Clear call data
      await _clearCallData();
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to end call - $e');
    }
  }

  Future<void> _handleCallRejected() async {
    try {
      log('CALL SERVICE: Handling call rejection');

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Clear call data
      await _clearCallData();
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to handle call rejection - $e');
    }
  }

  Future<void> _handleCallEnded() async {
    try {
      log('CALL SERVICE: Handling call end');

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Clear call data
      await _clearCallData();
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to handle call end - $e');
    }
  }

  Future<void> _clearCallData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPrefKeys.incomingCallName);
      await prefs.remove(SharedPrefKeys.incomingCallAppointmentId);
      await prefs.remove(SharedPrefKeys.incomingCallImage);

      _currentAppointmentId = '';
      _currentName = '';
      _currentImage = null;

      log('CALL SERVICE: Call data cleared');
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to clear call data - $e');
    }
  }

  Future<void> dispose() async {
    try {
      log('CALL SERVICE: Disposing call service');

      // Close CallKit UI
      await FlutterCallkitIncoming.endAllCalls();

      // Dispose socket
      _socketHandler.disposeSocket();

      // Clear data
      await _clearCallData();
    } catch (e) {
      log('CALL SERVICE ERROR: Failed to dispose call service - $e');
    }
  }
}

// Global function for backward compatibility
Future<void> ShowCaller({
  required String name,
  required String? image,
  required String appointmentId,
  BuildContext? context,
}) async {
  await CallService().showIncomingCall(
    name: name,
    image: image,
    appointmentId: appointmentId,
    context: context,
  );
}
