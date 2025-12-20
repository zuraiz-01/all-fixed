import 'package:eye_buddy/core/services/api/data/api_data.dart';
import 'package:eye_buddy/core/services/utils/assets/app_assets.dart';
import 'package:eye_buddy/core/services/utils/config/app_colors.dart';
import 'package:eye_buddy/core/services/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/features/agora_call/view/agora_call_screen.dart';
import 'package:eye_buddy/features/bootom_navbar_screen/views/bottom_navbar_screen.dart';
import 'package:eye_buddy/features/global_widgets/inter_text.dart';
import 'package:eye_buddy/features/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final token = await getToken();
    final prefs = await SharedPreferences.getInstance();

    bool? isFirstBoot = prefs.getBool('isFirstBoot');
    if (isFirstBoot == null) {
      await prefs.setBool('isFirstBoot', false);
    }

    if (!mounted) return;

    // Match bloc-code navigation rules:
    // - First boot -> IntroFlow (not present in GetX features folder), fallback to Login.
    // - Logged in -> BottomNavBar, then if call accepted flag -> open call screen.
    // - Otherwise -> Login.
    if (isFirstBoot == null) {
      Get.offAll(() => LoginScreen(showBackButton: false));
      return;
    }

    if (token != null && token.isNotEmpty) {
      await _handleAcceptedCallOrHome(prefs);
      return;
    }

    Get.offAll(() => LoginScreen(showBackButton: false));
  }

  Future<void> _handleAcceptedCallOrHome(SharedPreferences prefs) async {
    // First, navigate to BottomNavBarScreen
    Get.offAll(() => const BottomNavBarScreen());

    // Wait small delay (same idea as bloc-code) to let transition complete
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final bool accepted = prefs.getBool(isCallAccepted) ?? false;
    if (!accepted) return;

    await prefs.setBool(isCallAccepted, false);

    final name = prefs.getString(agoraDocName) ?? '';
    final image = prefs.getString(agoraDocPhoto) ?? '';
    final appointmentId = prefs.getString(agoraChannelId) ?? '';

    if (appointmentId.isEmpty) return;

    Get.to(
      () => AgoraCallScreen(name: name, image: image, callId: appointmentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.color008541,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(AppAssets.splashLogo, fit: BoxFit.contain),
              ),
            ),
            SizedBox(
              height: kToolbarHeight * 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      color: AppColors.colorFFFFFF,
                      strokeWidth: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InterText(
                    title: l10n.loading,
                    textColor: AppColors.colorFFFFFF,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
