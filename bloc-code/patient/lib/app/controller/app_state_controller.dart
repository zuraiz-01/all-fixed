import 'package:get/get.dart';

class AppStateController extends GetxController {
  var isPickingImage = false.obs;

  void setPickingImage(bool value) {
    isPickingImage.value = value;
  }
}
