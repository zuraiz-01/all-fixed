import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:eye_buddy/app/views/eye_test/instruction_right.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AmdLeft extends StatefulWidget {
  late int id;

  AmdLeft({required this.id});
  @override
  _AmdLeftState createState() => _AmdLeftState(id: id);
}

class _AmdLeftState extends State<AmdLeft> {
  int id;

  _AmdLeftState({required this.id});
  int counter = 0;
  late int slideIndex = 0;
  late PageController controller;

  void _incrementCounter() {
    setState(() {
      counter = counter + 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(
        title: "AMD Test",
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      // appBar: AppBar(
      //   leading: InkWell(
      //     child: Image.asset('assets/icon/back_arrow.png'),
      //     onTap: () {
      //       Navigator.pop(context, true);
      //     },
      //   ),
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   title: Text(
      //     'AMD Test',
      //     style: TextStyle(
      //       fontFamily: 'TT Commons DemiBold',
      //       fontSize: 18,
      //       color: const Color(0xff181d3d),
      //     ),
      //     textAlign: TextAlign.left,
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: hw * 0.8,
                  child: Image.asset(
                    'assets/images/amdtest.PNG',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Concentrate on the central point in the grid without moving your gaze. Do you see any strong distortions in certain lines?',
                  style: TextStyle(fontFamily: 'DemiBold', color: colorFromHex('#181D3D'), fontSize: 22),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisualEquityIntroRight(
                                        id: id,
                                        counter: counter,
                                      )));
                          print(counter);
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
                          _incrementCounter();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisualEquityIntroRight(
                                        id: id,
                                        counter: counter,
                                      )));
                          print(counter);
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
              //
              //
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
              //                   builder: (context) => VisualEquityIntroRight(
              //                         id: id,
              //                         counter: counter,
              //                       )));
              //           print(counter);
              //         },
              //         child: Text(
              //           'Yes',
              //           style: TextStyle(fontFamily: 'DemiBold', color: colorFromHex('#181D3D'), fontSize: 16),
              //         ),
              //         color: colorFromHex("#FEC62D"),
              //       ),
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
              //                   builder: (context) => VisualEquityIntroRight(
              //                         id: id,
              //                         counter: counter,
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
      ),
    );
  }
}
