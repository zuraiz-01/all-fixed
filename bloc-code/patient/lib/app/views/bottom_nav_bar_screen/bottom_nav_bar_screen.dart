import 'dart:developer';

import 'package:eye_buddy/app/bloc/appointment_cubit/appointment_cubit.dart';
import 'package:eye_buddy/app/bloc/homeframe_cubit/homeframe_cubit.dart';
import 'package:eye_buddy/app/bloc/patient_list_cubit/patient_list_cubit.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/profile/profile_cubit.dart';
import 'package:eye_buddy/app/services/firebase_notification_service.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/functions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/agora_call_room/agora_call_room_screen.dart';
import 'package:eye_buddy/app/views/agora_call_room/doctor_calling.dart';
import 'package:eye_buddy/app/views/appointments/appointments_page.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/widgets/bottom_nav_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/home_screen/home_page.dart';
import 'package:eye_buddy/app/views/more_screen/view/more_page.dart';
import 'package:eye_buddy/app/views/prescription_overview_screen/prescription_overview_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/agora_call_cubit/agora_call_cubit.dart';
import '../../bloc/doctor_list/doctor_list_cubit.dart';
import '../../bloc/favorites_doctor/favorites_doctor_cubit.dart';
import '../../bloc/home_banner_cubit/home_screen_banner_cubit.dart';
import '../../bloc/medication_tracker_cubit/medication_tracker_cubit.dart';
import '../../bloc/test_result/test_result_cubit.dart';
import '../../utils/keys/shared_pref_keys.dart';
import '../../utils/string_to_map.dart';
import '../all_prescriptions_screen/view/all_prescriptions_screen.dart';
import '../global_widgets/custom_loader.dart';

class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _BottomNavBarView();
  }
}

class _BottomNavBarView extends StatefulWidget {
  _BottomNavBarView();

  @override
  State<_BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<_BottomNavBarView> {
  List<Widget> bottomNavBarPages = [
    HomePage(),
    AppointmentsPage(),
    const MoreScreen(),
  ];

  AgoraCallState? agoraCallState;

  void getNotificationClickOpen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isMessagedOpen = prefs.getBool("prescription");

    log("prescription data from bottom bar $isMessagedOpen");

    if (isMessagedOpen != null && isMessagedOpen == true) {
      await prefs.setBool("prescription", false);
      NavigatorServices().to(
        context: context,
        widget: AllPrescriptionsScreen(),
      );
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(_firebasePushNotificationHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        log("Notification ");
      },
    );

    super.initState();

    agoraCallState = context.read<AgoraCallCubit>().state;
    getData();
    getCountryID();

    // FirebaseMessaging.onMessageOpenedApp.listen(_firebaseOnMessageBackgroundAppHandler);
  }

