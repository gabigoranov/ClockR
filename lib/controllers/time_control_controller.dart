import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';

import '../components/time_control_component.dart';
import '../models/time_control.dart';

class TimeControlController extends GetxController {
  static TimeControlController get to => Get.find();


  static final timeControlPresets = [
    // Bullet
    const TimeControl(30, 0, 'Bullet (30 sec)'),
    const TimeControl(60, 0, 'Bullet (1|0)'),
    const TimeControl(60, 1, 'Bullet (1|1)'),
    const TimeControl(120, 0, 'Bullet (2|0)'),
    const TimeControl(120, 1, 'Bullet (2|1)'),

    // Blitz
    const TimeControl(180, 0, 'Blitz (3|0)'),
    const TimeControl(180, 2, 'Blitz (3|2)'),
    const TimeControl(300, 0, 'Blitz (5|0)'),
    const TimeControl(300, 3, 'Blitz (5|3)'),
    const TimeControl(300, 5, 'Blitz (5|5)'),

    // Rapid
    const TimeControl(600, 0, 'Rapid (10|0)'),
    const TimeControl(600, 5, 'Rapid (10|5)'),
    const TimeControl(900, 0, 'Rapid (15|0)'),
    const TimeControl(900, 10, 'Rapid (15|10)'),

    // Classical
    const TimeControl(1800, 0, 'Classical (30|0)'),
    const TimeControl(1800, 20, 'Classical (30|20)'),
    const TimeControl(3600, 0, 'Classical (60|0)'),
    const TimeControl(3600, 30, 'Classical (60|30)'),
    const TimeControl(5400, 0, 'Classical (90|0)'),
    const TimeControl(5400, 30, 'Classical (90|30)'),
    const TimeControl(7200, 0, 'Classical (120|0)'),
    const TimeControl(7200, 30, 'Classical (120|30)'),

    // Daily (correspondence)
    const TimeControl(24 * 3600, 0, 'Daily (1 day)'),
    const TimeControl(2 * 24 * 3600, 0, 'Daily (2 days)'),
    const TimeControl(3 * 24 * 3600, 0, 'Daily (3 days)'),
    const TimeControl(7 * 24 * 3600, 0, 'Daily (7 days)'),
    const TimeControl(14 * 24 * 3600, 0, 'Daily (14 days)'),

    // Custom time controls that are popular on Chess.com
    const TimeControl(30, 5, 'UltraBullet (30|5)'),
    const TimeControl(60, 0, 'Bullet (1|0) - No Increment'),
    const TimeControl(900, 15, 'Rapid (15|15)'),
    const TimeControl(1800, 15, 'Classical (30|15)'),

    // Chess960 variants
    const TimeControl(180, 2, 'Chess960 Blitz (3|2)'),
    const TimeControl(600, 5, 'Chess960 Rapid (10|5)'),

    // Bughouse variants
    const TimeControl(180, 0, 'Bughouse Blitz (3|0)'),
    const TimeControl(300, 0, 'Bughouse Blitz (5|0)'),

    // Other variants
    const TimeControl(300, 2, 'Three-check Blitz (5|2)'),
    const TimeControl(600, 5, 'Crazyhouse Rapid (10|5)'),
  ].obs;

  @override
  Future<void> onInit() async{
    super.onInit();
    await readPresets();
  }

  /// Singleton instance of persistent storage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// The current time control
  static final currentTimeControl = timeControlPresets[3].obs;

  static void choosePreset(String name) {
    var preset = getPreset(name);
    if (preset != null) {
      currentTimeControl.value = preset;
      CountdownTimerController.to.initialize(preset.seconds, preset.increment);
    }
  }

  /// Add a new custom time control
  static Future<void> addPreset(TimeControl timeControl) async{
    timeControlPresets.add(timeControl);
    await savePresets();
  }

  /// Update an existing preset
  static Future<void> updatePreset(TimeControl timeControl) async {
    var index = timeControlPresets.indexWhere((x) => x.name == timeControl.name);
    if (index != -1) {
      timeControlPresets[index] = timeControl;
      await savePresets();
    }
  }

  /// Builds a list of time control presets as widgets
  static List<Widget> buildTimeControlWidgets(List<TimeControl> timeControls, {String? selectedPreset}) {
    return timeControls.map((x) {
      return TimeControlComponent(
        key: ValueKey(x.name),
        model: x,
        isSelected: selectedPreset == x.name,
      );
    }).toList();
  }


  /// Gets the custom time controls
  static List<TimeControl> customTimeControls() {
    return timeControlPresets.where((x) => x.isCustom).toList();
  }

  /// Gets the default time controls
  static List<TimeControl> defaultTimeControls() {
    return timeControlPresets.where((x) => !x.isCustom).toList();
  }


  /// Remove a preset by name
  static Future<void> removePreset(String name) async {
    timeControlPresets.removeWhere((x) => x.name == name);
    await savePresets();
  }

  /// Get a preset by name (returns null if not found)
  static TimeControl? getPreset(String name) {
    return timeControlPresets.singleWhere((x) => x.name == name);
  }

  /// Check if a preset exists by name
  static bool presetExists(String name) {
    return timeControlPresets.any((x) => x.name == name);
  }

  /// Save the presets to persistent storage
  static Future<void> savePresets() async {
    timeControlPresets.refresh();
    await _storage.write(key: "time_controls", value: jsonEncode(timeControlPresets));
  }

  /// Reads the presets from persistent storage
  static Future<void> readPresets() async {
    //await _storage.delete(key: "time_controls");
    var read = await _storage.read(key: "time_controls");

    if(read != null){
      List<dynamic> decoded = jsonDecode(read);
      timeControlPresets.clear();
      decoded.forEach((value) {
        timeControlPresets.add(TimeControl(value['seconds'], value['increment'], value['name'], isCustom:  value['isCustom']));
      });
    }
  }

  static Future<void> reorderTimeControls(int oldIndex, int newIndex) async{
    final item = timeControlPresets.removeAt(oldIndex);
    timeControlPresets.insert(newIndex, item);
    await savePresets();
  }

}
