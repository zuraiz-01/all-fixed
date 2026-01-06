import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/api/model/patient_list_model.dart';
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

  Widget _patientDropdown(AppLocalizations localLanguage) {
    return Obx(() {
      final patients = controller.patients;
      if (controller.isLoadingPatients.value && patients.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (patients.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InterText(
                  title: localLanguage.selectPatient,
                  fontSize: 14,
                  textColor: AppColors.black,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => controller.fetchPatients(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final selected = controller.selectedPatient.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.colorEDEDED),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<MyPatient>(
            isExpanded: true,
            value: selected == null
                ? null
                : patients.firstWhereOrNull(
                    (p) => (p.id ?? '') == (selected.id ?? ''),
                  ),
            hint: InterText(
              title: localLanguage.selectPatient,
              fontSize: 14,
              textColor: AppColors.black,
            ),
            items: patients
                .map(
                  (p) => DropdownMenuItem<MyPatient>(
                    value: p,
                    child: InterText(
                      title: (p.name ?? '').trim().isEmpty
                          ? 'Patient'
                          : (p.name ?? ''),
                      fontSize: 14,
                      textColor: AppColors.black,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) async {
              if (value == null) return;
              controller.setSelectedPatient(value);
              await controller.fetchPrescriptions(remoteOnly: true);
            },
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<MoreController>()
        ? Get.find<MoreController>()
        : Get.put(MoreController());
    Future.microtask(() async {
      await controller.fetchPatients();
      if (mounted && controller.selectedPatient.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final items = controller.patients;
          if (items.isNotEmpty && controller.selectedPatient.value == null) {
            controller.setSelectedPatient(items.first);
          }
        });
      }
      await controller.fetchPrescriptions(remoteOnly: true);
    });
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

        return RefreshIndicator(
          onRefresh: () => controller.fetchPrescriptions(remoteOnly: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(14),
                ),
                sliver: SliverToBoxAdapter(
                  child: _patientDropdown(localLanguage),
                ),
              ),
              if (controller.apiPrescriptions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: InterText(
                      title: localLanguage.you_dont_have_any_prescription,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(20),
                    bottom: getProportionateScreenHeight(40),
                    top: getProportionateScreenWidth(2),
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final prescription = controller.apiPrescriptions[index];
                      return PrescriptionListItem(prescription: prescription);
                    }, childCount: controller.apiPrescriptions.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: getProportionateScreenWidth(10),
                      mainAxisSpacing: getProportionateScreenWidth(10),
                      childAspectRatio: .8,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
