import 'package:eye_buddy/app/views/emergency_call/widgets/support_section.dart';
import 'package:flutter/material.dart';

import '../../global_widgets/common_app_bar.dart';

class EmergencyCallScreen extends StatelessWidget {
  EmergencyCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Emergency Call',
          elevation: 1.0,
          icon: Icons.arrow_back,
          finishScreen: true,
          isTitleCenter: true,
          context: context,
        ),
        body: Container(
          child: Column(
            children: [
              // CommonSizeBox(
              //   height: 20,
              // ),
              // OtherSection(),
              SupportSection(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
