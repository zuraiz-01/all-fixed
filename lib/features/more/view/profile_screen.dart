import 'package:eye_buddy/core/services/api/service/api_constants.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/common_network_image_widget.dart';
import 'package:eye_buddy/features/global_widgets/common_size_box.dart';
import 'package:eye_buddy/features/global_widgets/custom_button.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/app_localizations.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileController>();
    if (controller.profileData.value.profile == null) {
      controller.getProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.my_profile,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profileData.value.profile;
        if (profile == null) {
          return Center(
            child: InterText(
              title: l10n.profile_data_not_available,
              fontSize: 16,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: getProportionateScreenHeight(120),
                  width: getProportionateScreenHeight(120),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: CommonNetworkImageWidget(
                      imageLink:
                          profile.photo != null && profile.photo!.isNotEmpty
                          ? '${ApiConstants.imageBaseUrl}${profile.photo}'
                          : '',
                    ),
                  ),
                ),
              ),
              CommonSizeBox(height: getProportionateScreenHeight(16)),
              _ProfileInfoRow(label: l10n.full_name, value: profile.name ?? ''),
              _ProfileInfoRow(label: l10n.phone, value: profile.phone ?? ''),
              _ProfileInfoRow(label: l10n.email, value: profile.email ?? ''),
              _ProfileInfoRow(label: l10n.gender, value: profile.gender ?? ''),
              _ProfileInfoRow(
                label: l10n.weight,
                value: profile.weight != null ? '${profile.weight} KG' : '',
              ),
              const Spacer(),
              CustomButton(
                title: l10n.edit_profile,
                callBackFunction: () {
                  Get.to(() => EditProfileScreen(profile: profile));
                },
              ),
              CommonSizeBox(height: getProportionateScreenHeight(12)),
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterText(
            title: label,
            fontSize: 13,
            textColor: AppColors.color888E9D,
          ),
          CommonSizeBox(height: getProportionateScreenHeight(4)),
          InterText(
            title: value.isEmpty ? '-' : value,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
