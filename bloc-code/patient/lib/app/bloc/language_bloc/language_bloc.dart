import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eye_buddy/app/utils/config/language.dart';
import 'package:eye_buddy/app/utils/keys/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ChangeLanguage>(onChangeLanguage);
    on<GetLanguage>(onGetLanguage);
  }
  Future<void> onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    // # 1
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      languagePrefsKey,
      event.selectedLanguage.value.languageCode,
    );
    emit(state.copyWith(selectedLanguage: event.selectedLanguage));
  }

  // # 2
  Future<void> onGetLanguage(GetLanguage event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedLanguage = prefs.getString(languagePrefsKey);
    emit(
      state.copyWith(
        selectedLanguage: selectedLanguage != null
            ? Language.values
                .where(
                  (item) => item.value.languageCode == selectedLanguage,
                )
                .first
            : Language.english,
      ),
    );
  }
}
