import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../api/service/api_constants.dart';

class AgoraCallSocketHandler {
  factory AgoraCallSocketHandler() => _instance;
  AgoraCallSocketHandler._internal();
  static final AgoraCallSocketHandler _instance =
      AgoraCallSocketHandler._internal();

  IO.Socket? socket;
  String _activeAppointmentId = '';

  Future<void> initSocket({
    required String appointmentId,
    required Function onJoinedEvent,
    required Function onRejectedEvent,
    required Function onEndedEvent,
  }) async {
    try {
      log("SOCKET: Initializing socket for appointment: $appointmentId");

      if (socket != null &&
          _activeAppointmentId.isNotEmpty &&
          _activeAppointmentId == appointmentId) {
        try {
          socket?.off('call-joined');
          socket?.off('joinedCall');
          socket?.off('rejectCall');
          socket?.off('endCall');
          socket?.off('connect');
          socket?.off('connect_error');
          socket?.off('disconnect');
          socket?.off('error');
        } catch (_) {
          // ignore
        }

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
          try {
            if (_activeAppointmentId.isNotEmpty &&
                _activeAppointmentId == appointmentId) {
              onEndedEvent();
            }
          } catch (_) {
            // ignore
          }
        });

        socket?.onError((error) {
          log("SOCKET ERROR: $error");
        });

        if (socket?.connected ?? false) {
          _joinAppointmentRoom(appointmentId);
          _setupEventListeners(onJoinedEvent, onRejectedEvent, onEndedEvent);
        } else {
          socket?.connect();
        }
        return;
      }

      if (socket != null) {
        await disposeSocket();
      }

      _activeAppointmentId = appointmentId;

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
        try {
          if (_activeAppointmentId.isNotEmpty &&
              _activeAppointmentId == appointmentId) {
            onEndedEvent();
          }
        } catch (_) {
          // ignore
        }
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
    // Catch-all logger for socket events (helps diagnose backend event names).
    // Uses dynamic invocation so it won't break if onAny() isn't available.
    try {
      final dynamic s = socket;
      s.onAny((dynamic event, dynamic data) {
        try {
          final eventName = (event ?? '').toString();
          log('SOCKET: [onAny] event=$eventName data=$data');

          final lower = eventName.toLowerCase();
          if (lower.contains('reject') ||
              lower.contains('decline') ||
              lower.contains('cancel')) {
            onRejectedEvent();
          } else if (lower.contains('end') || lower.contains('hangup')) {
            onEndedEvent();
          }
        } catch (_) {
          // ignore
        }
      });
    } catch (_) {
      // ignore
    }

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

    socket?.on('declineCall', (data) {
      log("SOCKET: Call declined - $data");
      onRejectedEvent();
    });

    // Some backends emit different rejection/cancel event names
    socket?.on('cancelCall', (data) {
      log("SOCKET: Call cancelled - $data");
      onRejectedEvent();
    });

    socket?.on('call-cancelled', (data) {
      log("SOCKET: Call cancelled (call-cancelled) - $data");
      onRejectedEvent();
    });

    // Listen for call end
    socket?.on('endCall', (data) {
      log("SOCKET: Call ended - $data");
      onEndedEvent();
    });

    socket?.on('hangup', (data) {
      log("SOCKET: Call hangup - $data");
      onEndedEvent();
    });

    // Some backends emit different end event names
    socket?.on('callEnded', (data) {
      log("SOCKET: Call ended (callEnded) - $data");
      onEndedEvent();
    });

    socket?.on('call-ended', (data) {
      log("SOCKET: Call ended (call-ended) - $data");
      onEndedEvent();
    });

    socket?.on('endedCall', (data) {
      log("SOCKET: Call ended (endedCall) - $data");
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
        socket?.off('cancelCall');
        socket?.off('call-cancelled');
        socket?.off('endCall');
        socket?.off('callEnded');
        socket?.off('call-ended');
        socket?.off('endedCall');

        // Disconnect socket
        if (socket!.connected) {
          socket?.disconnect();
        }

        // Dispose socket
        socket?.dispose();
        socket = null;
      }

      _activeAppointmentId = '';

      log("SOCKET: Socket disposed successfully");
    } catch (e) {
      log("SOCKET ERROR: Failed to dispose socket - $e");
    }
  }

  bool isConnected() {
    return socket?.connected ?? false;
  }
}
