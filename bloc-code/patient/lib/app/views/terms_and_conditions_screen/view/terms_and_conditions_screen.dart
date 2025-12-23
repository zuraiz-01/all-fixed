import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/terms_and_conditions_screen/widgets/terms_and_condition_item.dart';
import 'package:eye_buddy/app_routes/page_route_arguments.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<TermsAndConditionsScreen> {
  int selectedIndexIndex = -10;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: CommonAppBar(
        title: widget.arguments.fromPage!,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: getProportionateScreenWidth(15), right: getProportionateScreenWidth(15)),
            child: Column(
              children: [
                _bannerImage(),
                ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return TermsAndConditionsItem(
                      title: 'Imtiaz Amin Sajid Khan',
                      callBackFunction: () {
                        if (selectedIndexIndex == index) {
                          selectedIndexIndex = -100;
                        } else {
                          selectedIndexIndex = index;
                        }
                        setState(() {});
                      },
                      index: index,
                      selectedIndexIndex: selectedIndexIndex,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage() {
    return Container(
      height: getProportionateScreenHeight(155),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(17)),
      ),
      child: Container(
        padding: const EdgeInsets.all(30),
        height: getProportionateScreenHeight(80),
        width: getProportionateScreenWidth(112),
        child: Image.asset(
          'assets/images/splash_logo.png',
        ),
      ),
    );
  }
}
