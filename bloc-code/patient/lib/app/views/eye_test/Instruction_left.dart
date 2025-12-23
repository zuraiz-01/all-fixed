import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/eye_test/AMD%20Test/amd_left.dart';
import 'package:eye_buddy/app/views/eye_test/Color%20Blind%20Test/color_blind_left.dart';
import 'package:eye_buddy/app/views/eye_test/Near%20Vision%20Test/nearvision.dart';
import 'package:eye_buddy/app/views/eye_test/colorconfig.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction%2016.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction18.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction19.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction20.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction21.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction22.dart';
import 'package:eye_buddy/app/views/eye_test/instruction/Instruction9-1.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class VisualEquityIntroLeft extends StatefulWidget {
  int id;
  int slide;

  VisualEquityIntroLeft({required this.id, required this.slide});

  @override
  _VisualEquityIntroLeftState createState() =>
      _VisualEquityIntroLeftState(id: id, slide: slide);
}

class _VisualEquityIntroLeftState extends State<VisualEquityIntroLeft> {
  int id;
  int slide;

  _VisualEquityIntroLeftState({required this.id, required this.slide});

  int slideIndex = 0;

  // late PageController controller = PageController(viewportFraction: 1, keepPage: true);
  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 6.0,
      width: 6.0,
      // height: isCurrentPage ? 10.0 : 6.0,
      // width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        border: Border.all(color: colorFromHex('#181D3D')),
        color: isCurrentPage ? AppColors.primaryColor : colorFromHex('#FFFFFF'),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var hp = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: id == 1
                  ? Container(
                      child: PageView(
                          // controller: controller,
                          onPageChanged: (index) {
                            setState(() {
                              slideIndex = index;
                            });
                          },
                          children: <Widget>[
                            Instruction21(),
                            Instruction22(),
                            Instruction91(),
                            Instruction16(),
                          ]),
                    )
                  // : id == -89
                  //     ? Container(
                  //         child: PageView(
                  //             // controller: controller,
                  //             onPageChanged: (index) {
                  //               setState(() {
                  //                 slideIndex = index;
                  //               });
                  //             },
                  //             children: <Widget>[
                  //               Instruction21(),
                  //               Instruction22(),
                  //               Instruction101(),
                  //               Instruction16(),
                  //             ]),
                  //       )
                  //     : id == -56
                  //         ? Container(
                  //             child: PageView(
                  //                 // controller: controller,
                  //                 onPageChanged: (index) {
                  //                   setState(() {
                  //                     slideIndex = index;
                  //                   });
                  //                 },
                  //                 children: <Widget>[
                  //                   Instruction21(),
                  //                   Instruction22(),
                  //                   Instruction92(),
                  //                   Instruction16(),
                  //                 ]),
                  //           )
                  //         :
                  : id == 2
                      ? Container(
                          child: PageView(
                              // controller: controller,
                              onPageChanged: (index) {
                                setState(() {
                                  slideIndex = index;
                                });
                              },
                              children: <Widget>[
                                Instruction21(),
                                Instruction22(),
                                Instruction18(),
                                Instruction16(),
                              ]),
                        )
                      : id == 3
                          ? Container(
                              child: PageView(
                                  // controller: controller,
                                  onPageChanged: (index) {
                                    setState(() {
                                      slideIndex = index;
                                    });
                                  },
                                  children: <Widget>[
                                    Instruction21(),
                                    Instruction22(),
                                    Instruction20(),
                                    Instruction16(),
                                  ]),
                            )
                          : id == 4
                              ? Container(
                                  child: PageView(
                                      // controller: controller,
                                      onPageChanged: (index) {
                                        setState(() {
                                          slideIndex = index;
                                        });
                                      },
                                      children: <Widget>[
                                        Instruction21(),
                                        Instruction22(),
                                        Instruction19(),
                                        Instruction16(),
                                      ]),
                                )
                              : null,
            ),
            Positioned(
                left: 20,
                top: 20,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "INSTRUCTION",
                      style: TextStyle(
                          color: colorFromHex('#181D3D'),
                          fontFamily: 'TTCommons',
                          fontSize: 20),
                    ),
                  ],
                )),
            Positioned(
              right: 20,
              top: 20,
              child: InkWell(
                child: Text(
                  "Skip",
                  style: TextStyle(
                      color: colorFromHex('#181D3D'),
                      fontFamily: 'TTCommons',
                      fontSize: 26),
                ),
                onTap: () {
                  if (id == 2) {
                    NavigatorServices().toReplacement(
                        context: context,
                        widget: NearVision(
                          id: id,
                        ));

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NearVision(
                    //               id: id,
                    //             )));
                  } else if (id == 3) {
                    NavigatorServices().toReplacement(
                        context: context,
                        widget: ColorBlindLeft(
                          id: id,
                        ));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ColorBlindLeft(
                    //               id: id,
                    //             )));
                  } else if (id == 4) {
                    NavigatorServices().toReplacement(
                        context: context,
                        widget: AmdLeft(
                          id: id,
                        ));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AmdLeft(
                    //               id: id,
                    //             )));
                  }

                  // id == 2
                  //     ? Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => NearVision(
                  //                   id: id,
                  //                 )))
                  //     : id == 3
                  //         ? Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => ColorBlindLeft(
                  //                       id: id,
                  //                     )))
                  //         : id == 4
                  //             ? Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => AmdLeft(
                  //                           id: id,
                  //                         )))
                  //             : null;
                },
              ),
            )
          ],
        ),
        floatingActionButton: slideIndex != (slide - 1)
            ? Padding(
                padding: EdgeInsets.only(bottom: hp * 0.02),
                child: Container(
                  height: 40,
                  width: 50,
                  child: Row(
                    children: [
                      for (int i = 0; i < slide; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(bottom: 30, left: 25, right: 25),
                child: CustomButton(
                  title: 'Done',
                  callBackFunction: () {
                    if (id == 2) {
                      NavigatorServices().toReplacement(
                          context: context,
                          widget: NearVision(
                            id: id,
                          ));

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => NearVision(
                      //               id: id,
                      //             )));
                    } else if (id == 3) {
                      NavigatorServices().toReplacement(
                          context: context,
                          widget: ColorBlindLeft(
                            id: id,
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ColorBlindLeft(
                      //               id: id,
                      //             )));
                    } else if (id == 4) {
                      NavigatorServices().toReplacement(
                          context: context,
                          widget: AmdLeft(
                            id: id,
                          ));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AmdLeft(
                      //               id: id,
                      //             )));
                    }
                  },
                )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomSheet:
      ),
    );
  }
}
