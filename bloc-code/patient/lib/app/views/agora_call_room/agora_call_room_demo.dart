// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// String appId = "0fb1a1ecf5a34db2b51d9896c994652a";

// class AgoraCallRomm extends StatefulWidget {
//   const AgoraCallRomm({super.key});

//   @override
//   State<AgoraCallRomm> createState() => _AgoraCallRommState();
// }

// class _AgoraCallRommState extends State<AgoraCallRomm> {
//   final AgoraClient client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: appId,
//       channelName: "test",
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   void initAgora() async {
//     await client.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Agora VideoUIKit'),
//           centerTitle: true,
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: client,
//                 layoutType: Layout.floating,
//                 enableHostControls: true, // Add this to enable host controls
//               ),
//               AgoraVideoButtons(
//                 client: client,
//                 addScreenSharing: false, // Add this to enable screen sharing
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
