// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GetGoogleMaps extends StatefulWidget {
//   bool showAnimationAndBounceBetweenTwoPoints;
//   bool isScrollable;
//   GetGoogleMaps({
//     Key? key,
//     this.showAnimationAndBounceBetweenTwoPoints = false,
//     this.isScrollable = false,
//   }) : super(key: key);

//   @override
//   State<GetGoogleMaps> createState() => _GetGoogleMapsState();
// }

// class _GetGoogleMapsState extends State<GetGoogleMaps> {
//   final CameraPosition myLocation = CameraPosition(
//     target: LatLng(23.744346, 90.417266),
//     zoom: 14,
//   );

//   Iterable markers = [
//     Marker(
//       markerId: MarkerId("someId"),
//       position: LatLng(23.744346, 90.417266),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRed,
//       ),
//     ),
//     Marker(
//       markerId: MarkerId("someId2"),
//       position: LatLng(23.743863, 90.414703),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRose,
//       ),
//       flat: true,
//       onTap: () {
//         // showToast(message: "This is pointer 2", context: context);
//       },
//       // infoWindow: InfoWindow(
//       //   title: 'Kyoto is traveling to IUB\nClick to view details.',
//       //   onTap: () {},
//       // ),
//     ),
//     Marker(
//       markerId: MarkerId("someId4"),
//       position: LatLng(23.737460, 90.407429),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRose,
//       ),
//       flat: true,
//       onTap: () {
//         // showCustomSnackbar(
//         //     title: "This is pointer 2", message: "Pointer 2 msg");
//       },
//       // infoWindow: InfoWindow(
//       //   title: 'Kyoto is traveling to IUB\nClick to view details.',
//       //   onTap: () {},
//       // ),
//     ),
//     Marker(
//       markerId: MarkerId("someId3"),
//       position: LatLng(23.743185, 90.415284),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueMagenta,
//       ),
//       flat: true,
//       onTap: () {
//         // showCustomSnackbar(
//         //     title: "This is pointer 2", message: "Pointer 2 msg");
//       },
//       // infoWindow: InfoWindow(
//       //   title: 'Kyoto is traveling to IUB\nClick to view details.',
//       //   onTap: () {},
//       // ),
//     ),
//   ];

//   late GoogleMapController gmapController;

//   moveMapCameraToNewPoint(LatLng latlang) {
//     gmapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: latlang,
//           // LatLng(23.737460, 90.407429),
//           zoom: 16,
//         ),
//       ),
//     );
//   }

//   animateBetweenTwoPoints() async {
//     String currentPointerLocation = "mine";
//     while (true) {
//       await Future.delayed(Duration(seconds: 2));
//       if (currentPointerLocation != "mine") {
//         moveMapCameraToNewPoint(LatLng(23.744346, 90.417266));
//         currentPointerLocation = "mine";
//       } else {
//         moveMapCameraToNewPoint(LatLng(23.737460, 90.407429));
//         currentPointerLocation = "2ndLocation";
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.showAnimationAndBounceBetweenTwoPoints) {
//       animateBetweenTwoPoints();
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 8,
//       ),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController mapController) {
//                 gmapController = mapController;
//               },
//               mapType: MapType.terrain,
//               trafficEnabled: true,
//               initialCameraPosition: myLocation,
//               myLocationEnabled: true,
//               buildingsEnabled: true,
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: false,
//               markers: Set.from(
//                 markers,
//               ),
//             ),
//           ),
//           widget.isScrollable
//               ? const SizedBox.shrink()
//               : Container(
//                   height: double.maxFinite,
//                   width: double.maxFinite,
//                   color: Colors.transparent,
//                 )
//         ],
//       ),
//     );
//   }
// }
