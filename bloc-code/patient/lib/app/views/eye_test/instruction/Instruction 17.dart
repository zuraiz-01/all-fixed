import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Instruction17 extends StatefulWidget {
  @override
  _Instruction17State createState() => _Instruction17State();
}

class _Instruction17State extends State<Instruction17> {
  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: hp * 0.15,
            ),
            Center(
              child: SvgPicture.asset("assets/svgs/eye_test/instruction 17.svg"),
            ),
            // Center(
            //     child: Column(
            //   children: <Widget>[
            //     SvgPicture.asset("assets/svg/instruction 6-1.svg"),
            //   ],
            // )),
            SizedBox(
              height: hp * 0.3,
            ),
            Center(
              child: Text(
                "Close your right eye",
                style: TextStyle(color: colorFromHex('#181D3D'), fontFamily: 'TTCommons', fontSize: 26),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
