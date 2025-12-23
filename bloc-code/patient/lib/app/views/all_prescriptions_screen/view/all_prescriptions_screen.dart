import 'dart:developer';

import 'package:eye_buddy/app/bloc/network_block/network_state.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_cubit.dart';
import 'package:eye_buddy/app/bloc/prescription_list/prescription_list_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/all_prescriptions_screen/widgets/prescription_filter.dart';
import 'package:eye_buddy/app/views/all_prescriptions_screen/widgets/prescription_list_item.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_loader.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/global_widgets/no_data_found_widget.dart';
import 'package:eye_buddy/app/views/global_widgets/no_internet_connection_widget.dart';
import 'package:eye_buddy/app/views/upload_prescription_or_clinical_data/view/upload_prescription_or_clinical_data_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/network_block/network_bloc.dart';
import '../../shemmer/card_skelton_screen.dart';

class AllPrescriptionsScreen extends StatelessWidget {
  AllPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AllPrescriptionsScreen();
  }
}

class _AllPrescriptionsScreen extends StatefulWidget {
  _AllPrescriptionsScreen();

  @override
  State<_AllPrescriptionsScreen> createState() =>
      _AllPrescriptionsScreenState();
}

class _AllPrescriptionsScreenState extends State<_AllPrescriptionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<PrescriptionListCubit>().getPrescriptionList();
    resetNotificationClickData();
  }

  resetNotificationClickData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("prescription", false);

    bool? temp = await prefs.getBool("prescription");

    log("prescription data from all pres $temp");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var _crossAxisSpacing = 1;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = getProportionateScreenHeight(300);
    var _aspectRatio = _width / cellHeight;

    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        title: InterText(
          title: localLanguage.all_prescriptions,
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
            child: PrescriptionUserMenu(),
          ),
        ],
      ),
      // appBar: CommonAppBar(
      //   title: localLanguage.all_prescriptions,
      //   height: getProportionateScreenHeight(60),
      //   elevation: 0,
      //   icon: Icons.arrow_back,
      //   finishScreen: true,
      //   isTitleCenter: false,
      //   context: context,
      // ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: CustomButton(
          title: localLanguage.add_new_prescription,
          callBackFunction: () {
            NavigatorServices().to(
                context: context,
                widget: UploadPrescriptionOrClinicalDataScreen(
                  screenName: localLanguage.add_new_prescription,
                  isFromPrescriptionScreen: true,
                ));
          },
        ),
      ),
      body: Builder(builder: (context) {
        var networkState = context.watch<NetworkBloc>().state;

        if (networkState is NetworkFailure) {
          return const NoInterConnectionWidget();
        } else if (networkState is NetworkSuccess) {
          return RefreshIndicator(
            onRefresh: context.read<PrescriptionListCubit>().refreshScreen,
            child: BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
              builder: (context, state) {
                return state.isLoading
                    ? Container(
                        height: getHeight(context: context),
                        width: getWidth(context: context),
                        color: Colors.white,
                        child: const CustomLoader(),
                      )
                    : state.prescriptionList!.isEmpty
                        ? NoDataFoundWidget(
                            title: localLanguage.you_dont_have_any_prescription,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(20)),
                            child: SizedBox(
                              child: GridView.builder(
                                itemCount: state.prescriptionList!.length,
                                // controller: _scrollController,
                                padding:
                                    const EdgeInsets.only(bottom: 40, top: 20),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing:
                                            getProportionateScreenWidth(10),
                                        mainAxisSpacing:
                                            getProportionateScreenWidth(10),
                                        childAspectRatio: .8),
                                // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // 3
                                  return PrescriptionListItem(
                                    prescription:
                                        state.prescriptionList![index],
                                  );
                                },
                              ),
                            ),
                          );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
