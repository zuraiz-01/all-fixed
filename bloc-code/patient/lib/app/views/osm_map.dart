import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OSMapWidget extends StatelessWidget {
  OSMapWidget({super.key});

  MapController controller = MapController(
    initPosition: GeoPoint(
      latitude: 23.8071754,
      longitude: 90.3932192,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // hospitalMarkerInit();
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        userTrackingOption: UserTrackingOption(
          enableTracking: true,
          unFollowUser: false,
        ),
        zoomOption: ZoomOption(
          initZoom: 10,
          minZoomLevel: 2,
          maxZoomLevel: 18,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: AppColors.primaryColor,
              size: 55,
            ),
          ),
          directionArrowMarker: MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 55,
            ),
          ),
        ),
        roadConfiguration: RoadOption(
          roadColor: Colors.yellowAccent,
        ),
        staticPoints: [
          StaticPositionGeoPoint(
            "line 1",
            MarkerIcon(
              icon: Icon(
                Icons.add_location_alt,
                size: 32,
                color: AppColors.primaryColor,
              ),
              // iconWidget: Container(
              //   height: 55,
              //   width: 55,
              //   child: Image.asset(
              //     AppAssets.splashLogo,
              //     fit: BoxFit.contain,
              //     color: AppColors.primaryColor,
              //   ),
              // ),
            ),
            [
              GeoPoint(latitude: 23.7469181, longitude: 90.3625013),
              GeoPoint(
                latitude: 23.7446895,
                longitude: 90.4091307,
              ),
              GeoPoint(
                latitude: 23.7941375,
                longitude: 90.398904,
              ),
              GeoPoint(
                latitude: 23.8742997,
                longitude: 90.3947147,
              ),
            ],
          ),
          /*StaticPositionGeoPoint(
                      "line 2",
                      MarkerIcon(
                        icon: Icon(
                          Icons.train,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      [
                        GeoPoint(latitude: 47.4433594, longitude: 8.4680184),
                        GeoPoint(latitude: 47.4517782, longitude: 8.4716146),
                      ],
                    )*/
        ],
        // markerOption: MarkerOption(
        //   defaultMarker: MarkerIcon(
        //     icon: Icon(
        //       Icons.local_hospital,
        //       color: AppColors.primaryColor,
        //       size: 21,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
