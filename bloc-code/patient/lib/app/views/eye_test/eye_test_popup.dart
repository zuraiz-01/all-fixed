// import 'package:eye_buddy/app/views/eye_test/Instruction_left.dart';
// import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
// import 'package:flutter/material.dart';
//
// class EyeTestPopup extends StatefulWidget {
//   int id;
//   String popup;
//   int slide;
//   EyeTestPopup(this.id, this.popup, this.slide);
//
//   @override
//   _EyeTestPopupState createState() => _EyeTestPopupState(id, popup, slide);
// }
//
// class _EyeTestPopupState extends State<EyeTestPopup> {
//   int id;
//   String popup;
//   int slide;
//   _EyeTestPopupState(this.id, this.popup, this.slide);
//
//   @override
//   Widget build(BuildContext context) {
//     var hp = MediaQuery.of(context).size.height;
//     var hw = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//         Stack(children: [
//           Container(
//             height: hp,
//             width: hw,
//             child: Image.asset(popup),
//           ),
//           Positioned(
//             left: hw * 0.80,
//             top: hp * 0.62,
//             child: CircleButton(
//               onTap: () =>
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => VisualEquityIntroLeft(id: id, slide: slide))),
//               iconData: Icons.close,
//             ),
//           ),
//         ]),
//       ]),
//     );
//   }
// }
//
// class CircleButton extends StatelessWidget {
//   final GestureTapCallback onTap;
//   final IconData iconData;
//
//   const CircleButton({Key? key, required this.onTap, required this.iconData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double size = 30.0;
//
//     return InkResponse(
//       onTap: onTap,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           color: ColorConfig.yeallow,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           iconData,
//           color: ColorConfig.black,
//           size: 20,
//         ),
//       ),
//     );
//   }
// }
