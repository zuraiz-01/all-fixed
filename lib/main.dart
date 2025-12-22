import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:display_metrics/display_metrics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eye_buddy/firebase_options.dart'
    if (dart.library.html) 'package:eye_buddy/firebase_options_web.dart';

// App Controllers
import 'package:eye_buddy/core/controler/app_state_controller.dart';

// Views
import 'package:eye_buddy/core/services/utils/services/calling_services.dart';
import 'package:eye_buddy/core/services/utils/notification_utils.dart';
import 'package:eye_buddy/features/agora_call/controller/call_controller.dart';
import 'package:eye_buddy/features/agora_call/controller/agora_call_controller.dart';
import 'package:eye_buddy/features/agora_call/controller/agora_singleton.dart';
import 'package:eye_buddy/features/agora_call/services/agora_call_service.dart';
import 'package:eye_buddy/features/reason_for_visit/view/appointment_overview_screen.dart';
import 'package:eye_buddy/features/payment_gateway/view/payment_gateway_screen.dart';
import 'package:eye_buddy/features/waiting_for_doctor/view/waiting_for_doctor_screen.dart';
import 'package:eye_buddy/features/splash/view/splash_screen.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:eye_buddy/features/eye_test/controller/eye_test_controller.dart';

// THEME
import 'package:eye_buddy/core/services/utils/config/theme.dart';

// LOCALIZATION
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';

import 'package:eye_buddy/core/services/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/core/services/utils/keys/token_keys.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eye_buddy/core/services/utils/string_to_map.dart';

Future<void> _firebasePushNotificationOnBackgroundMessageHandler(
  RemoteMessage message,
) async {
  print("Background notification received: ${message.toMap()}");
  print("Raw message.data: ${message.data}");
  log('sending background');
  await Firebase.initializeApp();

  final Map<String, dynamic> firebasePayload = stringToMap(
    message.data['meta'] as String,
  );
  print("Parsed firebasePayload: $firebasePayload");
  log('Firebase Data: ${firebasePayload['criteria']}');

  // Show local notification via AwesomeNotifications
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'Eyebuddy',
      body: message.notification?.body ?? '',
      payload: message.data.map((k, v) => MapEntry(k, '$v')),
    ),
  );

  switch (firebasePayload['criteria']) {
    case 'appointment':
      if ((firebasePayload['title'] as String).toLowerCase().contains(
        'calling'.toLowerCase(),
      )) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(criteria, 'appointment');
        log(
          "Background Notification: ${firebasePayload['metaData']['doctor']}",
        );

        ShowCaller(
          name: firebasePayload['metaData']['doctor']['name'] as String,
          image: firebasePayload['metaData']['doctor']['photo'] as String?,
          appointmentId: firebasePayload['metaData']['_id'] as String,
        );
      }
      break;
    case 'c':
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(criteria, 'prescription');
      log('click noti main screen ${message.data.toString()}');
      break;
    default:
      log('Received a push notification');
  }
}

