import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:eye_buddy/app/views/eye_test/Color%20Blind%20Test/color_blind_left.dart';
import 'package:eye_buddy/app/views/eye_test/model/eye_test_model.dart';
import 'package:eye_buddy/app/views/eye_test_list_screen/view/eye_test_list_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class GoodResult extends StatelessWidget {
  int id;

  GoodResult({required this.id});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var hp = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var hw = MediaQuery.of(context).size.width;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        return await Navigator.push(context,
            MaterialPageRoute(builder: (context) => BottomNavBarScreen()));
      },
      child: Scaffold(
        body: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Lottie.asset('assets/1.json'),
                  Image.asset("assets/images/good.png")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Result",
                    style: TextStyle(fontSize: 30, fontFamily: 'TTCommons'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    id == 1
                        ? "Congratulations, your visual acuity seems good in both eyes."
                        : id == 2
                            ? "Congratulations, you are not astigmatic."
                            : id == 3
                                ? "Congratulations, your sensitivity to contrasts in both eyes seems good."
                                : id == 4
                                    ? "Congratulations, you can read all the text from 40cm away."
                                    : id == 5
                                        ? "Congratulations, you have no color vision difficulties."
                                        : id == 6
                                            ? "Congratulations, you do not seem to have any symptoms of age-related macular degeneration (AMD)."
                                            : "Erorr!",
                    style: TextStyle(fontSize: 14, fontFamily: 'TTCommons'),
                    textAlign: TextAlign.center,
                  ),
                  InterText(
                    textAlign: TextAlign.center,
                    title: id == 1
                        ? "Do not hesitate to take a further vision exam with an eye care professional."
                        : id == 2
                            ? "Do not hesitate to take a further vision exam with an eye care professional"
                            : id == 3
                                ? "Do not hesitate to take a further vision exam with an eye care professional"
                                : id == 4
                                    ? "Do not hesitate to take a further vision exam with an eye care professional"
                                    : id == 5
                                        ? "Do not hesitate to take a further vision exam with an eye care professional"
                                        : id == 6
                                            ? "Do not hesitate to take a further vision exam with an eye care professional"
                                            : "Erorr!",
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      // height: hp * 0.07,
                      // minWidth: hw * 0.7,

                      onTap: () {
                        NavigatorServices().toReplacement(
                            context: context,
                            widget: ColorBlindLeft(
                              id: id,
                            ));
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => EyeTestListScreen()),
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: InterText(
                            textColor: AppColors.white,
                            title: 'Retry Test',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      // height: hp * 0.07,
                      // minWidth: hw * 0.7,

                      onTap: () {
                        NavigatorServices().toReplacement(
                            context: context, widget: EyeTestListScreen());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => EyeTestListScreen()),
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.color888E9D,
                        ),
                        child: Center(
                          child: InterText(
                            textColor: AppColors.white,
                            title: 'Exit',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
              child: CustomButton(
                title: 'Learn More',
                callBackFunction: () {
                  _launchURL();
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _launchURL() async =>
      await launchUrl(Uri.parse(testModels[id - 1].link));
}
