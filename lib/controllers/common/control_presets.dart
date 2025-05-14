// Predefined presets
import '../../models/time_control.dart';

final Map<String, TimeControl> timeControlPresets = {
  // Classical (Long Games)
  'Classical (FIDE Standard)': const TimeControl(90 * 60, 30), // 90 min + 30s
  'Classical (FIDE Long)': const TimeControl(120 * 60, 30),    // 2h + 30s

  // Rapid
  'Rapid (FIDE)': const TimeControl(15 * 60, 10),              // 15 min + 10s
  'Rapid (Online)': const TimeControl(10 * 60, 5),             // 10 min + 5s

  // Blitz
  'Blitz (FIDE)': const TimeControl(3 * 60, 2),                // 3 min + 2s
  'Blitz (5+0)': const TimeControl(5 * 60, 0),                 // 5 min (no increment)

  // Bullet
  'Bullet (1+0)': const TimeControl(1 * 60, 0),                // 1 min (no increment)
  'Bullet (2+1)': const TimeControl(2 * 60, 1),                // 2 min + 1s
};