Future<void> _firebasePushNotificationOnForegroundMessageHandler(
  RemoteMessage message,
) async {
  print("Foreground notification received (global): ${message.toMap()}");
  print("Raw message.data (global): ${message.data}");
  log('sending foreground (global handler)');

  final Map<String, dynamic> firebasePayload = stringToMap(
    message.data['meta'] as String,
  );
  print("Parsed firebasePayload (global): $firebasePayload");
  log('Firebase Data (global): ${firebasePayload['criteria']}');

  // Show local notification via AwesomeNotifications
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'Eyebuddy',
      body: message.notification?.body ?? '',
      payload: message.data.map((k, v) => MapEntry(k, '$v')),
    ),
  );

  switch (firebasePayload['criteria']) {
    case 'appointment':
      if ((firebasePayload['title'] as String).toLowerCase().contains(
        'calling'.toLowerCase(),
      )) {
        try {
          if (Get.isRegistered<AgoraSingleton>()) {
            final agora = AgoraSingleton.to;
            if (agora.isInCall.value || agora.isConnecting.value) {
              log(
                'MAIN NOTIFICATION: Ignoring calling notification because call is already active/connecting',
              );
              return;
            }
          }
        } catch (_) {
          // ignore
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(criteria, 'appointment');
        log(
          "Foreground Notification (global): ${firebasePayload['metaData']['doctor']}",
        );

        // Extract and save Agora credentials for call
        final appointmentId =
            firebasePayload['metaData']['_id'] as String? ?? '';

        // Try multiple possible token fields from notification
        final patientToken =
            firebasePayload['metaData']['patientAgoraToken'] as String? ??
            firebasePayload['metaData']['agoraToken'] as String? ??
            firebasePayload['metaData']['token'] as String? ??
            '';

        final doctorToken =
            firebasePayload['metaData']['doctorAgoraToken'] as String? ?? '';

        final channelId =
            firebasePayload['metaData']['channelId'] as String? ??
            firebasePayload['metaData']['agoraChannelId'] as String? ??
            appointmentId; // fallback to appointmentId

        log('MAIN NOTIFICATION: appointmentId → "$appointmentId"');
        log('MAIN NOTIFICATION: patientToken → "$patientToken"');
        log('MAIN NOTIFICATION: doctorToken → "$doctorToken"');
        log('MAIN NOTIFICATION: channelId → "$channelId"');

        // Start call even without token (will use existing tokens from SharedPreferences)
        if (appointmentId.isNotEmpty) {
          try {
            if (patientToken.isNotEmpty) {
              await prefs.setString('patient_agora_token', patientToken);
            } else {
              log(
                'MAIN NOTIFICATION: patientToken is empty - will not overwrite stored token',
              );
            }

            // Use channelId if available, otherwise use appointmentId as fallback
            final finalChannelId = channelId.isNotEmpty
                ? channelId
                : appointmentId;
            if (finalChannelId.isNotEmpty) {
              await prefs.setString('agora_channel_id', finalChannelId);
              log('MAIN NOTIFICATION: Saved channel ID → "$finalChannelId"');
            }

            // Also save appointment-specific tokens
            if (patientToken.isNotEmpty) {
              await prefs.setString(
                'patient_agora_token_$appointmentId',
                patientToken,
              );
            }

            if (doctorToken.isNotEmpty) {
              await prefs.setString('doctor_agora_token', doctorToken);
              await prefs.setString(
                'doctor_agora_token_$appointmentId',
                doctorToken,
              );
            }
            await prefs.setString(
              'agora_channel_id_$appointmentId',
              finalChannelId,
            );

            log(
              'MAIN NOTIFICATION: Saved Agora credentials to SharedPreferences',
            );
          } catch (e) {
            log('MAIN NOTIFICATION ERROR: Failed to save token - $e');
          }

          // Open in-app incoming call screen
          try {
            final doctorName =
                firebasePayload['metaData']['doctor']['name'] as String? ??
                'BEH - DOCTOR';
            final doctorPhoto =
                firebasePayload['metaData']['doctor']['photo'] as String?;
            CallController.to.showIncomingCall(
              appointmentId: appointmentId,
              doctorName: doctorName,
              doctorPhoto: doctorPhoto,
            );
          } catch (e) {
            log(
              'MAIN NOTIFICATION ERROR: Failed to open incoming call UI - $e',
            );
          }
        }
      }
      break;
    case 'c':
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(criteria, 'prescription');
      log(
        'Foreground click noti main screen (global) ${message.data.toString()}',
      );
      break;
    default:
      log('Received a foreground push notification (global)');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('[INIT] Starting main...');

  // AwesomeNotifications init
  print('[NOTIF] Initializing AwesomeNotifications...');
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic messages',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
    ),
  ]);
  print('[NOTIF] AwesomeNotifications initialized.');

  // Set listeners
  AwesomeNotifications().setListeners(
    onActionReceivedMethod:
        AwesomeNotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod:
        AwesomeNotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        AwesomeNotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        AwesomeNotificationController.onDismissActionReceivedMethod,
  );

  print('[FIREBASE] Initializing Firebase...');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("[FIREBASE] Firebase initialized successfully");
  } catch (e) {
    print("[FIREBASE] Firebase initialization failed: $e");
    rethrow;
  }

  // Initialize local notifications for permission handling
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // print("Local notifications initialized");

  // Background push handler (appointment calling, prescription etc.)
  FirebaseMessaging.onBackgroundMessage(
    _firebasePushNotificationOnBackgroundMessageHandler,
  );
  print('[FCM] Background handler registered.');

  FirebaseMessaging.onMessage.listen(
    _firebasePushNotificationOnForegroundMessageHandler,
  );
  print('[FCM] Foreground handler registered.');

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("[FCM] onMessageOpenedApp: ${message.toMap()}");
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("[FCM] getInitialMessage: ${message.toMap()}");
    }
  });

  // Check notification permissions at startup
  final settings = await FirebaseMessaging.instance.getNotificationSettings();
  print("Notification permission status: ${settings.authorizationStatus}");

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print(
      "Notification permissions are denied - user may need to enable in settings",
    );
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.notDetermined) {
    print("Notification permissions not determined - requesting now");
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  } else {
    print("Notification permissions already granted");
  }

  // Initialize Firebase Messaging Token
  print('[TOKEN] Fetching FCM token...');
  if (Platform.isIOS) {
    print('[TOKEN] Fetching FCM token for ios...');
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      FirebaseMessaging.instance.getToken().then((value) {
        print("[TOKEN] FCM TOKENnnnnnn: $value");
        log("[TOKEN] pushNoti token $value");
        pushNotificationTokenKey = value ?? "";
        userDeviceToken = value!;
        print('[TOKEN] Token saved to pushNotificationTokenKey');
        log('[TOKEN] Token saved to userDeviceToken IOS => $userDeviceToken');
      });
    }
  } else {
    print('[TOKEN] Fetching FCM token for android...');
    FirebaseMessaging.instance.getToken().then((value) {
      print("[TOKEN] FCM TOKEN: $value");
      log("[TOKEN] pushNoti token $value");
      pushNotificationTokenKey = value ?? "";
      userDeviceToken = value!;
      print('[TOKEN] Token saved to pushNotificationTokenKey');
      log('[TOKEN] Token saved to userDeviceToken Android => $userDeviceToken');
    });
  }

  // 🔑 FCM token (single source of truth)
  // final String? fcmToken = await FirebaseMessaging.instance.getToken();

  // if (fcmToken != null && fcmToken.isNotEmpty) {
  //   pushNotificationTokenKey = fcmToken;
  //   log('[TOKEN] FCM token: $fcmToken');
  // } else {
  //   log('[TOKEN] FCM token is null');
  // }

  // // 🍎 iOS: APNS token sirf debug / verification ke liye
  // if (Platform.isIOS) {
  //   final String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  //   log('[TOKEN] APNS token: $apnsToken');
  // }

  // // 🔁 Token refresh (VERY IMPORTANT for iOS)
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    pushNotificationTokenKey = newToken;
    log('[TOKEN] FCM token refreshed: $newToken');
  });

  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // ORIENTATION LOCK
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    DevicePreview(enabled: false, builder: (context) => const EyeBuddyApp()),
  );
}

