part of 'app_eye_test_cubit.dart';

class AppEyeTestState extends Equatable {
  bool isLefteye;
  String leftEyeScore;
  String rightEyeScore;
  AppEyeTestState({
    required this.isLefteye,
    required this.leftEyeScore,
    required this.rightEyeScore,
  });

  @override
  List<Object> get props => [
        isLefteye,
        isLefteye.hashCode,
        leftEyeScore.hashCode,
        rightEyeScore.hashCode,
      ];

  AppEyeTestState copyWith({
    bool? isLefteye,
    String? leftEyeScore,
    String? rightEyeScore,
  }) {
    return AppEyeTestState(
      isLefteye: isLefteye ?? this.isLefteye,
      leftEyeScore: leftEyeScore ?? this.leftEyeScore,
      rightEyeScore: rightEyeScore ?? this.rightEyeScore,
    );
  }
}
