import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';

class Instruction20 extends StatefulWidget {
  @override
  _Instruction20State createState() => _Instruction20State();
}

class _Instruction20State extends State<Instruction20> {
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
                  child: Image.asset("assets/images/Instruction20.png")),
              SizedBox(
                height: hp * 0.2,
              ),
              Text(
                "Identify the correct number/object.",
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
