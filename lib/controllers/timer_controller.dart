import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../models/time_control.dart';
import 'common/control_presets.dart';

class TimerController extends GetxController {
  static TimerController get to => Get.find();

  @override
  Future<void> onInit() async{
    super.onInit();
    await readPresets();
  }

  /// Singleton instance of persistent storage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// The current time control
  static TimeControl currentTimeControl = timeControlPresets[3];

  static void choosePreset(String name) {
    var preset = getPreset(name);
    if (preset != null) {
      currentTimeControl = preset;
    }
  }

  /// Add a new custom time control
  static void addPreset(TimeControl timeControl) {
    timeControlPresets.add(timeControl);
  }

  /// Remove a preset by name
  static void removePreset(String name) {
    timeControlPresets.removeWhere((x) => x.name == name);
  }

  /// Get a preset by name (returns null if not found)
  static TimeControl? getPreset(String name) {
    return timeControlPresets.singleWhere((x) => x.name == name);
  }

  /// Save the presets to persistent storage
  static Future<void> savePresets() async {
    await _storage.write(key: "time_controls", value: jsonEncode(timeControlPresets));
  }

  /// Reads the presets from persistent storage
  static Future<void> readPresets() async {
    var read = await _storage.read(key: "time_controls");

    if(read != null){
      List<dynamic> decoded = jsonDecode(read);
      timeControlPresets.clear();
      decoded.forEach((value) {
        timeControlPresets.add(TimeControl(value['seconds'], value['increment'], value['name']));
      });
    }
  }
}
