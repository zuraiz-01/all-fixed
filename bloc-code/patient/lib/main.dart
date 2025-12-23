import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/android_foreground_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:display_metrics/display_metrics.dart';
import 'package:eye_buddy/app/bloc/add_medication_cubit/add_medication_cubit.dart';
import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/beh_bloc_observer/beh_bloc_observer.dart';
import 'package:eye_buddy/app/bloc/doctor_rating_cubit/doctor_rating_cubit.dart';
import 'package:eye_buddy/app/bloc/edit_prescription/edit_prescription_cubit.dart';
import 'package:eye_buddy/app/bloc/favorites_doctor/favorites_doctor_cubit.dart';
import 'package:eye_buddy/app/bloc/home_banner_cubit/home_screen_banner_cubit.dart';
import 'package:eye_buddy/app/bloc/language_bloc/language_bloc.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result_bloc/test_result_tab_cubit.dart';
import 'package:eye_buddy/app/bloc/visual_acity_eye_test_cubit/visual_acuity_cubit.dart';
import 'package:eye_buddy/app/controller/app_state_controller.dart';
import 'package:eye_buddy/app/services/local_notification_services.dart';
import 'package:eye_buddy/app/utils/common_utils.dart';
import 'package:eye_buddy/app/utils/config/theme.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/agora_call_room/agora_call_room_screen.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:eye_buddy/app/views/splash/splash_screen.dart';
import 'package:eye_buddy/app_routes/app_router.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
// import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/bloc/agora_call_cubit/agora_call_cubit.dart';
import 'app/bloc/agora_call_cubit/agora_call_events/agora_call_events_cubit.dart';
import 'app/bloc/app_eye_test_cubit/app_eye_test_cubit.dart';
import 'app/bloc/appointment_filter_cubit/appointment_filter_cubit.dart';
import 'app/bloc/doctor_list/doctor_list_cubit.dart';
import 'app/bloc/homeframe_cubit/homeframe_cubit.dart';
import 'app/bloc/login_cubit/login_cubit.dart';
import 'app/bloc/medication_tracker_cubit/medication_tracker_cubit.dart';
import 'app/bloc/network_block/network_bloc.dart';
import 'app/bloc/network_block/network_event.dart';
import 'app/bloc/profile/profile_cubit.dart';
import 'app/bloc/reason_for_visit_cubit/reason_for_visit_cubit.dart';
import 'app/bloc/timer_cubit/timer_cubit.dart';
import 'app/utils/keys/shared_pref_keys.dart';
import 'app/utils/keys/token_keys.dart';
import 'app/utils/services/calling_services.dart';
import 'app/utils/string_to_map.dart';
import 'package:restart_app/restart_app.dart';

Future<void> _firebasePushNotificationOnBackgroundMessageHandler(
    RemoteMessage message) async {
  print("sending background");
  await Firebase.initializeApp();
  Map<String, dynamic> firebasePayload = stringToMap(message.data["meta"]);
  print("Firebase Data: ${firebasePayload["criteria"]}");
  switch (firebasePayload["criteria"]) {
    case "appointment":
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String docName = prefs
          .getString(
            agoraDocName,
          )
          .toString();

      if (docName != "null" &&
          firebasePayload["title"]
              .toLowerCase()
              .contains("Calling".toLowerCase())) {
        prefs.setString(criteria, "appointment");
        log("Background Notification: ${firebasePayload['metaData']['doctor']}");
        ShowCaller(
          name: firebasePayload['metaData']['doctor']['name'],
          image: firebasePayload['metaData']['doctor']['photo'],
          appointmentId: firebasePayload['metaData']['_id'],
        );
      } else {}
      break;
    case "c":
      // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      // final SharedPreferences prefs = await _prefs;
      // await prefs.setBool("prescription", true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(criteria, "prescription");
      log("click noti main screen ${message.data.toString()}");
      break;
    default:
      log("Received a push notification");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();

  NotificationService().initNotification();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'eye_doctor_basic_channel',
        channelName: 'eye_doctor_basic_channel',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        importance: NotificationImportance.Max,
      )
    ],
  );

   if (Platform.isIOS) {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
     FirebaseMessaging.instance.getToken().then((value) {
    print("pushNoti token $value");
    pushNotificationTokenKey = value ?? "";
  });
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        FirebaseMessaging.instance.getToken().then((value) {
    print("pushNoti token $value");
    pushNotificationTokenKey = value ?? "";
  });
      }
    }
  } else {
   FirebaseMessaging.instance.getToken().then((value) {
    print("pushNoti token $value");
    pushNotificationTokenKey = value ?? "";
  });
  }

  // FirebaseMessaging.instance.getToken().then((value) {
  //   print("pushNoti token $value");
  //   pushNotificationTokenKey = value ?? "";
  // });

  FirebaseMessaging.onBackgroundMessage(
      _firebasePushNotificationOnBackgroundMessageHandler);
  // FirebaseMessaging.onMessageOpenedApp.listen(_firebaseOnMessageOpenedAppHandler);

  FirebaseMessaging.instance.requestPermission(
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

  Bloc.observer = BehBlocObserver();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) {
          return EyeBuddyApp(
            appRouter: AppRouter(),
          );
        },
      ),
    );
  });
}

class EyeBuddyApp extends StatefulWidget {
  const EyeBuddyApp({
    super.key,
    required this.appRouter,
  });

