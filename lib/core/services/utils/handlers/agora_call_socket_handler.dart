import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api/service/api_constants.dart';

class AgoraCallSocketHandler {
  factory AgoraCallSocketHandler() => _instance;
  AgoraCallSocketHandler._internal();
  static final AgoraCallSocketHandler _instance =
      AgoraCallSocketHandler._internal();

  IO.Socket? socket;

  Future<void> initSocket({
    required String appointmentId,
    required Function onJoinedEvent,
    required Function onRejectedEvent,
    required Function onEndedEvent,
  }) async {
    try {
      log("SOCKET: Initializing socket for appointment: $appointmentId");

      // Dispose existing socket if any
      if (socket != null) {
        await disposeSocket();
      }

      // Create new socket connection
      socket = IO.io(ApiConstants.baseUrl, <String, dynamic>{
        'path': '/socket',
        'autoConnect': false,
        'transports': ['websocket'],
      });

      // Connect to socket
      socket?.connect();

      // Handle connection events
      socket?.onConnect((_) {
        log("SOCKET: Connected successfully");
        _joinAppointmentRoom(appointmentId);
        _setupEventListeners(onJoinedEvent, onRejectedEvent, onEndedEvent);
      });

      socket?.onConnectError((error) {
        log("SOCKET ERROR: Connection failed - $error");
      });

      socket?.onDisconnect((_) {
        log("SOCKET: Disconnected");
      });

      socket?.onError((error) {
        log("SOCKET ERROR: $error");
      });
    } catch (e) {
      log("SOCKET ERROR: Failed to initialize socket - $e");
    }
  }

  void _joinAppointmentRoom(String appointmentId) {
    log("SOCKET: Joining appointment room - $appointmentId");
    socket?.emit('joinAppointmentRoom', {"appointmentId": appointmentId});
  }

  void _setupEventListeners(
    Function onJoinedEvent,
    Function onRejectedEvent,
    Function onEndedEvent,
  ) {
    // Listen for call-joined events
    socket?.on('call-joined', (data) {
      log("SOCKET: Call joined event received - $data");
      onJoinedEvent();
    });

    // Listen for doctor joining the call
    socket?.on('joinedCall', (data) {
      log("SOCKET: Doctor joined call - $data");
      onJoinedEvent();
    });

    // Listen for call rejection
    socket?.on('rejectCall', (data) {
      log("SOCKET: Call rejected - $data");
      onRejectedEvent();
    });

    // Listen for call end
    socket?.on('endCall', (data) {
      log("SOCKET: Call ended - $data");
      onEndedEvent();
    });
  }

  void emitCallJoined({required String callId}) {
    log("SOCKET: Emitting call-joined event for callId: $callId");
    socket?.emit('call-joined', {"callId": callId, "status": "joined"});
  }

  void emitJoinCall({
    required String appointmentId,
    required int patientAgoraId,
  }) {
    log(
      "SOCKET: Emitting joinedCall for appointment: $appointmentId, agoraId: $patientAgoraId",
    );
    socket?.emit('joinedCall', {
      "appointmentId": appointmentId,
      "patientAgoraId": patientAgoraId,
    });
  }

  void emitRejectCall({required String appointmentId}) {
    log("SOCKET: Emitting rejectCall for appointment: $appointmentId");
    socket?.emit('rejectCall', {"appointmentId": appointmentId});
  }

  void emitEndCall({required String appointmentId}) {
    log("SOCKET: Emitting endCall for appointment: $appointmentId");
    socket?.emit('endCall', {"appointmentId": appointmentId});
  }

  Future<void> disposeSocket() async {
    try {
      log("SOCKET: Disposing socket connection");

      if (socket != null) {
        // Remove all listeners
        socket?.off('call-joined');
        socket?.off('joinedCall');
        socket?.off('rejectCall');
        socket?.off('endCall');

        // Disconnect socket
        if (socket!.connected) {
          socket?.disconnect();
        }

        // Dispose socket
        socket?.dispose();
        socket = null;
      }

      log("SOCKET: Socket disposed successfully");
    } catch (e) {
      log("SOCKET ERROR: Failed to dispose socket - $e");
    }
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }
}
