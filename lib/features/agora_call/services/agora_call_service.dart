import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

import '../../../core/services/api/service/api_constants.dart';

class AgoraCallService extends GetxService {
  static AgoraCallService get to => Get.find();

  IO.Socket? socket;

  // Callbacks for socket events
  Function()? onJoinedEvent;
  Function()? onRejectedEvent;
  Function()? onEndedEvent;

  @override
  void onInit() {
    super.onInit();
    log('AGORA SERVICE: Service initialized');
  }

  @override
  void onClose() {
    log('AGORA SERVICE: Service closing');
    disposeSocket();
    super.onClose();
  }

  Future<void> initSocket({
    required String appointmentId,
    Function()? onJoinedEvent,
    Function()? onRejectedEvent,
    Function()? onEndedEvent,
  }) async {
    try {
      log('AGORA SERVICE: Initializing socket for appointment: $appointmentId');

      // Store callbacks
      this.onJoinedEvent = onJoinedEvent;
      this.onRejectedEvent = onRejectedEvent;
      this.onEndedEvent = onEndedEvent;

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
        log('AGORA SERVICE: Socket connected successfully');
        _joinAppointmentRoom(appointmentId);
        _setupEventListeners();
      });

      socket?.onConnectError((error) {
        log('AGORA SERVICE ERROR: Socket connection failed - $error');
      });

      socket?.onDisconnect((_) {
        log('AGORA SERVICE: Socket disconnected');
      });

      socket?.onError((error) {
        log('AGORA SERVICE ERROR: Socket error - $error');
      });
    } catch (e) {
      log('AGORA SERVICE ERROR: Failed to initialize socket - $e');
    }
  }

  void _joinAppointmentRoom(String appointmentId) {
    log('AGORA SERVICE: Joining appointment room - $appointmentId');
    socket?.emit('joinAppointmentRoom', {"appointmentId": appointmentId});
  }

  void _setupEventListeners() {
    // Listen for call-joined events
    socket?.on('call-joined', (data) {
      log('AGORA SERVICE: Call joined event received - $data');
      onJoinedEvent?.call();
    });

    // Listen for doctor joining the call
    socket?.on('joinedCall', (data) {
      log('AGORA SERVICE: Doctor joined call - $data');
      onJoinedEvent?.call();
    });

    // Listen for call rejection
    socket?.on('rejectCall', (data) {
      log('AGORA SERVICE: Call rejected - $data');
      onRejectedEvent?.call();
    });

    // Listen for call end
    socket?.on('endCall', (data) {
      log('AGORA SERVICE: Call ended - $data');
      onEndedEvent?.call();
    });
  }

  void emitCallJoined({required String callId}) {
    log('AGORA SERVICE: Emitting call-joined event for callId: $callId');
    socket?.emit('call-joined', {"callId": callId, "status": "joined"});
  }

  void emitJoinCall({
    required String appointmentId,
    required int patientAgoraId,
  }) {
    log(
      'AGORA SERVICE: Emitting joinedCall for appointment: $appointmentId, agoraId: $patientAgoraId',
    );
    socket?.emit('joinedCall', {
      "appointmentId": appointmentId,
      "patientAgoraId": patientAgoraId,
    });
  }

  void emitRejectCall({required String appointmentId}) {
    log('AGORA SERVICE: Emitting rejectCall for appointment: $appointmentId');
    socket?.emit('rejectCall', {"appointmentId": appointmentId});
  }

  void emitEndCall({required String appointmentId}) {
    log('AGORA SERVICE: Emitting endCall for appointment: $appointmentId');
    socket?.emit('endCall', {"appointmentId": appointmentId});
  }

  Future<void> disposeSocket() async {
    try {
      log('AGORA SERVICE: Disposing socket connection');

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

      log('AGORA SERVICE: Socket disposed successfully');
    } catch (e) {
      log('AGORA SERVICE ERROR: Failed to dispose socket - $e');
    }
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }
}
