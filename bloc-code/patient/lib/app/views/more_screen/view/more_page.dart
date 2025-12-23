import 'package:eye_buddy/app/api/data/api_data.dart';
import 'package:eye_buddy/app/api/service/api_constants.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_size_box.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/toast.dart';
import 'package:eye_buddy/app/views/live_support/view/live_support_screen.dart';
import 'package:eye_buddy/app/views/login_flow/login_screen.dart';
import 'package:eye_buddy/app/views/more_screen/view/terms_and_condition.dart';
import 'package:eye_buddy/app/views/more_screen/widgets/more_header_section.dart';
import 'package:eye_buddy/app/views/more_screen/widgets/more_option_item.dart';
import 'package:eye_buddy/app_routes/page_route_arguments.dart';
import 'package:eye_buddy/app_routes/route_name.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColors.colorCCE7D9,
        ),
      ),
      backgroundColor: AppColors.appBackground,
      body: SizedBox(
        width: getWidth(context: context),
        child: Column(
          children: [
            const MoreHeaderSection(),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(10),
                        bottom: getProportionateScreenWidth(10),
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterText(
                            title: localLanguage.my_records.toUpperCase(),
                            fontSize: 16,
                            textColor: AppColors.color888E9D,
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.allPrescriptions,
                            title: localLanguage.all_prescriptions,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.allPrescriptionsScreen);
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.testResults,
                            title: localLanguage.test_results,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.testResultsScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(10),
                        bottom: getProportionateScreenWidth(10),
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterText(
                            title: localLanguage.general.toUpperCase(),
                            fontSize: 16,
                            textColor: AppColors.color888E9D,
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.favouriteDoctors,
                            title: localLanguage.favourite_doctors,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.favouriteDoctorsScreen);
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.transactionsHistory,
                            title: localLanguage.transactions_history,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.transactionsHistoryScreen);
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.promos,
                            title: localLanguage.promos,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.promosScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(10),
                        bottom: getProportionateScreenWidth(10),
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterText(
                            title: localLanguage.settings.toUpperCase(),
                            fontSize: 16,
                            textColor: AppColors.color888E9D,
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.changeMobileNumber,
                            title: localLanguage.change_mobile_number,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.changeMobileNumberScreen);
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.language,
                            title: localLanguage.language,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.changeLanguageScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(10),
                        bottom: getProportionateScreenWidth(10),
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: InterText(
                              title: localLanguage.legal.toUpperCase(),
                              fontSize: 16,
                              textColor: AppColors.color888E9D,
                            ),
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.termsAndConditions,
                            title: localLanguage.termsAndConditions,
                            callBackFunction: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditionScreen(
                                            url: ApiConstants.termsConditions,
                                            heading: localLanguage
                                                .termsAndConditions),
                                  ));
                              // Navigator.pushNamed(
                              //   context,
                              //   RouteName.termsAndConditionsScreen,
                              //   arguments: PageRouteArguments(
                              //     fromPage: localLanguage.termsAndConditions,
                              //     toPage: localLanguage.termsAndConditions,
                              //     data: [4],
                              //   ),
                              // );
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.privacyAndPolicy,
                            title: localLanguage.privacyPolicy,
                            callBackFunction: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditionScreen(
                                            url: ApiConstants.privacyPolicy,
                                            heading:
                                                localLanguage.privacyPolicy),
                                  ));
                              // Navigator.pushNamed(
                              //   context,
                              //   RouteName.termsAndConditionsScreen,
                              //   arguments: PageRouteArguments(
                              //     fromPage: localLanguage.privacyPolicy,
                              //     toPage: localLanguage.privacyPolicy,
                              //     data: [4],
                              //   ),
                              // );
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.paymentTerms,
                            title: localLanguage.payment_terms,
                            callBackFunction: () {
                              // showToast(
                              //     message: "Coming soon", context: context);
                              // Navigator.pushNamed(
                              //   context,
                              //   RouteName.termsAndConditionsScreen,
                              //   arguments: PageRouteArguments(
                              //     fromPage: localLanguage.payment_terms,
                              //     toPage: localLanguage.payment_terms,
                              //     data: [4],
                              //   ),
                              // );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditionScreen(
                                            url: ApiConstants.paymentTerms,
                                            heading:
                                                localLanguage.payment_terms),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(10),
                        bottom: getProportionateScreenWidth(10),
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: InterText(
                              title: localLanguage.help.toUpperCase(),
                              fontSize: 16,
                              textColor: AppColors.color888E9D,
                            ),
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.emergencyCall,
                            title: localLanguage.emergency_call,
                            callBackFunction: () {
                              Navigator.pushNamed(
                                  context, RouteName.emergencyCallScreen);
                            },
                          ),
                          MoreOptionItem(
                            iconName: AppAssets.liveSupport,
                            title: localLanguage.live_support,
                            callBackFunction: () {
                              NavigatorServices().to(
                                  context: context,
                                  widget: LiveSupportScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(10),
                    ),
                    GestureDetector(
                      onTap: () async {
                        removeToken();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("getProfileData");
                        NavigatorServices().toPushAndRemoveUntil(
                          context: context,
                          widget: LoginScreen(
                            showBackButton: false,
                          ),
                        );
                      },
                      child: Container(
                        color: AppColors.white,
                        height: kToolbarHeight,
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20),
                          right: getProportionateScreenWidth(20),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: const Icon(
                                Icons.logout,
                                size: 18,
                              ),
                            ),
                            CommonSizeBox(
                              width: 8,
                            ),
                            SizedBox(
                              child: InterText(
                                title: localLanguage.log_out,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CommonSizeBox(
                      height: getProportionateScreenWidth(20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
