// import 'package:eye_buddy/app/utils/config/app_colors.dart';
// import 'package:eye_buddy/app/utils/dimentions.dart';
// import 'package:eye_buddy/app/utils/services/navigator_services.dart';
// import 'package:eye_buddy/app/utils/show_in_app_toast.dart';
// import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
// import 'package:eye_buddy/app/views/login_flow/login_screen.dart';
// import 'package:eye_buddy/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';

// class UnknownScreen extends StatelessWidget {
//   const UnknownScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       body: SizedBox(
//         width: getWidth(context: context),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // await [Permission.camera, Permission.microphone].request();
//                 // NavigatorServices().to(
//                 //   context: context,
//                 //   widget: const AgoraCallScreen(),
//                 // );

//                 ShowInAppToast.showSnakeBar(
//                     context: context, msg: "Video Call is not available now", backgroundColors: AppColors.colorF14F4A, textColors: AppColors.white);
//               },
//               child: const Text('Join call'),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 NavigatorServices().to(
//                   context: context,
//                   widget: LoginScreen(
//                     showBackButton: true,
//                   ),
//                 );
//               },
//               child: const Text('Login flow'),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const BottomNavBarScreen(),
//                   ),
//                 );
//               },
//               child: const Text('Enter App'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
