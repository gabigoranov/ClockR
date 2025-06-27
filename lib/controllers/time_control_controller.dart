import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';

import '../components/time_control_component.dart';
import '../models/time_control.dart';
import '../models/time_control_data.dart';

class TimeControlController extends GetxController {
  static TimeControlController get to => Get.find();


  static final timeControlPresets = [
    // UltraBullet
    TimeControl(
      TimeControlData(30, 5),
      TimeControlData(30, 5),
      'UltraBullet (30|5)',
    ),

    // Bullet
    TimeControl(
      TimeControlData(30, 0),
      TimeControlData(30, 0),
      'Bullet (30 sec)',
    ),
    TimeControl(
      TimeControlData(60, 0),
      TimeControlData(60, 0),
      'Bullet (1|0)',
    ),
    TimeControl(
      TimeControlData(60, 1),
      TimeControlData(60, 1),
      'Bullet (1|1)',
    ),
    TimeControl(
      TimeControlData(120, 0),
      TimeControlData(120, 0),
      'Bullet (2|0)',
    ),
    TimeControl(
      TimeControlData(120, 1),
      TimeControlData(120, 1),
      'Bullet (2|1)',
    ),

    // Blitz
    TimeControl(
      TimeControlData(180, 0),
      TimeControlData(180, 0),
      'Blitz (3|0)',
    ),
    TimeControl(
      TimeControlData(180, 2),
      TimeControlData(180, 2),
      'Blitz (3|2)',
    ),
    TimeControl(
      TimeControlData(300, 0),
      TimeControlData(300, 0),
      'Blitz (5|0)',
    ),
    TimeControl(
      TimeControlData(300, 3),
      TimeControlData(300, 3),
      'Blitz (5|3)',
    ),

    // Rapid
    TimeControl(
      TimeControlData(600, 0),
      TimeControlData(600, 0),
      'Rapid (10|0)',
    ),
    TimeControl(
      TimeControlData(600, 5),
      TimeControlData(600, 5),
      'Rapid (10|5)',
    ),
    TimeControl(
      TimeControlData(900, 0),
      TimeControlData(900, 0),
      'Rapid (15|0)',
    ),
    TimeControl(
      TimeControlData(900, 10),
      TimeControlData(900, 10),
      'Rapid (15|10)',
    ),
    TimeControl(
      TimeControlData(900, 15),
      TimeControlData(900, 15),
      'Rapid (15|15)',
    ),

    // Classical
    TimeControl(
      TimeControlData(1800, 0),
      TimeControlData(1800, 0),
      'Classical (30|0)',
    ),
    TimeControl(
      TimeControlData(1800, 15),
      TimeControlData(1800, 15),
      'Classical (30|15)',
    ),
    TimeControl(
      TimeControlData(1800, 20),
      TimeControlData(1800, 20),
      'Classical (30|20)',
    ),
    TimeControl(
      TimeControlData(3600, 0),
      TimeControlData(3600, 0),
      'Classical (60|0)',
    ),
    TimeControl(
      TimeControlData(3600, 30),
      TimeControlData(3600, 30),
      'Classical (60|30)',
    ),
  ].obs;


  @override
  Future<void> onInit() async{
    super.onInit();
    await readPresets();

    selectedTimeControl = timeControlPresets[3].obs; // Default to the 4th preset
    activeTimeControl = timeControlPresets[3].obs; // Default to the 4th preset
  }

  /// Singleton instance of persistent storage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// The selected time control ( still not activated )
  static late Rx<TimeControl> selectedTimeControl;

  /// The current time control which the clock is using
  static late Rx<TimeControl> activeTimeControl;

  static void selectPreset(String name) {
    var preset = getPreset(name);
    if (preset != null) {
      selectedTimeControl.value = preset;
    }
  }

  static void activatePreset() {
    var preset = selectedTimeControl.value;
    activeTimeControl.value = preset;
    CountdownTimerController.to.initialize(preset.player, preset.opponent);
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
      for (var value in decoded) {
        timeControlPresets.add(TimeControl.fromJson(value));
      }
    }
  }

  static Future<void> reorderTimeControls(int oldIndex, int newIndex) async{
    final item = timeControlPresets.removeAt(oldIndex);
    timeControlPresets.insert(newIndex, item);
    await savePresets();
  }

}
