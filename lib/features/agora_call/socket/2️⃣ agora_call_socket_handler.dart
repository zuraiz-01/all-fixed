class AgoraCallSocketHandler {
  void initSocket({
    required String appointmentId,
    Function()? onJoined,
    Function()? onRejected,
    Function()? onEnded,
  }) {
    // connect socket
  }

  void emitRejectCall({required String appointmentId}) {}
  void emitEndCall({required String appointmentId}) {}
}
