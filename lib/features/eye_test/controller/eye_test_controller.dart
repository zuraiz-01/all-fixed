import 'package:get/get.dart';
import 'package:eye_buddy/core/services/api/repo/api_repo.dart';
import 'package:eye_buddy/features/login/controller/profile_controller.dart';
import 'package:eye_buddy/features/more/controller/more_controller.dart';

class EyeTestController extends GetxController {
  final ApiRepo _apiRepo = ApiRepo();

  Future<void> _refreshAppTestResults() async {
    if (!Get.isRegistered<MoreController>()) {
      return;
    }
    try {
      await Get.find<MoreController>().fetchAppTestResults();
    } catch (_) {
      // ignore
    }
  }

  // Observable variables
  var isLeftEye = true.obs;
  var leftEyeScore = '0/0'.obs;
  var rightEyeScore = '0/0'.obs;

  final nearVisionLeftCounter = 0.obs;
  final nearVisionRightCounter = 0.obs;

  final colorVisionLeftCorrect = 0.obs;
  final colorVisionRightCorrect = 0.obs;

  final amdLeftCounter = 0.obs;
  final amdRightCounter = 0.obs;

  // Update current eye being tested
  void updateCurrentEye(bool isLeft) {
    isLeftEye.value = isLeft;
  }

  // Update score for current eye
  void updateScore(String score) {
    if (isLeftEye.value) {
      leftEyeScore.value = score;
    } else {
      rightEyeScore.value = score;
    }

    print("Current left eye score: ${leftEyeScore.value}");
    print("Current right eye score: ${rightEyeScore.value}");
  }

  // Reset scores
  void resetScore() {
    isLeftEye.value = true;
    leftEyeScore.value = '0/0';
    rightEyeScore.value = '0/0';
  }

  void resetNearVision() {
    nearVisionLeftCounter.value = 0;
    nearVisionRightCounter.value = 0;
  }

  void resetColorVision() {
    colorVisionLeftCorrect.value = 0;
    colorVisionRightCorrect.value = 0;
  }

  void resetAmd() {
    amdLeftCounter.value = 0;
    amdRightCounter.value = 0;
  }

  void incrementNearVisionLeft() {
    nearVisionLeftCounter.value = nearVisionLeftCounter.value + 10;
  }

  void incrementNearVisionRight() {
    nearVisionRightCounter.value = nearVisionRightCounter.value + 10;
  }

  void incrementColorVisionLeft() {
    colorVisionLeftCorrect.value = colorVisionLeftCorrect.value + 1;
  }

  void incrementColorVisionRight() {
    colorVisionRightCorrect.value = colorVisionRightCorrect.value + 1;
  }

  void incrementAmdLeft() {
    amdLeftCounter.value = amdLeftCounter.value + 5;
  }

  void incrementAmdRight() {
    amdRightCounter.value = amdRightCounter.value + 5;
  }

  // Get current eye score
  String getCurrentEyeScore() {
    return isLeftEye.value ? leftEyeScore.value : rightEyeScore.value;
  }

  // Check if both eyes have scores
  bool areBothEyesTested() {
    return leftEyeScore.value != '0/0' && rightEyeScore.value != '0/0';
  }

  // Get formatted result for API
  Map<String, dynamic> getTestResults() {
    return {
      'leftEyeScore': leftEyeScore.value,
      'rightEyeScore': rightEyeScore.value,
    };
  }

  Future<void> submitVisualAcuityResults() async {
    try {
      final profileId = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>().profileData.value.profile?.sId
          : null;

      if (profileId == null || profileId.isEmpty) {
        return;
      }

      await _apiRepo.updateVisualAcuityTestResults(
        patientId: profileId,
        leftEyeScore: leftEyeScore.value,
        rightEyeScore: rightEyeScore.value,
      );

      await _refreshAppTestResults();
    } catch (_) {
      // ignore
    }
  }

  Future<void> submitNearVisionResults() async {
    try {
      final profileId = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>().profileData.value.profile?.sId
          : null;

      if (profileId == null || profileId.isEmpty) {
        return;
      }

      await _apiRepo.updateNearVisionTestResults(
        patientId: profileId,
        leftEyeCounter: nearVisionLeftCounter.value,
        rightEyeCounter: nearVisionRightCounter.value,
        leftVisualAcuityScore: leftEyeScore.value,
        rightVisualAcuityScore: rightEyeScore.value,
      );

      await _refreshAppTestResults();
    } catch (_) {
      // ignore
    }
  }

  Future<void> submitColorVisionResults() async {
    try {
      final profileId = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>().profileData.value.profile?.sId
          : null;

      if (profileId == null || profileId.isEmpty) {
        return;
      }

      final total =
          colorVisionLeftCorrect.value + colorVisionRightCorrect.value;
      final result = total >= 10 ? 'Normal' : 'Abnormal';

      await _apiRepo.updateColorVisionTestResults(
        patientId: profileId,
        leftResult: result,
        rightResult: result,
        leftVisualAcuityScore: leftEyeScore.value,
        rightVisualAcuityScore: rightEyeScore.value,
        leftNearVisionResult: '${nearVisionLeftCounter.value}/23',
        rightNearVisionResult: '${nearVisionRightCounter.value}/23',
      );

      await _refreshAppTestResults();
    } catch (_) {
      // ignore
    }
  }

  Future<void> submitAmdResults() async {
    try {
      final profileId = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>().profileData.value.profile?.sId
          : null;

      if (profileId == null || profileId.isEmpty) {
        return;
      }

      final total = amdLeftCounter.value + amdRightCounter.value;
      final result = total >= 10 ? 'Normal' : 'Abnormal';

      await _apiRepo.updateAmdTestResults(
        patientId: profileId,
        leftResult: result,
        rightResult: result,
        leftVisualAcuityScore: leftEyeScore.value,
        rightVisualAcuityScore: rightEyeScore.value,
        leftNearVisionResult: '${nearVisionLeftCounter.value}/23',
        rightNearVisionResult: '${nearVisionRightCounter.value}/23',
        colorVisionLeft:
            (colorVisionLeftCorrect.value + colorVisionRightCorrect.value) >= 10
            ? 'Normal'
            : 'Abnormal',
        colorVisionRight:
            (colorVisionLeftCorrect.value + colorVisionRightCorrect.value) >= 10
            ? 'Normal'
            : 'Abnormal',
      );

      await _refreshAppTestResults();
    } catch (_) {
      // ignore
    }
  }
}
