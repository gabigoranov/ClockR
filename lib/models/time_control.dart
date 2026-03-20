import 'dart:convert';
import 'package:tempus/models/time_control_data.dart';

class TimeControl {
  TimeControlData player;
  TimeControlData opponent;

  String name;
  bool isCustom;

  TimeControl(this.player, this.opponent, this.name, {this.isCustom = false});

  TimeControl.fromJson(Map<String, dynamic> json)
      : player = TimeControlData.fromJson(jsonDecode(json['player'])),
        opponent = TimeControlData.fromJson(jsonDecode(json['opponent'])),
        name = json['name'] ?? "???",
        isCustom = json['isCustom'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'player': jsonEncode(player),
      'opponent': jsonEncode(opponent),
      'isCustom': isCustom,
    };
  }

  @override
  String toString() {
    if(player.seconds == opponent.seconds && player.increment == opponent.increment) {
      return player.toString();
    } else {
      // suggest that the time control has different settings for each player
      return " ? ";
    }
  }
}
