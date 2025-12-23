import 'package:eye_buddy/app/models/eye_list_dummy_list_model.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/eye_test/Instruction_left.dart';
import 'package:eye_buddy/app/views/eye_test/model/eye_test_model.dart';
import 'package:eye_buddy/app/views/eye_test_list_screen/widget/eye_test_list_item.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/visual_acuity/visual_acuity_select_screen.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/visual_acity_eye_test_cubit/visual_acuity_cubit.dart';

class EyeTestListScreen extends StatelessWidget {
  EyeTestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: localLanguage.eye_test,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: SizedBox(
        child: ListView.builder(
          itemCount: EyeListDummyListModelHandler().eyeListDummyListModelList.length,
          // controller: _scrollController,
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(50), top: getProportionateScreenHeight(10)),
          // padding: EdgeInsets.only(left: getProportionateScreenWidth(18), right: getProportionateScreenWidth(18)),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // 3
            return EyeTestListItem(
              iconName: EyeListDummyListModelHandler().eyeListDummyListModelList[index].iconName,
              title: EyeListDummyListModelHandler().eyeListDummyListModelList[index].title,
              shortDetails: EyeListDummyListModelHandler().eyeListDummyListModelList[index].shortDetails,
              callBackFunction: () {
                if (index == 0) {
                  context.read<VisualAcuityCubit>().resetScore();
                  NavigatorServices().to(
                    context: context,
                    widget: VisualAcuitySelectEyeScreen(),
                  );
                } else {
                  NavigatorServices().to(
                    context: context,
                    widget: VisualEquityIntroLeft(
                      id: testModels[index].id,
                      slide: testModels[index].slide,
                    ),
                  );
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EyeTestPopup(
                  //           testModels[index].id,
                  //           testModels[index].popup,
                  //           testModels[index].slide,
                  //         )));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
