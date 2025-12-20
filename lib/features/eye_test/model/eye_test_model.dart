import 'package:eye_buddy/core/services/utils/assets/app_assets.dart';

class EyeTestModel {
  final String title;
  final String iconName;
  final String shortDetails;

  EyeTestModel({
    required this.title,
    required this.iconName,
    required this.shortDetails,
  });
}

class EyeTestListData {
  static final List<EyeTestModel> eyeTestList = [
    EyeTestModel(
      title: 'Visual Acuity',
      iconName: AppAssets.visualAcuity,
      shortDetails:
          'The visual acuity test checks how well you see the details of a letter from a specific distance',
    ),
    EyeTestModel(
      title: 'Near Vision',
      iconName: AppAssets.nearVision,
      shortDetails:
          'The near vision test of your ability to see clearly at close range',
    ),
    EyeTestModel(
      title: 'Color Vision',
      iconName: AppAssets.colorVision,
      shortDetails:
          'The color vision test measure the level and type of your color blindness',
    ),
    EyeTestModel(
      title: 'AMD',
      iconName: AppAssets.amdSvg,
      shortDetails:
          'The Amsler grid test check for problem spots in your field of vision (if there are any)',
    ),
  ];
}