class EyeBuddyApp extends StatefulWidget {
  const EyeBuddyApp({super.key});

  @override
  State<EyeBuddyApp> createState() => _EyeBuddyAppState();
}

class _EyeBuddyAppState extends State<EyeBuddyApp> with WidgetsBindingObserver {
  final appStateController = Get.put(AppStateController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DisplayMetricsWidget(
      child: GetMaterialApp(
        initialBinding: BindingsBuilder(() {
          Get.put(
            AgoraSingleton(),
            permanent: true,
          ); // Initialize singleton permanently
          Get.put(AgoraCallService());
          Get.put(CallController());
          Get.put(AgoraCallController());
          Get.put(ProfileController(), permanent: true);
          Get.lazyPut(() => MoreController(), fenix: true);
          Get.lazyPut(() => EyeTestController(), fenix: true);
        }),
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.unfocus();
              }
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,

        // <-- IMPORTANT (Fix Language Changing)
        locale: Get.locale, // ⭐ current locale
        fallbackLocale: const Locale('en'), // ⭐ fallback locale
        // LOCALIZATION SETUP
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,

        getPages: [
          GetPage(
            name: '/appointment-overview',
            page: () => const AppointmentOverviewScreen(),
          ),
          GetPage(
            name: '/payment-gateway',
            page: () => const PaymentGatewayScreen(),
          ),
          GetPage(
            name: '/waiting-for-doctor',
            page: () => const WaitingForDoctorScreen(),
          ),
        ],

        home: const SplashScreen(),
      ),
    );
  }
}
