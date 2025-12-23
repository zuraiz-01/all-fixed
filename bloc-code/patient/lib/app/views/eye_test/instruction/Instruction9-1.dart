import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Instruction91 extends StatefulWidget {
  @override
  _Instruction91State createState() => _Instruction91State();
}

class _Instruction91State extends State<Instruction91> {
  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          width: hw,
          height: hp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: hp * 0.15,
              ),
              SizedBox(
                height: hp * 0.3,
                child: SvgPicture.asset("assets/svgs/e.svg"),
              ),
              // Center(
              //     child: Column(
              //   children: <Widget>[
              //     SvgPicture.asset("assets/svg/instruction 6-1.svg"),
              //   ],
              // )),
              SizedBox(
                height: hp * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  "Identify the Object/Letter",
                  style: TextStyle(
                    color: colorFromHex('#181D3D'),
                    fontFamily: 'TTCommons',
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
