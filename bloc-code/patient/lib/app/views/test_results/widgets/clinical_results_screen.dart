import 'package:eye_buddy/app/bloc/test_result/test_result_cubit.dart';
import 'package:eye_buddy/app/bloc/test_result/test_result_state.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/custom_button.dart';
import 'package:eye_buddy/app/views/test_results/widgets/clinical_result_list_item.dart';
import 'package:eye_buddy/app/views/upload_prescription_or_clinical_data/view/upload_prescription_or_clinical_data_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global_widgets/no_data_found_widget.dart';

class ClinicalResultScreen extends StatelessWidget {
  const ClinicalResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: CustomButton(
          title: localLanguage.add_new_test_result,
          callBackFunction: () {
            NavigatorServices().to(
                context: context,
                widget: UploadPrescriptionOrClinicalDataScreen(
                  screenName: localLanguage.add_new_test_result,
                  isFromTestResultScreen: true,
                ));
          },
        ),
      ),
      body: BlocConsumer<TestResultCubit, TestResultState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SizedBox(
              child: state.clinicalResultList!.isNotEmpty
                  ? GridView.builder(
                      itemCount: state.clinicalResultList!.length,
                      // controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 50, top: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: getProportionateScreenWidth(10),
                        mainAxisSpacing: getProportionateScreenWidth(10),
                        // childAspectRatio: 1.1
                      ),
                      // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // 3
                        return ClinicalResultListItem(
                          testResult: state.clinicalResultList![index],
                        );
                      },
                    )
                  : Container(
                      height: MediaQuery.sizeOf(context).height,
                      child: NoDataFoundWidget(
                        title: "You don't have any clinical results",
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
