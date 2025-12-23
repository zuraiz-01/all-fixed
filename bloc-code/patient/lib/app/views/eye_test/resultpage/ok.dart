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

class OK extends StatelessWidget {
  int id;
  OK({required this.id});
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var hp = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    var hw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          return await Navigator.push(context,
              MaterialPageRoute(builder: (context) => BottomNavBarScreen()));
        },
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Stack(
                children: <Widget>[
                  Lottie.asset(
                    'assets/2.json',
                    height: MediaQuery.of(context).size.height * .3,
                  ),
                  Image.asset(
                    "assets/images/ok.png",
                    height: MediaQuery.of(context).size.height * .3,
                  )
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
                        ? "You seem to have some difficulty recognising small characters with both eyes."
                        : id == 2
                            ? "You seem to see some lines that are darker than others with one of your eyes."
                            : id == 3
                                ? "You have some difficulties in seeing subtle contrasts with both eyes."
                                : id == 4
                                    ? "You can read some text from 40cm away."
                                    : id == 5
                                        ? "You likely have some color vision difficulties."
                                        : id == 6
                                            ? "You saw distortions in the grid with one of your eyes. It's possible that this symptom is potentially linked to age-related macular degeneration (AMD)"
                                            : 'Erorr!',
                    style: TextStyle(fontSize: 14, fontFamily: 'TTCommons'),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    id == 1
                        ? "We recommend visiting an eye care professional."
                        : id == 2
                            ? "You could be astigmatic. We recommend visiting an eye care professional."
                            : id == 3
                                ? "We recommend visiting an eye care professional."
                                : id == 4
                                    ? "We recommend visiting an eye care professional to find out about different corrective solutions"
                                    : id == 5
                                        ? "We recommend visiting an eye care professional."
                                        : id == 6
                                            ? "We recommend visiting an eye care professional."
                                            : "Erorr!",
                    style: TextStyle(fontSize: 14, fontFamily: 'TTCommons'),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      // height: hp * 0.07,
                      // minWidth: hw * 0.7,

                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => EyeTestListScreen()),
                        // );
                        NavigatorServices().toReplacement(
                            context: context,
                            widget: ColorBlindLeft(
                              id: id,
                            ));
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => EyeTestListScreen()),
                        // );

                        NavigatorServices().toReplacement(
                            context: context, widget: EyeTestListScreen());
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
