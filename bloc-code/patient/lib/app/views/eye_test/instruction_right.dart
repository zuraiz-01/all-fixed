import 'package:eye_buddy/app/views/eye_test/AMD%20Test/amd_right.dart';
import 'package:eye_buddy/app/views/eye_test/Color%20Blind%20Test/color_blind_right.dart';
import 'package:eye_buddy/app/views/eye_test/Near%20Vision%20Test/nearvision.dart';
import 'package:eye_buddy/app/views/eye_test/Near%20Vision%20Test/nearvision_right.dart';
import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction%2017.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VisualEquityIntroRight extends StatefulWidget {
  int id;
  int counter;

  VisualEquityIntroRight({
    required this.id,
    required this.counter,
  });

  @override
  _VisualEquityIntroRightState createState() =>
      _VisualEquityIntroRightState(id: id, counter: counter);
}

class _VisualEquityIntroRightState extends State<VisualEquityIntroRight> {
  int id;
  int counter;

  _VisualEquityIntroRightState({
    required this.id,
    required this.counter,
  });

  int slideIndex = 0;

  // late PageController controller;
  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 6.0,
      width: 6.0,
      // height: isCurrentPage ? 10.0 : 6.0,
      // width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        border: Border.all(color: colorFromHex('#181D3D')),
        color:
            isCurrentPage ? colorFromHex('#FEC62D') : colorFromHex('#FFFFFF'),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: PageView(
              // controller: controller,
              onPageChanged: (index) {
                setState(() {
                  slideIndex = index;
                });
              },
              children: <Widget>[
                Instruction17(),
              ]),
        ),
        floatingActionButton: slideIndex != 0
            ? Padding(
                padding: EdgeInsets.only(bottom: hp * 0.2),
                child: Container(
                  height: 40,
                  width: 50,
                  child: Row(
                    children: [
                      for (int i = 0; i < 1; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(bottom: 30, left: 25, right: 25),
                child: CustomButton(
                  title: id == 4 || id == 2 ? 'Next' : 'Learn More',
                  callBackFunction: () {
                    if (id == 2) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NearVisionRight(
                                    id: id,
                                    counter: counter,
                                  )));
                    } else if (id == 3) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ColorBlindRight(id: id, counter: counter)));
                    } else if (id == 4) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AmdRight(id: id, counter: counter)));
                    }
                    // id == 2
                    //     ? Navigator.push(context, MaterialPageRoute(builder: (context) => NearVision(id: id)))
                    //     : id == 3
                    //         ? Navigator.push(
                    //             context, MaterialPageRoute(builder: (context) => ColorBlindRight(id: id, counter: counter)))
                    //         : id == 4
                    //             ? Navigator.push(
                    //                 context, MaterialPageRoute(builder: (context) => AmdRight(id: id, counter: counter)))
                    //             : null;
                  },
                )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomSheet:
      ),
    );
  }
}
