import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api/service/api_constants.dart';

class AgoraCallSocketHandler {
  factory AgoraCallSocketHandler() => _subscriptionServices;
  AgoraCallSocketHandler._internal();
  static final AgoraCallSocketHandler _subscriptionServices =
      AgoraCallSocketHandler._internal();
  IO.Socket? socket;

  Future<void> initSocket({
    required String appintId,
    required Function onJoinedEvent,
    required Function onRejectedEvent,
    required Function onEndedEvent,
  }) async {
    socket = IO.io(
      ApiConstants.baseUrl,
      <String, dynamic>{
        'path': '/socket',
        'autoConnect': false,
        'transports': ['websocket'], //polling or websocket
      },
    );
    await socket?.connect();
    socket?.onConnect((_) {
      log('Socket Connection established');
      socket?.emit(
        'joinAppointmentRoom',
        {
          "appointmentId": appintId,
        },
      );

      socket?.on('joinedCall', (data) {
        onJoinedEvent();
        log("Socket joinedCall - received data: $data");
      });
      socket?.on('rejectCall', (data) {
        onRejectedEvent();
        log("Socket rejectCall - received data: $data");
      });
      socket?.on('endCall', (data) {
        onEndedEvent();
        log("Socket endCall - received data: $data");
      });

      log("Socket initialized with appointment id: ${appintId}");

      socket?.onDisconnect((_) => log('Socket Connection Disconnection'));
      socket?.onConnectError((err) => log('Socket onConnectError $err'));
      socket?.onError((err) => log('Socket onError $err'));
    });
    return;
  }

  disposeSocket() {
    socket?.disconnect();
    // socket?.dispose();
    if (socket!.disconnected) {
      log("Socket disconnected");
    }
  }

  emitEndCall({
    required String appintId,
  }) {
    socket?.emit(
      'endCall',
      {
        "appointmentId": appintId,
      },
    );
    log("Socket Emitting endCall");
    log("Socket Appointment id: ${appintId}");
  }

  emitJoinCall({
    required String appintId,
    required int patientAgoraId,
  }) {
    socket?.emit(
      'joinedCall',
      {
        "appointmentId": appintId,
        "remoteUID": patientAgoraId,
      },
    );
    log("Socket Emitting joinCall");
    log("Socket Appointment id: ${appintId}");
  }

  emitRejectCall({
    required String appintId,
  }) {
    socket?.emit(
      'rejectCall',
      {
        "appointmentId": appintId,
      },
    );
    log("Socket Rejecting call...");
    log("Socket Appointment id: ${appintId}");
  }
}
