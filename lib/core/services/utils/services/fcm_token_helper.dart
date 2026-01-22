import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../keys/token_keys.dart';

Future<String?> ensureFcmToken({
  bool forceRefresh = false,
  int maxAttempts = 5,
  Duration retryDelay = const Duration(seconds: 2),
}) async {
  final existingToken = userDeviceToken.trim().isNotEmpty
      ? userDeviceToken.trim()
      : pushNotificationTokenKey.trim();
  if (!forceRefresh && existingToken.isNotEmpty) {
    return existingToken;
  }

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    var apnsReady = true;
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null && apnsToken.isNotEmpty) {
        apnsDeviceToken = apnsToken;
      } else {
        apnsReady = false;
        if (kDebugMode) {
          developer.log(
            '[TOKEN] APNs token not ready (attempt $attempt/$maxAttempts)',
          );
        }
      }
    }

    if (!apnsReady && attempt < maxAttempts) {
      await Future.delayed(retryDelay);
      continue;
    }

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && fcmToken.trim().isNotEmpty) {
      pushNotificationTokenKey = fcmToken;
      userDeviceToken = fcmToken;
      return fcmToken;
    }

    if (kDebugMode) {
      developer.log(
        '[TOKEN] FCM token empty (attempt $attempt/$maxAttempts)',
      );
    }
    if (attempt < maxAttempts) {
      await Future.delayed(retryDelay);
    }
  }

  return null;
}
