import 'dart:developer';

import 'package:eye_buddy/app/bloc/agora_call_cubit/agora_call_events/agora_call_events_cubit.dart';
import 'package:eye_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/service/api_constants.dart';
import '../../views/agora_call_room/agora_call_room_screen.dart';
import '../../views/global_widgets/toast.dart';
import '../handlers/agora_call_socket_handler.dart';
import '../keys/shared_pref_keys.dart';
import 'navigator_services.dart';

ShowCaller({
  // required Doctor doctor,
  BuildContext? context,
  required String name,
  required String? image,
  required String appointmentId,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  AgoraCallSocketHandler().initSocket(
    appintId: appointmentId,
    onJoinedEvent: () {},
    onRejectedEvent: () {},
    onEndedEvent: () {},
  );
  if (context != null) {
    // AgoraCallSocketHandler().initSocket(
    //   appintId: prefs
    //       .getString(
    //         agoraChannelId,
    //       )
    //       .toString(),
    //   onJoinedEvent: () {
    //     context.read<AgoraCallEventsCubit>().emitJoinedEvent();
    //   },
    //   onRejectedEvent: () {
    //     context.read<AgoraCallEventsCubit>().emitRejectedEvent();
    //   },
    //   onEndedEvent: () {
    //     context.read<AgoraCallEventsCubit>().emitEndedEvent();
    //   },
    // );
  }
  CallKitParams callKitParams = CallKitParams(
    id: appointmentId,
    nameCaller: name,
    appName: 'Eye Buddy',
    avatar: ApiConstants.baseUrl + "${image ?? ""}",
    handle: "Eye Buddy",
    type: 0,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: NotificationParams(
      showNotification: false,
      isShowCallback: false,
      subtitle: "",
      callbackText: 'Call back',
    ),
    duration: 30000,
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: AndroidParams(
      isCustomNotification: false,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#008541',
      backgroundUrl:
          ApiConstants.baseUrl + (prefs.getString(agoraDocPhoto) ?? ""),
      actionColor: '#4CAF50',
      incomingCallNotificationChannelName: "Incoming Call",
      missedCallNotificationChannelName: "Missed Call",
    ),
    ios: IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'generic',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );

  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
    log("CustomTag Triggered");
    switch (event!.event) {
      case Event.actionCallAccept:
        log("CustomTag Accepted");
        await prefs.setBool(isCallAccepted, true);
        await prefs.setString(agoraDocName, name);
        await prefs.setString(agoraDocPhoto, image!);
        await prefs.setString(agoraChannelId, appointmentId);
        log("CustomTag Accepted: ${prefs.getBool(isCallAccepted)}");

        // NavigatorServices().to(
        //   context: context!,
        //   widget: AgoraCallScreen(
        //     name: name,
        //     image: image,
        //     appointmentId: appointmentId,
        //   ),
        // );
        break;
      case Event.actionCallDecline:
        log("CustomTag declined");
        AgoraCallSocketHandler().emitRejectCall(appintId: appointmentId);
        prefs.setString(criteria, "");
        break;
      case Event.actionCallIncoming:
        log("CustomTag incoming call");
        break;
      case Event.actionCallStart:
        log("CustomTag action call start");
        break;
      case Event.actionCallEnded:
        log("CustomTag call ended");
        prefs.setString(criteria, "");
        break;
      case Event.actionCallTimeout:
        log("CustomTag call timeout");
        AgoraCallSocketHandler().emitRejectCall(
            appintId: prefs
                .getString(
                  agoraChannelId,
                )
                .toString());
        prefs.setString(criteria, "");
        break;
      case Event.actionCallCallback:
        log("CustomTag call callback");
        break;
      case Event.actionCallToggleHold:
        log("CustomTag hold");
        break;
      case Event.actionCallToggleMute:
        log("CustomTag mute");
        break;
      case Event.actionCallToggleDmtf:
        log("CustomTag dmtf");
        break;
      case Event.actionCallToggleGroup:
        log("CustomTag toogle group");
        break;
      case Event.actionCallToggleAudioSession:
        log("CustomTag audio session");
        break;
      case Event.actionDidUpdateDevicePushTokenVoip:
        log("CustomTag pushToken voip");
        break;
      case Event.actionCallCustom:
        log("CustomTag call custom");
        break;
    }
  });
  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
}
