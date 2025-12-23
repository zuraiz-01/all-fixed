import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/device_utils.dart';
import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:eye_buddy/app/views/eye_test/result.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NearVisionRight extends StatefulWidget {
  int id;
  int counter;

  NearVisionRight({
    required this.id,
    required this.counter,
  });

  @override
  _NearVisionRightState createState() => _NearVisionRightState(
        id: id,
      );
}

class _NearVisionRightState extends State<NearVisionRight> {
  int id;

  _NearVisionRightState({required this.id});

  int counter2 = 0;
  int slideIndex = 0;
  late PageController controller;

  void _incrementCounter() {
    setState(() {
      counter2 = counter2 + 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    double ppi = DeviceUtils.getDevicePPI(context);
    double letterHeightMm = 0.582;
    double letterHeightPx = DeviceUtils.mmToPixels(letterHeightMm, ppi);
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Near Vision',
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Being able to see well at any distance',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: letterHeightPx + 6,
                          wordSpacing: letterHeightPx),
                    ),
                    Text(
                      'Being able to see well at any distance',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: letterHeightPx + 3,
                          wordSpacing: letterHeightPx),
                    ),
                    Text(
                      'Being able to see well at any distance',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: letterHeightPx,
                          wordSpacing: letterHeightPx),
                    ),
                    Text(
                      'Being able to see well at any distance',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: letterHeightPx - 3,
                          wordSpacing: letterHeightPx),
                    ),
                    // SizedBox(
                    //   height: 20,
                    //   child: Text(
                    //     'Being able to see well at any distance',
                    //     style: TextStyle(color: Colors.black87, fontSize: 10),
                    //   ),
                    // ),
                    // Container(
                    //   height: 20,
                    //   child: Text(
                    //     'Being able to see well at any distance',
                    //     style: TextStyle(color: Colors.black87, fontSize: 8),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Can you read all the 4 lines of text, including the smallest one?',
                style: TextStyle(
                    fontFamily: 'DemiBold',
                    color: colorFromHex('#181D3D'),
                    fontSize: 22),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40,
                    child: CustomButton(
                      title: 'Yes',
                      callBackFunction: () {
                        _incrementCounter();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EyeTestResult(
                                      id: id,
                                      counter: widget.counter,
                                      counter2: counter2,
                                    )));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    child: CustomButton(
                      title: 'No',
                      backGroundColor: AppColors.color888E9D,
                      callBackFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EyeTestResult(
                                      id: id,
                                      counter: widget.counter,
                                      counter2: counter2,
                                    )));
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 50),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       MaterialButton(
            //         height: 40,
            //         minWidth: 150,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         onPressed: () {
            //           _incrementCounter();
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => EyeTestResult(
            //                         id: id,
            //                         counter: counter,
            //                         counter2: counter2,
            //                       )));
            //           print(counter);
            //         },
            //         child: InterText(
            //           title: 'Yes',
            //           textColor: AppColors.white,
            //           fontSize: 16,
            //         ),
            //         color: AppColors.primaryColor,
            //       ),
            //       MaterialButton(
            //         height: 40,
            //         minWidth: 150,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => EyeTestResult(
            //                         id: id,
            //                         counter: counter,
            //                         counter2: counter2,
            //                       )));
            //           print(counter);
            //         },
            //         child: Text(
            //           'No',
            //           style: TextStyle(fontFamily: 'DemiBold', color: colorFromHex('#FEC62D'), fontSize: 16),
            //         ),
            //         color: colorFromHex("#181D3D"),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
