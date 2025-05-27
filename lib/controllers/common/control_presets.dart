// Predefined presets
import '../../models/time_control.dart';

final List<TimeControl> timeControlPresets = [
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
  const TimeControl(300, 5, 'Blitz (5|5)'),
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
];