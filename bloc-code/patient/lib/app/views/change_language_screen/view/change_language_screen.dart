import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/config/language.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/size_config.dart';
import 'package:eye_buddy/app/views/global_widgets/common_app_bar.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/language_bloc/language_bloc.dart';

class ChangeLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final localLanguage = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: CommonAppBar(
        title: localLanguage.language,
        elevation: 0,
        icon: Icons.arrow_back,
        finishScreen: true,
        isTitleCenter: false,
        context: context,
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return Container(
            width: getWidth(context: context),
            padding: EdgeInsets.symmetric(
              horizontal: 22,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<LanguageBloc>().add(
                          const ChangeLanguage(
                            selectedLanguage: Language.english,
                          ),
                        );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InterText(
                          title: "English",
                          fontSize: 14,
                        ),
                        Icon(
                          Icons.check,
                          color: state.selectedLanguage == Language.english ? AppColors.primaryColor : AppColors.appBackground,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    context.read<LanguageBloc>().add(
                          const ChangeLanguage(
                            selectedLanguage: Language.bangla,
                          ),
                        );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InterText(
                          title: "বাংলা",
                          fontSize: 14,
                        ),
                        Icon(
                          Icons.check,
                          color: state.selectedLanguage == Language.bangla ? AppColors.primaryColor : AppColors.appBackground,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
