import 'package:bloc/bloc.dart';
import 'package:eye_buddy/app/api/data/api_data.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit()
      : super(
          SplashIdle(),
        );

  Future<void> triggerSplash() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );
    String? token = await getToken();

    final prefs = await SharedPreferences.getInstance();
    bool? isFirstBoot = await prefs.getBool("isFirstBoot");
    if (isFirstBoot == null) {
      prefs.setBool(
        "isFirstBoot",
        false,
      );
    }

    emit(
      SplashCompleted(
        userIsLoggedIn: token != null,
        isFirstBoot: isFirstBoot == null ? true : isFirstBoot,
      ),
    );
  }
}
