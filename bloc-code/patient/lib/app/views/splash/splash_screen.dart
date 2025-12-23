import 'package:eye_buddy/app/bloc/agora_call_cubit/agora_call_cubit.dart';
import 'package:eye_buddy/app/bloc/splash_cubit/splash_cubit.dart';
import 'package:eye_buddy/app/utils/assets/app_assets.dart';
import 'package:eye_buddy/app/utils/config/app_colors.dart';
import 'package:eye_buddy/app/utils/dimentions.dart';
import 'package:eye_buddy/app/utils/keys/shared_pref_keys.dart';
import 'package:eye_buddy/app/utils/services/navigator_services.dart';
import 'package:eye_buddy/app/views/agora_call_room/agora_call_room_screen.dart';
import 'package:eye_buddy/app/views/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:eye_buddy/app/views/global_widgets/inter_text.dart';
import 'package:eye_buddy/app/views/intro_flow/into_flow_screen.dart';
import 'package:eye_buddy/app/views/login_flow/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  handleAcceptedCall() async {
    print("Navigating to BottomNavBarScreen first");

    var prefs = await SharedPreferences.getInstance();

    // First, navigate to BottomNavBarScreen
    NavigatorServices().toReplacement(
      context: context,
      widget: BottomNavBarScreen(),
    );

    // Wait for a small delay before navigating to the AgoraCallScreen
    await Future.delayed(
        const Duration(milliseconds: 500)); // Delay to ensure the transition

    // Check if the call was accepted
    if (prefs.getBool(isCallAccepted) ?? false) {
      prefs.setBool(isCallAccepted, false);

      // Navigate to AgoraCallScreen
      NavigatorServices().to(
        context: context,
        widget: AgoraCallScreen(
          name: prefs.getString(agoraDocName) ?? '',
          image:
              prefs.getString(agoraDocPhoto) ?? 'https://picsum.photos/200/300',
          appointmentId: prefs.getString(agoraChannelId) ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    context.read<SplashCubit>().triggerSplash();
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          if (state.isFirstBoot) {
            NavigatorServices().toReplacement(
              context: context,
              widget: const IntroFlowScreen(),
            );
          } else if (state.userIsLoggedIn) {
            handleAcceptedCall();
          } else {
            NavigatorServices().toReplacement(
              context: context,
              widget: LoginScreen(
                showBackButton: false,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.color008541,
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          height: getHeight(context: context),
          width: getWidth(context: context),
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: getHeight(context: context),
                  width: getWidth(context: context),
                  child: Image.asset(
                    AppAssets.splashLogo,
                    fit: BoxFit.contain,
                  ),
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
                    const SizedBox(
                      width: 8,
                    ),
                    InterText(
                      title: l10n.loading,
                      textColor: AppColors.colorFFFFFF,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
