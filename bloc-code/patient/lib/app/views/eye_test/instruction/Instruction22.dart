import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Instruction22 extends StatefulWidget {
  @override
  _Instruction22State createState() => _Instruction22State();
}

class _Instruction22State extends State<Instruction22> {
  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: hp * 0.15,
            ),
            SizedBox(
              height: hp * 0.3,
              child: Center(
                child:
                    SvgPicture.asset("assets/svgs/eye_test/Instruction22.svg"),
              ),
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
            Center(
              child: Text(
                "Hold the Screen about 40cm or 15 inches away.",
                style: TextStyle(
                    color: colorFromHex('#181D3D'),
                    fontFamily: 'TTCommons',
                    fontSize: 26),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
