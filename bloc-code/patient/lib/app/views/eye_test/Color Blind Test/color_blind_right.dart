import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:eye_buddy/app/views/eye_test/result.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ColorBlindRight extends StatefulWidget {
  int id;
  int counter;
  ColorBlindRight({required this.id, required this.counter});
  @override
  _ColorBlindRightState createState() => _ColorBlindRightState(id: id, counter: counter);
}

class _ColorBlindRightState extends State<ColorBlindRight> {
  int id;
  int counter;
  _ColorBlindRightState({required this.id, required this.counter});

  int counter2 = 0;
  late PageController controller;
  final _text = TextEditingController();
  bool _validate = false;
  var tap = 0;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _tapConter() {
    setState(() {
      tap++;
      print('This is Tap: $tap');
    });
  }

  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CommonAppBar(
        title: "Color Blind",
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
      //   title: Text(
      //     'Color Blind',
      //     style: TextStyle(
      //       fontFamily: 'TT Commons DemiBold',
      //       fontSize: 18,
      //       color: const Color(0xff181d3d),
      //     ),
      //     textAlign: TextAlign.left,
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 220,
                  width: 334,
                  child: Image.asset('assets/images/color_blind/vision${tap == 0 ? 1 : tap == 1 ? 2 : tap == 2 ? 3 : tap == 3 ? 4 : tap == 4 ? 5 : 6}.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'If you don\'t see any number, enter the letter \'0\'.',
                  style: TextStyle(fontFamily: 'DemiBold', color: colorFromHex('#181D3D'), fontSize: 22),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'I see',
                      style: TextStyle(color: ColorConfig.black, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: 130,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _text,
                      decoration: InputDecoration(
                        labelText: 'Insert Number Here',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                      ),
                    ),
                  ),
                ],
              ),
          
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CustomButton(
                  title: 'Confirm',
                  callBackFunction: () {
                    setState(() {
                      _text.text.isEmpty ? _validate = true : _validate = false;
                      _validate == false ? _tapConter() : null;
          
                      if (tap == 1) {
                        if (_text.text.toString() == "12") {
                          counter2 = counter2 + 1;
                        }
                      }
                      if (tap == 2) {
                        if (_text.text.toString() == "29") {
                          counter2 = counter2 + 1;
                        }
                      }
                      if (tap == 3) {
                        if (_text.text.toString() == "15") {
                          counter2 = counter2 + 1;
                        }
                      }
                      if (tap == 4) {
                        if (_text.text.toString() == "97") {
                          counter2 = counter2 + 1;
                        }
                      }
                      if (tap == 5) {
                        if (_text.text.toString() == "16") {
                          counter2 = counter2 + 1;
                        }
                      }
                      if (tap == 6) {
                        if (_text.text.toString() == "0") {
                          counter2 = counter2 + 1;
                        }
                      }
                      print('This Is Input: ${_text.text}');
                      print('This Is counter 2 $counter');
                      _validate == false ? _text.clear() : null;
                    });
          
                    tap == 6
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EyeTestResult(
                                      id: id,
                                      counter: counter - 1,
                                      counter2: counter2 - 1,
                                    )))
                        : null;
                  },
                ),
              ),
          
              // Padding(
              //   padding: const EdgeInsets.only(top: 50),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       MaterialButton(
              //         height: 40,
              //         minWidth: 150,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         onPressed: () {
              //
              //         },
              //         child: Text(
              //           'Confirm',
              //           style: TextStyle(fontFamily: 'DemiBold', color: ColorConfig.black, fontSize: 16),
              //         ),
              //         color: ColorConfig.yeallow,
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
