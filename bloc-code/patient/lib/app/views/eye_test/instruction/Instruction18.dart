import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';

class Instruction18 extends StatefulWidget {
  @override
  _Instruction18State createState() => _Instruction18State();
}

class _Instruction18State extends State<Instruction18> {
  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          height: hp,
          width: hw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: hp * 0.20,
              ),
              Center(
                child: Container(
                  height: 220,
                  width: hw - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Text(
                          'This sample text is used to test your near vision aquity.',
                          style: TextStyle(
                              color: Colors.black87, fontSize: hw * 0.04),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          'You can go and see an eyecare specialist if you feel some',
                          style: TextStyle(
                              color: Colors.black87, fontSize: hw * 0.035),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          'difficulties to read this text till the last lines and words.',
                          style: TextStyle(
                              color: Colors.black87, fontSize: hw * 0.03),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          'This just means that you may need to wear glasses.',
                          style: TextStyle(
                              color: Colors.black87, fontSize: hw * 0.025),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          'Don\'t panic it happens to the best of us.',
                          style: TextStyle(
                              color: Colors.black87, fontSize: hw * 0.02),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: hp * 0.1,
              ),
              Text(
                "Try to read the sentences out loud. Continue to the bottom row or until the sentences are too difficult to see. ",
                style: TextStyle(
                    color: colorFromHex('#181D3D'),
                    fontFamily: 'TTCommons',
                    fontSize: 26),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