  // Future<void> _firebaseOnMessageBackgroundAppHandler(RemoteMessage message) async {
  //   Map<String, dynamic> firebasePayload = stringToMap(message.data["meta"]);
  //   if (firebasePayload["criteria"] == "prescription") {
  //     log("click noti ${message.data.toString()}");
  //     final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //     final SharedPreferences prefs = await _prefs;
  //     await prefs.setBool("prescription", true);
  //
  //     log("prescription save");
  //
  //   }
  // }
  bool checkTimeDifference(String inputTimeUtc) {
    // Parse the input UTC time
    DateTime inputTime = DateTime.parse(inputTimeUtc);

    // Get the current UTC time
    DateTime currentTime = DateTime.now().toUtc();

    // Calculate the difference in seconds
    Duration difference = currentTime.difference(inputTime).abs();

    // Check if the difference is more than 30 seconds
    if (difference.inSeconds > 30) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _firebasePushNotificationHandler(RemoteMessage message) async {
    // await Firebase.initializeApp();
    print("Firebase Payload: ${message.toMap()}");
    Map<String, dynamic> firebasePayload = stringToMap(message.data["meta"]);
    log("Logging Firebase Push noti response from bottom nav bar  :: " +
        firebasePayload.toString());
    switch (firebasePayload["criteria"]) {
      case "appointment":
        if (firebasePayload["title"]
            .toLowerCase()
            .contains("Calling".toLowerCase())) {
          context.read<AgoraCallCubit>().setAgoraChannelID(
                channelId: firebasePayload["metaData"]["_id"] ?? "",
              );

          log("Firebase Payload: ${firebasePayload['updatedAt']}");
          if (checkTimeDifference(firebasePayload['updatedAt'])) {
            NavigatorServices().to(
              context: context,
              widget: DoctorCallingView(
                // prefs: await SharedPreferences.getInstance(),
                name: firebasePayload['metaData']['doctor']['name'],
                image: firebasePayload['metaData']['doctor']['photo'],
                appointmentId: firebasePayload['metaData']['_id'],
              ),
            );
          }
        } else if (firebasePayload["title"]
            .toLowerCase()
            .contains("Prescription Submitted".toLowerCase())) {
          showToast(
            message: firebasePayload["body"] ?? "",
            context: context,
          );

          NavigatorServices().to(
            context: context,
            widget: PrescriptionOverviewScreen(
              payload: {
                "id": firebasePayload["metaData"]["appointment"] ?? "",
                "diagnosis": firebasePayload["metaData"]["diagnosis"],
                "note": firebasePayload["metaData"]["note"],
                "investigations": firebasePayload["metaData"]["investigations"],
                "medicines": firebasePayload["metaData"]["medicines"],
                "surgery": firebasePayload["metaData"]["surgery"],
                "followUpDate": firebasePayload["metaData"]["followUpDate"],
                "referredTo": firebasePayload["metaData"]["referredTo"]
                // "note": "This is note"
              },
            ),
          );
        }
        break;
      case "prescription":
        showNotification(
          message: message,
        );

        NavigatorServices().to(
          context: context,
          widget: AllPrescriptionsScreen(),
        );

        break;
      default:
        showNotification(
          message: message,
        );
        log("Notifications");
    }
  }

  void getData() async {
    context.read<ProfileCubit>().getProfileData();
    context.read<TestResultCubit>().getAppTestResultData();
    context.read<PatientListCubit>().getPatientList().then((_) {
      var userPatientsCubitState = context.read<PatientListCubit>().state;
      userPatientsCubitState.myPatientList.forEach((element) {
        if (element.relation == "myself") {
          context.read<AppointmentCubit>().updatePatient(element);
          context
              .read<PrescriptionListCubit>()
              .updatePatientForPrescription(element);
        }
      });
    });
    context.read<FavoritesDoctorCubit>().getFavoritesDoctorList();
    context.read<DoctorListCubit>().getSearchDoctorList({});
    context.read<MedicationTrackerCubit>().getMedications();
    context.read<HomeScreenBannerCubit>().getHomeBannersList();
    context.read<PatientListCubit>().getPatientList().then((_) {
      var userPatientsCubitState = context.read<PatientListCubit>().state;
      userPatientsCubitState.myPatientList.forEach((element) {
        if (element.relation == "myself") {
          context.read<AppointmentCubit>().updatePatient(element);
          context
              .read<PrescriptionListCubit>()
              .updatePatientForPrescription(element);
        }
      });
    });
    // context.read<DoctorListCubit>().getSearchDoctorList({});
    context.read<DoctorListCubit>().getSpecialtiesList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? noti_criteria = prefs
        .getString(
          criteria,
        )
        .toString();
    switch (noti_criteria) {
      case "appointment":
        await context.read<AgoraCallCubit>().setAgoraChannelID(
            channelId: prefs
                .getString(
                  agoraChannelId,
                )
                .toString());

        String docName = prefs
            .getString(
              agoraDocName,
            )
            .toString();
        if (docName != "null") {
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
          // NavigatorServices().to(
          //   context: context,
          //   widget: AgoraCallScreen(
          //     prefs: await SharedPreferences.getInstance(),
          //   ),
          // );
        } else {
          showToast(
            message: "Appointment expired.",
            context: context,
          );
        }
        break;
      // case "prescription":
      //   prefs.setString(criteria, "");
      //   NavigatorServices().to(
      //     context: context,
      //     widget: AllPrescriptionsScreen(),
      //   );
    }
  }

  PageController bottomNavBarPageController = PageController();

  @override
  Widget build(BuildContext context) {
    getNotificationClickOpen();
    return Scaffold(
      body: Builder(builder: (context) {
        var profileBlocState = context.watch<ProfileCubit>().state;
        var appointmentBlocState = context.watch<AppointmentCubit>().state;
        var doctorListBlocState = context.watch<DoctorListCubit>().state;
        var patientListBlocState = context.watch<PatientListCubit>().state;
        if (profileBlocState.isLoading) {
          return CustomLoadingScreen();
        }
        // getNotificationClickOpen();
        return SizedBox(
          height: getHeight(context: context),
          width: getWidth(context: context),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: bottomNavBarPageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bottomNavBarPages.length,
                  itemBuilder: (context, index) {
                    return bottomNavBarPages[index];
                  },
                ),
              ),
              BottomNavBar(
                  bottomNavBarPageController: bottomNavBarPageController)
            ],
          ),
        );
      }),
    );
  }
}