  final AppRouter appRouter;

  @override
  State<EyeBuddyApp> createState() => _EyeBuddyAppState();
}

class _EyeBuddyAppState extends State<EyeBuddyApp> with WidgetsBindingObserver {
  final appStateController = Get.put(AppStateController());
  @override
  void initState() {
    // AwesomeNotifications().actionStream.listen((event) {
    //   print(
    //     event.body,
    //   );
    // });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        return calls[0];
      } else {
        return null;
      }
    }
  }

  Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      print("Current Call: ${currentCall['id']}");
      if (currentCall['accepted']) {
        NavigatorServices().to(
          context: context,
          widget: AgoraCallScreen(
            name: currentCall['nameCaller'],
            image: currentCall['avatar'],
            appointmentId: currentCall['id'],
          ),
        );
      }
    }
  }

  // Future<void> handleAcceptedCall({int retryCount = 0}) async {
  //   final prefs = GetStorage();
  //   bool? callAccepted = prefs.read(isCallAccepted); // Synchronous read
  //   log("handleAcceptedCall attempt: ${retryCount + 1}, isCallAccepted: $callAccepted");

  //   if (callAccepted ?? false) {
  //     prefs.write(isCallAccepted, false); // Write new value
  //     NavigatorServices().to(
  //       context: context,
  //       widget: AgoraCallScreen(
  //         name: prefs.read(agoraDocName) ?? '',
  //         image: prefs.read(agoraDocPhoto) ?? 'https://picsum.photos/200/300',
  //         appointmentId: prefs.read(agoraChannelId) ?? '',
  //       ),
  //     );
  //   } else if (retryCount < 100) {
  //     await Future.delayed(const Duration(milliseconds: 100)); // Retry delay
  //     await handleAcceptedCall(retryCount: retryCount + 1);
  //   } else {
  //     log("Max retries reached. Exiting handleAcceptedCall.");
  //   }
  // }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.paused) {
      log("App state resumed: tags");
      //Check call when open app from background
      // checkAndNavigationCallingPage();
      // handleAcceptedCall();
      if (!appStateController.isPickingImage.value) {
        log("App going to background, restarting...");
        // Restart.restartApp();
      } else {
        log("ImagePicker is active, skipping app restart");
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc()..add(GetLanguage()),
        ),
        BlocProvider(
          create: (context) => AddMedicationCubit(),
        ),
        BlocProvider(
          create: (context) => TestResultTabCubit(),
        ),
        BlocProvider(
          create: (context) => MedicationTrackerCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => FavoritesDoctorCubit(),
        ),
        BlocProvider(
          create: (context) => AppointmentCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorListCubit(),
        ),
        BlocProvider(
          create: (context) => PatientListCubit(),
        ),
        BlocProvider(
          create: (context) => ReasonForVisitCubit(),
        ),
        BlocProvider(
          create: (context) => TestResultCubit(),
        ),
        BlocProvider(
          create: (context) => TimerCubit(),
        ),
        BlocProvider(
          create: (context) => PrescriptionListCubit(),
        ),
        BlocProvider(
          create: (context) => HomeScreenBannerCubit(),
        ),
        BlocProvider(
          create: (context) => EditPrescriptionCubit(),
        ),
        BlocProvider(
          create: (context) => AgoraCallCubit(),
        ),
        BlocProvider(
          create: (context) => HomeframeCubit(),
        ),
        BlocProvider(
          create: (context) => AppointmentFilterCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorRatingCubit(),
        ),
        BlocProvider(
          create: (context) => NetworkBloc()..add(NetworkObserve()),
        ),
        BlocProvider(
          create: (context) => AgoraCallEventsCubit(),
        ),
        BlocProvider(
          create: (context) => VisualAcuityCubit(),
        ),
        BlocProvider(
          create: (context) => AppEyeTestCubit(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          log("Selected Language: ${state.selectedLanguage.value}");
          return DisplayMetricsWidget(
            updateSizeOnRotate: true,
            child: GetMaterialApp(
              key: ValueKey(state.selectedLanguage),
              locale: state.selectedLanguage.value,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              debugShowCheckedModeBanner: false,
              theme: CustomTheme.lightTheme,
              home: const SplashScreen(),
              onGenerateRoute: widget.appRouter.onGeneratedRoute,
              builder: (context, router) => router!,
            ),
          );
        },
      ),
    );
  }
}

Future<void> requestForIosPermission() async {
  // NotificationPermissions.requestNotificationPermissions(
  //     iosSettings:
  //         const NotificationSettingsIos(sound: true, badge: true, alert: true));

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

Future<void> requestForAndroidPermission() async {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

Future<void> _firebaseOnMessageOpenedAppHandler(RemoteMessage message) async {
  Map<String, dynamic> firebasePayload = stringToMap(message.data["meta"]);
  if (firebasePayload["criteria"] == "prescription") {
    log("click noti ${message.data.toString()}");
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool("prescription", true);
  }
}
//
// Future<void> _firebaseOnMessageBackgroundAppHandler(RemoteMessage message) async {
//
//
// }

// listenActionStream() {
//   AwesomeNotifications().actionStream.listen((receivedAction) {
//     var payload = receivedAction.payload;

//     if (receivedAction.channelKey == 'eye_doctor_basic_channel') {
//       //do something here
//     }
//   });
// }

// To update localization data, edit the l10n files and run "flutter gen-l10n"
