import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';

class Instruction19 extends StatefulWidget {
  @override
  _Instruction19State createState() => _Instruction19State();
}

class _Instruction19State extends State<Instruction19> {
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
                height: hp * 0.15,
              ),
              SizedBox(
                  height: hp * 0.3,
                  child: Image.asset("assets/images/Instruction19.png")),
              SizedBox(
                height: hp * 0.1,
              ),
              Center(
                child: Text(
                  "Look directly at the dot at the center of the grid and keep eyes focused on it.",
                  style: TextStyle(
                      color: colorFromHex('#181D3D'),
                      fontFamily: 'TTCommons',
                      fontSize: 26),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "•Does any line the grid appear wavy, blurred, or distorted? ",
                style: TextStyle(
                    color: colorFromHex('#181D3D'),
                    fontFamily: 'TTCommons',
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
              Text(
                "•Are there any dark spots or missing areas in the grid?",
                style: TextStyle(
                    color: colorFromHex('#181D3D'),
                    fontFamily: 'TTCommons',
                    fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
