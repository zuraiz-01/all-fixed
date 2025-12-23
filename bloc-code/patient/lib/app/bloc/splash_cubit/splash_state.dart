// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashIdle extends SplashState {}

class SplashCompleted extends SplashState {
  bool isFirstBoot;
  bool userIsLoggedIn;
  SplashCompleted({
    required this.isFirstBoot,
    required this.userIsLoggedIn,
  });
}
