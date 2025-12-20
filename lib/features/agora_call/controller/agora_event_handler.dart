import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:eye_buddy/features/agora_call/controller/agora_call_controller.dart';
import 'package:eye_buddy/features/agora_call/controller/call_controller.dart';

class AgoraEventHandler {
  static const String _tag = 'AGORA EVENT';
  AgoraCallController _agoraCallController = AgoraCallController.to;

  void onJoinChannelSuccess(RtcConnection connection, int elapsed) {
    log(
      '[$_tag] onJoinChannelSuccess: uid=${connection.localUid}, channel=${connection.channelId}, elapsed=$elapsed',
    );
  }

  void onUserJoined(RtcConnection connection, int remoteUid, int elapsed) {
    _agoraCallController.remoteUserId.value = remoteUid;
    log(
      '[$_tag] onUserJoined: remoteUid=$remoteUid, channel=${connection.channelId}, elapsed=$elapsed',
    );
  }

  void onUserOffline(
    RtcConnection connection,
    int remoteUid,
    UserOfflineReasonType reason,
  ) {
    log(
      '[$_tag] onUserOffline: remoteUid=$remoteUid, channel=${connection.channelId}, reason=$reason',
    );
  }

  void onConnectionStateChanged(
    RtcConnection connection,
    ConnectionStateType state,
    ConnectionChangedReasonType reason,
  ) {
    log(
      '[$_tag] onConnectionStateChanged: state=$state, reason=$reason, channel=${connection.channelId}',
    );
  }

  void onTokenPrivilegeWillExpire(RtcConnection connection, String token) {
    log('[$_tag] onTokenPrivilegeWillExpire: channel=${connection.channelId}');
  }

  void onError(int err, String msg) {
    log('[$_tag] onError: err=$err, msg=$msg');
  }
}
