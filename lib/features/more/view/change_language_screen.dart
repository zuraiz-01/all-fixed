import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/size_config.dart';
import 'package:eye_buddy/features/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/app_localizations.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final MoreController controller = Get.find<MoreController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: l10n.language,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: Obx(
        () => ListView(
          children: [
            _LanguageTile(
              title: l10n.english_language,
              value: 'en',
              groupValue: controller.selectedLocaleCode.value,
              onChanged: (value) {
                controller.setLocale(value);
              },
            ),
            const Divider(height: 1),
            _LanguageTile(
              title: l10n.bangla_language,
              value: 'bn',
              groupValue: controller.selectedLocaleCode.value,
              onChanged: (value) {
                controller.setLocale(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InterText(title: title, fontSize: 14),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.primaryColor,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
      onTap: () => onChanged(value),
    );
  }
}
