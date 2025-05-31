import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SystemChromeService {
  static SystemChromeService get to => Get.find();

  void enableFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void disableFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}