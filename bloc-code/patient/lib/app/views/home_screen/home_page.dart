import 'dart:async';

import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/home_screen/widgets/home_app_bar.dart';
import 'package:eye_buddy/app/views/home_screen/widgets/home_feature_section.dart';
import 'package:eye_buddy/app/views/home_screen/widgets/home_slider_section.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/services/navigator_services.dart';
import '../all_prescriptions_screen/view/all_prescriptions_screen.dart';
import '../global_widgets/common_size_box.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getNotificationClickOpen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isMessagedOpen = prefs.getBool("prescription");
    if (isMessagedOpen != null || isMessagedOpen == true) {
      await prefs.setBool("prescription", false);
      NavigatorServices().to(
        context: context,
        widget: AllPrescriptionsScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;

    // final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

    // const CameraPosition _kGooglePlex = CameraPosition(
    //   target: LatLng(37.42796133580664, -122.085749655962),
    //   zoom: 14.4746,
    // );
    // getNotificationClickOpen();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(),
            // ElevatedButton(
            //   onPressed: () {
            //     NotificationService().initNotification();
            //     NotificationService().scheduleNotification(
            //       id: Random().nextInt(100000),
            //       title: "This is a push noti",
            //       body: "This is a push noti body",
            //       scheduledNotificationDateTime: DateTime.now().add(Duration(minutes: 1)),
            //     );
            //   },
            //   child: const Text("Join call"),
            // ),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: const HomeFeatureSection(),
            ),
            CommonSizeBox(
              height: 10,
            ),
            HomeSliderSection(),
            SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 24,),
            //   child: InterText(
            //     title: l10n.nearest_eye_hospital,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     textColor: AppColors.black,
            //     textAlign: TextAlign.start,
            //   ),
            // ),

            // Container(
            //   height: 280,
            //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(6),
            //     child: OSMapWidget(),
            //   ),
            // ),
            SizedBox(
              height: kToolbarHeight,
            )
            // Container(
            //   height: 400,
            //   width: double.maxFinite,
            //   child: GoogleMap(
            //     mapType: MapType.hybrid,
            //     initialCameraPosition: _kGooglePlex,
            //     onMapCreated: (GoogleMapController controller) {
            //       _controller.complete(controller);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
