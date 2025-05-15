// Predefined presets
import '../../models/time_control.dart';

final List<TimeControl> timeControlPresets = [
  // Classical
  const TimeControl(90 * 60, 30, 'Classical (FIDE Standard)'),
  const TimeControl(120 * 60, 30, 'Classical (FIDE Long)'),

  // Rapid
  const TimeControl(15 * 60, 10, 'Rapid (FIDE)'),
  const TimeControl(10 * 60, 5, 'Rapid (Online)'),

  // Blitz
  const TimeControl(3 * 60, 2, 'Blitz (FIDE)'),
  const TimeControl(5 * 60, 0, 'Blitz (5+0)'),

  // Bullet
  const TimeControl(1 * 60, 0, 'Bullet (1+0)'),
  const TimeControl(2 * 60, 1, 'Bullet (2+1)'),
];
