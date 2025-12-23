class TestModel {
  int id;
  String logo;
  String title;
  String desc;
  String popup, link;
  int slide;

  TestModel({
    required this.id,
    required this.logo,
    required this.title,
    required this.desc,
    required this.popup,
    required this.slide,
    required this.link,
  });
}

List<TestModel> testModels = <TestModel>[
  TestModel(
      link: 'https://www.mdcalc.com/visual-acuity-testing-snellen-chart#why-use',
      id: 1,
      logo: 'assets/svgs/eye_test/visual_aquity_test.svg',
      title: 'Visual Acuity Test',
      desc: 'The visual acuity test checks how well you see the details of a letter or symbol from a specific distance.',
      popup: 'assets/images/popup/1.png',
      slide: 4),
  // TestModel(
  //     link: 'https://www.nvisioncenters.com/astigmatism-lasik/astigmatism-testing/',
  //     id: 0,
  //     logo: 'assets/svgs/eye_test/astigmatism.svg',
  //     title: 'Astigmatism Test',
  //     desc:
  //         'The astigmatism mirror test check if you have astigmatism ( condition where the lens of the eye is improperly curved)',
  //     popup: 'assets/images/popup/2.png',
  //     slide: 4),
  // TestModel(
  //     link: 'https://www.vectorvision.com/contrast-sensitivity-background/',
  //     id: 0,
  //     logo: 'assets/svgs/eye_test/Light Sensitivity Test_logo.svg',
  //     title: 'Light Sensitivity Test',
  //     desc:
  //         'The Light sensitivity test measures your ability to distinguish between finer and finer increments of light versus dark.',
  //     popup: 'assets/images/popup/3.png',
  //     slide: 4),
  TestModel(
      link: 'https://medlineplus.gov/ency/article/003446.html',
      id: 2,
      logo: 'assets/svgs/eye_test/Near Vision Test_logo.svg',
      title: 'Near Vision Test',
      desc: 'The near vision test measure how well you see at close range.',
      popup: 'assets/images/popup/4.png',
      slide: 4),
  TestModel(
      link: 'https://www.westchesterhealth.com/blog/are-you-color-blind-heres-how-to-tell/',
      id: 3,
      logo: 'assets/svgs/eye_test/Color Blind Test_logo.svg',
      title: 'Color Blind Test',
      desc: 'The Color Vision Test measure the level and Type of your Color Blindness.',
      popup: 'assets/images/popup/5.png',
      slide: 4),
  TestModel(
      link: 'https://www.amslergrid.org/',
      id: 4,
      logo: 'assets/svgs/eye_test/AMD Test_logo.svg',
      title: 'AMD Test',
      desc: 'The Amsler Grid Test check for problem spots in your field of vision ( if there are any)',
      popup: 'assets/images/popup/6.png',
      slide: 4),
];
