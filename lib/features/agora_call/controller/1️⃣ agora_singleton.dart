import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class AgoraSingleton extends GetxService {
  late RtcEngine engine;

  Future<AgoraSingleton> init(String appId) async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    return this;
  }
}
