// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'visual_acuity_cubit.dart';

class VisualAcuityState extends Equatable {
  bool isLefteye;
  String leftEyeScore;
  String rightEyeScore;
  VisualAcuityState({
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

  VisualAcuityState copyWith({
    bool? isLefteye,
    String? leftEyeScore,
    String? rightEyeScore,
  }) {
    return VisualAcuityState(
      isLefteye: isLefteye ?? this.isLefteye,
      leftEyeScore: leftEyeScore ?? this.leftEyeScore,
      rightEyeScore: rightEyeScore ?? this.rightEyeScore,
    );
  }
}
