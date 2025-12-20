import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/custom_button.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:eye_buddy/features/more/view/add_prescription_screen.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/more/widgets/prescription_list_item.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPrescriptionsScreen extends StatefulWidget {
  const AllPrescriptionsScreen({super.key});

  @override
  State<AllPrescriptionsScreen> createState() => _AllPrescriptionsScreenState();
}

class _AllPrescriptionsScreenState extends State<AllPrescriptionsScreen> {
  late MoreController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MoreController());
    controller.fetchPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: localLanguage.all_prescriptions,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: getProportionateScreenWidth(20),
          right: getProportionateScreenWidth(20),
          bottom: getProportionateScreenWidth(20),
        ),
        child: CustomButton(
          title: localLanguage.add_new_prescription,
          callBackFunction: () {
            Get.to(() => const AddPrescriptionScreen());
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingPrescriptions.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.apiPrescriptions.isEmpty) {
          return Center(
            child: InterText(
              title: localLanguage.you_dont_have_any_prescription,
              fontSize: 16,
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchPrescriptions(remoteOnly: true),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(14),
            ),
            child: GridView.builder(
              itemCount: controller.apiPrescriptions.length,
              padding: EdgeInsets.only(
                bottom: getProportionateScreenHeight(40),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: getProportionateScreenWidth(10),
                mainAxisSpacing: getProportionateScreenWidth(10),
                childAspectRatio: .8,
              ),
              itemBuilder: (context, index) {
                final prescription = controller.apiPrescriptions[index];
                return PrescriptionListItem(prescription: prescription);
              },
            ),
          ),
        );
      }),
    );
  }
}
