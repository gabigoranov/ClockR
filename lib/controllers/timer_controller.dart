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

  /// Add a new custom time control
  static void addPreset(String name, TimeControl timeControl) {
    timeControlPresets[name] = timeControl;
  }

  /// Remove a preset by name
  static void removePreset(String name) {
    timeControlPresets.remove(name);
  }

  /// Get a preset by name (returns null if not found)
  static TimeControl? getPreset(String name) {
    return timeControlPresets[name];
  }

  /// Save the presets to persistent storage
  static Future<void> savePresets() async {
    await _storage.write(key: "time_controls", value: jsonEncode(timeControlPresets));
  }

  /// Reads the presets from persistent storage
  static Future<void> readPresets() async {
    var read = await _storage.read(key: "time_controls");

    if(read != null){
      Map<String, dynamic> decoded = jsonDecode(read);
      timeControlPresets.clear();
      decoded.forEach((key, value) {
        timeControlPresets[key] = TimeControl(value['seconds'], value['increment']);
      });
    }
  }
}
