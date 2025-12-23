import 'package:eye_buddy/app/views/eye_test/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LightSensitivityRight extends StatefulWidget {
  int counter;
  int id;
  LightSensitivityRight({required this.id, required this.counter});
  @override
  _LightSensitivityRightState createState() => _LightSensitivityRightState(id: id, counter: counter);
}

class _LightSensitivityRightState extends State<LightSensitivityRight> {
  int id;
  int counter;
  _LightSensitivityRightState({required this.id, required this.counter});
  int counter2 = 0;

  // ignore: unused_field

  void _incrementCounter() {
    setState(() {
      counter2++;
    });
  }

  var tap = 0;
  var textSize = 200.0;
  void _tapConter() {
    setState(() {
      tap++;
      print('This is Tap: $tap');
      textSize = textSize - 15.0;
      print(textSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Image.asset('assets/icon/back_arrow.png'),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Light Sensitivity',
            style: TextStyle(
              fontFamily: 'TT Commons DemiBold',
              fontSize: 18,
              color: const Color(0xff181d3d),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25, 100, 25, 100),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _tapConter();
                            tap == 1 || tap == 5 ? _incrementCounter() : null;
                            tap == 5
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EyeTestResult(id: id, counter: counter, counter2: counter2)))
                                : null;
                          },
                          child: SvgPicture.asset('assets/svg/eye_test/arrow/up_arrow.svg'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _tapConter();
                            tap == 2 ? _incrementCounter() : null;
                            tap == 5
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EyeTestResult(id: id, counter: counter, counter2: counter2)))
                                : null;
                          },
                          child: SvgPicture.asset('assets/svg/eye_test/arrow/left_arrow.svg'),
                        ),
                        RotatedBox(
                          quarterTurns: tap == 0
                              ? 3
                              : tap == 1
                                  ? 2
                                  : tap == 2
                                      ? 4
                                      : tap == 3
                                          ? 1
                                          : 3,
                          child: RichText(
                            text: TextSpan(
                              text: 'C',
                              style: TextStyle(
                                fontSize: textSize,
                                color: tap == 0
                                    ? Colors.black87
                                    : tap == 1
                                        ? Colors.black54
                                        : tap == 2
                                            ? Colors.black45
                                            : tap == 3
                                                ? Colors.black38
                                                : Colors.black26,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _tapConter();
                            tap == 3 ? _incrementCounter() : null;

                            tap == 5
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EyeTestResult(id: id, counter: counter, counter2: counter2)))
                                : null;
                          },
                          child: SvgPicture.asset('assets/svg/eye_test/arrow/right_arrow.svg'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _tapConter();
                            tap == 4 ? _incrementCounter() : null;

                            tap == 5
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EyeTestResult(id: id, counter: counter, counter2: counter2)))
                                : null;
                          },
                          child: SvgPicture.asset('assets/svg/eye_test/arrow/down_arrow.svg'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
