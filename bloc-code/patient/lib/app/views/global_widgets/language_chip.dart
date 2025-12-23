import 'package:eye_buddy/app/bloc/language_bloc/language_bloc.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/config/language.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageChip extends StatelessWidget {
  const LanguageChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(63),
              border: Border.all(
                color: AppColors.color008541,
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      context.read<LanguageBloc>().add(
                            const ChangeLanguage(
                              selectedLanguage: Language.bangla,
                            ),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(63),
                          bottomLeft: Radius.circular(63),
                        ),
                        color: state.selectedLanguage == Language.english ? Colors.transparent : AppColors.color008541,
                      ),
                      alignment: Alignment.center,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: InterText(
                        title: 'বাং',
                        fontSize: 9,
                        textColor: state.selectedLanguage == Language.english ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      context.read<LanguageBloc>().add(
                            const ChangeLanguage(
                              selectedLanguage: Language.english,
                            ),
                          );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(63),
                          bottomRight: Radius.circular(63),
                        ),
                        color: state.selectedLanguage == Language.bangla ? Colors.transparent : AppColors.color008541,
                      ),
                      alignment: Alignment.center,
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: InterText(
                        title: 'ENG',
                        fontSize: 9,
                        textColor: state.selectedLanguage == Language.bangla ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
