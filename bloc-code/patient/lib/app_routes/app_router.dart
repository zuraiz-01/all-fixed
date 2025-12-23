import 'package:eye_buddy/app/views/all_prescriptions_screen/view/all_prescriptions_screen.dart';
import 'package:eye_buddy/app/views/change_language_screen/view/change_language_screen.dart';
import 'package:eye_buddy/app/views/change_mobile_number_screen/view/change_mobile_number_screen.dart';
import 'package:eye_buddy/app/views/doctor_list_screen/views/doctor_list_screen.dart';
import 'package:eye_buddy/app/views/doctor_profile/view/doctor_profile.dart';
import 'package:eye_buddy/app/views/emergency_call/view/emergency_call_screen.dart';
import 'package:eye_buddy/app/views/eye_test_list_screen/view/eye_test_list_screen.dart';
import 'package:eye_buddy/app/views/favourite_doctors_screen/view/favourite_doctors_screen.dart';
import 'package:eye_buddy/app/views/intro_flow/into_flow_screen.dart';
import 'package:eye_buddy/app/views/medication_tracker/medication_tracker_screen.dart';
import 'package:eye_buddy/app/views/profile_screen/view/profile_screen.dart';
import 'package:eye_buddy/app/views/promos_screen/views/promos_screen.dart';
import 'package:eye_buddy/app/views/terms_and_conditions_screen/view/terms_and_conditions_screen.dart';
import 'package:eye_buddy/app/views/test_results/views/test_results_screen.dart';
import 'package:eye_buddy/app/views/transactions_history_screen/view/transactions_history_screen.dart';
import 'package:eye_buddy/app/views/upload_prescription_or_clinical_data/view/upload_prescription_or_clinical_data_screen.dart';
import 'package:eye_buddy/app_routes/page_route_arguments.dart';
import 'package:eye_buddy/app_routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  Route? onGeneratedRoute(RouteSettings? route) {
    switch (route!.name) {
      case RouteName.root:
        return PageTransition(
          child: const IntroFlowScreen(),
          type: PageTransitionType.fade,
        );

      case RouteName.profileScreen:
        return PageTransition(
          child: ProfileScreen(),
          type: PageTransitionType.fade,
        );
      // case RouteName.editProfileScreen:
      //   return PageTransition(
      //     child: EditProfileScreen(),
      //     type: PageTransitionType.fade,
      //   );
      case RouteName.allPrescriptionsScreen:
        return PageTransition(
          child: AllPrescriptionsScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.favouriteDoctorsScreen:
        return PageTransition(
          child: FavouriteDoctorsScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.transactionsHistoryScreen:
        return PageTransition(
          child: const TransactionsHistoryScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.changeMobileNumberScreen:
        return PageTransition(
          child: ChangeMobileNumberScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.changeLanguageScreen:
        return PageTransition(
          child: ChangeLanguageScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.emergencyCallScreen:
        return PageTransition(
          child: EmergencyCallScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.testResultsScreen:
        return PageTransition(
          child: TestResultsScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.medicationTrackerScreen:
        return PageTransition(
          child: const MedicationTrackerScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.uploadPrescriptionOrClinicalDataScreen:
        return PageTransition(
          child: UploadPrescriptionOrClinicalDataScreen(
            screenName: '',
          ),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.doctorListScreen:
        return PageTransition(
          child: DoctorListScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.doctorProfileScreen:
        return PageTransition(
          child: DoctorProfileScreen(),
          type: PageTransitionType.fade,
        );
      case RouteName.promosScreen:
        return PageTransition(
          child: PromosScreen(),
          type: PageTransitionType.rightToLeft,
        );
      case RouteName.termsAndConditionsScreen:
        final arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: TermsAndConditionsScreen(
            arguments: arg,
          ),
          type: PageTransitionType.rightToLeft,
        );
      // case RouteName.createPatientProfileScreen:
      //   return PageTransition(
      //     child: CreatePatientProfileScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );
      // case RouteName.patientSelectScreen:
      //   return PageTransition(
      //     child: PatientSelectScreen(),
      //     type: PageTransitionType.rightToLeft,
      //   );
      case RouteName.eyeTestListScreen:
        return PageTransition(
          child: EyeTestListScreen(),
          type: PageTransitionType.rightToLeft,
        );

      // case RouteName.dashboard:
      //   var arg = route.arguments as PageRouteArguments;
      //   logInfo('[${arg.fromPage}]  👉 [${arg.toPage}]');
      //   return PageTransition(
      //     child: Dashboard(arguments: arg),
      //     type: PageTransitionType.fade,
      //   );
      default:
        return _errorRoute();
    }
  }

  // AppRouter._(); CheckOutScreen
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page not found!'),
        ),
      ),
    );
  }
}
