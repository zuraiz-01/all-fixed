import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Instruction16 extends StatefulWidget {
  @override
  _Instruction16State createState() => _Instruction16State();
}

class _Instruction16State extends State<Instruction16> {
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
                  child: SvgPicture.asset(
                      "assets/svgs/eye_test/instruction 16.svg")),
              SizedBox(
                height: hp * 0.2,
              ),
              Text(
                "Close your left eye",
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
